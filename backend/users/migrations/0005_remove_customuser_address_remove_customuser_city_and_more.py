# Generated by Django 5.0.6 on 2024-07-06 07:55

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0004_rename_birth_place_customuser_address_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='customuser',
            name='address',
        ),
        migrations.RemoveField(
            model_name='customuser',
            name='city',
        ),
        migrations.RemoveField(
            model_name='customuser',
            name='district',
        ),
        migrations.RemoveField(
            model_name='customuser',
            name='phone_number',
        ),
        migrations.RemoveField(
            model_name='customuser',
            name='province',
        ),
        migrations.RemoveField(
            model_name='customuser',
            name='village',
        ),
    ]