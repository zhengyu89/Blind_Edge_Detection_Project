from django.http import JsonResponse
from .models import User

def get_users(request):
    users = list(User.objects.values())  # Convert queryset to list of dictionaries
    return JsonResponse({"users": users})
