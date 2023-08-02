from django.urls import path
from . import views

urlpatterns = [
    path('get-pass-details/<int:pk>/',views.get_pass_details),
]


