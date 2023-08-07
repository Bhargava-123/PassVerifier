# Generated by Django 4.2.3 on 2023-08-07 08:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0018_rename_scanuser_user'),
    ]

    operations = [
        migrations.RenameField(
            model_name='pass',
            old_name='transport',
            new_name='isTransport',
        ),
        migrations.RemoveField(
            model_name='pass',
            name='academic_year',
        ),
        migrations.AddField(
            model_name='pass',
            name='hostel_room',
            field=models.CharField(blank=True, default='NULL', max_length=20),
        ),
        migrations.AddField(
            model_name='pass',
            name='image_url',
            field=models.URLField(default=None),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='pass',
            name='isHostel',
            field=models.BooleanField(default=None),
            preserve_default=False,
        ),
    ]
