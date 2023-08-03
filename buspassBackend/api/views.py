from django.shortcuts import render
from django.http import JsonResponse
from .models import Pass
from rest_framework import serializers
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import PassSerializer

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

#37802
#37249
#34671


@api_view(['GET'])
def get_pass_details(request,pk):
    pass_instance = Pass.objects.filter(bio_id=pk)
    serializer = PassSerializer(pass_instance,many=True)
    return Response(serializer.data)
    
    
