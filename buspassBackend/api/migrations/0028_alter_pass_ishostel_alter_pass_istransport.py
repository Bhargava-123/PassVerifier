# Generated by Django 4.2.3 on 2023-08-11 17:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0027_alter_pass_ishostel_alter_pass_istransport'),
    ]

    operations = [
        migrations.AlterField(
            model_name='pass',
            name='isHostel',
            field=models.BooleanField(),
        ),
        migrations.AlterField(
            model_name='pass',
            name='isTransport',
            field=models.BooleanField(),
        ),
    ]
