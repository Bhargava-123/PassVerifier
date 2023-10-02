from django.shortcuts import render
from django.http import JsonResponse
from .models import Pass,ScanLog,User
from .models import *
from rest_framework import serializers
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import PassSerializer,ScanLogSerializer,UserSerializer,SessionTableSerializer
import jwt
import requests
import base64
import buspassBackend.settings as settings
from datetime import datetime as dt
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer, TokenObtainSerializer
import json

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
    serializer = ScanLogSerializer(scanLog_instance,many=True)
    return Response(serializer.data)
#userid
#access token
#refresh token
#created date and timestamp
#expiry

@api_view(["POST","GET"])
def post_scan_logs(request,date):
    # scanLog_instance = ScanLog.objects.filter(scan_date="21-08-2023")
    # serializer = ScanLogSerializer(scanLog_instance,many=True)
    # print("hello")
    # student_list = serializer.data[0]['student_list']
    # if request.data['bioId'] not in student_list:
    #     student_list.append(request.data['bioId'])
    #     scanLog_instance_new = ScanLog(scan_date=date,id=1)
    #     scanLog_instance_new.student_list.set(student_list)
    #     serializer = ScanLogSerializer(scanLog_instance)
    #     print(serializer.data)
    #     # new_serializer = ScanLogSerializer(data = serializer.data)
    #     # if new_serializer.is_valid():
    #     #     new_serializer.save()
    serializer = ScanLogSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({"Success": "Full"})
    return Response({'date' : date})
        
@api_view(['POST'])
def authenticate_user(request):
    
    #generating access and refresh token
    response = requests.post('http://127.0.0.1:8000/api/token/',data=request.data)
    access_token = response.json()['access']
    refresh_token = response.json()['refresh']
    #decoding access_token to get user_id
    user_id = ""
    try:
        decoded_data = jwt.decode(jwt=access_token,key=settings.SECRET_KEY,algorithms=["HS256"])
        user_id = decoded_data['user_id']
        exp = decoded_data['exp']
        iat = decoded_data['iat']
        print(type(exp))
        print(type(iat))
    except:
        pass
    data = {
        'user_id' : user_id,
        'username' : request.data['username'],
        'access_token' : access_token,
        'refresh_token' : refresh_token,
        'exp' : exp,
        'iat' : iat
        }
    serializer = SessionTableSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
    else:
        return Response(status=401)
    return Response(data)

    


@api_view(['POST'])
def decode_jwt_example(request):
    response_data = {}
    if request.method == "POST":
        response_data['access_token'] = request.data['access_token']
        print(response_data['access_token'])
        try:
            decoded_data = jwt.decode(jwt=request.data['access_token'],key=settings.SECRET_KEY,algorithms=["HS256"])
            print(decoded_data['user_id'])
            timestamp_now = dt.now().replace(microsecond=0)
            #converting int timestamp into date and time
            timestamp_exp = dt.fromtimestamp(int(decoded_data['exp']))
            print(timestamp_now < timestamp_exp)
            print(timestamp_now)   
            print(timestamp_exp)
        except:
            return Response(status=401)
        # response_data['decoded_data'] = decoded_data
    return Response(response_data)

@api_view(['POST'])
def check_access_token(request):
    if request.method == "POST":
        #WAS WORKING HERE BITCH
        access_token = request.data['access_token']
        sessiontable_instance = SessionTable.objects.filter(access_token=access_token)
        serializer = SessionTableSerializer(sessiontable_instance,many=True)
        try:
            decoded_data = jwt.decode(jwt=access_token,key=settings.SECRET_KEY,algorithms=["HS256"])
            requested_user_id = decoded_data['user_id']
            if(serializer.data == []):
                return Response(status=401)
            else:   
                return Response(serializer.data[0])
                return Response(status=200)
        except:
            print("ACCESS TOKEN HAS EXPIRED")
            #if access token expires or isn't valid
            #renew new access token
            if(serializer.data != []):
                print('ACCESS TOKEN FOUND')
                renew_new_access_token(serializer.data[0]['refresh_token'])
            else:
                print('ACCESS TOKEN NOT FOUND YOU ARE HACKER')
            return Response(status=401)
        return Response(status=200)

def renew_new_access_token(refresh_token):
    print("RENEWING ACCESS TOKEN")
    response = requests.post("http://127.0.0.1:8000/api/token/refresh/",data={'refresh' :refresh_token})
    print(response.json())
    #update in database
    #i was working here
    return response.json()
        


    

#{"username": "a", "password": "123"}