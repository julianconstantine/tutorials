from django.conf.urls import url
from . import views

urlpatterns = [
    url(regex=r'^$', view=views.post_list, name='post_list'),
    url(regex=r'^post/(?P<pk>[0-9]+)/$', view=views.post_detail, name='post_detail'),
]