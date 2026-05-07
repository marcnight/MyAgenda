from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone

class Compromisso(models.Model):
    titulo = models.CharField(max_length=200)
    descricao = models.TextField()
    data = models.DateField()
    usuario = models.ForeignKey(User, on_delete=models.CASCADE, related_name='compromissos')
    criado_em = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.titulo

class Anotacao(models.Model):
    titulo = models.CharField(max_length=200)
    texto = models.TextField()
    usuario = models.ForeignKey(User, on_delete=models.CASCADE, related_name='anotacoes')
    criado_em = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.titulo
