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
from buspassBackend.settings import BASE_URL

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

def get_access_from_header(request):
    return request.headers.get("Authorization",None)[7::]


@api_view(['GET'])
def get_pass_details(request,pk):
    try:
        access_token = get_access_from_header(request)
    except:
        return Response(status=401)
    if(check_token(access_token)):
        pass_instance = Pass.objects.filter(bio_id=pk)
        serializer = PassSerializer(pass_instance,many=True)
        return Response(serializer.data)
    else:
        return Response(status=401)

@api_view(["GET"])
def get_scan_logs(request,date):
    access_token = get_access_from_header(request)
    if(check_token(access_token)):
        scanLog_instance = ScanLog.objects.filter(scan_date=date)
        serializer = ScanLogSerializer(scanLog_instance,many=True)
        return Response(serializer.data)
    else:
        return Response(status=401)

@api_view(["POST","GET"])
def post_scan_logs(request,date):
    access_token = get_access_from_header(request)
    if(check_token(access_token)):
        serializer = ScanLogSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"Success": "Full"})
        return Response({'date' : date})
    else:
        return Response(status=401)
        
        
@api_view(['POST'])
def login(request):
    if(request.method == 'POST'):
        response = requests.post(BASE_URL+"token/",data=request.data)
        if(response.status_code == 401):
            return Response(status=401)
        elif(response.status_code == 200):
            access_token = response.json()['access']
            decoded_data = jwt.decode(jwt=access_token,key=settings.SECRET_KEY,algorithms=['HS256'])
            user_id = decoded_data['user_id']
            exp = decoded_data['exp']
            iat = decoded_data['iat']
            data = {
            'user_id' : user_id,
            'username' : request.data['username'],
            'access_token' : access_token,
            'exp' : exp,
            'iat' : iat
            }
            serializer = SessionTableSerializer(data=data)
            if serializer.is_valid():
                serializer.save()
            else:
                return Response(status=500)
            return Response(data)

@api_view(['POST'])
def logout(request):
    user_id = get_user_id(request.data['access'])
    print(user_id)
    user_id_entry = SessionTable.objects.filter(user_id=user_id)
    if user_id_entry.exists():
        user_id_entry.delete()
        return Response(status=200)
    else:
        return Response(status=401)

#check if the access token in the Shared Preference is valid before getting into the app
@api_view(['POST'])
def check_access_token(request):
    if request.method == "POST":
        if SessionTable.objects.filter(access_token=request.data['access']).exists():
            try:
                decoded_data = jwt.decode(jwt=request.data['access'],key=settings.SECRET_KEY,algorithms=['HS256'])
                return Response(status=200)
            except:
                return Response(status=401)
        else:
            return Response(status=401)

#to get token from header and check if the token is valid before returning data in reponse
def check_token(access_token):
    if SessionTable.objects.filter(access_token=access_token).exists():
        try:
            decoded_data = jwt.decode(jwt=access_token,key=settings.SECRET_KEY,algorithms=['HS256'])
            return True
        except:
            return False
    else:
        return False



    

def get_user_id(token):
    decoded_data = jwt.decode(jwt=token,key=settings.SECRET_KEY,algorithms=['HS256'],options={"verify_signature" :False})
    return decoded_data['user_id']
    
def get_refresh_token_for_access_token(access_token):
    return SessionTableSerializer(SessionTable.objects.filter(access_token=access_token),many=True).data[0]['refresh_token']

    


