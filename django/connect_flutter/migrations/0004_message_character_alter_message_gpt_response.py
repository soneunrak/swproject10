# Generated by Django 5.0.4 on 2024-06-14 10:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('connect_flutter', '0003_message_gpt_response'),
    ]

    operations = [
        migrations.AddField(
            model_name='message',
            name='character',
            field=models.CharField(default='의사소통 전문가 김교수', max_length=100),
        ),
        migrations.AlterField(
            model_name='message',
            name='gpt_response',
            field=models.TextField(blank=True, null=True),
        ),
    ]