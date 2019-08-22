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