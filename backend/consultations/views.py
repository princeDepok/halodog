from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .models import Doctor, ConsultationPackage
from .serializers import DoctorSerializer, ConsultationPackageSerializer

class DoctorViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Doctor.objects.all()
    serializer_class = DoctorSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

class ConsultationPackageViewSet(viewsets.ModelViewSet):
    queryset = ConsultationPackage.objects.all()
    serializer_class = ConsultationPackageSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]
