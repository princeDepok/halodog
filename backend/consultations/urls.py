from django.urls import include, path
from rest_framework.routers import DefaultRouter
from .views import DoctorListView, DoctorViewSet, ConsultationPackageViewSet

router = DefaultRouter()
router.register(r'doctors', DoctorViewSet)
router.register(r'packages', ConsultationPackageViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('doctor-list/', DoctorListView.as_view(), name='doctor-list'),
]
