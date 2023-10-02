from django.urls import path
from . import views

urlpatterns = [
    path('get-pass-details/<int:pk>/',views.get_pass_details),
    path('get-scan-log/<str:date>/',views.get_scan_logs),
    path('post-scan-log/<str:date>/',views.post_scan_logs),
    path('authenticate/',views.authenticate_user),
    path('decode-jwt/',views.decode_jwt_example),
    path('check-access-token/',views.check_access_token)
    
]


