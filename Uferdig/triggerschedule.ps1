$servere = get-content -path "c:\server.txt"

#$actionArray = '"{00000000-0000-0000-0000-000000000113}"',"{00000000-0000-0000-0000-000000000108}","{3A88A2F3-0C39-45fa-8959-81F212BF500CE}","{8EF4D77C-8A23-45c8-BEC3-630827704F51}"

#$mpre = {8EF4D77C-8A23-45c8-BEC3-630827704F51}

Foreach ($server in $servere) {
if (test-connection $server) {
        $ms = New-Object system.management.managementscope
        $ms.path = "\\$server\root\ccm"

        $options = $ms.options

        $ms.options = $options

        $mc = New-Object System.Management.ManagementClass($ms,'sms_client',$null)
        $mc.InvokeMethod('TriggerSchedule','{00000000-0000-0000-0000-000000000024}')
        
            Write-Host "TriggerSchedule kjørt på $server"
}


Else {
    Write-Host "$server feilet på ping."
     }
}



#Software Updates Scan Cycle

#{00000000-0000-0000-0000-000000000113}

#Software Updates Deployment Evaluation Cycle

#{00000000-0000-0000-0000-000000000108}

#User Policy Retrieval & Evaluation Cycle

#{3A88A2F3-0C39-45fa-8959-81F212BF500CE}

#Machine Policy Retrieval & Evaluation Cycle

#{8EF4D77C-8A23-45c8-BEC3-630827704F51}




Foreach ($server in $servere) {
if (test-connection $server) {
        $ms = New-Object system.management.managementscope
        $ms.path = "\\$server\root\ccm"

        $options = $ms.options

        $ms.options = $options

        $mc = New-Object System.Management.ManagementClass($ms,'sms_client',$null)
        #$mc.InvokeMethod('TriggerSchedule','{00000000-0000-0000-0000-000000000108}')
        triggerSoftwareUpdatesEvaluationCycle(
            Write-Host "TriggerSchedule kjørt på $server"
}


Else {
    Write-Host "$server feilet på ping."
     }
}

function triggerSoftwareUpdatesEvaluationCycle([string]$input) {
        [string]$output = $mc.InvokeMethod('TriggerSchedule',$actionArray[$input])
        return $output
}

function triggerSoftwareUpdateScan([string]$input) {
        [string]$output = $mc.InvokeMethod('TriggerSchedule','{00000000-0000-0000-0000-000000000108}')
        return $output
}

function triggerMachinePolicyRetrieval([string]$input) {
        [string]$output = $mc.InvokeMethod('TriggerSchedule','{00000000-0000-0000-0000-000000000021}')
        return $output
}

function triggerSendUnsentStateMessage([string]$input) {
        [string]$output = $mc.InvokeMethod('TriggerSchedule','{00000000-0000-0000-0000-000000000111}')
        return $output
}        

#$s = triggerSendUnsentStateMessage(