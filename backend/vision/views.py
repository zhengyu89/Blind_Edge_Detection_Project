import base64
import json
import numpy as np
import cv2
import os
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from google.cloud import vision
from google.cloud.vision_v1 import types
from dotenv import load_dotenv
import requests
import time

# Load environment variables (e.g., GOOGLE_APPLICATION_CREDENTIALS)
load_dotenv()

# Initialize Google Cloud Vision API client
client = vision.ImageAnnotatorClient()

# Define keywords for detecting relevant objects
KEYWORDS = keywords = [
    # Platform Edge & Gaps
    "Platform", "Edge", "Gap", "Rail", "Track", "Cliff", "Drop", "Step", "Threshold",

    # Obstacles & Hazards
    "Stairs", "Obstacle", "Barrier", "Pole", "Bench", "Signpost", "Pothole",
    "Debris", "Uneven Surface", "Curb",

    # Train & Station Related Objects
    "Train", "Subway", "Railway", "Ticket Gate", "Turnstile", "Platform Sign",

    # Safety & Navigation
    "Handrail", "Warning Sign", "Yellow Line", "Crosswalk", "Tactile Paving",

    #People
    "Person",
]

# Set confidence threshold (adjust this value to control sensitivity)
CONFIDENCE_THRESHOLD = 0.5

def detect_edges(frame):
    """
    Send a frame (numpy array) to the Google Cloud Vision API
    and return detected objects that match our keywords.
    """
    # Encode frame as JPEG and convert to base64 string
    _, buffer = cv2.imencode('.jpg', frame)
    content = base64.b64encode(buffer).decode('utf-8')
    image = types.Image(content=base64.b64decode(content))
    
    # Call object localization API
    response = client.object_localization(image=image)
    objects = response.localized_object_annotations

    # Filter objects by our keywords and confidence threshold
    detected_objects = [
        obj for obj in objects
        if any(keyword.lower() in obj.name.lower() for keyword in KEYWORDS)
        and obj.score >= CONFIDENCE_THRESHOLD
    ]
    return detected_objects

@csrf_exempt
def process_frame(request):
    """
    Django view to process a frame sent from Flutter.
    The view expects a POST request with a JSON body containing:
    
        { "image": "<base64_encoded_image>" }
    
    It returns a JSON response with:
     - A list of detected objects (name, confidence, bounding_box)
     - A warning message such as "Watch out! There is a ___ in front of you."
    """
    if request.method != "POST":
        return JsonResponse({"error": "Only POST method allowed"}, status=405)
    
    try:
        # Parse incoming JSON data
        data = json.loads(request.body)
        image_data = data.get("image")
        if not image_data:
            return JsonResponse({"error": "No image data provided"}, status=400)
        
        # Decode the base64 image into a numpy array
        image_bytes = base64.b64decode(image_data)
        np_arr = np.frombuffer(image_bytes, np.uint8)
        frame = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
        if frame is None:
            return JsonResponse({"error": "Failed to decode image"}, status=400)
        
        # Detect objects using Google Cloud Vision API
        detected_objects = detect_edges(frame)
        height, width, _ = frame.shape
        objects_data = []
        
        #----------------------------------------------------------------------------------------------------------------------
        # For multiple objects
        # for obj in detected_objects:
        #     vertices = obj.bounding_poly.normalized_vertices
        #     pts = [{"x": int(v.x * width), "y": int(v.y * height)} for v in vertices]
        #     objects_data.append({
        #         "name": obj.name,
        #         # "confidence": obj.score,
        #         "bounding_box": pts
        #     })
        
        # # Create a warning message based on the highest-confidence detected object
        # if detected_objects:
        #     best_obj = max(detected_objects, key=lambda x: x.score)
        #     warning_message = f"Watch out! There is a {best_obj.name.lower()} in front of you."
        # else:
        #     warning_message = "All clear ahead."
        
        # response_data = {
        #     "objects": objects_data,
        #     "warning_message": warning_message
        # }
        # return JsonResponse(response_data)
        #----------------------------------------------------------------------------------------------------------------------
    
        if detected_objects:
            best_obj = max(detected_objects, key=lambda x: x.score)
            vertices = best_obj.bounding_poly.normalized_vertices
            pts = [{"x": int(v.x * width), "y": int(v.y * height)} for v in vertices]
            objects_data = [{
                "name": best_obj.name,
                # "confidence": best_obj.score,
                "bounding_box": pts
            }]
            warning_message = f"Watch out! There is a {best_obj.name.lower()} in front of you."
        else:
            objects_data = []
            warning_message = "All clear ahead."

