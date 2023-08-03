from django.db import models
from rest_framework.response import Response
from rest_framework.decorators import api_view
import re
from django.core.validators import RegexValidator,MaxValueValidator,MinValueValidator

# Create your models here.
#institution
#name
#rollnumber
#department
#year of study
#academic year
#valid upto
#bio id
#transport - route number aand boarding point
#hostel - hostel room number and type



class Pass(models.Model):
    institution = models.CharField(max_length=10)
    student_name = models.CharField(max_length=50)
    reg_number = models.CharField(max_length=20)
    department = models.CharField(max_length=20)
    year = models.CharField(max_length=20)
    academic_year = models.CharField(max_length=10)
    valid_upto = models.DateField(auto_now=False,auto_now_add=False)
    bio_id = models.IntegerField(
        primary_key=True,
        validators=[
            MinValueValidator(30000),
            MaxValueValidator(40000)
        ]
    )
    transport = models.BooleanField()
    transport_route = models.CharField(default='NULL',max_length=20,blank=True)

    class Meta:
        verbose_name_plural = "Pass"


