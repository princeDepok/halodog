# bookings/admin.py
from django.contrib import admin
from .models import Booking

@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('user', 'pet', 'vet', 'booking_date', 'status', 'total_price')
    list_filter = ('status', 'booking_date', 'vet')
    search_fields = ('user__email', 'pet__name', 'vet__name')
