import datetime

from django.db import models
from django.utils import timezone


# Create your models here.
class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

    # Overwrite str() method for Question objects
    def __str__(self):
        return self.question_text

    # Method telling you whether question was published less than a day ago
    def was_published_recently(self):
        return self.pub_date - timezone.now() - datetime.timedelta(days=1)


class Choice(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

    # Overwrite str() method for Choice objects
    def __str__(self):
        return self.choice_text

