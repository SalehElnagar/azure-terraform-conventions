#!/usr/bin/env pwsh
#requires -PSEdition Core

$inputJson = [Console]::In.Readline()

#Convert JSON to string
$json = ConvertFrom-Json $inputJson
$locationName = $json.location

# https://github.com/Azure/azure-cli/issues/1520
# az account list-locations --query "[?name=='southeastasia'].{DisplayName:displayName, Name:name}" --output table
$locations = $(az account list-locations --query "[?!(contains(displayName, '(Stage)'))].{DisplayName:displayName, Name:name}" --output jsonc) | ConvertFrom-Json 
$location = $locations | Where-Object { $_.Name -eq $locationName } | Select-Object -First 1
#$formattedLocations = $locations | ForEach-Object {$_.Name = "Bloop"}
# ForEach ($location In $locations) { 
#   $location.DisplayName = $location.DisplayName.Replace(' ', '') 
# }

$displayName = $location.DisplayName.Replace(' ', '')

Write-Output @{location=$displayName} | ConvertTo-Json -Compress
