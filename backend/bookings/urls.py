# bookings/urls.py
from django.urls import path
from .views import BookingListCreateView, BookingDetailView

urlpatterns = [
    path('', BookingListCreateView.as_view(), name='booking-list-create'),
    path('bookings/<int:pk>/', BookingDetailView.as_view(), name='booking-detail'),
]
