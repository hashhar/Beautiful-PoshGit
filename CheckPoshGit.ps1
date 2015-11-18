$Global:PoshGitMissing = $false

# If we don't find posh-git we abort and say so'
if (!(Get-Module –FullyQualifiedName @{ModuleName="posh-git";RequiredVersion="0.0"})) {
	Write-Warning "You dont seem to have posh-git installed. Please install it."
	$Global:PoshGitMissing = $true
	return
}