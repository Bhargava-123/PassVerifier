from django.contrib import admin
from .models import Pass,ScanLog,User

# Register your models here.
admin.site.register(Pass)
admin.site.register(ScanLog)
admin.site.register(User)
