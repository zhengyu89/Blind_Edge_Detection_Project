import cv2
import base64
import os
from google.cloud import vision
from google.cloud.vision_v1 import types
from dotenv import load_dotenv

load_dotenv()

# Initialize Google Cloud Vision API client
client = vision.ImageAnnotatorClient()

def capture_frame():
    cap = cv2.VideoCapture(0)  # Open webcam
    ret, frame = cap.read()
    cap.release()
    if not ret:
        print("❌ Failed to capture frame")
        return None
    return frame

def detect_edges(frame):
    client = vision.ImageAnnotatorClient()
    _, buffer = cv2.imencode('.jpg', frame)
    content = base64.b64encode(buffer).decode('utf-8')

    image = types.Image(content=base64.b64decode(content))
    response = client.label_detection(image=image)

    print("\n=== API Response ===")
    for label in response.label_annotations:
        print(f"Detected: {label.description} (Confidence: {label.score:.2f})")

if __name__ == "__main__":
    print("📸 Capturing test frame...")
    frame = capture_frame()
    if frame is not None:
        detect_edges(frame)
    else:
        print("❌ No frame captured, exiting...")
