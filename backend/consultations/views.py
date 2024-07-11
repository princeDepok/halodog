from rest_framework import viewsets, generics
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .models import VetDoctor, ConsultationPackage
from .serializers import DoctorCreateSerializer, DoctorSerializer, ConsultationPackageSerializer

class DoctorViewSet(viewsets.ModelViewSet):
    queryset = VetDoctor.objects.all()
    # permission_classes = [IsAuthenticatedOrReadOnly]

    def get_serializer_class(self):
        if self.action in ['create', 'update', 'partial_update']:
            return DoctorCreateSerializer
        return DoctorSerializer

class ConsultationPackageViewSet(viewsets.ModelViewSet):
    queryset = ConsultationPackage.objects.all()
    serializer_class = ConsultationPackageSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

class DoctorListView(generics.ListAPIView):
    queryset = VetDoctor.objects.all()
    serializer_class = DoctorSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]