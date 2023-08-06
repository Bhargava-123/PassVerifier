from django.urls import path
from . import views

urlpatterns = [
    path('get-pass-details/<int:pk>/',views.get_pass_details),
    path('get-scan-log/<str:date>/',views.get_scan_logs),
    path('post-scan-log/<int:pk>/',views.post_scan_logs),
    path('authenticate/',views.authenticate_user)
]


