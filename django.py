from django.shortcuts import render
from django.http import HttpResponse,JsonResponse,HttpResponseRedirect

# 主页视图，如果未登录跳转到login登陆页面
def index(request):
    # 如果没有获取到session键is_login,则跳转到login页面
    if not request.session.get('is_login', None):
        return HttpResponseRedirect('/login/')
    else:
        # 获取当前页面的session键user_name，如果没有为None
        username = request.session.get('user_name',None)
        content = {
            'title':'主页',
            'username': username,
        }
        return render(request,'userinfo/main.html',locals())

# 退出登录
def logout(request):
    if not request.session.get('is_login', None):
    # 如果本来就未登录，也就没有登出一说
        return HttpResponseRedirect("/login/")
    request.session.flush()
    return HttpResponseRedirect("/login/")

# 登录页面
def login(request):
    # 如果已经登录，跳转至首页 不允许重复登录
    if request.session.get('is_login', None):  
        return HttpResponseRedirect('/')
    # 如果请求的方式是POST，验证账号密码，成功后跳转首页
    elif request.method == 'POST':
        try:
            m = UserInfo.objects.get(username=request.POST['username'])
            if m.userpasswd == request.POST['userpasswd']:
                # 如果验证成功，向session写入如下信息
                request.session['is_login'] = True
                request.session['user_id'] = m.id
                request.session['user_name'] = m.username
                # 设定session到期时间，单位秒，0为关闭浏览器即过期，None为永不过期，默认为2周
                # request.session.set_expiry(10)
                return HttpResponseRedirect('/')
            else:
                return HttpResponse("请检查你密码")
        except UserInfo.DoesNotExist as e:
            return HttpResponse("请检查你的账号与密码%s"% e)
    # 否则 展示登陆页面
    else:
        return render(request,'userinfo/login.html',{'title':'登录'})



# 上传文件需要引入settings中的MDEIA_ROOT路径
from django.conf import settings
# 用来确定存放文件的具体路径
import os
# 上传文件的页面
def UUP(request):
    return render(request,'userinfo/upfile.html')
# 接受上传文件的请求
def upfile(request):
    if request.method == 'POST':
        print('1')
        # 取传过来的文件
        f = request.FILES["userImg"]
        # 取传过来的文件的文件名
        filename = f.name
        print('2')
        # 括号内前者是媒体文件的存放路径，后者是文件名，userimg确定了绝对路径
        userImg = os.path.join(settings.MDEIA_ROOT, filename)
        print('3')
        with open(userImg, 'wb+') as destination:
            for chunk in f.chunks():
                destination.write(chunk)
        return HttpResponse('NICE')

==============================================================================================
from django.shortcuts import render

from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from .forms import NameForm
import json
from django.views.decorators.csrf import csrf_exempt
from django.contrib import auth
from django.contrib.auth.decorators import login_required

# Create your views here.

def home(request):
    # 此函数返回布尔值，用来判断用户是否登录
    if request.user.is_authenticated:
        name = request.user.username
        return HttpResponse('用户"%s"已登陆' % name)
    else:
        return HttpResponseRedirect('/login/')

    
# @csrf_exempt
# def home(request):
#     # if this is a POST request we need to process the form data
#     if request.method == 'POST':
#         # create a form instance and populate it with data from the request:
#         form = NameForm(request.POST)
#         # check whether it's valid:
#         if form.is_valid():

#             info = form.cleaned_data
#             userInfo = {
#                 'subject': info['subject'],
#                 'email': info['email'],
#                 'message': info['message'],
#             }
#             return JsonResponse(userInfo)

#     # if a GET (or any other method) we'll create a blank form
#     else:
#         content = '首页'
#         form = NameForm()
#     return render(request, 'formApp/index.html', locals())

def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username', '')
        password = request.POST.get('userpw', '')
        print(username,password)
        user = auth.authenticate(username=username, password=password)
        if user is not None and user.is_active:

            # 密码验证成功并且标记为活动用户
            auth.login(request, user)
            # 此处我重定向至首页
            return HttpResponseRedirect('/')

        else:
            # Show an error page
            return HttpResponse('登陆失败')
       
    else:
        content = '首页'
        form = NameForm()
        return render(request, 'formApp/index.html', locals())

def logout_view(request):

    #清除了cookie和session，清除了当前的用户，
    auth.logout(request)

    # 此处可重定向至登录页
    return HttpResponse('已成功退出登录')

# 测试需要登陆才能访问的页面，添加装饰器login_required,可传入参数，如果未登录跳转至登录页
@login_required(login_url='/login/')
def securityPage(request):
    return HttpResponse('这是只有已登录用户才能访问的页面')