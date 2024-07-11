from django.contrib import admin
from .models import VetDoctor, Speciality, ConsultationPackage

@admin.register(Speciality)
class SpecialityAdmin(admin.ModelAdmin):
    list_display = ('name',)

@admin.register(VetDoctor)
class VetDoctorAdmin(admin.ModelAdmin):
    list_display = ('name', 'rating', 'clinic_name', 'clinic_address', 'contact_number')
    search_fields = ('name', 'clinic_name')
    list_filter = ('specialties',)

@admin.register(ConsultationPackage)
class ConsultationPackageAdmin(admin.ModelAdmin):
    list_display = ('doctor', 'duration', 'mode')
    list_filter = ('duration', 'mode')


