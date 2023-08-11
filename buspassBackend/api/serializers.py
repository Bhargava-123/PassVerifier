from rest_framework import serializers
from .models import Pass,ScanLog,User

class PassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pass
        fields = "__all__"

class ScanLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = ScanLog
        fields = ["scan_date","scan_time","bio_id"]
        exclude_fields = ['id']

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = "__all__"

