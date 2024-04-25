from django.urls import path
from .views import MessageListAPI

urlpatterns = [
    path('api/messages/', MessageListAPI.as_view(), name='message_list'),
]
