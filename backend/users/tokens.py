# users/tokens.py
import random
from django.core.cache import cache

def generate_otp(email):
    otp = random.randint(100000, 999999)
    cache.set(email, otp, timeout=300)  # OTP valid for 5 minutes
    return otp

def get_otp(email):
    return cache.get(email)