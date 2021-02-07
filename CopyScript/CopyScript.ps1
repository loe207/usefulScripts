﻿$sourceFolder = 'C:\xxx'
$targetFolder = 'C:\xxx'

$copyoptions = "/MIR"
$command = "robocopy `"$($sourceFolder)`" $($targetFolder) $copyOptions"
$output = Invoke-Expression $command

$fsw = New-Object IO.FileSystemWatcher $sourceFolder -Property @{IncludeSubdirectories = $true}
     
Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -Action { 
    $name = $Event.SourceEventArgs.Name 
    Invoke-Expression $command
}

Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action {
    $name = $Event.SourceEventArgs.Name 
    Invoke-Expression $command
} 

Register-ObjectEvent $fsw Renamed -SourceIdentifier FileRenamed -Action {
    $name = $Event.SourceEventArgs.Name
    Invoke-Expression $command
}


Register-ObjectEvent $fsw Deleted -SourceIdentifier FileDeleted -Action {
    $name = $Event.SourceEventArgs.Name
    Invoke-Expression $command
}

function unregisterEvents() {
    Unregister-Event -SourceIdentifier FileChanged
    Unregister-Event -SourceIdentifier FileCreated
    Unregister-Event -SourceIdentifier FileRenamed
    Unregister-Event -SourceIdentifier FileDeleted
}
    