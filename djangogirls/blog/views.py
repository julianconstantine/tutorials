from django.shortcuts import render, get_object_or_404
from django.utils import timezone
from .models import Post  # Remember: views connect models (e.g. Post to templates!)


# Create your views here.
def post_list(request):
    posts = Post.objects.filter(published_date__lte=timezone.now()).order_by('published_date')
    return render(request=request, template_name='blog/post_list.html', context={'posts': posts})


def post_detail(request, pk):
    post = get_object_or_404(klass=Post, pk=pk)
    return render(request=request, template_name='blog/post_detail.html', context={'post': post})
