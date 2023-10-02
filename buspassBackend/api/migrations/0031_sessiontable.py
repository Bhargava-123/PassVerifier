# Generated by Django 4.2.3 on 2023-10-02 11:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0030_scanlog_student_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='SessionTable',
            fields=[
                ('user_id', models.IntegerField(primary_key=True, serialize=False)),
                ('username', models.CharField(max_length=255)),
                ('access_token', models.CharField(max_length=1000)),
                ('refresh_token', models.CharField(max_length=1000)),
                ('exp', models.IntegerField()),
                ('iat', models.IntegerField()),
            ],
        ),
    ]
