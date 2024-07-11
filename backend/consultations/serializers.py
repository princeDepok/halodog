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
            'id', 'picture', 'name', 'rating', 'description', 
            'clinic_name', 'clinic_address', 'contact_number', 
            'email', 'availability', 'consultation_fee', 'experience_years', 'specialties'
        ]

class DoctorSerializer(serializers.ModelSerializer):
    specialties = SpecialitySerializer(many=True, read_only=True)
    consultation_fee = serializers.DecimalField(max_digits=6, decimal_places=2)

    class Meta:
        model = VetDoctor
        fields = [
            'id', 'picture', 'name', 'rating', 'description', 
            'clinic_name', 'clinic_address', 'contact_number', 
            'email', 'availability', 'consultation_fee', 'experience_years', 'specialties'
        ]
