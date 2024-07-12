# bookings/serializers.py
from rest_framework import serializers
from consultations.models import VetDoctor
from users.models import Pet
from .models import Booking

class BookingSerializer(serializers.ModelSerializer):
    pet = serializers.CharField(source='pet.name')
    vet = serializers.CharField(source='vet.name')

    class Meta:
        model = Booking
        fields = [
            'id', 'user', 'pet', 'package', 'duration', 'total_price', 'vet', 
            'booking_date', 'payment_proof', 'status'
        ]

    def create(self, validated_data):
        pet_name = validated_data.pop('pet')['name']
        vet_name = validated_data.pop('vet')['name']
        pet = Pet.objects.get(name=pet_name)
        vet = VetDoctor.objects.get(name=vet_name)
        booking = Booking.objects.create(pet=pet, vet=vet, **validated_data)
        return booking
