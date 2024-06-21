# Generated by Django 4.2.2 on 2024-06-20 12:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0003_remove_customuser_name'),
    ]

    operations = [
        migrations.RenameField(
            model_name='customuser',
            old_name='birth_place',
            new_name='address',
        ),
        migrations.RemoveField(
            model_name='customuser',
            name='birth_date',
        ),
        migrations.RemoveField(
            model_name='customuser',
            name='gender',
        ),
        migrations.AddField(
            model_name='customuser',
            name='city',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
        migrations.AddField(
            model_name='customuser',
            name='district',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
        migrations.AddField(
            model_name='customuser',
            name='province',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
        migrations.AddField(
            model_name='customuser',
            name='village',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]
