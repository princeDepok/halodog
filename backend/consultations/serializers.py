from rest_framework import serializers
from .models import Speciality, VetDoctor, ConsultationPackage

class ConsultationPackageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConsultationPackage
        fields = '__all__'

class SpecialitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Speciality
        fields = ['name']

class DoctorCreateSerializer(serializers.ModelSerializer):
    specialties = serializers.PrimaryKeyRelatedField(queryset=Speciality.objects.all(), many=True)

    class Meta:
        model = VetDoctor
        fields = [
          'id', 'name', 'rating', 'specialties', 'description', 'picture', 
            'clinic_name', 'clinic_address', 'contact_number', 'email', 
            'availability', 'range_fee', 'chat_consultation_fee', 
            'voice_call_consultation_fee', 'appointment_fee', 'experience_years'
        ]

class DoctorSerializer(serializers.ModelSerializer):
    specialties = SpecialitySerializer(many=True, read_only=True)

    class Meta:
        model = VetDoctor
        fields = [
           'id', 'name', 'rating', 'specialties', 'description', 'picture', 
            'clinic_name', 'clinic_address', 'contact_number', 'email', 
            'availability', 'range_fee', 'chat_consultation_fee', 
            'voice_call_consultation_fee', 'appointment_fee', 'experience_years'
        ]
