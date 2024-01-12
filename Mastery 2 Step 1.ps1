# Function to add user to Hogwarts client
function Add-User {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Username,
        [Parameter(Mandatory=$true)]
        [string]$Group
    )

    $Password = Read-Host -AsSecureString "Enter password for user $Username"

    $UserParams = @{
        'Name'        = $Username
        'Description' = "Group: $Group"
        'Password'    = $Password
        'PasswordNeverExpires' = $true
        'UserMayNotChangePassword' = $true
        'AccountPassword' = (ConvertTo-SecureString -String 'password' -AsPlainText -Force)
    }

    $NewUser = New-LocalUser @UserParams
    $NewUser | Select-Object Name, Description
}

# Add users
Add-User -Username "Luna Lovegood" -Group "Ravenclaw"
Add-User -Username "Draco Malfoy" -Group "Slytherin"
Add-User -Username "Ginny Weasley" -Group "Gryffindor"

# Display user info
Write-Host "User information:"
Write-Host "-----------------"
Get-LocalUser | Select-Object Name, Description
