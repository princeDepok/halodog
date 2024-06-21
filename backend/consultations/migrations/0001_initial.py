# Generated by Django 4.2.2 on 2024-06-20 20:33

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Doctor',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('rating', models.FloatField()),
                ('specialty', models.CharField(max_length=255)),
                ('description', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='ConsultationPackage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('duration', models.IntegerField(choices=[(5, '5 minutes'), (10, '10 minutes'), (15, '15 minutes'), (20, '20 minutes')])),
                ('mode', models.CharField(choices=[('msg', 'Messaging'), ('voice', 'Voice Call'), ('video', 'Video Call')], max_length=5)),
                ('doctor', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='packages', to='consultations.doctor')),
            ],
        ),
    ]