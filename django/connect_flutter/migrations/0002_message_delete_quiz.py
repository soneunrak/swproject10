# Generated by Django 4.2.7 on 2024-04-25 06:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('connect_flutter', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Message',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('content', models.TextField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
        ),
        migrations.DeleteModel(
            name='Quiz',
        ),
    ]
