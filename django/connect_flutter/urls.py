# urls.py

from django.urls import path
from .views import MessageAPI, audio_to_text

urlpatterns = [
    path('api/messages/', MessageAPI.as_view(), name='message-list-create'),
    path('api/audio_to_text/', audio_to_text, name='audio_to_text'),
]
