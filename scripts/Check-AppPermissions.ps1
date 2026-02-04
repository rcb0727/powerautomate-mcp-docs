<#
.SYNOPSIS
    Check the permissions configured for a Power Automate MCP app registration.

.DESCRIPTION
    Connects to Microsoft Graph and retrieves the app registration details
    including redirect URIs and API permissions.

.PARAMETER ClientId
    The Application (client) ID of your app registration.

.EXAMPLE
    .\Check-AppPermissions.ps1 -ClientId "your-client-id-here"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ClientId
)

Import-Module Microsoft.Graph.Applications
Connect-MgGraph -Scopes 'Application.Read.All' -NoWelcome

$app = Get-MgApplication -Filter "appId eq '$ClientId'"

if (-not $app) {
    Write-Error "App registration not found with client ID: $ClientId"
    exit 1
}

Write-Host "`nApp Registration Details:" -ForegroundColor Cyan
Write-Host "Display Name: $($app.DisplayName)"
Write-Host "App ID: $($app.AppId)"
Write-Host "Sign-In Audience: $($app.SignInAudience)"

Write-Host "`nRedirect URIs:" -ForegroundColor Cyan
$app.PublicClient.RedirectUris | ForEach-Object { Write-Host "  $_" }

Write-Host "`nRequired API Permissions:" -ForegroundColor Cyan
foreach ($resource in $app.RequiredResourceAccess) {
    $resourceName = switch ($resource.ResourceAppId) {
        "00000003-0000-0000-c000-000000000000" { "Microsoft Graph" }
        "7df0a125-d3be-4c96-aa54-591f83ff541c" { "Power Automate (Flow Service)" }
        default { $resource.ResourceAppId }
    }
    Write-Host "`n  $resourceName" -ForegroundColor Yellow
    foreach ($access in $resource.ResourceAccess) {
        $permName = switch ($access.Id) {
            "e1fe6dd8-ba31-4d61-89e7-88639da4683d" { "User.Read" }
            "e07c4438-06fe-4349-9077-b8ab4e888e21" { "Flows.Read.All" }
            "f3a53f5e-1975-4e99-8c6e-c6a0dfac61f6" { "Flows.Manage.All" }
            default { $access.Id }
        }
        Write-Host "    - $permName ($($access.Type))"
    }
}

Disconnect-MgGraph | Out-Null
