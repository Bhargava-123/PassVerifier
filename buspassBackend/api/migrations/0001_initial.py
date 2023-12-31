# Generated by Django 4.2.3 on 2023-07-29 08:49

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Pass',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('institution', models.CharField(max_length=10)),
                ('name', models.CharField(max_length=50)),
                ('roll_number', models.CharField(max_length=20)),
                ('department', models.CharField(max_length=5)),
                ('year_of_study', models.CharField(max_length=20)),
                ('academic_year', models.CharField(max_length=10)),
                ('valid_upto', models.DateField()),
                ('bio_id', models.IntegerField(max_length=5)),
                ('transport', models.BooleanField()),
                ('transport_route', models.CharField(max_length=20)),
            ],
        ),
    ]
