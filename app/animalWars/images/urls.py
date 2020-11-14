from django.urls import path, include
from rest_framework import routers
from .views import *

router = routers.DefaultRouter(trailing_slash=False)
router.register('images', ImageViewSet, basename='images')
router.register('tags', TagViewSet, basename='tags')

urlpatterns = [
    path('', include(router.urls)),
    path('randomImages', RandomImages.as_view(), name='randomimages'),
    path('newestImages', NewestImages.as_view(), name='newestimages'),
    path('higherscore', HigherScore.as_view(), name='higherscore'),
    path('lowerscore', LowerScore.as_view(), name='lowerscore'),
    path('vote', VoteImages.as_view(), name="vote"),
    path('profileimages', ImageProfile.as_view(), name="imagesprofile"),
    path('imageTags', ImageTags.as_view(), name="imagetags"),
    path('searchTag', SearchTags.as_view(), name="searchtag"),
]