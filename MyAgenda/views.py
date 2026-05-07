from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.contrib import messages
from django.core.cache import cache
from .models import Compromisso, Anotacao

def homepage(request):
    return render(request, "MyAgenda.html")

def cadastro(request):
    if request.method == 'POST':
        # Simple rate limiting
        ip = request.META.get('REMOTE_ADDR')
        cache_key = f'cadastro_{ip}'
        if cache.get(cache_key):
            messages.error(request, 'Muitas tentativas. Tente novamente em 1 minuto.')
            return render(request, "Cadastro.html")
        cache.set(cache_key, True, 60)  # 60 seconds
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        if not username or not password:
            messages.error(request, 'Preencha todos os campos!')
            return render(request, "Cadastro.html")
        
        if len(password) < 8:
            messages.error(request, 'A senha deve ter pelo menos 8 caracteres.')
            return render(request, "Cadastro.html")
        
        if password.isdigit() or password.lower() == password or not any(c in '!@#$%^&*()_+-=[]{}|;:,.<>?' for c in password):
            messages.error(request, 'A senha deve conter letras maiúsculas, minúsculas, números e caracteres especiais.')
            return render(request, "Cadastro.html")
        
        try:
            if User.objects.filter(username=username).exists():
                messages.error(request, 'Nome de usuário indisponível. Tente outro.')
                return render(request, "Cadastro.html")
            
            user = User.objects.create_user(username=username, password=password)
            login(request, user)
            messages.success(request, 'Cadastro realizado com sucesso!')
            return redirect('logado')
        except Exception as e:
            messages.error(request, 'Erro ao criar usuário. Tente novamente.')
    
    return render(request, "Cadastro.html")

def login_view(request):
    if request.method == 'POST':
        # Simple rate limiting
        ip = request.META.get('REMOTE_ADDR')
        cache_key = f'login_{ip}'
        attempts = cache.get(cache_key, 0)
        if attempts >= 10:
            messages.error(request, 'Muitas tentativas. Tente novamente em 1 minuto.')
            return render(request, "MyAgenda.html")
        cache.set(cache_key, attempts + 1, 60)  # 60 seconds
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        if not username or not password:
            messages.error(request, 'Preencha todos os campos!')
            return render(request, "MyAgenda.html")
        
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            return redirect('logado')
        else:
            messages.error(request, 'Usuário ou senha inválidos!')
    
    return render(request, "MyAgenda.html")

@login_required
def logado(request):
    compromissos = Compromisso.objects.filter(usuario=request.user).order_by('data')
    anotacoes = Anotacao.objects.filter(usuario=request.user).order_by('-criado_em')
    return render(request, "Logado.html", {'compromissos': compromissos, 'anotacoes': anotacoes})

@login_required
def compromisso(request):
    if request.method == 'POST':
        titulo = request.POST.get('titulocomp')
        descricao = request.POST.get('Descricaocomp')
        data = request.POST.get('Datacomp')
        
        if titulo and descricao and data:
            if len(descricao) > 2000:
                messages.error(request, 'Descrição muito longa. Máximo 2000 caracteres.')
                return render(request, "Compromisso.html")
            Compromisso.objects.create(
                titulo=titulo,
                descricao=descricao,
                data=data,
                usuario=request.user
            )
            messages.success(request, 'Compromisso salvo com sucesso!')
            return redirect('logado')
        else:
            messages.error(request, 'Preencha todos os campos!')
    
    return render(request, "Compromisso.html")

@login_required
def anotacao(request):
    if request.method == 'POST':
        titulo = request.POST.get('titulo')
        texto = request.POST.get('texto')
        
        if titulo and texto:
            if len(texto) > 5000:
                messages.error(request, 'Texto muito longo. Máximo 5000 caracteres.')
                return render(request, "Anotacao.html")
            Anotacao.objects.create(
                titulo=titulo,
                texto=texto,
                usuario=request.user
            )
            messages.success(request, 'Anotação salva com sucesso!')
            return redirect('logado')
        else:
            messages.error(request, 'Preencha todos os campos!')
    
    return render(request, "Anotacao.html")

def logout_view(request):
    if request.method == 'POST':
        logout(request)
        messages.success(request, 'Logout realizado com sucesso!')
    return redirect('homepage')
