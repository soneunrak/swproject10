'''
!git clone https://github.com/openai/whisper.git
%cd whisper

!pip install -r requirements.txt
%cd ..

!python -m whisper.whisper --model tiny --task transcribe 2056B6134C5A45F268.wav
'''

# 위가 원본 코드, 밑이 함수화(저장 기능 추가)
# .wav/.mp3는 sampledata폴더 안에 있는 음성파일 사용하시면 됩니다.

import subprocess

# 음성 파일을 텍스트로 변환하는 함수
def transcribe_audio(model, audio_file):
    result = subprocess.run(
        ['python', '-m', 'whisper', '--model', model, '--task', 'transcribe', audio_file],
        text=True,
        capture_output=True  # 결과를 캡처
    )
    return result.stdout

# Whisper 모델로 오디오 파일 변환 실행
transcription_result = transcribe_audio('tiny', '2056B6134C5A45F268.wav') # .wav는 test파일 넣으시면 됩니다.

# 결과를 파일로 저장
with open('/content/transcription_result.txt', 'w', encoding='utf-8') as file:
    file.write(transcription_result)

# 저장된 결과 파일 출력
print("Transcription has been saved to 'transcription_result.txt'. Here's the content:")
with open('/content/transcription_result.txt', 'r', encoding='utf-8') as file:
    print(file.read())