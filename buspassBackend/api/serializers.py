from rest_framework import serializers
from .models import Pass,ScanLog

class PassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pass
        fields = "__all__"

class ScanLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = ScanLog
        fields = "__all__"

