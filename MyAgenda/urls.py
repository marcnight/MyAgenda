from django.urls import path
from . import views

urlpatterns = [
    path('', views.homepage, name='homepage'),
    path('cadastro/', views.cadastro, name='cadastro'),
    path('login/', views.login_view, name='login'),
    path('logado/', views.logado, name='logado'),
    path('compromisso/', views.compromisso, name='compromisso'),
    path('anotacao/', views.anotacao, name='anotacao'),
    path('logout/', views.logout_view, name='logout'),
]
