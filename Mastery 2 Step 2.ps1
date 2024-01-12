# Function to add user to Hogwarts server
function Add-User {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Username,
        [Parameter(Mandatory=$true)]
        [string]$Group,
        [Parameter(Mandatory=$true)]
        [switch]$Disabled
    )

    $Password = Read-Host -AsSecureString "Enter password for user $Username"

    $UserParams = @{
        'Name'        = $Username
        'Description' = "Group: $Group"
        'Password'    = $Password
        'UserMayNotChangePassword' = $true
        'PasswordNeverExpires' = $true
        'Enabled'     = -not $Disabled
    }

    $NewUser = New-LocalUser @UserParams
    $NewUser | Select-Object Name, Description, Enabled
}

# Add users
Add-User -Username "Bellatrix Lestrange" -Group "Villains" -Disabled
Add-User -Username "Gellert Grindelwald" -Group "Villains" -Disabled
Add-User -Username "Sybill Trelawney" -Group "Teachers"

# Display user info
Write-Host "User information:"
Write-Host "-----------------"
Get-LocalUser | Select-Object Name, Description, Enabled
