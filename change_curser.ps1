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
	write-Host "(c)reate new scheme (1) | (l)ist schemes (2) | (d)elete schemes (3) | (e)xit (4)"
	$userInput = Read-Host -Prompt "choose: "
   
   Switch ($userInput) {
		'c' {createScheme; Break}
		1 {createScheme; Break}
		'l' {listSchemes; Break}
		2 {listSchemes; Break}
		'd' {deleteSchemes; Break}
		3 {deleteSchemes; Break}
		'e' {exit}
		"exit" {exit}
		4 {exit}
		Default { Write-Host -ForegroundColor "DarkRed" "unvalid input"; scriptStart }
   }
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
		$curserPath = Read-Host -Prompt "choose: "
		if ($userInput -eq "back") { scriptStart }
	}
	Remove-ItemProperty -Path "Registry::$schemesKey" -Name "$userInput"
	Write-Host -ForegroundColor "Green" "deleted $userInput"
	scriptStart
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
	$arrow_search_strings = @("normal", "arrow")
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
	
	foreach ($searchWord in $arrow_search_strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$arrow = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Arrow" -Value "$arrow" -Force
			break
		}
	}
	
	foreach ($searchWord in $helpsel_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$helpsel = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Help" -Value "$helpsel" -Force
			break
		}
	}
	
	foreach ($searchWord in $working_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$working = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "AppStarting" -Value "$working" -Force
			break
		}
	}
	
	foreach ($searchWord in $busy_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$busy = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Wait" -Value "$busy" -Force
			break
		}
	}
	
	foreach ($searchWord in $precisionsel_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$precisionsel = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Crosshair" -Value "$precisionsel" -Force
			break
		}
	}

	foreach ($searchWord in $txtsel_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$txtsel = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "IBeam" -Value "$txtsel" -Force
			break
		}
	}

	foreach ($searchWord in $pen_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$pen = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "NWPen" -Value "$pen" -Force
			break
		}
	}

	foreach ($searchWord in $unavail_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$unavail = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "No" -Value "$unavail" -Force
			break
		}
	}

	foreach ($searchWord in $ns_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$ns = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeNS" -Value "$ns" -Force
			break
		}
	}

	foreach ($searchWord in $ew_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$ew = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeWE" -Value "$ew" -Force
			break
		}
	}

	foreach ($searchWord in $nwse_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$nwse = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeNWSE" -Value "$nwse" -Force
			break
		}
	}

	foreach ($searchWord in $nesw_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$nesw = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeNESW" -Value "$nesw" -Force
			break
		}
	}

	foreach ($searchWord in $move_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$move = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "SizeAll" -Value "$move" -Force
			break
		}
	}

	foreach ($searchWord in $up_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$up = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "UpArrow" -Value "$up" -Force
			break
		}
	}

	foreach ($searchWord in $link_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$link = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Hand" -Value "$link" -Force
			break
		}
	}

	foreach ($searchWord in $pin_search_Strings) {
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$pin = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Pin" -Value "$pin" -Force
			break
		}
	}

	foreach ($searchWord in $person_search_Strings) {	
	
		$matchingFiles = Get-ChildItem -LiteralPath $folderPath -Filter "*$searchWord*" -Include *.ani, *.cur -File
		if ($matchingFiles.Count -gt 0) {
			foreach ($file in $matchingFiles) {
				Write-Host "Found File(s): $($file.Name)"
			}
			$person = $matchingFiles[0].FullName
			New-ItemProperty -Path "Registry::$cursersKey" -Name "Person" -Value "$person" -Force
			break
		}
	}

	# create new regestry key if it doesn't exist.
	If (-Not (Test-Path -Path "Registry::$schemesKey")) { 
		New-Item -Path "Registry::$schemesKey" 
	}
	
	$regValue = $arrow + "," + $helpsel + "," + $working + "," + $busy + "," + $precisionsel + "," + $txtsel + "," + $pen + "," + $unavail + "," + $ns + "," + $ew + "," + $nwse + "," + $nesw + "," + $move + "," + $up + "," + $link + "," + $pin + "," + $person
	# create the scheme as a value in the regestry
	If (-Not (Get-ItemProperty -Path "Registry::$schemesKey" -Name "$schemeName" -ErrorAction SilentlyContinue)) {
		New-ItemProperty -Path "Registry::$schemesKey" -Name "$schemeName" -Value "$regValue"
	}
	
	#apply scheme
	New-ItemProperty -Path "Registry::$cursersKey" -Name "Scheme Source" -PropertyType "DWORD" -Value "1" -Force
	
	#We have to tell windows to reload the curser, reloading the cursor settings from PowerShell can be a bit tricky. So we are emulating a click on the apply button in mouse Properties...
	$mousePropertiesPath = "$env:SystemRoot\System32\rundll32.exe"
	$parameters = "shell32.dll,Control_RunDLL main.cpl,,1"
	Start-Process -FilePath $mousePropertiesPath -ArgumentList $parameters -Wait
	
	scriptStart
}

scriptStart
exit