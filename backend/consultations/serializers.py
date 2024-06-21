from rest_framework import serializers
from .models import Doctor, ConsultationPackage

class ConsultationPackageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConsultationPackage
        fields = '__all__'

class DoctorSerializer(serializers.ModelSerializer):
    picture = serializers.ImageField(required=False)

    class Meta:
        model = Doctor
        fields = '__all__'