#--------------------------------------------------------------------------------------------------------------------------
# I had set a condition to restrict the calling of tts.
# The TTS should only be call at least with a gap of 1 sec. 
# If same thing, it need to have more gap. Including the all clear ahead message
#--------------------------------------------------------------------------------------------------------------------------
        
        current_time = time.time()
        # Ensure the global variables are initialized
        if 'last_warning_message' not in globals():
            last_warning_message = ""
        if 'last_tts_time' not in globals():
            last_tts_time = 0

        if (
            warning_message != last_warning_message and
            current_time - last_tts_time >= 1
        ):
            try:
                tts_response = requests.post("http://localhost:8000/tts/", json={"text": warning_message})
                tts_response_data = tts_response.json()

                if "audio_base64" in tts_response_data:
                    audio_base64 = tts_response_data["audio_base64"]
                    response_data = {
                        "objects": objects_data,
                        "warning_message": warning_message,
                        "audio_base64": audio_base64
                    }
                    last_warning_message = warning_message
                    last_tts_time = current_time
                else:
                    response_data = {
                        "objects": objects_data,
                        "warning_message": warning_message,
                        "audio_base64": None,
                        "error": "TTS service failed."
                    }
            except Exception as e:
                response_data = {
                    "objects": objects_data,
                    "warning_message": warning_message,
                    "audio_base64": None,
                    "error": str(e)
                }
        else:
            response_data = {
                "objects": objects_data,
                "warning_message": warning_message
            }

        return JsonResponse(response_data)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

#--------------------------------------------------------------------------------------------------------------------------
# For Debuging
# import base64
# import json
# import numpy as np
# import cv2
# from django.http import JsonResponse
# from django.views.decorators.csrf import csrf_exempt

# @csrf_exempt
# def process_frame(request):
#     if request.method != "POST":
#         return JsonResponse({"error": "Only POST method allowed"}, status=405)

#     try:
#         # Step 1: Parse the JSON request
#         data = json.loads(request.body)
#         image_data = data.get("image")

#         if not image_data:
#             return JsonResponse({"error": "No image data provided"}, status=400)

#         # Debug: Print first 100 characters of Base64 string
#         print(f"Received Base64 (First 100 chars): {image_data[:100]}")

#         # Step 2: Decode Base64 safely
#         try:
#             image_bytes = base64.b64decode(image_data, validate=True)
#             print(f"Decoded Image Bytes Length: {len(image_bytes)} bytes")
#         except Exception as e:
#             return JsonResponse({"error": f"Base64 decoding failed: {str(e)}"}, status=400)

#         # Step 3: Convert bytes to numpy array
#         np_arr = np.frombuffer(image_bytes, np.uint8)
#         print(f"Numpy Array Size: {np_arr.size}")

#         # Step 4: Decode image with OpenCV
#         frame = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

#         if frame is None:
#             # Save the corrupted file for debugging
#             with open("corrupted_image.jpg", "wb") as f:
#                 f.write(image_bytes)
#             return JsonResponse({"error": "Failed to decode image with OpenCV. Saved for debugging."}, status=400)

#         # Debug: Show image (for local testing)
#         cv2.imshow("Received Image", frame)
#         cv2.waitKey(0)
#         cv2.destroyAllWindows()

#         return JsonResponse({"message": "Image received and processed successfully!"})

#     except Exception as e:
#         return JsonResponse({"error": str(e)}, status=500)
