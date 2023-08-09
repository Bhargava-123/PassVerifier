from django.db import models
from django.contrib.postgres.fields import ArrayField
from rest_framework.response import Response
from django.core.validators import RegexValidator
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
    dept_choices = [
        ('CSE','CSE'),
        ('IT','IT'),
        ('ECE','ECE')
    ]
    year_choices = [
        ('I','I'),
        ('II','II'),
        ('III','III'),
        ('IV,','IV'),
    ]
    institution_choices = [
        ('SIMATS','SIMATS'),
        ('SEC','SEC'),
        ('AHS','AHS')
    ]
    bio_id = models.IntegerField(
        primary_key=True,
        validators=[
            MinValueValidator(30000),
            MaxValueValidator(40000)
        ]
    )
    student_name = models.CharField(max_length=50)
    reg_number = models.CharField(max_length=20)
    department = models.CharField(max_length=20,choices=dept_choices)
    year = models.CharField(max_length=20,choices=year_choices)
    image_url = models.URLField(max_length=200,blank=True)
    institution = models.CharField(max_length=10,choices=institution_choices)
    valid_upto_hostel = models.DateField(auto_now=False,auto_now_add=False,blank=True,null=True)
    valid_upto_bus = models.DateField(auto_now=False,auto_now_add=False,blank=True,null=True)
    isTransport = models.BooleanField()
    transport_route = models.CharField(default='NULL',max_length=20,blank=True)
    isHostel = models.BooleanField()
    hostel_room = models.CharField(default='NULL',max_length=20,blank=True)

    class Meta:
        verbose_name_plural = "Pass"
        
    
    def __str__(self):
        return str(self.bio_id)

class ScanLog(models.Model):
    id = models.AutoField(primary_key=True)
    scan_date = models.CharField(max_length=100,validators=[
        RegexValidator(r"^\d{1,2}-\d{1,2}-\d{4}$")
    ])
    student_list = models.ManyToManyField(Pass,blank=True,null=True)
    class Meta:
        verbose_name_plural = "ScanLogs"
    
    def __str__(self):
        return self.scan_date

class User(models.Model):
    username = models.CharField(max_length=100)
    password = models.CharField(max_length=20)
    
    def __str__(self):
        return self.username

