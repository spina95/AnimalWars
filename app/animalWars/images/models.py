from django.db import models

class Image(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey("users.Profile", on_delete=models.CASCADE)
    name = models.CharField(max_length=30)
    image = models.ImageField(upload_to='images/', null=False, blank=False)
    score = models.FloatField(default=0)
    wins = models.IntegerField(default=0)
    lost = models.IntegerField(default=0)
    uploaded_at = models.DateTimeField(auto_now_add=True)

class Tag(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=30)
    image = models.ForeignKey("Image", on_delete=models.CASCADE)

