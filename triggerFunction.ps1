function triggerSoftwareUpdatesEvaluationCycle([string]$input) {
        [string]$aAOutput = $actionArray[$input]
        [string]$output = $mc.InvokeMethod('TriggerSchedule',$aAOutput)
        return $output
}

$actionArray = '{00000000-0000-0000-0000-000000000024}','{00000000-0000-0000-0000-000000000113}',"{00000000-0000-0000-0000-000000000108}","{3A88A2F3-0C39-45fa-8959-81F212BF500CE}","{8EF4D77C-8A23-45c8-BEC3-630827704F51}"


        $ms = New-Object system.management.managementscope
        $ms.path = "\\FJES\root\ccm"

        $options = $ms.options

        $ms.options = $options

        $mc = New-Object System.Management.ManagementClass($ms,'sms_client',$null)
        
$input = Read-Host -Prompt "Fyr inn et arrayvalue: "


Write-Host triggerSoftwareUpdatesEvaluationCycle "$input"
triggerSoftwareUpdatesEvaluationCycle $output
Write-Host $output