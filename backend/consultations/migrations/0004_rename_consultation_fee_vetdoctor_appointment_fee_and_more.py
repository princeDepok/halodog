# Generated by Django 5.0.6 on 2024-07-11 10:41

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('consultations', '0003_speciality_vetdoctor_and_more'),
    ]

    operations = [
        migrations.RenameField(
            model_name='vetdoctor',
            old_name='consultation_fee',
            new_name='appointment_fee',
        ),
        migrations.AddField(
            model_name='vetdoctor',
            name='chat_consultation_fee',
            field=models.DecimalField(blank=True, decimal_places=2, max_digits=6, null=True),
        ),
        migrations.AddField(
            model_name='vetdoctor',
            name='range_fee',
            field=models.CharField(blank=True, max_length=50, null=True),
        ),
        migrations.AddField(
            model_name='vetdoctor',
            name='voice_call_consultation_fee',
            field=models.DecimalField(blank=True, decimal_places=2, max_digits=6, null=True),
        ),
    ]
