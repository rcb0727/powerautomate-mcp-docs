<#
.SYNOPSIS
    Registers the Power Automate MCP multi-tenant app in Microsoft Entra.

.DESCRIPTION
    One-time setup script for publishers. Creates the Microsoft Entra app registration
    with required permissions for Power Automate MCP server.

.PARAMETER DisplayName
    The display name for the app registration. Default: "Power Automate MCP"

.PARAMETER UpdateSourceFile
    If specified, updates the published-app.ts file with the new client ID.

.EXAMPLE
    .\Register-PublishedApp.ps1

.EXAMPLE
    .\Register-PublishedApp.ps1 -DisplayName "My PA MCP" -UpdateSourceFile
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$DisplayName = "Power Automate MCP",
    [switch]$UpdateSourceFile
)

$ErrorActionPreference = 'Stop'

# Check for Azure CLI
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "Azure CLI not found. Install from: https://aka.ms/installazurecli"
    exit 1
}

# Check login status
Write-Host "Checking Azure CLI login status..." -ForegroundColor Cyan
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "Not logged in. Starting Azure CLI login..." -ForegroundColor Yellow
    az login --allow-no-subscriptions
    $account = az account show | ConvertFrom-Json
}
Write-Host "Logged in as: $($account.user.name)" -ForegroundColor Green

# Required API permissions
# Microsoft Graph - User.Read (delegated)
$graphUserRead = @{
    resourceAppId = "00000003-0000-0000-c000-000000000000"  # Microsoft Graph
    resourceAccess = @(
        @{
            id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"  # User.Read
            type = "Scope"
        }
    )
}

# Power Automate / Flow Service
# Note: Power Automate uses the Flow Service API
$flowService = @{
    resourceAppId = "7df0a125-d3be-4c96-aa54-591f83ff541c"  # Power Automate / Flow Service
    resourceAccess = @(
        @{
            id = "e07c4438-06fe-4349-9077-b8ab4e888e21"  # Flows.Read.All
            type = "Scope"
        },
        @{
            id = "f3a53f5e-1975-4e99-8c6e-c6a0dfac61f6"  # Flows.Manage.All
            type = "Scope"
        }
    )
}

$requiredResourceAccess = @($graphUserRead, $flowService) | ConvertTo-Json -Depth 10 -Compress

# App manifest for multi-tenant public client
$appManifest = @{
    displayName = $DisplayName
    signInAudience = "AzureADMultipleOrgs"  # Multi-tenant
    publicClient = @{
        redirectUris = @(
            "https://login.microsoftonline.com/common/oauth2/nativeclient"
            "ms-appx-web://microsoft.aad.brokerplugin/{client_id}"  # WAM
        )
    }
    requiredResourceAccess = @($graphUserRead, $flowService)
}

Write-Host "`nCreating app registration: $DisplayName" -ForegroundColor Cyan

if ($PSCmdlet.ShouldProcess($DisplayName, "Create Microsoft Entra App Registration")) {
    # Create the app
    $appJson = $appManifest | ConvertTo-Json -Depth 10
    $tempFile = [System.IO.Path]::GetTempFileName()
    $appJson | Out-File -FilePath $tempFile -Encoding utf8

    try {
        $app = az ad app create --display-name $DisplayName `
            --sign-in-audience "AzureADMultipleOrgs" `
            --enable-access-token-issuance false `
            --enable-id-token-issuance false `
            --public-client-redirect-uris "https://login.microsoftonline.com/common/oauth2/nativeclient" `
            --required-resource-accesses $requiredResourceAccess `
            2>&1 | ConvertFrom-Json

        if (-not $app.appId) {
            Write-Error "Failed to create app registration"
            exit 1
        }

        $clientId = $app.appId
        Write-Host "`n========================================" -ForegroundColor Green
        Write-Host "App Registration Created Successfully!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "`nApplication (client) ID: " -NoNewline
        Write-Host $clientId -ForegroundColor Yellow
        Write-Host "Display Name: $DisplayName"
        Write-Host "Sign-in Audience: Multi-tenant (AzureADMultipleOrgs)"

        # Update the WAM redirect URI with actual client ID
        $wamRedirect = "ms-appx-web://microsoft.aad.brokerplugin/$clientId"
        Write-Host "`nAdding WAM redirect URI..." -ForegroundColor Cyan
        az ad app update --id $clientId --public-client-redirect-uris `
            "https://login.microsoftonline.com/common/oauth2/nativeclient" `
            $wamRedirect 2>&1 | Out-Null

        Write-Host "`nRequired Permissions:" -ForegroundColor Cyan
        Write-Host "  - Microsoft Graph: User.Read (delegated)"
        Write-Host "  - Power Automate: Flows.Read.All, Flows.Manage.All (delegated)"

        Write-Host "`n[!] IMPORTANT: Admin consent may be required for users." -ForegroundColor Yellow
        Write-Host "    Admin consent URL:" -ForegroundColor Yellow
        Write-Host "    https://login.microsoftonline.com/common/adminconsent?client_id=$clientId" -ForegroundColor Cyan

        # Update source file if requested
        if ($UpdateSourceFile) {
            $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
            $publishedAppFile = Join-Path $scriptDir "..\src\setup\published-app.ts"
            $publishedAppFile = [System.IO.Path]::GetFullPath($publishedAppFile)

            if (Test-Path $publishedAppFile) {
                Write-Host "`nUpdating $publishedAppFile..." -ForegroundColor Cyan
                $content = Get-Content $publishedAppFile -Raw
                $content = $content -replace 'YOUR-PUBLISHED-APP-CLIENT-ID', $clientId
                $content = $content -replace '[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}', $clientId
                Set-Content -Path $publishedAppFile -Value $content -NoNewline
                Write-Host "Updated PUBLISHED_APP_CLIENT_ID to: $clientId" -ForegroundColor Green
            } else {
                Write-Warning "Could not find published-app.ts at: $publishedAppFile"
            }
        }

        Write-Host "`n========================================" -ForegroundColor Green
        Write-Host "Next Steps:" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "1. Update src/setup/published-app.ts with client ID: $clientId"
        Write-Host "2. Rebuild: npm run build"
        Write-Host "3. Reinstall globally: npm install -g ."
        Write-Host "4. Run setup: powerautomate-mcp --setup"

        # Copy to clipboard
        $clientId | Set-Clipboard
        Write-Host "`n[Copied client ID to clipboard]" -ForegroundColor Gray

    } finally {
        Remove-Item $tempFile -ErrorAction SilentlyContinue
    }
}
