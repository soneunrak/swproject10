from django.db import models

class Message(models.Model):
    content = models.TextField()
    character = models.CharField(max_length=100, default='의사소통 전문가 김교수')  # 기본값 추가
    gpt_response = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.content