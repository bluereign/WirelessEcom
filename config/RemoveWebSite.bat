@echo off

pushd .
cd %~dp0

set appcmd=%windir%\System32\inetsrv\appcmd.exe
set costcoAppName=MembershipWireless
set aafesAppName=AAFES
set pagemasterAppName=PageMaster


%appcmd% delete site %costcoAppName%
%appcmd% delete AppPool %costcoAppName%

%appcmd% delete site %aafesAppName%
%appcmd% delete AppPool %aafesAppName%

%appcmd% delete site %pagemasterAppName%
%appcmd% delete AppPool %pagemasterAppName%


popd