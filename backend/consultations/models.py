from django.db import models

class Speciality(models.Model):
    name = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.name

class VetDoctor(models.Model):
    name = models.CharField(max_length=255)
    rating = models.FloatField()
    specialties = models.ManyToManyField(Speciality)
    description = models.TextField()
    picture = models.ImageField(upload_to='vet_doctor_pictures/', blank=True, null=True)
    clinic_name = models.CharField(max_length=255)
    clinic_address = models.CharField(max_length=255)
    contact_number = models.CharField(max_length=20)
    email = models.EmailField(blank=True, null=True)
    availability = models.CharField(max_length=255, blank=True, null=True)  # Example: "Mon-Fri, 9AM-5PM"
    range_fee = models.CharField(max_length=50, blank=True, null=True)  # Example: "50-100"
    chat_consultation_fee = models.DecimalField(max_digits=9, decimal_places=2, blank=True, null=True)
    voice_call_consultation_fee = models.DecimalField(max_digits=9, decimal_places=2, blank=True, null=True)
    appointment_fee = models.DecimalField(max_digits=9, decimal_places=2, blank=True, null=True)
    experience_years = models.IntegerField(blank=True, null=True)

    def __str__(self):
        return f"{self.name} - {', '.join([speciality.name for speciality in self.specialties.all()])}"

class ConsultationPackage(models.Model):
    DURATION_CHOICES = [
        (5, '5 minutes'),
        (10, '10 minutes'),
        (15, '15 minutes'),
        (20, '20 minutes'),
    ]

    MODE_CHOICES = [
        ('msg', 'Chat'),
        ('voice', 'Video Call'),
        ('video', 'Clinic Appointment'),
    ]

    doctor = models.ForeignKey(VetDoctor, on_delete=models.CASCADE, related_name='packages')
    duration = models.IntegerField(choices=DURATION_CHOICES)
    mode = models.CharField(max_length=5, choices=MODE_CHOICES)

    def __str__(self):
        return f"{self.duration} min - {self.get_mode_display()}"
