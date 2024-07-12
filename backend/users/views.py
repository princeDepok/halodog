# users/views.py
import logging
from django.contrib.auth import get_user_model
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import (
    LogoutSerializer, SetNewPasswordSerializer, UserDetailSerializer, 
    UserListSerializer, UserSerializer, LoginSerializer, 
    ResetPasswordSerializer, ValidateOTPSerializer, PetSerializer
)
from .tokens import generate_otp, get_otp
from .tasks import send_otp_via_email
from rest_framework.views import APIView
from .models import Pet

logger = logging.getLogger(__name__)

User = get_user_model()

class UserListView(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserListSerializer

class UserDetailView(generics.RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = UserDetailSerializer
    lookup_field = 'pk'
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        try:
            response = super().get(request, *args, **kwargs)
            logger.debug("User detail retrieved successfully.")
            return response
        except Exception as e:
            logger.error(f"Error retrieving user detail: {e}")
            return Response({"error": "Internal Server Error"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

class LoginView(generics.GenericAPIView):
    serializer_class = LoginSerializer

    def post(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        refresh = RefreshToken.for_user(user)
        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user_id': user.id,
        })

class ResetPasswordView(generics.GenericAPIView):
    serializer_class = ResetPasswordSerializer

    def post(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data['email']
        otp = generate_otp(email)
        send_otp_via_email(email, otp)
        return Response({"message": "OTP sent to email"}, status=status.HTTP_200_OK)

class ValidateOTPView(generics.GenericAPIView):
    serializer_class = ValidateOTPSerializer

    def post(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data['email']
        otp = serializer.validated_data['otp']
        
        cached_otp = get_otp(email)
        logger.debug(f"Cached OTP: {cached_otp}, Provided OTP: {otp}")

        if cached_otp and str(cached_otp) == otp:
            return Response({"message": "OTP validated successfully"}, status=status.HTTP_200_OK)
        return Response({"error": "Invalid OTP"}, status=status.HTTP_400_BAD_REQUEST)

class SetNewPasswordView(generics.GenericAPIView):
    serializer_class = SetNewPasswordSerializer

    def post(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data['email']
        new_password = serializer.validated_data['new_password']
        
        user = User.objects.get(email=email)
        user.set_password(new_password)
        user.save()
        return Response({"message": "Password reset successful"}, status=status.HTTP_200_OK)

class LogoutView(APIView):
    def post(self, request):
        logger.debug("Logout request received with data: %s", request.data)
        serializer = LogoutSerializer(data=request.data)
        if serializer.is_valid():
            refresh = serializer.validated_data['refresh']
            try:
                token = RefreshToken(refresh)
                token.blacklist()
                logger.debug("Successfully blacklisted refresh token.")
                return Response({"message": "Successfully logged out."}, status=status.HTTP_205_RESET_CONTENT)
            except Exception as e:
                logger.error("Error blacklisting token: %s", str(e))
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        else:
            logger.error("Invalid data: %s", serializer.errors)
            return Response({"error": "Invalid data"}, status=status.HTTP_400_BAD_REQUEST)

class RefreshTokenView(APIView):
    def get_tokens_for_user(user):
        refresh = RefreshToken.for_user(user)

        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }

class PetListView(generics.ListCreateAPIView):
    queryset = Pet.objects.all()
    serializer_class = PetSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

class PetDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Pet.objects.all()
    serializer_class = PetSerializer
    # permission_classes = [IsAuthenticated]
    # lookup_field = 'pk'
