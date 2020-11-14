from rest_framework import serializers
from .models import Image, Tag

class ImageRegisterSerializer(serializers.ModelSerializer):

    name = serializers.CharField(required=True)
    image = serializers.ImageField(required=True)

    class Meta:
        model = Image
        fields = ['name', 'image', 'user']
    
class ImageSerializer(serializers.ModelSerializer):

    class Meta:
        model = Image
        fields = '__all__'

class TagRegisterSerializer(serializers.ModelSerializer):    
    
    name = serializers.CharField(required=True)

    class Meta:
        model = Tag
        fields = ['name', 'image']

class TagSerializer(serializers.ModelSerializer):

    class Meta:
        model = Tag
        fields = '__all__'

