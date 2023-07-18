@echo off

:: BatchGotAdmin
:: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file/10052222#10052222
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

cls

echo 1. show hyper-v status
echo 2. turn on hyper-v
echo 3. turn off hyper-v
echo:

choice /c 123 /m "Enter your choice: "

if errorlevel 3 goto TurnOffHyperV
if errorlevel 2 goto TurnOnHyperV
if errorlevel 1 goto ShowHyperVStatus

:TurnOnHyperV
reg add HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity /v Enabled /f /t REG_DWORD /d 1
DISM.exe /Online /Enable-Feature /All /FeatureName:Microsoft-Windows-Subsystem-Linux /NoRestart
DISM.exe /Online /Enable-Feature /All /FeatureName:VirtualMachinePlatform /NoRestart
bcdedit /set hypervisorlaunchtype auto
goto ShowHyperVStatus

:TurnOffHyperV
reg add HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity /v Enabled /f /t REG_DWORD /d 0
DISM.exe /Online /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:VirtualMachinePlatform /NoRestart
bcdedit /set hypervisorlaunchtype off
goto ShowHyperVStatus

:ShowHyperVStatus
cls

reg query HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity /v Enabled
echo:

Dism /online /Get-FeatureInfo /FeatureName:Microsoft-Windows-Subsystem-Linux | findstr /c:"Display Name : " /c:"State : "
echo:

Dism /online /Get-FeatureInfo /FeatureName:VirtualMachinePlatform | findstr /c:"Display Name : " /c:"State : "
echo:

bcdedit /enum | findstr hypervisorlaunchtype
echo:

sc query HvHost | findstr /c:"SERVICE_NAME: " /c:"STATE"
echo:

pause
