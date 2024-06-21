from django.contrib import admin
from .models import Doctor, ConsultationPackage

@admin.register(Doctor)
class DoctorAdmin(admin.ModelAdmin):
    list_display = ('name', 'rating', 'specialty')

@admin.register(ConsultationPackage)
class ConsultationPackageAdmin(admin.ModelAdmin):
    list_display = ('doctor', 'duration', 'mode')
