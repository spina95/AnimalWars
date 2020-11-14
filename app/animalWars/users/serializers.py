from rest_framework import serializers
from rest_auth.registration.serializers import RegisterSerializer
from allauth.account import app_settings as allauth_settings
from allauth.utils import email_address_exists
from allauth.account.adapter import get_adapter
from allauth.account.utils import setup_user_email
from . import models

class UserSerializer(serializers.ModelSerializer):

    profilepicture = serializers.SerializerMethodField()

    class Meta:
        model = models.Profile
        fields = ['id', 'email', 'first_name', 'last_name', 'profilepicture']

    def get_profilepicture(self, user):
        request = self.context.get('request')
        if user.profilepicture:
            photo_url = user.profilepicture.url
            print(photo_url)
            return request.build_absolute_uri(photo_url)
        return request.build_absolute_uri("/media/profilepictures/blank-profile-picture-973460_640.png")

class UserLogininSerializer(serializers.Serializer):
    email = serializers.CharField(required = True)
    password = serializers.CharField(required = True)

class CustomRegisterSerializer(RegisterSerializer):
    email = serializers.EmailField(required=allauth_settings.EMAIL_REQUIRED)
    first_name = serializers.CharField(required=True, write_only=True)
    last_name = serializers.CharField(required=True, write_only=True)
    password1 = serializers.CharField(required=True, write_only=True)
    password2 = serializers.CharField(required=True, write_only=True)
    profilepicture = serializers.ImageField(required=False)

    def get_cleaned_data(self):
        data_dict = super().get_cleaned_data()
        data_dict['email'] = self.validated_data.get('email', '')
        data_dict['first_name'] = self.validated_data.get('first_name', '')
        data_dict['last_name'] = self.validated_data.get('last_name', '')
        data_dict['profilepicture'] = self.validated_data.get('profilepicture', '')
        return data_dict