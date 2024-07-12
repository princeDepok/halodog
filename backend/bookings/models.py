# bookings/models.py
from django.db import models
from django.conf import settings
from users.models import Pet
from consultations.models import ConsultationPackage, VetDoctor

class Booking(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('on_progress', 'On Progress'),
        ('completed', 'Completed'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE)
    package = models.CharField(max_length=250)
    duration = models.IntegerField()
    total_price = models.DecimalField(max_digits=9, decimal_places=2)
    vet = models.ForeignKey(VetDoctor, on_delete=models.CASCADE)
    booking_date = models.DateTimeField(auto_now_add=True)
    payment_proof = models.ImageField(upload_to='payment_proofs/', blank=True, null=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')

    def __str__(self):
        return f"Booking for {self.pet.name} by {self.user.email} with {self.vet.name}"
