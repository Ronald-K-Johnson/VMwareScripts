Connect-VIServer -Server vcenteraddress

# List of VM Names 
$vmNames = @(
 "Computer1",
 "Computer2"
)

# Loop through each VM
foreach ($vmName in $vmNames) {
    # Get the Virtual Machine
    $vm = Get-VM -Name $vmName

    if ($vm) {
        # Configure the VM Options
        $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
        $spec.changeVersion = $vm.ExtensionData.Config.ChangeVersion
        $spec.tools = New-Object VMware.Vim.ToolsConfigInfo
        $spec.tools.toolsUpgradePolicy = "upgradeAtPowerCycle"
        # Apply the Configuration
        $vm.ExtensionData.ReconfigVM($spec)
        Write-Host "VMware Tools auto-upgrade enabled for $($vm.Name)"
        # Perform a silent VMware Tools upgrade with reboot suppression
        #Update-Tools -VM $vm -NoReboot -Verbose
        #Write-Host "VMware Tools upgraded silently for $($vm.Name) without reboot."
     } else {
         Write-Warning "VM '$vmName' not found."
    }
}