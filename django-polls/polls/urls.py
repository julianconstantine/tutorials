from django.conf.urls import url
from . import views

# Set the polls application namespace for use in the Django project
app_name = 'polls'

# URLPATTERNS WITH GENERIC VIEWS
urlpatterns = [
    url(r'^$', views.IndexView.as_view(), name='index'),
    # Note: <question_id> has changed to <pk> in the second/third regexes
    url(r'^(?P<pk>[0-9]+)/$', views.DetailView.as_view(), name='detail'),
    url(r'^(?P<pk>[0-9]+)/results/$', views.ResultsView.as_view(), name='results'),
    url(r'^(?P<question_id>[0-9]+)/vote/$', views.vote, name='vote')
]

# OLD URLPATTERNS SANS GENERIC VIEWS
# urlpatterns = [
#     # ex: /polls/
#     url(r'^$', views.index, name='index'),
#
#     # ex: /polls/5/
#     # the 'name' value as called by the {% url %} template tag
#     url(r'^(?P<question_id>[0-9]+)/$', views.detail, name='detail'),
#
#     # ex: /polls/5/results/
#     url(r'^(?P<question_id>[0-9]+)/results/$', views.results, name='results'),
#
#     # ex: /polls/5/vote/
#     url(r'^(?P<question_id>[0-9]+)/vote/$', views.vote, name='vote'),
# ]
