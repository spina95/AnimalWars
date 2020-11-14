from django.contrib import admin
from django.utils.safestring import mark_safe
from .models import Image, Tag

class ImageAdmin(admin.ModelAdmin):
    model = Image
    list_display = ['id', 'user', 'name', 'score', 'wins', 'lost', 'image_tag', 'uploaded_at']

    def image_tag(self, obj):
        if obj.image:
            return mark_safe('<img src="%s" style="width: 45px; height:45px;" />' % obj.image.url)
        else:
            return 'No Image Found'

    image_tag.short_description = 'Image'
    image_tag.allow_tags = True

admin.site.register(Image, ImageAdmin)

class TagAdmin(admin.ModelAdmin):

    def get_id(self, obj):
        return obj.image.id
    get_id.short_description = 'Image id'

    model = Tag
    list_display = ['id', 'get_id', 'name']

admin.site.register(Tag, TagAdmin)