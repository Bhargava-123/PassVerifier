# Generated by Django 4.2.3 on 2023-07-29 14:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0005_rename_year_of_study_pass_year'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pass',
            name='department',
            field=models.CharField(max_length=20),
        ),
    ]