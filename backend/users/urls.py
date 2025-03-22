from django.urls import path
from .views import get_users

urlpatterns = [
    path('', get_users, name='user-list'),
]
