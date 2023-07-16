# hyper_v_on_off

```bat
:TurnOnHyperV
DISM.exe /Online /Enable-Feature /All /FeatureName:Microsoft-Windows-Subsystem-Linux /NoRestart
DISM.exe /Online /Enable-Feature /All /FeatureName:HypervisorPlatform /NoRestart
bcdedit /set hypervisorlaunchtype auto
```

```bat
:TurnOffHyperV
DISM.exe /Online /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /NoRestart
DISM.exe /Online /Disable-Feature /FeatureName:HypervisorPlatform /NoRestart
bcdedit /set hypervisorlaunchtype off
```

```bat
:ShowHyperVStatus
Dism /online /Get-FeatureInfo /FeatureName:Microsoft-Windows-Subsystem-Linux | findstr /c:"Display Name : " /c:"State : "
Dism /online /Get-FeatureInfo /FeatureName:HypervisorPlatform | findstr /c:"Display Name : " /c:"State : "
bcdedit /enum | findstr hypervisorlaunchtype
sc query HvHost | findstr /c:"SERVICE_NAME: " /c:"STATE"
```
