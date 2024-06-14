# views.py

from rest_framework import generics
from .models import Message
from .serializers import MessageSerializer
from django.http import JsonResponse 
import openai

API_KEY = ''
openai.api_key = API_KEY

# 캐릭터 정보를 미리 정의
CHARACTERS = {
    '의사소통 전문가 김교수 (Professor Kim, Communication Expert)': {
        'personality': '이해심 많고 설득력이 뛰어나며, 상대방의 감정을 잘 이해하고 존중하는 성격. 상대방의 말을 주의 깊게 듣고, 그들의 관점을 존중하며 반응하는 태도를 지님.',
        'speech_style': '명확하고 이해하기 쉬운 언어를 사용하며, 비유와 예시를 통해 복잡한 개념을 쉽게 설명. 상대방의 의견을 적극적으로 경청하고, 이를 반영하여 설득력 있는 대화를 이어감.',
        'role_model': '세계적인 의사소통 전문가로서, 다양한 문화와 배경을 가진 사람들과 효과적으로 소통할 수 있는 능력을 갖춤.',
        'gender': 'female'
    },
    '혁신가 이박사 (Dr. Lee, Innovator)': {
        'personality': '창의적이고 도전적인 성격으로, 항상 새로운 아이디어와 접근 방식을 탐구하며 문제 해결에 접근. 위험을 감수하고 새로운 것을 시도하는 것을 두려워하지 않음.',
        'speech_style': '신선하고 혁신적인 아이디어를 제시하며, 복잡한 내용을 쉽게 설명하는 능력이 뛰어남. 청중을 사로잡는 열정적인 발표 스타일을 지니고 있음.',
        'role_model': '실리콘밸리의 창업자로서, 기술 혁신과 창업 문화에 깊은 이해를 가지고 있으며, 글로벌 무대에서 활약 중.'
    },
    '건강 전문가 박트레이너 (Trainer Park, Health Expert)': {
        'personality': '활기차고 긍정적인 성격으로, 주변 사람들에게 항상 긍정적인 에너지를 전파함. 사람들의 건강과 웰빙을 위해 헌신하며, 지속적인 동기부여를 제공.',
        'speech_style': '항상 격려하고 동기부여하는 말투를 사용하며, 건강과 웰빙에 대한 열정을 전파. 실제 사례와 경험을 통해 사람들에게 실질적인 도움을 주는 조언을 제공.',
        'role_model': '유명 헬스 트레이너로서, 다양한 연령대와 체력 수준의 사람들을 지도하며, 그들의 건강 목표를 달성하도록 지원.'
    }
}

def gpt_send(prompt, personality, speech_style, character, role_model):
    formatted_prompt = f'''당신은 {character}입니다. 성격은 {personality}, 말투는 {speech_style}, 역할 모델은 {role_model}입니다.
    당신의 역할은 사용자와 대화하면서 그들의 질문에 답변하는 것입니다.
    간단한 자기소개 이후 사용자가 어떤 질문을 하든지, 당신의 성격과 말투를 반영하여 대답하세요.
    이모티콘을 사용하지 마세요. 자세한 설명이 필요한 답변이 아니라면 짧고 간결하게 대답하세요. 매번 인사를 반복하지 마세요.
    if you don't know the answer just say you don't know, don't make it up
    사용자: {prompt}
    {character}:'''
    print(formatted_prompt)
    try:
        response = openai.ChatCompletion.create(
            model="gpt-4o",
            messages=[
                {"role": "system", "content": formatted_prompt}
            ],
            max_tokens=150,  # 응답 길이를 제한하기 위해 토큰 수 조정
            temperature=0.5,  # 다양성을 줄임
            frequency_penalty=0.5,  # 반복을 줄임
            presence_penalty=0.6,  # 새로운 정보를 생성할 확률을 높임
        )
        response_message = response.choices[0].message['content'].strip()
        print(response_message)
        return response_message
    except Exception as e:
        print(f"Error in GPT request: {e}")
        raise 

class MessageAPI(generics.ListCreateAPIView):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer

    def post(self, request, *args, **kwargs):
        print("Request data:", request.data)  # 요청 데이터 출력
        serializer = self.get_serializer(data=request.data)
        if not serializer.is_valid():
            print("Invalid data:", serializer.errors)  # 오류 출력
            return JsonResponse({'error': serializer.errors}, status=400)
        
        self.perform_create(serializer)

        prompt = request.data.get('content', '')
        character = request.data.get('character', '')  # 변경된 부분: 기본 값 설정
        personality = request.data.get('personality', '')  # 변경된 부분: 기본 값 설정
        speech_style = request.data.get('speechStyle', '')  # 변경된 부분: 기본 값 설정

        if not prompt or not character or not personality or not speech_style:
            return JsonResponse({'error': 'Missing required fields: content, character, personality, speechStyle'}, status=400)
        
        role_model = CHARACTERS.get(character, {}).get('role_model', '')

        try:
            gpt_response = gpt_send(prompt, personality, speech_style, character, role_model)  # 변경된 부분: gpt_send 함수 호출 시 추가된 인자 전달
            serializer.validated_data['gpt_response'] = gpt_response
            serializer.save()
        except Exception as e:
            print(f"Error: {e}")  # 오류 출력
            return JsonResponse({'error': str(e)}, status=500)

        headers = self.get_success_headers(serializer.data)
        return JsonResponse(serializer.data, status=201, headers=headers)
