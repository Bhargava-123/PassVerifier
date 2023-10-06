from django.urls import path
from . import views

urlpatterns = [
    path('get-pass-details/<int:pk>/',views.get_pass_details),
    path('get-scan-log/<str:date>/',views.get_scan_logs),
    path('post-scan-log/<str:date>/',views.post_scan_logs),

    # path('authenticate/',views.authenticate_user),
    
    # get username and passowrd, ping to api/token and generate access and refresh token and send back to frontend, add to session table
    path('login/',views.login),

    #decode access-token and return 200 if valid 401 if invalid
    path('check-access-token/',views.check_access_token),

    # #decode refresh-tokne and return 200 if valid 401 if invalid
    path('check-refresh-token/',views.check_refresh_token),
    # check the expiry of refresh token
    # #remove the user id entry from the table
    path('logout/',views.logout),

    path('check-token-validity/',views.check_token_validity),
    path('get-user-id/',views.get_user_id),
    
    # # get refresh token as request, check its validity
    # #generate new accesss and refresh token - update in session table
    # path('new-access-token/'),

    # path('decode-jwt/',views.decode_jwt_example),
    # path('check-access-token/',views.check_access_token)
    
]


