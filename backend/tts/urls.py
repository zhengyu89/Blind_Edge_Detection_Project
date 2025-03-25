from django.urls import path
from .views import text_to_speech

urlpatterns = [
    path('', text_to_speech, name='tts'),
]