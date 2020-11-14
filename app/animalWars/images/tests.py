from django.test import TestCase, Client
from django.urls import reverse
from users.models import Profile
from .models import Image
from django.core.files.uploadedfile import SimpleUploadedFile
from rest_framework.test import APIClient, APIRequestFactory
from rest_framework.authtoken.models import Token
from rest_framework import status
import os

# Create your tests here.

class ModelTestCase(TestCase):
   
    def setUp(self):
        username = "example"
        email = 'example@example.com'
        password = 'password'
        self.user = Profile.objects.create_user(username, email, password)

        self.client = APIClient()
        self.client.force_authenticate(user=self.user)

        self.pwd = os.path.dirname(__file__)
        self.imageupload()
        self.vote()
        self.createTag()

    def imageupload(self):
        self.image = open(self.pwd + '/templates/images/eagle.jpg', 'rb')
        data = {
                'name': 'test1',
                'user': self.user.id,
                'image': self.image
            }
        response = self.client.post(reverse('images-list'), data=data) 
        self.image1 = response.data
        self.image = open(self.pwd + '/templates/images/eagle.jpg', 'rb') 
        data = {
                'name': 'test2',
                'user': self.user.id,
                'image': self.image
            }
        response = self.client.post(reverse('images-list'), data=data)
        self.image2 = response.data
    
    def vote(self):
        url = reverse('vote') + "?winner_id=" + str(self.image1["id"]) + "&loser_id=" + str(self.image2["id"])
        response = self.client.post(url)   
    
    def createTag(self):
        data = {
            "name": "test",
            "image": self.image1['id']
        }
        response = self.client.post(reverse('tags-list'), data=data)
        self.tag = response.data

    def test_image_upload(self):  
        self.image = open(self.pwd + '/templates/images/eagle.jpg', 'rb')
        data = {
            'name': 'test',
            'user': self.user.id,
            'image': self.image
        }
        response = self.client.post(reverse('images-list'), data=data)

        self.assertEqual(response.status_code, 201)
    
    def test_vote(self):
        url = reverse('vote') + "?winner_id=" + str(self.image1["id"]) + "&loser_id=" + str(self.image2["id"])
        response = self.client.post(url)   
        self.assertEqual(response.status_code, 200)
        
    def test_higher_score(self):
        response = self.client.get(reverse('higherscore'))

        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 2)
        self.assertTrue(response.data[0]["score"] > response.data[1]["score"])
    
    def test_lower_score(self):
        response = self.client.get(reverse('lowerscore'))

        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 2)
        self.assertTrue(response.data[0]["score"] < response.data[1]["score"])
    
    def test_newest(self):
        response = self.client.get(reverse('newestimages'))

        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 2)
        self.assertTrue(response.data[0]["uploaded_at"] > response.data[1]["uploaded_at"])
    
    def test_create_tag(self):
        data = {
            "name": "test1",
            "image": self.image1['id']
        }
        response = self.client.post(reverse('tags-list'), data=data)
        self.assertEqual(response.status_code, 201)

    def test_image_tags(self):
        url = reverse('imagetags') + "?image_id=" + str(self.image1['id'])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['name'], 'test')

    def test_search_tag(self):
        url = reverse('searchtag') + "?order=newest&tag=" + str(self.tag['name'])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['id'], self.image1['id'])

    def test_images_profile(self):
        url = reverse('imagesprofile') + "?profile_id=" + str(self.user.id)
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 2)

    def test_image_info(self):
        url = reverse('images-detail', args=[self.image1['id']])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['id'], self.image1['id'])
    
    def test_image_user(self):
        url = reverse('profile-detail', args=[self.image1['user']])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['id'], self.image1['id'])
