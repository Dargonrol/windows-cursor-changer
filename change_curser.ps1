$schemesKey = "HKEY_CURRENT_USER\Control Panel\Cursors\Schemes"
$cursersKey = "HKEY_CURRENT_USER\Control Panel\Cursors"

function scriptStart {
	Write-Host "
    __  __ __  ____    _____   ___  ____          __  __ __   ____  ____    ____    ___  ____  
   /  ]|  |  ||    \  / ___/  /  _]|    \        /  ]|  |  | /    ||    \  /    |  /  _]|    \ 
  /  / |  |  ||  D  )(   \_  /  [_ |  D  )      /  / |  |  ||  o  ||  _  ||   __| /  [_ |  D  )
 /  /  |  |  ||    /  \__  ||    _]|    /      /  /  |  _  ||     ||  |  ||  |  ||    _]|    / 
/   \_ |  :  ||    \  /  \ ||   [_ |    \     /   \_ |  |  ||  _  ||  |  ||  |_ ||   [_ |    \ 
\     ||     ||  .  \ \    ||     ||  .  \    \     ||  |  ||  |  ||  |  ||     ||     ||  .  \
 \____| \__,_||__|\_|  \___||_____||__|\_|     \____||__|__||__|__||__|__||___,_||_____||__|\_|
                                                                                               
"
	Write-Host "What do you want to do?"
	write-Host "(c)reate new scheme (1) | (l)ist schemes (2) | (d)elete schemes (3) | (o)pen curser settings (4) | (e)xit (5)"
	$userInput = Read-Host -Prompt "choose: "
   
   Switch ($userInput) {
		'c' {createScheme; Break}
		1 {createScheme; Break}
		'l' {listSchemes; Break}
		2 {listSchemes; Break}
		'd' {deleteSchemes; Break}
		3 {deleteSchemes; Break}
		'o' {openCurserSettings; Break}
		4 {openCurserSettings; Break}
		'e' {exit}
		"exit" {exit}
		5 {exit}
		Default { Write-Host -ForegroundColor "DarkRed" "unvalid input"; scriptStart }
   }
   scriptStart
}

function createScheme {
	Write-Host -ForegroundColor "Yellow" "New scheme name: " -NoNewline
	$schemeName = Read-Host
	Write-Host -ForegroundColor "Yellow" ".ani or .cur files directiory (empty for current): " -NoNewline
	$curserPath = Read-Host
	if ($curserPath.Length -eq 0) { $curserPath = Get-Location } 
	while (-Not (Test-Path -Path $curserPath -PathType Container)) {
		Write-Host -ForegroundColor "Red" "directiory does not exist!"
		$curserPath = Read-Host -Prompt "directiory: "
	}
	applyCurser -folderPath "$curserPath" -schemeName "$schemeName"
}

function listSchemes {
	$properties = Get-ItemProperty -Path "Registry::$schemesKey"
	Write-Host "schemes: "
	foreach ($property in $properties.PSObject.Properties) {
		if (-Not ($property.Name -eq "PSPath" -or $property.Name -eq "PSParentPath" -or $property.Name -eq "PSChildName" -or $property.Name -eq "PSProvider")) {
			Write-Host -ForegroundColor "Cyan" "$($property.Name)"
		}
	}
	scriptStart
}

function deleteSchemes {
	$properties = Get-ItemProperty -Path "Registry::$schemesKey"
	Write-Host "schemes: "
	foreach ($property in $properties.PSObject.Properties) {
		if (-Not ($property.Name -eq "PSPath" -or $property.Name -eq "PSParentPath" -or $property.Name -eq "PSChildName" -or $property.Name -eq "PSProvider")) {
			Write-Host -ForegroundColor "Cyan" "$($property.Name)"
		}
	}
	Write-Host -ForegroundColor "Red" "Which scheme do you want to delete? (type back to return)"
	$userInput = Read-Host -Prompt "choose: "
	if ($userInput -eq "back") { scriptStart }
	while (-Not (Get-ItemProperty -Path "Registry::$schemesKey" -Name "$userInput" -ErrorAction SilentlyContinue)) {
		Write-Host -ForegroundColor "Red" "scheme does not exist!"
		$userInput = Read-Host -Prompt "choose: "
		if ($userInput -eq "back") { scriptStart }
	}
	Remove-ItemProperty -Path "Registry::$schemesKey" -Name "$userInput"
	Write-Host -ForegroundColor "Green" "deleted $userInput"
	scriptStart
}

function openCurserSettings {
	$mousePropertiesPath = "$env:SystemRoot\System32\rundll32.exe"
	$parameters = "shell32.dll,Control_RunDLL main.cpl,,1"
	Start-Process -FilePath $mousePropertiesPath -ArgumentList $parameters -Wait
}

function applyCurser {	
	param(
		[string]$folderPath,
		[string]$schemeName
	)
		
	$arrow
	$helpsel
	$working
	$busy
	$precisionsel
	$txtsel
	$pen
	$unavail
	$ns
	$ew
	$nwse
	$nesw
	$move
	$up
	$link
	$pin
	$person
	$arrow_search_strings = @("normal", "arrow", "nomal")
	$helpsel_search_Strings = @("help")
	$working_search_Strings = @("working")
	$busy_search_Strings = @("busy")
	$precisionsel_search_Strings = @("precision", "cross")
	$txtsel_search_Strings = @("text")
	$pen_search_Strings = @("pen", "handwriting")
	$unavail_search_Strings = @("unavail", "allowed")
	$ns_search_Strings = @("ns")
	$ew_search_Strings = @("ew")
	$nwse_search_Strings = @("nwse")
	$nesw_search_Strings = @("nesw")
	$move_search_Strings = @("move")
	$up_search_Strings = @("up")
	$link_search_Strings = @("link")
	$pin_search_Strings = @("pin")
	$person_search_Strings = @("person")
	
	Write-Host -ForegroundColor "Magenta" "searching for arrow file"
	foreach ($searchWord in $arrow_search_strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$arrow = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Arrow" -Value "$arrow" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for help select file"
	foreach ($searchWord in $helpsel_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$helpsel = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Help" -Value "$helpsel" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for working file..."
	foreach ($searchWord in $working_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$working = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "AppStarting" -Value "$working" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for busy file"
	foreach ($searchWord in $busy_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$busy = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Wait" -Value "$busy" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for precision select file"
	foreach ($searchWord in $precisionsel_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$precisionsel = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Crosshair" -Value "$precisionsel" -Force | Out-Null
			break
		}
	}

	Write-Host -ForegroundColor "Magenta" "searching for text select file"
	foreach ($searchWord in $txtsel_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$txtsel = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "IBeam" -Value "$txtsel" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for pen file"
	foreach ($searchWord in $pen_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$pen = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "NWPen" -Value "$pen" -Force | Out-Null
			break
		}
	}

	Write-Host -ForegroundColor "Magenta" "searching for unavailable file"
	foreach ($searchWord in $unavail_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$unavail = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "No" -Value "$unavail" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for ns file"
	foreach ($searchWord in $ns_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$ns = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeNS" -Value "$ns" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for ew file"
	foreach ($searchWord in $ew_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$ew = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeWE" -Value "$ew" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for nwse file"
	foreach ($searchWord in $nwse_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$nwse = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeNWSE" -Value "$nwse" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for nesw file"
	foreach ($searchWord in $nesw_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$nesw = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeNESW" -Value "$nesw" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for move file"
	foreach ($searchWord in $move_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$move = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeAll" -Value "$move" -Force | Out-Null
			break
		}
	}

	Write-Host -ForegroundColor "Magenta" "searching for up arrow file"
	foreach ($searchWord in $up_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$up = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "UpArrow" -Value "$up" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for link file"
	foreach ($searchWord in $link_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$link = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Hand" -Value "$link" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for pin file"
	foreach ($searchWord in $pin_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$pin = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Pin" -Value "$pin" -Force | Out-Null
			break
		}
	}
	
	Write-Host -ForegroundColor "Magenta" "searching for person file"
	foreach ($searchWord in $person_search_Strings) {	
	
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$person = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Person" -Value "$person" -Force | Out-Null
			break
		}
	}

	# create new regestry key if it doesn't exist.
	If (-Not (Test-Path -Path "Registry::$schemesKey")) { 
		New-Item -Path "Registry::$schemesKey" | Out-Null
	}
	
	$regValue = $arrow + "," + $helpsel + "," + $working + "," + $busy + "," + $precisionsel + "," + $txtsel + "," + $pen + "," + $unavail + "," + $ns + "," + $ew + "," + $nwse + "," + $nesw + "," + $move + "," + $up + "," + $link + "," + $pin + "," + $person
	# create the scheme as a value in the regestry
	If (-Not (Get-ItemProperty -Path "Registry::$schemesKey" -Name "$schemeName" -ErrorAction SilentlyContinue)) {
		New-ItemProperty -Path "Registry::$schemesKey" -Name "$schemeName" -Value "$regValue" | Out-Null
	}
	
	#apply scheme
	New-ItemProperty -Path "Registry::$cursersKey" -Name "Scheme Source" -PropertyType "DWORD" -Value "1" -Force | Out-Null
	New-ItemProperty -Path "Registry::$cursersKey" -Name "(Default)" -Value "$schemeName" -Force | Out-Null
	
	Update-UserPreferencesMask
	
	scriptStart
}

function Update-UserPreferencesMask {
$Signature = @"
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);

const int SPI_SETCURSORS = 0x0057;
const int SPIF_UPDATEINIFILE = 0x01;
const int SPIF_SENDCHANGE = 0x02;

public static void UpdateUserPreferencesMask() {
    SystemParametersInfo(SPI_SETCURSORS, 0, 0, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
}
"@
    Add-Type -MemberDefinition $Signature -Name UserPreferencesMaskSPI -Namespace User32
    [User32.UserPreferencesMaskSPI]::UpdateUserPreferencesMask()
}

scriptStart
exit