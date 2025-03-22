from django.shortcuts import render
from django.http import JsonResponse
from google.cloud import texttospeech
import os
import json
import base64
from dotenv import load_dotenv

# Load environment variables (e.g., GOOGLE_APPLICATION_CREDENTIALS)
load_dotenv()

from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def text_to_speech(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode('utf-8'))  # Parse JSON request body
            text = data.get('text', 'Hello, this is a default message!')

            # Initialize Google Cloud Text-to-Speech client
            client = texttospeech.TextToSpeechClient()

            # Set text input
            input_text = texttospeech.SynthesisInput(text=text)

            # Configure voice
            voice = texttospeech.VoiceSelectionParams(
                language_code="en-US",
                ssml_gender=texttospeech.SsmlVoiceGender.FEMALE
            )

            # Audio configuration
            audio_config = texttospeech.AudioConfig(
                audio_encoding=texttospeech.AudioEncoding.MP3
            )

            # Synthesize speech
            response = client.synthesize_speech(
                input=input_text, voice=voice, audio_config=audio_config
            )

            # Convert audio to base64
            audio_base64 = base64.b64encode(response.audio_content).decode('utf-8')

            return JsonResponse({"audio_base64": audio_base64})

        except Exception as e:
            return JsonResponse({"error": "Failed to generate TTS", "details": str(e)}, status=500)

    return JsonResponse({"error": "Invalid request method. Use POST."}, status=400)
