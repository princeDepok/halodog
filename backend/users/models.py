# users/models.py
from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']
    
    def __str__(self):
        return self.email

class Pet(models.Model):
    owner = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    species = models.CharField(max_length=100)
    breed = models.CharField(max_length=100, blank=True, null=True)
    age = models.IntegerField()
    description = models.TextField(blank=True, null=True)
    photo = models.ImageField(upload_to='pet_photos/', blank=True, null=True)

    def __str__(self):
        return self.name
