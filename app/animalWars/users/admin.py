from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin
from django.utils.safestring import mark_safe

from .models import Profile

class ProfileAdmin(UserAdmin):
    model = Profile
    list_display = ['id', 'email', 'first_name', 'last_name', 'image_tag']

    def image_tag(self, obj):
        if obj.profilepicture:
            return mark_safe('<img src="%s" style="width: 45px; height:45px;" />' % obj.profilepicture.url)
        else:
            return 'No Image Found'

    image_tag.short_description = 'profilepicture'
    image_tag.allow_tags = True

admin.site.register(Profile, ProfileAdmin)