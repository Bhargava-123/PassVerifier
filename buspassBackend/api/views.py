from django.shortcuts import render
from django.http import JsonResponse
from .models import Pass,ScanLog,User
from rest_framework import serializers
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import PassSerializer,ScanLogSerializer,UserSerializer

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

@api_view(["GET"])
def get_scan_logs(request,date):
    scanLog_instance = ScanLog.objects.filter(scan_date=date)
    print(scanLog_instance.all())
    serializer = ScanLogSerializer(scanLog_instance,many=True)
    return Response(serializer.data)
    
def post_scan_logs(request,pk):
    return Response({'data' : 'post scan logs'})

@api_view(['POST'])
def authenticate_user(request):
    response_data = {}
    if request.method == "POST":
        user_instance = User.objects.filter(username=request.data['username'],password=request.data['password'])
        serializer = UserSerializer(user_instance,many=True)
        if serializer.data == []:#wrong password or username
            response_data['response'] = 'false'
        else:
            response_data['response'] = 'true'
    return Response(response_data)
    

#{"username": "a", "password": "123"}