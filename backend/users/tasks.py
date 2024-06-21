# users/tasks.py
from django.core.mail import send_mail
from django.conf import settings

def send_otp_via_email(email, otp):
    subject = 'Your OTP for password reset'
    message = f'Your OTP is {otp}'
    email_from = settings.EMAIL_HOST_USER
    recipient_list = [email]
    send_mail(subject, message, email_from, recipient_list)
