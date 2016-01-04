from django.contrib import admin
from .models import Question


# Register your models here.
admin.site.register(Question)  # Registers the Question model with the admin superuser
