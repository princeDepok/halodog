# Generated by Django 5.0.6 on 2024-07-11 08:10

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0006_pet'),
    ]

    operations = [
        migrations.AddField(
            model_name='pet',
            name='photo',
            field=models.ImageField(blank=True, null=True, upload_to='pet_photos/'),
        ),
    ]
