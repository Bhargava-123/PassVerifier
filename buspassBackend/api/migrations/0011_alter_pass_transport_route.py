# Generated by Django 4.2.3 on 2023-07-29 15:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0010_alter_pass_transport_route'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pass',
            name='transport_route',
            field=models.CharField(blank=True, default='NULL', max_length=20),
        ),
    ]
