# Generated by Django 5.0.6 on 2024-07-11 14:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('bookings', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='booking',
            name='package',
            field=models.CharField(max_length=250),
        ),
    ]
