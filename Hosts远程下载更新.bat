echo off
mode con lines=31 cols=60
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
set hostsfile="%SYSTEMROOT%\System32\Drivers\etc\hosts"
set dowhosts="%temp%\dowhosts.vbs"
title HostsԶ�����ظ���
:main
cls
color 5f
echo.
echo  ��    ��     �̡̡�      �̡̡̡�  �̡̡̡̡�    �̡̡̡�
echo  ��    ��   ��      ��  ��      ��  ��  ��  ��  ��      ��
echo  ��    ��   ��      ��  ��              ��      ��
echo  �̡̡̡�   ��      ��    �̡�          ��        �̡�
echo  ��    ��   ��      ��        ��        ��            ��
echo  ��    ��   ��      ��          ��      ��              ��
echo  ��    ��   ��      ��  ��      ��      ��      ��      ��
echo  ��    ��     �̡̡�     �̡̡̡�       ��       �̡̡̡�
echo.
echo.----------------------------------------------------------- 
echo. 360�����ԹܼҵȰ�ȫ������ѣ��빴ѡ��������Ͳ������ѣ�
echo.
echo. ����Լ��޸Ĺ�hosts��Ϣ���븴�Ƶ� defined_hosts.txt
echo.��defined_hosts.txt���ļ����Զ���hosts�����»��Զ��ϲ���
if not exist defined_hosts.txt goto defined_hosts >NUL 2>NUL
echo.
echo. �糤ʱ��ͣ�ڡ��������ء� ��༭��������(84��)hosts����
echo.
echo. ���棺ִ�и����� ���� HOSTS �Ὣ���Զ��滻���ǣ�
echo.-----------------------------------------------------------
echo. ��ѡ��ʹ�ã�
echo.
echo.
echo.      [1] Զ���������� HOSTS      [2] �ָ���ʼ HOSTS
echo.
echo.-----------------------------------------------------------
if exist "%SystemRoot%\System32\choice.exe" goto Choice

set /p choice=������ѡ����س���ȷ��:

echo.
if %choice%==1 goto host DNS
if %choice%==2 goto CL
cls
"set choice="
echo ����������������ѡ��
ping 127.0.1 -n "2">nul
goto main

:Choice
choice /c 12 /n /m "����������ѡ��"
if errorlevel 2 goto CL
if errorlevel 1 goto host DNS
cls
goto main

:host DNS
echo.
echo �������� Hosts ......
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
:: ������ַΪhostsԶ�����ӣ����ʧЧ�������޸ġ�
:: 
echo download "https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts","%cd%\host" >> %dowhosts%
echo download "https://raw.githubusercontent.com/racaljk/hosts/master/hosts","%cd%\host2" >> %dowhosts%
:: ȥ���
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
::ˢ�� DNS ��������
ipconfig /flushdns
del /f /q hosts>NUL 2>NUL
del /f /q %dowhosts%>NUL 2>NUL
echo.-----------------------------------------------------------
echo.
echo ���Ǳ���hosts��ˢ�±���DNS��������ɹ�!
echo ����ȥ��Google��Twitter��Facebook��Gmail���ȸ�ѧ���ɣ�
echo.�ȸ���Щ��վ�ǵ�ʹ��https���м��ܷ��ʣ�
echo.
echo.����https://www.google.com
echo.
echo.���ߣ�https://www.google.com/ncr
echo.      https://www.google.com.hk/ncr
echo.
echo.-----------------------------------------------------------
goto end

:CL
cls
echo.-----------------------------------------------------------
echo.
echo # Localhost (DO NOT REMOVE)>%hostsfile%&&echo.>>%hostsfile%&&echo 127.0.0.1 localhost>>%hostsfile%&&echo ::1 localhost ip6-localhost ip6-loopback>>%hostsfile%&&echo.>>%hostsfile%
echo ��ϲ����hosts�ָ���ʼ�ɹ�!
echo.
echo.-----------------------------------------------------------
goto end

:end
ping 127.0.1 -n "5">nul
exit

echo �밴������˳���
Pause>nul

:configowner
cls
echo ����hosts�ļ���������
echo.
echo ��ִ�����沽�裺
echo.
echo 1) �Ҽ�hosts�ļ�����������ԡ��˵�����
echo 2) �����ԶԻ����ѡ�񡰰�ȫ��ѡ������·��ġ��߼�����ť
echo 3) �ڳ��ֵ��´��������ڶ��С������ߡ��ұ���ɫ�ġ����ġ��ı�����
echo 4) �ڡ�ѡ���û����顱�Ի���������ı��������롰administrators�����㡰ȷ����
echo 5) �ص���������������㡰ȷ�����������
echo.
echo ��ʾ����������hosts�ļ�����ѡ�����˵��ġ�6.��ʾ�����ļ�����Ȼ��ˢ���ļ��С�
ping 127.1 -n 2 >nul
start "" explorer.exe /select,%hostsfile%

:defined_hosts
echo #�û��Զ���hosts������ʹ��notepad++�༭���༭>>defined_hosts.txt&&echo #���ڱ��к������Զ���hosts>>defined_hosts.txt&&echo.>>defined_hosts.txt&&echo.>>defined_hosts.txt&&echo.>>defined_hosts.txt
goto main

:nohost
cls
echo.-----------------------------------------------------------
echo.
echo.
echo  ��������δ���ص����µ�hosts�������±༭�������ڵ����ӡ�
echo.
echo.-----------------------------------------------------------
echo.
echo.
echo �밴������˳���
Pause>nul
exit
