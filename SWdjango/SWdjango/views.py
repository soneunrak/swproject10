# views.py

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

@csrf_exempt
def receive_message(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        message = data.get('message')

        # 여기에 메시지를 저장하거나 처리하는 코드를 작성하세요

        return JsonResponse({'success': True})
    else:
        return JsonResponse({'success': False, 'error': 'Invalid request method'})
