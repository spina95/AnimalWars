from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import generics, viewsets
from . import models
from . import serializers
from . import authentication

# Create your views here.
class ProfileViewset(viewsets.ModelViewSet):
    queryset = models.Profile.objects.all()
    serializer_class = serializers.UserSerializer
