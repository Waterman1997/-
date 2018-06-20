echo off
mode con lines=31 cols=60
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
set hostsfile="%SYSTEMROOT%\System32\Drivers\etc\hosts"
set dowhosts="%temp%\dowhosts.vbs"
title Hosts远程下载更新
:main
cls
color 5f
echo.
echo  √    √     √√√      √√√√  √√√√√    √√√√
echo  √    √   √      √  √      √  √  √  √  √      √
echo  √    √   √      √  √              √      √
echo  √√√√   √      √    √√          √        √√
echo  √    √   √      √        √        √            √
echo  √    √   √      √          √      √              √
echo  √    √   √      √  √      √      √      √      √
echo  √    √     √√√     √√√√       √       √√√√
echo.
echo.----------------------------------------------------------- 
echo. 360、电脑管家等安全软件提醒，请勾选信任允许和不再提醒！
echo.
echo. 如果自己修改过hosts信息，请复制到 defined_hosts.txt
echo.【defined_hosts.txt】文件可自定义hosts，更新会自动合并。
if not exist defined_hosts.txt goto defined_hosts >NUL 2>NUL
echo.
echo. 如长时间停在“正在下载” 请编辑本批处理(84行)hosts链接
echo.
echo. 警告：执行该命令 您的 HOSTS 会将被自动替换覆盖！
echo.-----------------------------------------------------------
echo. 请选择使用：
echo.
echo.
echo.      [1] 远程下载最新 HOSTS      [2] 恢复初始 HOSTS
echo.
echo.-----------------------------------------------------------
if exist "%SystemRoot%\System32\choice.exe" goto Choice

set /p choice=请输入选项并按回车键确认:

echo.
if %choice%==1 goto host DNS
if %choice%==2 goto CL
cls
"set choice="
echo 您输入有误，请重新选择。
ping 127.0.1 -n "2">nul
goto main

:Choice
choice /c 12 /n /m "请输入您的选择："
if errorlevel 2 goto CL
if errorlevel 1 goto host DNS
cls
goto main

:host DNS
echo.
echo 正在下载 Hosts ......
if exist host ( del /f /q host )
if exist host1 ( del /f /q host1 )
if exist host2 ( del /f /q host2 )
if exist host3 ( del /f /q host3 )
if exist hosts ( del /f /q hosts )
if exist %dowhosts% ( del /f /q %dowhosts% )
echo Sub download(url,target) > %dowhosts%
echo 	Const adTypeBinary = 1 >> %dowhosts%
echo 	Const adSaveCreateOverWrite = 2 >> %dowhosts%
echo 	Dim http,ado >> %dowhosts%
echo 	Set http = CreateObject("Msxml2.XMLHTTP") >> %dowhosts%
echo 	http.open "GET",url,False >> %dowhosts%
echo 	http.send >> %dowhosts%
echo 	Set ado = createobject("Adodb.Stream") >> %dowhosts%
echo 	ado.Type = adTypeBinary >> %dowhosts%
echo 	ado.Open >> %dowhosts%
echo 	ado.Write http.responseBody >> %dowhosts%
echo 	ado.SaveToFile target >> %dowhosts%
echo 	ado.Close >> %dowhosts%
echo End Sub >> %dowhosts%
::
:: 以下网址为hosts远程连接，如果失效请自行修改。
:: 
echo download "https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts","%cd%\host" >> %dowhosts%
echo download "https://raw.githubusercontent.com/racaljk/hosts/master/hosts","%cd%\host2" >> %dowhosts%
:: 去广告
:: echo download "https://raw.githubusercontent.com/vokins/yhosts/master/hosts","%cd%\host3" >> %dowhosts%
::
::
%dowhosts%
if not exist host goto nohost >NUL 2>NUL
type defined_hosts.txt>>hosts&&echo.>>hosts&&echo.>>hosts&&echo.>>hosts&&echo.>>hosts&&type host>>hosts
if exist host1 ( copy/ b /y hosts+host1 ) >NUL 2>NUL
if exist host2 ( copy/ b /y hosts+host2 ) >NUL 2>NUL
if exist host3 ( copy/ b /y hosts+host3 ) >NUL 2>NUL
if exist host ( del /f /q host ) >NUL 2>NUL
if exist host1 ( del /f /q host1 ) >NUL 2>NUL
if exist host2 ( del /f /q host2 ) >NUL 2>NUL
if exist host3 ( del /f /q host3 ) >NUL 2>NUL
cls
echo.-----------------------------------------------------------
echo.
copy /y "hosts" %hostsfile%
::刷新 DNS 解析缓存
ipconfig /flushdns
del /f /q hosts>NUL 2>NUL
del /f /q %dowhosts%>NUL 2>NUL
echo.-----------------------------------------------------------
echo.
echo 覆盖本地hosts并刷新本地DNS解析缓存成功!
echo 现在去打开Google、Twitter、Facebook、Gmail、谷歌学术吧！
echo.谷歌这些网站记得使用https进行加密访问！
echo.
echo.即：https://www.google.com
echo.
echo.或者：https://www.google.com/ncr
echo.      https://www.google.com.hk/ncr
echo.
echo.-----------------------------------------------------------
goto end

:CL
cls
echo.-----------------------------------------------------------
echo.
echo # Localhost (DO NOT REMOVE)>%hostsfile%&&echo.>>%hostsfile%&&echo 127.0.0.1 localhost>>%hostsfile%&&echo ::1 localhost ip6-localhost ip6-loopback>>%hostsfile%&&echo.>>%hostsfile%
echo 恭喜您，hosts恢复初始成功!
echo.
echo.-----------------------------------------------------------
goto end

:end
ping 127.0.1 -n "5">nul
exit

echo 请按任意键退出。
Pause>nul

:configowner
cls
echo 配置hosts文件的所有者
echo.
echo 请执行下面步骤：
echo.
echo 1) 右键hosts文件，点击“属性”菜单命令
echo 2) 在属性对话框里，选择“安全”选项卡，点下方的“高级”按钮
echo 3) 在出现的新窗口里，点击第二行“所有者”右边蓝色的“更改”文本链接
echo 4) 在“选择用户或组”对话框下面的文本框里输入“administrators”，点“确定”
echo 5) 回到其他窗口里，继续点“确定”完成配置
echo.
echo 提示：若看不见hosts文件，请选择主菜单的“6.显示隐藏文件”，然后刷新文件夹。
ping 127.1 -n 2 >nul
start "" explorer.exe /select,%hostsfile%

:defined_hosts
echo #用户自定义hosts，建议使用notepad++编辑器编辑>>defined_hosts.txt&&echo #请在本行后填入自定义hosts>>defined_hosts.txt&&echo.>>defined_hosts.txt&&echo.>>defined_hosts.txt&&echo.>>defined_hosts.txt
goto main

:nohost
cls
echo.-----------------------------------------------------------
echo.
echo.
echo  出错啦！未下载到最新的hosts，请重新编辑批处理内的链接。
echo.
echo.-----------------------------------------------------------
echo.
echo.
echo 请按任意键退出。
Pause>nul
exit
