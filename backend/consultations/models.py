from django.db import models

class Doctor(models.Model):
    name = models.CharField(max_length=255)
    rating = models.FloatField()
    specialty = models.CharField(max_length=255)
    description = models.TextField()
    picture = models.ImageField(upload_to='doctor_pictures/', blank=True, null=True)

    def __str__(self):
        return self.name

class ConsultationPackage(models.Model):
    DURATION_CHOICES = [
        (5, '5 minutes'),
        (10, '10 minutes'),
        (15, '15 minutes'),
        (20, '20 minutes'),
    ]

    MODE_CHOICES = [
        ('msg', 'Messaging'),
        ('voice', 'Voice Call'),
        ('video', 'Video Call'),
    ]

    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE, related_name='packages')
    duration = models.IntegerField(choices=DURATION_CHOICES)
    mode = models.CharField(max_length=5, choices=MODE_CHOICES)

    def __str__(self):
        return f"{self.duration} min - {self.get_mode_display()}"
