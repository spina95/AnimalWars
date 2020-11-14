from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status, generics, authentication, viewsets
from django.core.exceptions import ObjectDoesNotExist
from django.db.models import Avg
from .serializers import ImageRegisterSerializer, ImageSerializer, TagRegisterSerializer, TagSerializer
from .models import Image, Tag
from users.models import Profile
from users.serializers import UserSerializer

class ImageViewSet(viewsets.ModelViewSet):
    queryset = Image.objects.all()
    serializer_class = ImageSerializer

    def list(self, request):
        queryset = Image.objects.all()
        serializer = ImageSerializer(queryset, many=True)
        return Response(serializer.data)
    
    def create(self, request):
        serializer = ImageRegisterSerializer(data=request.data)
        if serializer.is_valid():
            average = 0
            if Image.objects.count() != 0:
                average = Image.objects.all().aggregate(Avg('score')).get('score__avg')
            post = serializer.save(
                score = average
            )
            post = ImageSerializer(post)
            return Response(post.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class TagViewSet(viewsets.ModelViewSet):
    queryset = Tag.objects.all()
    serializer_class = TagSerializer

class RandomImages(generics.ListAPIView):
    """
    Retrieve 2 random images
    """
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = ImageSerializer

    def get_queryset(self):
        image1 = Image.objects.order_by('?').first()
        check = False
        while check == False:
            image2 = Image.objects.order_by('?').first()
            if image1 != image2:
                check = True
        return [image1, image2]

class NewestImages(generics.ListAPIView):
    """
    Retrieve newest images
    """
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = ImageSerializer

    def get_queryset(self):
        return Image.objects.order_by('uploaded_at').reverse()
        
class HigherScore(generics.ListAPIView):
    """
    Retrieve images with score in order ascending
    """
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = ImageSerializer

    def get_queryset(self):
        return Image.objects.order_by('score').reverse()

class LowerScore(generics.ListAPIView):
    """
    Retrieve images with score in order ascending
    """
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = ImageSerializer

    def get_queryset(self):
        return Image.objects.order_by('score')

class VoteImages(generics.GenericAPIView):
    """
    Vote winner and loser
    """
    authentication_classes = [authentication.TokenAuthentication]

    def post(self, request):
        query_params = self.request.query_params
        winner_id = query_params.get('winner_id', None)
        loser_id = query_params.get('loser_id', None)

        if winner_id == loser_id:
            return Response("Invalid parameters", 400)

        try:
            winner = Image.objects.get(pk=winner_id)
        except ObjectDoesNotExist:
            return Response("Invalid parameters", 400)
        if winner.wins + winner.lost != 0:
            winner.score += float(1 / (winner.wins + winner.lost))
        else:
            winner.score +=1
        winner.wins += 1
        
        try: 
            loser = Image.objects.get(pk=loser_id)
        except ObjectDoesNotExist:
            return Response("Invalid parameters", 400)
        if loser.wins + loser.lost != 0:
            loser.score -= 1 / (loser.wins + loser.lost)
        else:
            loser.score -= 1
        loser.lost += 1
        winner.save()
        loser.save()
        return Response(status=200)

class ImageProfile(generics.ListAPIView):
    """
    Retrieve images posted from a profile
    """
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = ImageSerializer

    def get_queryset(self):
        query_params = self.request.query_params
        profile_id = query_params.get('profile_id', None)
        images = Image.objects.filter(user=profile_id)
        return images

class ImageTags(generics.ListAPIView):
    """
    Retrieve tags of an image
    """
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = TagSerializer

    def get_queryset(self):
        query_params = self.request.query_params
        image_id = query_params.get('image_id', None)
        tags = Tag.objects.filter(image=image_id)
        return tags

class SearchTags(generics.ListAPIView):
    """
    Search images with tags
    """
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = ImageSerializer

    def get_queryset(self):
        values = self.request.GET.getlist('tag')
        order = self.request.query_params.get('order')
        print(values)
        images = []
        for item in values:
            tags = Tag.objects.filter(name=item)
            im = []
            for t in tags: 
                im.append(t.image)
            
            images.append(im)
        
        result = set(images[0])
        for s in images[1:]:
            result.intersection_update(s)
        out = list(result)
        if order == 'descending':
            return sorted(out, key=lambda x: x.score, reverse=True)
        if order == 'newest':
            return sorted(out, key=lambda x: x.uploaded_at, reverse=True)
        return sorted(out, key=lambda x: x.score, reverse=False)