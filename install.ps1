param([switch]$WhatIf = $false)

if(!(Test-Path $PROFILE)) {
	Write-Host "Creating PowerShell profile...`n$PROFILE"
	New-Item $PROFILE -Force -Type File -ErrorAction Stop -WhatIf:$WhatIf > $null
}

$installDir = Split-Path $MyInvocation.MyCommand.Path -Parent
# if(!(. (Join-Path $installDir "CheckPoshGit.ps1"))) {
# 	return
# }

# Adapted from http://www.west-wind.com/Weblog/posts/197245.aspx
function Get-FileEncoding($Path) {
	$bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

	if(!$bytes) { return 'utf8' }

	switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
		'^efbbbf'   { return 'utf8' }
		'^2b2f76'   { return 'utf7' }
		'^fffe'     { return 'unicode' }
		'^feff'     { return 'bigendianunicode' }
		'^0000feff' { return 'utf32' }
		default     { return 'ascii' }
	}
}

$autoloadScript = ". '$installDir\autoload.ps1'"
if(Select-String -Path $PROFILE -Pattern $autoloadScript -Quiet -SimpleMatch) {
	Write-Host "It seems Beautiful-PoshGit is already installed..."
	return
}

Write-Host "Adding Beautiful-PoshGit to profile..."
@"

# Load autoload script
$autoloadScript

"@ | Out-File $PROFILE -Append -WhatIf:$WhatIf -Encoding (Get-FileEncoding $PROFILE)

Write-Host 'Beautiful-PoshGit sucessfully installed!'
Write-Host 'Please reload your profile for the changes to take effect:'
Write-Host '    . $PROFILE'
