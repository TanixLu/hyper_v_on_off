# hyper_v_on_off

开关的东西有：

- 内存完整性
- Windows Subsystem for Linux 功能
- Virtual Machine Platform 功能
- hypervisorlaunchtype auto/off

Things to switch on/off:

- Memory Integrity
- Windows Subsystem for Linux feature
- Virtual Machine Platform feature
- hypervisorlaunchtype

```bat
:TurnOnHyperV
reg add HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity /v Enabled /f /t REG_DWORD /d 1
DISM.exe /Online /Enable-Feature /All /FeatureName:Microsoft-Windows-Subsystem-Linux /NoRestart
DISM.exe /Online /Enable-Feature /All /FeatureName:VirtualMachinePlatform /NoRestart
DISM.exe /Online /Enable-Feature /All /FeatureName:HypervisorPlatform /NoRestart
bcdedit /set hypervisorlaunchtype auto
```

```bat
:TurnOffHyperV
reg add HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity /v Enabled /f /t REG_DWORD /d 0
DISM.exe /Online /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:VirtualMachinePlatform /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:HypervisorPlatform /NoRestart
bcdedit /set hypervisorlaunchtype off
```

```bat
:ShowHyperVStatus
reg query HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity /v Enabled
Dism /online /Get-FeatureInfo /FeatureName:Microsoft-Windows-Subsystem-Linux | findstr /c:"Display Name : " /c:"State : "
Dism /online /Get-FeatureInfo /FeatureName:VirtualMachinePlatform | findstr /c:"Display Name : " /c:"State : "
Dism /online /Get-FeatureInfo /FeatureName:HypervisorPlatform | findstr /c:"Display Name : " /c:"State : "
bcdedit /enum | findstr hypervisorlaunchtype
sc query HvHost | findstr /c:"SERVICE_NAME: " /c:"STATE"
```

TODO:

- 更友好的输出
- 开关的时候，加一个确认
