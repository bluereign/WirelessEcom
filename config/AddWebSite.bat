@echo off

pushd .
cd %~dp0

set appcmd=%windir%\System32\inetsrv\appcmd.exe
set hosts=%windir%\System32\drivers\etc\hosts


set appPath=c:\inetpub\sites\wa-ecom\2015.01.01
mkdir %appPath%


set costcoAppName=MembershipWireless
set costcoHostName=local.costco.wa


set aafesAppName=AAFES
set aafesHostName=local.aafes.wa


set pagemasterAppName=PageMaster
set pagemasterHostName=local.pagemaster.wa


set port=80

pushd . 
cd %appPath%
for /f "delims=" %%a in ('cd') do @set appPathFull=%%a
popd



rem Add site to IIS
%appcmd% add AppPool /name:%costcoAppName%
%appcmd% add site /name:%costcoAppName% /bindings:http://%costcoHostName%:%port% /physicalPath:%appPathFull%
%appcmd% set app %costcoAppName%/ /applicationPool:%costcoAppName%


%appcmd% add AppPool /name:%aafesAppName%
%appcmd% add site /name:%aafesAppName% /bindings:http://%aafesHostName%:%port% /physicalPath:%appPathFull%
%appcmd% set app %aafesAppName%/ /applicationPool:%aafesAppName%


%appcmd% add AppPool /name:%pagemasterAppName%
%appcmd% add site /name:%pagemasterAppName% /bindings:http://%pagemasterHostName%:%port% /physicalPath:%appPathFull%
%appcmd% set app %pagemasterAppName%/ /applicationPool:%pagemasterAppName%


rem Add costco site to hosts file
find /c /i "%costcoHostName%" %hosts% > NUL

if %ErrorLevel% equ 0 (
  echo %costcoHostName% already exists
  goto end
) else (
  echo Adding %costcoHostName% to hosts files
  echo 127.0.0.1 %costcoHostName% >> %hosts%
)

:end


rem Add aafes site to hosts file
find /c /i "%aafesHostName%" %hosts% > NUL

if %ErrorLevel% equ 0 (
  echo %aafesHostName% already exists
  goto end
) else (
  echo Adding %aafesHostName% to hosts files
  echo 127.0.0.1 %aafesHostName% >> %hosts%
)

:end


rem Add pagemaster site to hosts file
find /c /i "%pagemasterHostName%" %hosts% > NUL

if %ErrorLevel% equ 0 (
  echo %pagemasterHostName% already exists
  goto end
) else (
  echo Adding %pagemasterHostName% to hosts files
  echo 127.0.0.1 %pagemasterHostName% >> %hosts%
)

:end


popd