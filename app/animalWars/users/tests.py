from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework.authtoken.models import Token
from rest_framework import status
from rest_framework.test import APIClient
import tempfile
from .models import Profile

# Create your tests here.

class ModelTestCase(TestCase):

    def setUp(self):
        data = {
            "first_name": "test",
            "last_name": "test",
            "email": "test@test.com",
            "password1": "test123",
            "password2": "test123"
        }
        response = self.client.post('/users/rest-auth/registration/', data=data) 

    def test_registration(self):
        data = {
            "first_name": "test",
            "last_name": "test",
            "email": "test2@test.com",
            "password1": "test123",
            "password2": "test123"
        }
        response = self.client.post('/users/rest-auth/registration/', data=data) 
        self.assertEqual(response.status_code, 201)

    def test_equal_email_registration(self):
        data = {
            "first_name": "test",
            "last_name": "test",
            "email": "test@test.com",
            "password1": "test123",
            "password2": "test123"
        }
        response = self.client.post('/users/rest-auth/registration/', data=data) 
        self.assertEqual(response.status_code, 400)
    
    def test_login(self):
        data = {
            "email": "test@test.com",
            "password": "test123"
        }
        response = self.client.post('/users/rest-auth/login/', data=data)
        self.assertEqual(response.status_code, 200)
    
    def test_get_user_data(self):
        client = APIClient()
        test = client.login(email='test@test.com', password='test123')
        token = Token.objects.get(user__email='test@test.com')
        client.credentials(HTTP_AUTHORIZATION='Token ' + token.key)
        response = client.get('/users/rest-auth/user/')
        self.assertEqual(response.status_code, 200)
