# views.py

from rest_framework import generics
from .models import Message
from .serializers import MessageSerializer
from django.http import JsonResponse 
from django.views.decorators.csrf import csrf_exempt
import openai

openai.api_key = ''

def gpt_send(prompt): 
    print(prompt) 
    query = openai.ChatCompletion.create( 
        model="gpt-3.5-turbo",
        messages=[
            {'role':'user','content': prompt}
        ], 
        max_tokens=1024, 
        n=1, 
        stop=None, 
        temperature=0.5, 
    ) 
    response = query.choices[0].message["content"]
    print(response) 
    return response 

class MessageAPI(generics.ListCreateAPIView):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)

        prompt = request.data['content']        
        gpt_response = gpt_send(prompt)
        serializer.validated_data['gpt_response'] = gpt_response
        serializer.save()

        headers = self.get_success_headers(serializer.data)
        return JsonResponse(serializer.data, status=201, headers=headers)

# 음성 파일을 텍스트로 변환하는 뷰
@csrf_exempt
def audio_to_text(request):
    if request.method == 'POST' and request.FILES.get('audio'):
        audio_file = request.FILES['audio']
        
        # 가정: OpenAI Whisper 모델을 사용하여 음성을 텍스트로 변환
        text = "Decoded text from audio"  # 임시 음성 인식 결과
        return JsonResponse({'text': text}, status=200)
    else:
        return JsonResponse({'error': 'No audio file provided'}, status=400)