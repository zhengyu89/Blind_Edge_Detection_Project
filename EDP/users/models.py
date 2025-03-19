from django.db import models

class User(models.Model):
    user_id = models.AutoField(primary_key=True)  # Auto-incrementing ID
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)

    def __str__(self):
        return self.name

