from django.db import models

class Message(models.Model):
    content = models.TextField()
    gpt_response = models.TextField(blank=True)  # GPT 응답을 저장할 필드 추가
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.content
