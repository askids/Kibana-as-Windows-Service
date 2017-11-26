@echo off
SETLOCAL EnableDelayedExpansion

SET KIBANAVER=5.5.2
SET KIBANALOGDIR=D:\MyLogs\Kibana
SET KIBANAINSTALLDIR=
SET NSSMDIR=D:\apps\nssm-2.24\win64
SET NSSMEXE=

@echo off
FOR %%A IN (%*) DO (
   FOR /f "tokens=1,2 delims=#" %%G IN ("%%A") DO set %%G=%%H
)

if [%KIBANAINSTALLDIR%] == [] (
SET KIBANAINSTALLDIR="D:\Program Files\kibana-%KIBANAVER%-windows-x86"
)

if [%NSSMEXE%] == [] (
SET NSSMEXE=%NSSMDIR%\nssm.exe
)

echo.
echo Input Parameters
echo.
echo Kibana Version: %KIBANAVER%
echo Install Directory: %KIBANAINSTALLDIR%
echo Log Directory: %KIBANALOGDIR%
echo NSSM Path: %NSSMEXE%
echo.

if not exist %KIBANALOGDIR% mkdir %KIBANALOGDIR%

if not exist %KIBANALOGDIR% mkdir %KIBANALOGDIR%

for /F "tokens=3 delims=: " %%H in ('sc query "Kibana" ^| findstr "        STATE"') do (
  if /I "%%H" == "RUNNING" (
   GOTO UPGRADE_KIBANA_STOP
  )
  
  if /I "%%H" == "STOPPED" (
     GOTO UPGRADE_KIBANA_MSG
  )
)

:INSTALL_KIBANA
Echo Starting Kibana Install process
%NSSMEXE% install Kibana %KIBANAINSTALLDIR%\bin\kibana.bat
%NSSMEXE% set Kibana AppDirectory %KIBANAINSTALLDIR%
%NSSMEXE% set Kibana AppStdout %KIBANALOGDIR%\kibana.stdout
%NSSMEXE% set Kibana AppStderr %KIBANALOGDIR%\kibana.stderr
%NSSMEXE% set Kibana AppStdoutCreationDisposition 4
%NSSMEXE% set Kibana AppStderrCreationDisposition 4
%NSSMEXE% set Kibana AppRotateFiles 1
%NSSMEXE% set Kibana AppRotateOnline 0
%NSSMEXE% set Kibana AppRotateSeconds 86400
%NSSMEXE% set Kibana Start SERVICE_DELAYED_AUTO_START
GOTO :START_KIBANA

:UPGRADE_KIBANA_STOP
Echo Existing version of Kibana found
%NSSMEXE% stop Kibana
GOTO UPGRADE_KIBANA

:UPGRADE_KIBANA_MSG
Echo Existing version of Kibana found

:UPGRADE_KIBANA
%NSSMEXE% set Kibana Application %KIBANAINSTALLDIR%\bin\kibana.bat
%NSSMEXE% set Kibana AppDirectory %KIBANAINSTALLDIR%
%NSSMEXE% set Kibana Start SERVICE_DELAYED_AUTO_START
GOTO :START_KIBANA

:START_KIBANA
%NSSMEXE% set Kibana Description Kibana v%KIBANAVER%
%NSSMEXE% start Kibana

:EXIT_PRCS
Echo Kibana Install/Upgrade process was completed