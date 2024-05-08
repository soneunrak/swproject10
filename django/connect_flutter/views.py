from rest_framework import generics
from .models import Message
from .serializers import MessageSerializer
from django.http import JsonResponse 
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
