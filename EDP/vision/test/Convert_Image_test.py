import cv2
import base64
import numpy as np
import json

def encode_image(image_path, max_width=100):
    """
    Encode an image as a base64 string after resizing it to a maximum width.

    Parameters:
        image_path (str): Path to the image file.
        max_width (int): Maximum width of the resized image (default: 800px).

    Returns:
        dict: JSON containing the base64-encoded image string.
    """
    # Read the image
    image = cv2.imread(image_path)
    if image is None:
        raise ValueError("❌ Failed to read image. Check the file path.")

    # Get current dimensions
    height, width = image.shape[:2]

    # Resize only if the width exceeds max_width
    if width > max_width:
        aspect_ratio = height / width
        new_width = max_width
        new_height = int(max_width * aspect_ratio)
        image = cv2.resize(image, (new_width, new_height), interpolation=cv2.INTER_AREA)

    # Encode image to JPEG and then base64
    _, buffer = cv2.imencode('.jpg', image, [cv2.IMWRITE_JPEG_QUALITY, 85])  # Reduce quality to save bandwidth
    image_base64 = base64.b64encode(buffer).decode('utf-8')

    return {"image": image_base64}

# Example usage:
encoded_data = encode_image("Me1Person.jpg")

# Save output to a text file
with open("encoded_output.txt", "w") as file:
    file.write(json.dumps(encoded_data, indent=4))

print("✅ Base64 string saved to encoded_output.txt")
