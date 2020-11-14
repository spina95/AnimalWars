from django.urls import path, include
from django.conf.urls import url
from rest_framework import routers
from . import views

router = routers.DefaultRouter(trailing_slash=False)
router.register('', views.ProfileViewset, basename='profile')

urlpatterns = [
    path('', include(router.urls), name='usersViewset'),
    path('rest-auth/', include('rest_auth.urls')),
    path('rest-auth/registration/', include('rest_auth.registration.urls'), name='registration'),
]