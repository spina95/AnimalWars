from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.html import mark_safe

# Create your models here.
class Profile(AbstractUser):
	profilepicture = models.ImageField(upload_to='profilepictures/', null=True, blank=True)
	
	def __str__(self):
		return self.email