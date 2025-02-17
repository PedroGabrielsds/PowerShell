<#
╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤════════════════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   DECLARAÇÃO DE VARIÁVEIS  ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   COPIADAS DO PSAPPDEPLOY  ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧════════════════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 
- Aqui está uma série de variáveis que podem ser úteis e que foram
  copiadas do pacote do PS APP DEPLOY TOOLKIT. 
  Não são todas as variáveis, mas as que eu achei mais úteis.
  Essas variáveis ficam disponíveis para todos os scripts criados com o Modelo             #>
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# █        INICIO da Declaraçao de Variáveis Comuns         █
# ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼

## Variables: Datetime and Culture
[DateTime]$currentDateTime = Get-Date
[String]$currentTime = Get-Date -Date $currentDateTime -UFormat '%T'
[String]$currentDate = Get-Date -Date $currentDateTime -UFormat '%d-%m-%Y'
[Timespan]$currentTimeZoneBias = [TimeZone]::CurrentTimeZone.GetUtcOffset($currentDateTime)
[Globalization.CultureInfo]$culture = Get-Culture
[String]$currentLanguage = $culture.TwoLetterISOLanguageName.ToUpper()
[Globalization.CultureInfo]$uiculture = Get-UICulture
[String]$currentUILanguage = $uiculture.TwoLetterISOLanguageName.ToUpper()

## Variables: Environment Variables
[PSObject]$envHost = $Host
[PSObject]$envShellFolders = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -ErrorAction 'SilentlyContinue'
[String]$envAllUsersProfile = $env:ALLUSERSPROFILE
[String]$envAppData = [Environment]::GetFolderPath('ApplicationData')
[String]$envArchitecture = $env:PROCESSOR_ARCHITECTURE
[String]$envCommonDesktop = $envShellFolders | Select-Object -ExpandProperty 'Common Desktop' -ErrorAction 'SilentlyContinue'
[String]$envCommonDocuments = $envShellFolders | Select-Object -ExpandProperty 'Common Documents' -ErrorAction 'SilentlyContinue'
[String]$envCommonStartMenuPrograms = $envShellFolders | Select-Object -ExpandProperty 'Common Programs' -ErrorAction 'SilentlyContinue'
[String]$envCommonStartMenu = $envShellFolders | Select-Object -ExpandProperty 'Common Start Menu' -ErrorAction 'SilentlyContinue'
[String]$envCommonStartUp = $envShellFolders | Select-Object -ExpandProperty 'Common Startup' -ErrorAction 'SilentlyContinue'
[String]$envCommonTemplates = $envShellFolders | Select-Object -ExpandProperty 'Common Templates' -ErrorAction 'SilentlyContinue'
[String]$envComputerName = [Environment]::MachineName.ToUpper()
[String]$envHomeDrive = $env:HOMEDRIVE
[String]$envHomePath = $env:HOMEPATH
[String]$envHomeShare = $env:HOMESHARE
[String]$envLocalAppData = [Environment]::GetFolderPath('LocalApplicationData')
[String[]]$envLogicalDrives = [Environment]::GetLogicalDrives()
[String]$envProgramData = [Environment]::GetFolderPath('CommonApplicationData')
[String]$envPublic = $env:PUBLIC
[String]$envSystemDrive = $env:SYSTEMDRIVE
[String]$envSystemRoot = $env:SYSTEMROOT
[String]$envTemp = [IO.Path]::GetTempPath()
[String]$envUserCookies = [Environment]::GetFolderPath('Cookies')
[String]$envUserDesktop = [Environment]::GetFolderPath('DesktopDirectory')
[String]$envUserFavorites = [Environment]::GetFolderPath('Favorites')
[String]$envUserInternetCache = [Environment]::GetFolderPath('InternetCache')
[String]$envUserInternetHistory = [Environment]::GetFolderPath('History')
[String]$envUserMyDocuments = [Environment]::GetFolderPath('MyDocuments')
[String]$envUserName = [Environment]::UserName
[String]$envUserPictures = [Environment]::GetFolderPath('MyPictures')
[String]$envUserProfile = $env:USERPROFILE
[String]$envUserSendTo = [Environment]::GetFolderPath('SendTo')
[String]$envUserStartMenu = [Environment]::GetFolderPath('StartMenu')
[String]$envUserStartMenuPrograms = [Environment]::GetFolderPath('Programs')
[String]$envUserStartUp = [Environment]::GetFolderPath('StartUp')
[String]$envUserTemplates = [Environment]::GetFolderPath('Templates')
[String]$envSystem32Directory = [Environment]::SystemDirectory
[String]$envWinDir = $env:WINDIR

## Variables: Operating System
[PSObject]$envOS = Get-WmiObject -Class 'Win32_OperatingSystem' -ErrorAction 'SilentlyContinue'
[String]$envOSName = $envOS.Caption.Trim()
[String]$envOSServicePack = $envOS.CSDVersion
[Version]$envOSVersion = $envOS.Version
[String]$envOSVersionMajor = $envOSVersion.Major
[String]$envOSVersionMinor = $envOSVersion.Minor
[String]$envOSVersionBuild = $envOSVersion.Build
If ((Get-ItemProperty -LiteralPath 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction 'SilentlyContinue').PSObject.Properties.Name -contains 'UBR') {
    [String]$envOSVersionRevision = (Get-ItemProperty -LiteralPath 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'UBR' -ErrorAction 'SilentlyContinue').UBR
}
ElseIf ((Get-ItemProperty -LiteralPath 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction 'SilentlyContinue').PSObject.Properties.Name -contains 'BuildLabEx') {
    [String]$envOSVersionRevision = , ((Get-ItemProperty -LiteralPath 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'BuildLabEx' -ErrorAction 'SilentlyContinue').BuildLabEx -split '\.') | ForEach-Object { $_[1] }
}
If ($envOSVersionRevision -notmatch '^[\d\.]+$') { $envOSVersionRevision = '' }
If ($envOSVersionRevision) { [string]$envOSVersion = "$($envOSVersion.ToString()).$envOSVersionRevision" } Else { [string]$envOSVersion = "$($envOSVersion.ToString())" }
#  Get the operating system type
[int32]$envOSProductType = $envOS.ProductType
[boolean]$IsServerOS = [boolean]($envOSProductType -eq 3)
[boolean]$IsDomainControllerOS = [boolean]($envOSProductType -eq 2)
[boolean]$IsWorkStationOS = [boolean]($envOSProductType -eq 1)
[boolean]$IsMultiSessionOS = [boolean](($envOSName -match '^Microsoft Windows \d+ Enterprise for Virtual Desktops$') -or ($envOSName -match '^Microsoft Windows \d+ Enterprise Multi-Session$'))

Switch ($envOSProductType) {
    3 { [string]$envOSProductTypeName = 'Server' }
    2 { [string]$envOSProductTypeName = 'Domain Controller' }
    1 { [string]$envOSProductTypeName = 'Workstation' }
    Default { [string]$envOSProductTypeName = 'Unknown' }
}
#  Get the OS Architecture
[Boolean]$Is64Bit = [Boolean]((Get-WmiObject -Class 'Win32_Processor' -ErrorAction 'SilentlyContinue' | Where-Object { $_.DeviceID -eq 'CPU0' } | Select-Object -ExpandProperty 'AddressWidth') -eq 64)
If ($Is64Bit) {
    [String]$envOSArchitecture = '64-bit'
}
Else {
    [String]$envOSArchitecture = '32-bit'
}

## Variables: Current Process Architecture
[Boolean]$Is64BitProcess = [Boolean]([IntPtr]::Size -eq 8)
If ($Is64BitProcess) {
    [String]$psArchitecture = 'x64'
}
Else {
    [String]$psArchitecture = 'x86'
}

## Variables: Get Normalized ProgramFiles and CommonProgramFiles Paths
[String]$envProgramFiles = ''
[String]$envProgramFilesX86 = ''
[String]$envCommonProgramFiles = ''
[String]$envCommonProgramFilesX86 = ''
If ($Is64Bit) {
    If ($Is64BitProcess) {
        [String]$envProgramFiles = [Environment]::GetFolderPath('ProgramFiles')
        [String]$envCommonProgramFiles = [Environment]::GetFolderPath('CommonProgramFiles')
    }
    Else {
        [String]$envProgramFiles = [Environment]::GetEnvironmentVariable('ProgramW6432')
        [String]$envCommonProgramFiles = [Environment]::GetEnvironmentVariable('CommonProgramW6432')
    }
    ## Powershell 2 doesn't support X86 folders so need to use variables instead
    Try {
        [String]$envProgramFilesX86 = [Environment]::GetFolderPath('ProgramFilesX86')
        [String]$envCommonProgramFilesX86 = [Environment]::GetFolderPath('CommonProgramFilesX86')
    }
    Catch {
        [String]$envProgramFilesX86 = [Environment]::GetEnvironmentVariable('ProgramFiles(x86)')
        [String]$envCommonProgramFilesX86 = [Environment]::GetEnvironmentVariable('CommonProgramFiles(x86)')
    }
}
Else {
    [String]$envProgramFiles = [Environment]::GetFolderPath('ProgramFiles')
    [String]$envProgramFilesX86 = $envProgramFiles
    [String]$envCommonProgramFiles = [Environment]::GetFolderPath('CommonProgramFiles')
    [String]$envCommonProgramFilesX86 = $envCommonProgramFiles
}

## Variables: Hardware
[Int32]$envSystemRAM = Get-WmiObject -Class 'Win32_PhysicalMemory' -ErrorAction 'SilentlyContinue' | Measure-Object -Property 'Capacity' -Sum -ErrorAction 'SilentlyContinue' | ForEach-Object { [Math]::Round(($_.Sum / 1GB), 2) }

## Variables: PowerShell And CLR (.NET) Versions
[Hashtable]$envPSVersionTable = $PSVersionTable
#  PowerShell Version
[Version]$envPSVersion = $envPSVersionTable.PSVersion
[String]$envPSVersionMajor = $envPSVersion.Major
[String]$envPSVersionMinor = $envPSVersion.Minor
[String]$envPSVersionBuild = $envPSVersion.Build
[String]$envPSVersionRevision = $envPSVersion.Revision
[String]$envPSVersion = $envPSVersion.ToString()

## Variables: Permissions/Accounts
[Security.Principal.WindowsIdentity]$CurrentProcessToken = [Security.Principal.WindowsIdentity]::GetCurrent()
[Security.Principal.SecurityIdentifier]$CurrentProcessSID = $CurrentProcessToken.User
[String]$ProcessNTAccount = $CurrentProcessToken.Name
[String]$ProcessNTAccountSID = $CurrentProcessSID.Value
[Boolean]$IsAdmin = [Boolean]($CurrentProcessToken.Groups -contains [Security.Principal.SecurityIdentifier]'S-1-5-32-544')
[Boolean]$IsLocalSystemAccount = $CurrentProcessSID.IsWellKnown([Security.Principal.WellKnownSidType]'LocalSystemSid')
[Boolean]$IsLocalServiceAccount = $CurrentProcessSID.IsWellKnown([Security.Principal.WellKnownSidType]'LocalServiceSid')
[Boolean]$IsNetworkServiceAccount = $CurrentProcessSID.IsWellKnown([Security.Principal.WellKnownSidType]'NetworkServiceSid')
[Boolean]$IsServiceAccount = [Boolean]($CurrentProcessToken.Groups -contains [Security.Principal.SecurityIdentifier]'S-1-5-6')
[Boolean]$IsProcessUserInteractive = [Environment]::UserInteractive
$GetAccountNameUsingSid = [ScriptBlock] {
    Param (
        [String]$SecurityIdentifier = $null
    )

    Try {
        Return (New-Object -TypeName 'System.Security.Principal.SecurityIdentifier' -ArgumentList ([Security.Principal.WellKnownSidType]::"$SecurityIdentifier", $null)).Translate([System.Security.Principal.NTAccount]).Value
    }
    Catch {
        Return ($null)
    }
}
[String]$LocalSystemNTAccount = & $GetAccountNameUsingSid 'LocalSystemSid'
[String]$LocalUsersGroup = & $GetAccountNameUsingSid 'BuiltinUsersSid'
# Test if the current Windows is a Home edition
Try {
    If (!((Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Expand Caption) -like "*Home*")){
        [string]$LocalPowerUsersGroup = & $GetAccountNameUsingSid 'BuiltinPowerUsersSid'
    }
}
Catch{}
[String]$LocalAdministratorsGroup = & $GetAccountNameUsingSid 'BuiltinAdministratorsSid'
#  Check if script is running in session zero
[Boolean]$SessionZero = ($IsLocalSystemAccount -or $IsLocalServiceAccount -or $IsNetworkServiceAccount -or $IsServiceAccount)

## Variables: Script Name and Script Paths
[String]$scriptPath = $MyInvocation.MyCommand.Definition
[String]$scriptName = [IO.Path]::GetFileNameWithoutExtension($scriptPath)
[String]$scriptFileName = Split-Path -Path $scriptPath -Leaf
[String]$scriptRoot = Split-Path -Path $scriptPath -Parent
[String]$invokingScript = (Get-Variable -Name 'MyInvocation').Value.ScriptName
#  Get the invoking script directory
If ($invokingScript) {
    #  If this script was invoked by another script
    [String]$scriptParentPath = Split-Path -Path $invokingScript -Parent
}
Else {
    #  If this script was not invoked by another script, fall back to the directory one level above this script
    [String]$scriptParentPath = (Get-Item -LiteralPath $scriptRoot).Parent.FullName
}

# ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
# █          FIM da Declaraçao de Variáveis Comuns          █
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

<#
╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤════════════════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤       FUNÇÕES COMUNS       ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧════════════════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 
- Aqui está uma funções que podem ser utilizadas em qualquer script.
  Essas funções ficam  disponíveis para todos os scripts criados com o Modelo             #>
# ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
# █               INICIO das Funções Comuns                 █
# ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼

# Colocar as funções mais comuns que podemos precisar usar no STF
#
#
# Exemplos:
#
# 1) Função: Write-Log
# 2) Função: Ler Impressoras do Servidor
# 3) Função: Ler grupos do AD do usuário
# 4) Função: Ler grupos do AD
# 5) Função: Obter usuário Logado
# 6) Função: Ler impressoras Instaladas no usuário
# 7) Função: Criar pasta
# 8) 

Function Write-FunctionHeaderOrFooter {
    <#
    .SYNOPSIS
    
    Write the function header or footer to the log upon first entering or exiting a function.
    
    .DESCRIPTION
    
    Write the "Function Start" message, the bound parameters the function was invoked with, or the "Function End" message when entering or exiting a function.
    
    Messages are debug messages so will only be logged if LogDebugMessage option is enabled in XML config file.
    
    .PARAMETER CmdletName
    
    The name of the function this function is invoked from.
    
    .PARAMETER CmdletBoundParameters
    
    The bound parameters of the function this function is invoked from.
    
    .PARAMETER Header
    
    Write the function header.
    
    .PARAMETER Footer
    
    Write the function footer.
    
    .INPUTS
    
    None
    
    You cannot pipe objects to this function.
    
    .OUTPUTS
    
    None
    
    This function does not generate any output.
    
    .EXAMPLE
    
    Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    
    .EXAMPLE
    
    Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    
    .NOTES
    
    This is an internal script function and should typically not be called directly.
    
    .LINK
    
    https://psappdeploytoolkit.com
    #>
        [CmdletBinding()]
        Param (
            [Parameter(Mandatory = $true)]
            [ValidateNotNullorEmpty()]
            [String]$CmdletName,
            [Parameter(Mandatory = $true, ParameterSetName = 'Header')]
            [AllowEmptyCollection()]
            [Hashtable]$CmdletBoundParameters,
            [Parameter(Mandatory = $true, ParameterSetName = 'Header')]
            [Switch]$Header,
            [Parameter(Mandatory = $true, ParameterSetName = 'Footer')]
            [Switch]$Footer
        )
    
        If ($Header) {
            Write-Log -Message 'Function Start' -Source ${CmdletName} -DebugMessage
    
            ## Get the parameters that the calling function was invoked with
            [String]$CmdletBoundParameters = $CmdletBoundParameters | Format-Table -Property @{ Label = 'Parameter'; Expression = { "[-$($_.Key)]" } }, @{ Label = 'Value'; Expression = { $_.Value }; Alignment = 'Left' }, @{ Label = 'Type'; Expression = { $_.Value.GetType().Name }; Alignment = 'Left' } -AutoSize -Wrap | Out-String
            If ($CmdletBoundParameters) {
                Write-Log -Message "Function invoked with bound parameter(s): `r`n$CmdletBoundParameters" -Source ${CmdletName} -DebugMessage
            }
            Else {
                Write-Log -Message 'Function invoked without any bound parameters.' -Source ${CmdletName} -DebugMessage
            }
        }
        ElseIf ($Footer) {
            Write-Log -Message 'Function End' -Source ${CmdletName} -DebugMessage
        }
    }
    #endregion
    
# Função Write-Log
Function Write-Log {
    <#
.SYNOPSIS

Write messages to a log file in CMTrace.exe compatible format or Legacy text file format.

.DESCRIPTION

Write messages to a log file in CMTrace.exe compatible format or Legacy text file format and optionally display in the console.

.PARAMETER Message

The message to write to the log file or output to the console.

.PARAMETER Severity

Defines message type. When writing to console or CMTrace.exe log format, it allows highlighting of message type.
Options: 0 = Success (highlighted in green), 1 = Information (default), 2 = Warning (highlighted in yellow), 3 = Error (highlighted in red)

.PARAMETER Source

The source of the message being logged.

.PARAMETER ScriptSection

The heading for the portion of the script that is being executed. Default is: $script:installPhase.

.PARAMETER LogType

Choose whether to write a CMTrace.exe compatible log file or a Legacy text log file.

.PARAMETER LogFileDirectory

Set the directory where the log file will be saved.

.PARAMETER LogFileName

Set the name of the log file.

.PARAMETER AppendToLogFile

Append to existing log file rather than creating a new one upon toolkit initialization. Default value is defined in AppDeployToolkitConfig.xml.

.PARAMETER MaxLogHistory

Maximum number of previous log files to retain. Default value is defined in AppDeployToolkitConfig.xml.

.PARAMETER MaxLogFileSizeMB

Maximum file size limit for log file in megabytes (MB). Default value is defined in AppDeployToolkitConfig.xml.

.PARAMETER ContinueOnError

Suppress writing log message to console on failure to write message to log file. Default is: $true.

.PARAMETER WriteHost

Write the log message to the console.

.PARAMETER PassThru

Return the message that was passed to the function

.PARAMETER DebugMessage

Specifies that the message is a debug message. Debug messages only get logged if -LogDebugMessage is set to $true.

.PARAMETER LogDebugMessage

Debug messages only get logged if this parameter is set to $true in the config XML file.

.INPUTS

System.String

The message to write to the log file or output to the console.

.OUTPUTS

None

This function does not generate any output.

.EXAMPLE

Write-Log -Message "Installing patch MS15-031" -Source 'Add-Patch' -LogType 'CMTrace'

.EXAMPLE

Write-Log -Message "Script is running on Windows 8" -Source 'Test-ValidOS' -LogType 'Legacy'

.EXAMPLE

Write-Log -Message "Log only message" -WriteHost $false

.NOTES

.LINK
https://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [AllowEmptyCollection()]
        [Alias('Text')]
        [String[]]$Message,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateRange(0, 3)]
        [Int16]$Severity = 1,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNull()]
        [String]$Source = $([String]$parentFunctionName = [IO.Path]::GetFileNameWithoutExtension((Get-Variable -Name 'MyInvocation' -Scope 1 -ErrorAction 'SilentlyContinue').Value.MyCommand.Name); If ($parentFunctionName) {
            $parentFunctionName
        }
        Else {
            'Unknown'
        }),
        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateNotNullorEmpty()]
        [String]$ScriptSection = $script:FaseDoScript,
        [Parameter(Mandatory = $false, Position = 4)]
        [ValidateSet('CMTrace', 'Legacy')]
        [String]$LogType = 'CMTrace',
        [Parameter(Mandatory = $false, Position = 5)]
        [ValidateNotNullorEmpty()]
        [String]$LogFileDirectory = $configLogDir,
        [Parameter(Mandatory = $false, Position = 6)]
        [ValidateNotNullorEmpty()]
        [String]$LogFileName = $configLogName,
        [Parameter(Mandatory=$false,Position=7)]
        [ValidateNotNullorEmpty()]
        [Boolean]$AppendToLogFile = $configLogAppend,
        [Parameter(Mandatory=$false,Position=8)]
        [ValidateNotNullorEmpty()]
        [Int]$MaxLogHistory = $configLogMaxHistory,
        [Parameter(Mandatory = $false, Position = 9)]
        [ValidateNotNullorEmpty()]
        [Decimal]$MaxLogFileSizeMB = $configLogMaxSize,
	    [Parameter(Mandatory=$false,Position=10)]
        [ValidateNotNullorEmpty()]
        [Boolean]$ContinueOnError = $true,
        [Parameter(Mandatory = $false, Position = 11)]
        [ValidateNotNullorEmpty()]
        [Boolean]$WriteHost = $configLogWriteToHost,
        [Parameter(Mandatory=$false,Position=12)]
        [Switch]$PassThru = $false,
	    [Parameter(Mandatory=$false,Position=13)]
        [Switch]$DebugMessage = $false,
	    [Parameter(Mandatory=$false,Position=14)]
        [Boolean]$LogDebugMessage = $configLogDebugMessage
    )

    Begin {
        ## Get the name of this function
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        ## Logging Variables
        #  Log file date/time
        [DateTime]$DateTimeNow = Get-Date
        [String]$LogTime = $DateTimeNow.ToString('HH\:mm\:ss.fff')
        [String]$LogDate = $DateTimeNow.ToString('MM-dd-yyyy')
        If (-not (Test-Path -LiteralPath 'variable:LogTimeZoneBias')) {
            [Int32]$script:LogTimeZoneBias = [TimeZone]::CurrentTimeZone.GetUtcOffset($DateTimeNow).TotalMinutes
        }
        [String]$LogTimePlusBias = $LogTime + $script:LogTimeZoneBias
        #  Initialize variables
        [Boolean]$ExitLoggingFunction = $false
        If (-not (Test-Path -LiteralPath 'variable:DisableLogging')) {
            $DisableLogging = $false
        }
        If ([System.String]::IsNullOrEmpty($LogFileName) -or $LogFileName.Trim().Length -eq 0) {
            $DisableLogging = $true
        }
        #  Check if the script section is defined
        [Boolean]$ScriptSectionDefined = [Boolean](-not [String]::IsNullOrEmpty($ScriptSection))
        #  Get the file name of the source script
        $ScriptSource = If (![System.String]::IsNullOrEmpty($script:MyInvocation.ScriptName)) {
            Split-Path -Path $script:MyInvocation.ScriptName -Leaf -ErrorAction SilentlyContinue
        }
        Else {
            Split-Path -Path $script:MyInvocation.MyCommand.Definition -Leaf -ErrorAction SilentlyContinue
        }

        ## Create script block for generating CMTrace.exe compatible log entry
        [ScriptBlock]$CMTraceLogString = {
            Param (
                [String]$lMessage,
                [String]$lSource,
                [Int16]$lSeverity
            )
            "<![LOG[$lMessage]LOG]!>" + "<time=`"$LogTimePlusBias`" " + "date=`"$LogDate`" " + "component=`"$lSource`" " + "context=`"$([Security.Principal.WindowsIdentity]::GetCurrent().Name)`" " + "type=`"$lSeverity`" " + "thread=`"$PID`" " + "file=`"$ScriptSource`">"
        }

        ## Create script block for writing log entry to the console
        [ScriptBlock]$WriteLogLineToHost = {
            Param (
                [String]$lTextLogLine,
                [Int16]$lSeverity
            )
            If ($WriteHost) {
                #  Only output using color options if running in a host which supports colors.
                If ($Host.UI.RawUI.ForegroundColor) {
                    Switch ($lSeverity) {
                        3 {
                            Write-Host -Object $lTextLogLine -ForegroundColor 'Red' -BackgroundColor 'Black'
                        }
                        2 {
                            Write-Host -Object $lTextLogLine -ForegroundColor 'Yellow' -BackgroundColor 'Black'
                        }
                        1 {
                            Write-Host -Object $lTextLogLine
                        }
                        0 {
                            Write-Host -Object $lTextLogLine -ForegroundColor 'Green' -BackgroundColor 'Black'
                        }
                    }
                }
                #  If executing "powershell.exe -File <filename>.ps1 > log.txt", then all the Write-Host calls are converted to Write-Output calls so that they are included in the text log.
                Else {
                    Write-Output -InputObject ($lTextLogLine)
                }
            }
        }

        ## Exit function if it is a debug message and logging debug messages is not enabled in the config XML file
        If (($DebugMessage) -and (-not $LogDebugMessage)) {
            [Boolean]$ExitLoggingFunction = $true; Return
        }
        ## Exit function if logging to file is disabled and logging to console host is disabled
        If (($DisableLogging) -and (-not $WriteHost)) {
            [Boolean]$ExitLoggingFunction = $true; Return
        }
        ## Exit Begin block if logging is disabled
        If ($DisableLogging) {
            Return
        }
        ## Exit function function if it is an [Initialization] message and the toolkit has been relaunched
        If (($AsyncToolkitLaunch) -and ($ScriptSection -eq 'Initialization')) {
            [Boolean]$ExitLoggingFunction = $true; Return
        }

        ## Create the directory where the log file will be saved
        If (-not (Test-Path -LiteralPath $LogFileDirectory -PathType 'Container')) {
            Try {
                $null = New-Item -Path $LogFileDirectory -Type 'Directory' -Force -ErrorAction 'Stop'
            }
            Catch {
                [Boolean]$ExitLoggingFunction = $true
                #  If error creating directory, write message to console
                If (-not $ContinueOnError) {
                    Write-Host -Object "[$LogDate $LogTime] [${CmdletName}] $ScriptSection :: Failed to create the log directory [$LogFileDirectory]. `r`n$(Resolve-Error)" -ForegroundColor 'Red'
                }
                Return
            }
        }

        ## Assemble the fully qualified path to the log file
        [String]$LogFilePath = Join-Path -Path $LogFileDirectory -ChildPath $LogFileName
        if (Test-Path -Path $LogFilePath -PathType Leaf) {
            Try {
                $LogFile = Get-Item $LogFilePath
                [Decimal]$LogFileSizeMB = $LogFile.Length / 1MB

                # Check if log file needs to be rotated
                if ((!$script:LogFileInitialized -and !$AppendToLogFile) -or ($MaxLogFileSizeMB -gt 0 -and $LogFileSizeMB -gt $MaxLogFileSizeMB)) {

                    # Get new log file path
                    $LogFileNameWithoutExtension = [IO.Path]::GetFileNameWithoutExtension($LogFileName)
                    $LogFileExtension = [IO.Path]::GetExtension($LogFileName)
                    $Timestamp = $LogFile.LastWriteTime.ToString('yyyy-MM-dd-HH-mm-ss')
                    $ArchiveLogFileName = "{0}_{1}{2}" -f $LogFileNameWithoutExtension, $Timestamp, $LogFileExtension
                    [String]$ArchiveLogFilePath = Join-Path -Path $LogFileDirectory -ChildPath $ArchiveLogFileName

                    if ($MaxLogFileSizeMB -gt 0 -and $LogFileSizeMB -gt $MaxLogFileSizeMB) {
                        [Hashtable]$ArchiveLogParams = @{ ScriptSection = $ScriptSection; Source = ${CmdletName}; Severity = 2; LogFileDirectory = $LogFileDirectory; LogFileName = $LogFileName; LogType = $LogType; MaxLogFileSizeMB = 0; AppendToLogFile = $true; WriteHost = $WriteHost; ContinueOnError = $ContinueOnError; PassThru = $false }

                        ## Log message about archiving the log file
                        $ArchiveLogMessage = "Maximum log file size [$MaxLogFileSizeMB MB] reached. Rename log file to [$ArchiveLogFileName]."
                        Write-Log -Message $ArchiveLogMessage @ArchiveLogParams
                    }

                    # Rename the file
                    Move-Item -Path $LogFilePath -Destination $ArchiveLogFilePath -Force -ErrorAction 'Stop'

                    if ($MaxLogFileSizeMB -gt 0 -and $LogFileSizeMB -gt $MaxLogFileSizeMB) {
                        ## Start new log file and Log message about archiving the old log file
                        $NewLogMessage = "Previous log file was renamed to [$ArchiveLogFileName] because maximum log file size of [$MaxLogFileSizeMB MB] was reached."
                        Write-Log -Message $NewLogMessage @ArchiveLogParams
                    }

                    # Get all log files (including any .lo_ files that may have been created by previous toolkit versions) sorted by last write time
                    $LogFiles = @(Get-ChildItem -LiteralPath $LogFileDirectory -Filter ("{0}_*{1}" -f $LogFileNameWithoutExtension, $LogFileExtension)) + @(Get-Item -LiteralPath ([IO.Path]::ChangeExtension($LogFilePath, 'lo_')) -ErrorAction Ignore) | Sort-Object LastWriteTime

                    # Keep only the max number of log files
                    if ($LogFiles.Count -gt $MaxLogHistory) {
                        $LogFiles | Select-Object -First ($LogFiles.Count - $MaxLogHistory) | Remove-Item -ErrorAction 'Stop'
                    }
                }
            }
            Catch {
                Write-Host -Object "[$LogDate $LogTime] [${CmdletName}] $ScriptSection :: Failed to rotate the log file [$LogFilePath]. `r`n$(Resolve-Error)" -ForegroundColor 'Red'
                # Treat log rotation errors as non-terminating by default
                If (-not $ContinueOnError) {
                    [Boolean]$ExitLoggingFunction = $true
                    Return
                }
            }
        }

        $script:LogFileInitialized = $true
    }
    Process {
        ## Exit function if logging is disabled
        If ($ExitLoggingFunction) {
            Return
        }

        ForEach ($Msg in $Message) {
            ## If the message is not $null or empty, create the log entry for the different logging methods
            [String]$CMTraceMsg = ''
            [String]$ConsoleLogLine = ''
            [String]$LegacyTextLogLine = ''
            If ($Msg) {
                #  Create the CMTrace log message
                If ($ScriptSectionDefined) {
                    [String]$CMTraceMsg = "[$ScriptSection] :: $Msg"
                }

                #  Create a Console and Legacy "text" log entry
                [String]$LegacyMsg = "[$LogDate $LogTime]"
                If ($ScriptSectionDefined) {
                    [String]$LegacyMsg += " [$ScriptSection]"
                }
                If ($Source) {
                    [String]$ConsoleLogLine = "$LegacyMsg [$Source] :: $Msg"
                    Switch ($Severity) {
                        3 {
                            [String]$LegacyTextLogLine = "$LegacyMsg [$Source] [Error] :: $Msg"
                        }
                        2 {
                            [String]$LegacyTextLogLine = "$LegacyMsg [$Source] [Warning] :: $Msg"
                        }
                        1 {
                            [String]$LegacyTextLogLine = "$LegacyMsg [$Source] [Info] :: $Msg"
                        }
                        0 {
                            [String]$LegacyTextLogLine = "$LegacyMsg [$Source] [Success] :: $Msg"
                        }
                    }
                }
                Else {
                    [String]$ConsoleLogLine = "$LegacyMsg :: $Msg"
                    Switch ($Severity) {
                        3 {
                            [String]$LegacyTextLogLine = "$LegacyMsg [Error] :: $Msg"
                        }
                        2 {
                            [String]$LegacyTextLogLine = "$LegacyMsg [Warning] :: $Msg"
                        }
                        1 {
                            [String]$LegacyTextLogLine = "$LegacyMsg [Info] :: $Msg"
                        }
                        0 {
                            [String]$LegacyTextLogLine = "$LegacyMsg [Success] :: $Msg"
                        }
                    }
                }
            }

            ## Execute script block to create the CMTrace.exe compatible log entry
            [String]$CMTraceLogLine = & $CMTraceLogString -lMessage $CMTraceMsg -lSource $Source -lSeverity $Severity

            ## Choose which log type to write to file
            If ($LogType -ieq 'CMTrace') {
                [String]$LogLine = $CMTraceLogLine
            }
            Else {
                [String]$LogLine = $LegacyTextLogLine
            }

            ## Write the log entry to the log file if logging is not currently disabled
            If (-not $DisableLogging) {
                Try {
                    $LogLine | Out-File -FilePath $LogFilePath -Append -NoClobber -Force -Encoding 'UTF8' -ErrorAction 'Stop'
#                    $LogLine | Out-File -LiteralPath $LogFilePath -Append -NoClobber -Force -Encoding 'UTF8BOM' -ErrorAction 'Stop'
                }
                Catch {
                    If (-not $ContinueOnError) {
                        Write-Host -Object "[$LogDate $LogTime] [$ScriptSection] [${CmdletName}] :: Failed to write message [$Msg] to the log file [$LogFilePath]. `r`n$(Resolve-Error)" -ForegroundColor 'Red'
                    }
                }
            }

            ## Execute script block to write the log entry to the console if $WriteHost is $true
            & $WriteLogLineToHost -lTextLogLine $ConsoleLogLine -lSeverity $Severity
        }
    }
    End {
        If ($PassThru) {
            Write-Output -InputObject ($Message)
        }
    }
}

# Função Execute-Process
Function Execute-Process {
    <#
.SYNOPSIS

Execute a process with optional arguments, working directory, window style.

.DESCRIPTION

Executes a process, e.g. a file included in the Files directory of the App Deploy Toolkit, or a file on the local machine.
Provides various options for handling the return codes (see Parameters).

.PARAMETER Path

Path to the file to be executed. If the file is located directly in the "Files" directory of the App Deploy Toolkit, only the file name needs to be specified.
Otherwise, the full path of the file must be specified. If the files is in a subdirectory of "Files", use the "$dirFiles" variable as shown in the example.

.PARAMETER Parameters

Arguments to be passed to the executable

.PARAMETER SecureParameters

Hides all parameters passed to the executable from the Toolkit log file

.PARAMETER WindowStyle

Style of the window of the process executed. Options: Normal, Hidden, Maximized, Minimized. Default: Normal.
Note: Not all processes honor WindowStyle. WindowStyle is a recommendation passed to the process. They can choose to ignore it.
Only works for native Windows GUI applications. If the WindowStyle is set to Hidden, UseShellExecute should be set to $true.

.PARAMETER CreateNoWindow

Specifies whether the process should be started with a new window to contain it. Only works for Console mode applications. UseShellExecute should be set to $false.
Default is false.

.PARAMETER WorkingDirectory

The working directory used for executing the process. Defaults to the directory of the file being executed.
Parameter UseShellExecute affects this parameter.

.PARAMETER NoWait

Immediately continue after executing the process.

.PARAMETER PassThru

If NoWait is not specified, returns an object with ExitCode, STDOut and STDErr output from the process. If NoWait is specified, returns an object with Id, Handle and ProcessName.

.PARAMETER WaitForMsiExec

Sometimes an EXE bootstrapper will launch an MSI install. In such cases, this variable will ensure that
this function waits for the msiexec engine to become available before starting the install.

.PARAMETER MsiExecWaitTime

Specify the length of time in seconds to wait for the msiexec engine to become available. Default: 600 seconds (10 minutes).

.PARAMETER IgnoreExitCodes

List the exit codes to ignore or * to ignore all exit codes.

.PARAMETER PriorityClass

Specifies priority class for the process. Options: Idle, Normal, High, AboveNormal, BelowNormal, RealTime. Default: Normal

.PARAMETER ExitOnProcessFailure

Specifies whether the function should call Exit-Script when the process returns an exit code that is considered an error/failure. Default: $true

.PARAMETER UseShellExecute

Specifies whether to use the operating system shell to start the process. $true if the shell should be used when starting the process; $false if the process should be created directly from the executable file.

The word "Shell" in this context refers to a graphical shell (similar to the Windows shell) rather than command shells (for example, bash or sh) and lets users launch graphical applications or open documents.
It lets you open a file or a url and the Shell will figure out the program to open it with.
The WorkingDirectory property behaves differently depending on the value of the UseShellExecute property. When UseShellExecute is true, the WorkingDirectory property specifies the location of the executable.
When UseShellExecute is false, the WorkingDirectory property is not used to find the executable. Instead, it is used only by the process that is started and has meaning only within the context of the new process.
If you set UseShellExecute to $true, there will be no available output from the process.

Default: $false

.PARAMETER ContinueOnError

Continue if an error occured while trying to start the process. Default: $false.

.EXAMPLE

Execute-Process -Path 'uninstall_flash_player_64bit.exe' -Parameters '/uninstall' -WindowStyle 'Hidden'

If the file is in the "Files" directory of the App Deploy Toolkit, only the file name needs to be specified.

.INPUTS

None

You cannot pipe objects to this function.

.OUTPUTS

None

This function does not generate any output.

.EXAMPLE

Execute-Process -Path "$dirFiles\Bin\setup.exe" -Parameters '/S' -WindowStyle 'Hidden'

.EXAMPLE

Execute-Process -Path 'setup.exe' -Parameters '/S' -IgnoreExitCodes '1,2'

.EXAMPLE

Execute-Process -Path 'setup.exe' -Parameters "-s -f2`"$configToolkitLogDir\$installName.log`""

Launch InstallShield "setup.exe" from the ".\Files" sub-directory and force log files to the logging folder.

.EXAMPLE

Execute-Process -Path 'setup.exe' -Parameters "/s /v`"ALLUSERS=1 /qn /L* \`"$configToolkitLogDir\$installName.log`"`""

Launch InstallShield "setup.exe" with embedded MSI and force log files to the logging folder.

.NOTES

.LINK

https://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [Alias('FilePath')]
        [ValidateNotNullorEmpty()]
        [String]$Path,
        [Parameter(Mandatory = $false)]
        [Alias('Arguments')]
        [ValidateNotNullorEmpty()]
        [String[]]$Parameters,
        [Parameter(Mandatory = $false)]
        [Switch]$SecureParameters = $false,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Normal', 'Hidden', 'Maximized', 'Minimized')]
        [Diagnostics.ProcessWindowStyle]$WindowStyle = 'Normal',
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [Switch]$CreateNoWindow = $false,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [String]$WorkingDirectory,
        [Parameter(Mandatory = $false)]
        [Switch]$NoWait = $false,
        [Parameter(Mandatory = $false)]
        [Switch]$PassThru = $false,
        [Parameter(Mandatory = $false)]
        [Switch]$WaitForMsiExec = $false,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [Int32]$MsiExecWaitTime = 600,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [String]$IgnoreExitCodes,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Idle', 'Normal', 'High', 'AboveNormal', 'BelowNormal', 'RealTime')]
        [Diagnostics.ProcessPriorityClass]$PriorityClass = 'Normal',
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [Boolean]$ExitOnProcessFailure = $true,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [Boolean]$UseShellExecute = $false,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [Boolean]$ContinueOnError = $false
    )

    Begin {
        ## Get the name of this function and write header
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {
            $private:returnCode = $null
            $stdOut = $stdErr = $null

            ## Validate and find the fully qualified path for the $Path variable.
            If (([IO.Path]::IsPathRooted($Path)) -and ([IO.Path]::HasExtension($Path))) {
                Write-Log -Message "[$Path] is a valid fully qualified path, continue." -Source ${CmdletName}
                If (-not (Test-Path -LiteralPath $Path -PathType 'Leaf' -ErrorAction 'Stop')) {
                    Write-Log -Message "File [$Path] not found." -Severity 3 -Source ${CmdletName}
                    If (-not $ContinueOnError) {
                        Throw "File [$Path] not found."
                    }
                    Return
                }
            }
            Else {
                #  The first directory to search will be the 'Files' subdirectory of the script directory
                [String]$PathFolders = $dirFiles
                #  Add the current location of the console (Windows always searches this location first)
                [String]$PathFolders = $PathFolders + ';' + (Get-Location -PSProvider 'FileSystem').Path
                #  Add the new path locations to the PATH environment variable
                $env:PATH = $PathFolders + ';' + $env:PATH

                #  Get the fully qualified path for the file. Get-Command searches PATH environment variable to find this value.
                [String]$FullyQualifiedPath = Get-Command -Name $Path -CommandType 'Application' -TotalCount 1 -Syntax -ErrorAction 'Stop'

                #  Revert the PATH environment variable to it's original value
                $env:PATH = $env:PATH -replace [RegEx]::Escape($PathFolders + ';'), ''

                If ($FullyQualifiedPath) {
                    Write-Log -Message "[$Path] successfully resolved to fully qualified path [$FullyQualifiedPath]." -Source ${CmdletName}
                    $Path = $FullyQualifiedPath
                }
                Else {
                    Write-Log -Message "[$Path] contains an invalid path or file name." -Severity 3 -Source ${CmdletName}
                    If (-not $ContinueOnError) {
                        Throw "[$Path] contains an invalid path or file name."
                    }
                    Return
                }
            }

            ## Set the Working directory (if not specified)
            If (-not $WorkingDirectory) {
                $WorkingDirectory = Split-Path -Path $Path -Parent -ErrorAction 'Stop'
            }

            ## If the WindowStyle parameter is set to 'Hidden', set the UseShellExecute parameter to '$true'.
            If ($WindowStyle -eq 'Hidden') {
                $UseShellExecute = $true
            }

            ## If MSI install, check to see if the MSI installer service is available or if another MSI install is already underway.
            ## Please note that a race condition is possible after this check where another process waiting for the MSI installer
            ##  to become available grabs the MSI Installer mutex before we do. Not too concerned about this possible race condition.
            If (($Path -match 'msiexec') -or ($WaitForMsiExec)) {
                [Timespan]$MsiExecWaitTimeSpan = New-TimeSpan -Seconds $MsiExecWaitTime
                [Boolean]$MsiExecAvailable = Test-IsMutexAvailable -MutexName 'Global\_MSIExecute' -MutexWaitTimeInMilliseconds $MsiExecWaitTimeSpan.TotalMilliseconds
                Start-Sleep -Seconds 1
                If (-not $MsiExecAvailable) {
                    #  Default MSI exit code for install already in progress
                    [Int32]$returnCode = 1618
                    Write-Log -Message 'Another MSI installation is already in progress and needs to be completed before proceeding with this installation.' -Severity 3 -Source ${CmdletName}
                    If (-not $ContinueOnError) {
                        Throw 'Another MSI installation is already in progress and needs to be completed before proceeding with this installation.'
                    }
                    Return
                }
            }

            Try {
                ## Disable Zone checking to prevent warnings when running executables
                $env:SEE_MASK_NOZONECHECKS = 1

                ## Using this variable allows capture of exceptions from .NET methods. Private scope only changes value for current function.
                $private:previousErrorActionPreference = $ErrorActionPreference
                $ErrorActionPreference = 'Stop'

                ## Define process
                $processStartInfo = New-Object -TypeName 'System.Diagnostics.ProcessStartInfo' -ErrorAction 'Stop'
                $processStartInfo.FileName = $Path
                $processStartInfo.WorkingDirectory = $WorkingDirectory
                $processStartInfo.UseShellExecute = $UseShellExecute
                $processStartInfo.ErrorDialog = $false
                $processStartInfo.RedirectStandardOutput = $true
                $processStartInfo.RedirectStandardError = $true
                $processStartInfo.CreateNoWindow = $CreateNoWindow
                If ($Parameters) {
                    $processStartInfo.Arguments = $Parameters
                }
                $processStartInfo.WindowStyle = $WindowStyle
                If ($processStartInfo.UseShellExecute -eq $true) {
                    Write-Log -Message 'UseShellExecute is set to true, standard output and error will not be available.' -Source ${CmdletName}
                    $processStartInfo.RedirectStandardOutput = $false
                    $processStartInfo.RedirectStandardError = $false
                }
                $process = New-Object -TypeName 'System.Diagnostics.Process' -ErrorAction 'Stop'
                $process.StartInfo = $processStartInfo

                If ($processStartInfo.UseShellExecute -eq $false) {
                    ## Add event handler to capture process's standard output redirection
                    [ScriptBlock]$processEventHandler = { If (-not [String]::IsNullOrEmpty($EventArgs.Data)) {
                            $Event.MessageData.AppendLine($EventArgs.Data)
                        } }
                    $stdOutBuilder = New-Object -TypeName 'System.Text.StringBuilder' -ArgumentList ('')
                    $stdOutEvent = Register-ObjectEvent -InputObject $process -Action $processEventHandler -EventName 'OutputDataReceived' -MessageData $stdOutBuilder -ErrorAction 'Stop'
                    $stdErrBuilder = New-Object -TypeName 'System.Text.StringBuilder' -ArgumentList ('')
                    $stdErrEvent = Register-ObjectEvent -InputObject $process -Action $processEventHandler -EventName 'ErrorDataReceived' -MessageData $stdErrBuilder -ErrorAction 'Stop'
                }

                ## Start Process
                Write-Log -Message "Working Directory is [$WorkingDirectory]." -Source ${CmdletName}
                If ($Parameters) {
                    If ($Parameters -match '-Command \&') {
                        Write-Log -Message "Executing [$Path [PowerShell ScriptBlock]]..." -Source ${CmdletName}
                    }
                    Else {
                        If ($SecureParameters) {
                            Write-Log -Message "Executing [$Path (Parameters Hidden)]..." -Source ${CmdletName}
                        }
                        Else {
                            Write-Log -Message "Executing [$Path $Parameters]..." -Source ${CmdletName}
                        }
                    }
                }
                Else {
                    Write-Log -Message "Executing [$Path]..." -Source ${CmdletName}
                }

                $null = $process.Start()
                ## Set priority
                If ($PriorityClass -ne 'Normal') {
                    Try {
                        If ($process.HasExited -eq $false) {
                            Write-Log -Message "Changing the priority class for the process to [$PriorityClass]" -Source ${CmdletName}
                            $process.PriorityClass = $PriorityClass
                        }
                        Else {
                            Write-Log -Message "Cannot change the priority class for the process to [$PriorityClass], because the process has exited already." -Severity 2 -Source ${CmdletName}
                        }

                    }
                    Catch {
                        Write-Log -Message 'Failed to change the priority class for the process.' -Severity 2 -Source ${CmdletName}
                    }
                }
                ## NoWait specified, return process details. If it isn't specified, start reading standard Output and Error streams
                If ($NoWait) {
                    Write-Log -Message 'NoWait parameter specified. Continuing without waiting for exit code...' -Source ${CmdletName}

                    If ($PassThru) {
                        If ($process.HasExited -eq $false) {
                            Write-Log -Message 'PassThru parameter specified, returning process details object.' -Source ${CmdletName}
                            [PSObject]$ProcessDetails = New-Object -TypeName 'PSObject' -Property @{ Id = If ($process.Id) {
                                    $process.Id
                                }
                                Else {
                                    $null
                                } ; Handle                                                              = If ($process.Handle) {
                                    $process.Handle
                                }
                                Else {
                                    [IntPtr]::Zero
                                }; ProcessName                                                          = If ($process.ProcessName) {
                                    $process.ProcessName
                                }
                                Else {
                                    ''
                                }
                            }
                            Write-Output -InputObject ($ProcessDetails)
                        }
                        Else {
                            Write-Log -Message 'PassThru parameter specified, however the process has already exited.' -Source ${CmdletName}
                        }
                    }
                }
                Else {
                    If ($processStartInfo.UseShellExecute -eq $false) {
                        $process.BeginOutputReadLine()
                        $process.BeginErrorReadLine()
                    }
                    ## Instructs the Process component to wait indefinitely for the associated process to exit.
                    $process.WaitForExit()

                    ## HasExited indicates that the associated process has terminated, either normally or abnormally. Wait until HasExited returns $true.
                    While (-not $process.HasExited) {
                        $process.Refresh(); Start-Sleep -Seconds 1
                    }

                    ## Get the exit code for the process
                    Try {
                        [Int32]$returnCode = $process.ExitCode
                    }
                    Catch [System.Management.Automation.PSInvalidCastException] {
                        #  Catch exit codes that are out of int32 range
                        [Int32]$returnCode = 60013
                    }

                    If ($processStartInfo.UseShellExecute -eq $false) {
                        ## Unregister standard output and error event to retrieve process output
                        If ($stdOutEvent) {
                            Unregister-Event -SourceIdentifier $stdOutEvent.Name -ErrorAction 'Stop'; $stdOutEvent = $null
                        }
                        If ($stdErrEvent) {
                            Unregister-Event -SourceIdentifier $stdErrEvent.Name -ErrorAction 'Stop'; $stdErrEvent = $null
                        }
                        $stdOut = $stdOutBuilder.ToString() -replace $null, ''
                        $stdErr = $stdErrBuilder.ToString() -replace $null, ''

                        If ($stdErr.Length -gt 0) {
                            Write-Log -Message "Standard error output from the process: $stdErr" -Severity 3 -Source ${CmdletName}
                        }
                    }
                }
            }
            Finally {
                If ($processStartInfo.UseShellExecute -eq $false) {
                    ## Make sure the standard output and error event is unregistered
                    If ($stdOutEvent) {
                        Unregister-Event -SourceIdentifier $stdOutEvent.Name -ErrorAction 'SilentlyContinue'; $stdOutEvent = $null
                    }
                    If ($stdErrEvent) {
                        Unregister-Event -SourceIdentifier $stdErrEvent.Name -ErrorAction 'SilentlyContinue'; $stdErrEvent = $null
                    }
                }
                ## Free resources associated with the process, this does not cause process to exit
                If ($process) {
                    $process.Dispose()
                }

                ## Re-enable Zone checking
                Remove-Item -LiteralPath 'env:SEE_MASK_NOZONECHECKS' -ErrorAction 'SilentlyContinue'

                If ($private:previousErrorActionPreference) {
                    $ErrorActionPreference = $private:previousErrorActionPreference
                }
            }

            If (-not $NoWait) {
                ## Check to see whether we should ignore exit codes
                $ignoreExitCodeMatch = $false
                If ($ignoreExitCodes) {
                    ## Check whether * was specified, which would tell us to ignore all exit codes
                    If ($ignoreExitCodes.Trim() -eq '*') {
                        $ignoreExitCodeMatch = $true
                    }
                    Else {
                        ## Split the processes on a comma
                        [Int32[]]$ignoreExitCodesArray = $ignoreExitCodes -split ','
                        ForEach ($ignoreCode in $ignoreExitCodesArray) {
                            If ($returnCode -eq $ignoreCode) {
                                $ignoreExitCodeMatch = $true
                            }
                        }
                    }
                }

                ## If the passthru switch is specified, return the exit code and any output from process
                If ($PassThru) {
                    Write-Log -Message 'PassThru parameter specified, returning execution results object.' -Source ${CmdletName}
                    [PSObject]$ExecutionResults = New-Object -TypeName 'PSObject' -Property @{ ExitCode = $returnCode; StdOut = If ($stdOut) {
                            $stdOut
                        }
                        Else {
                            ''
                        }; StdErr = If ($stdErr) {
                            $stdErr
                        }
                        Else {
                            ''
                        }
                    }
                    Write-Output -InputObject ($ExecutionResults)
                }

                If ($ignoreExitCodeMatch) {
                    Write-Log -Message "Execution completed and the exit code [$returncode] is being ignored." -Source ${CmdletName}
                }
                ElseIf (($returnCode -eq 3010) -or ($returnCode -eq 1641)) {
                    Write-Log -Message "Execution completed successfully with exit code [$returnCode]. A reboot is required." -Severity 2 -Source ${CmdletName}
                    Set-Variable -Name 'msiRebootDetected' -Value $true -Scope 'Script'
                }
                ElseIf (($returnCode -eq 1605) -and ($Path -match 'msiexec')) {
                    Write-Log -Message "Execution failed with exit code [$returnCode] because the product is not currently installed." -Severity 3 -Source ${CmdletName}
                }
                ElseIf (($returnCode -eq -2145124329) -and ($Path -match 'wusa')) {
                    Write-Log -Message "Execution failed with exit code [$returnCode] because the Windows Update is not applicable to this system." -Severity 3 -Source ${CmdletName}
                }
                ElseIf (($returnCode -eq 17025) -and ($Path -match 'fullfile')) {
                    Write-Log -Message "Execution failed with exit code [$returnCode] because the Office Update is not applicable to this system." -Severity 3 -Source ${CmdletName}
                }
                ElseIf ($returnCode -eq 0) {
                    Write-Log -Message "Execution completed successfully with exit code [$returnCode]." -Source ${CmdletName}
                }
                Else {
                    [String]$MsiExitCodeMessage = ''
                    If ($Path -match 'msiexec') {
                        [String]$MsiExitCodeMessage = Get-MsiExitCodeMessage -MsiExitCode $returnCode
                    }

                    If ($MsiExitCodeMessage) {
                        Write-Log -Message "Execution failed with exit code [$returnCode]: $MsiExitCodeMessage" -Severity 3 -Source ${CmdletName}
                    }
                    Else {
                        Write-Log -Message "Execution failed with exit code [$returnCode]." -Severity 3 -Source ${CmdletName}
                    }

                    If ($ExitOnProcessFailure) {
                        Exit-Script -ExitCode $returnCode
                    }
                }
            }
        }
        Catch {
            If ([String]::IsNullOrEmpty([String]$returnCode)) {
                [Int32]$returnCode = 60002
                Write-Log -Message "Function failed, setting exit code to [$returnCode]. `r`n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
                If (-not $ContinueOnError) {
                    Throw "Function failed, setting exit code to [$returnCode]. $($_.Exception.Message)"
                }
            }
            Else {
                Write-Log -Message "Execution completed with exit code [$returnCode]. Function failed. `r`n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            }

            If ($PassThru) {
                [PSObject]$ExecutionResults = New-Object -TypeName 'PSObject' -Property @{ ExitCode = $returnCode; StdOut = If ($stdOut) {
                        $stdOut
                    }
                    Else {
                        ''
                    }; StdErr = If ($stdErr) {
                        $stdErr
                    }
                    Else {
                        ''
                    }
                }
                Write-Output -InputObject ($ExecutionResults)
            }

            If ($ExitOnProcessFailure) {
                Exit-Script -ExitCode $returnCode
            }
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}

#region Function Write-FunctionHeaderOrFooter
# Função colocar algumas inforamções uteis no início do LOG
Function Inicializa-Log {
	Write-Log -Message "Nome do Script [$mainScript]"
	Write-Log -Message "Caminho do Script [$mainScriptRoot]"
	Write-Log -Message "Computador [$envComputerName]"
	Write-Log -Message "Usuário [$ProcessNTAccount]"
	Write-Log -Message "Endereço IP [$(Get-LocalIPAddress)]"
	If ($envOSServicePack) { Write-Log -Message "Sistema Operacional [$envOSName $envOSServicePack $envOSArchitecture $envOSVersion]" } 
	Else { Write-Log -Message "Sistema Operacional [$envOSName $envOSArchitecture $envOSVersion]"}
	Write-Log -Message "Tipo do SO [$envOSProductTypeName]"
	Write-Log -Message "Host do PowerShell [$($envHost.Name)] versão [$($envHost.Version)]" 
	Write-Log -Message "Versão do Powershell [$envPSVersion $psArchitecture]"
	
}

#region Function Resolve-Error
Function Resolve-Error {
    <#
.SYNOPSIS

Enumerate error record details.

.DESCRIPTION

Enumerate an error record, or a collection of error record, properties. By default, the details for the last error will be enumerated.

.PARAMETER ErrorRecord

The error record to resolve. The default error record is the latest one: $global:Error(0). This parameter will also accept an array of error records.

.PARAMETER Property

The list of properties to display from the error record. Use "*" to display all properties.

Default list of error properties is: Message, FullyQualifiedErrorId, ScriptStackTrace, PositionMessage, InnerException

.PARAMETER GetErrorRecord

Get error record details as represented by $_.

.PARAMETER GetErrorInvocation

Get error record invocation information as represented by $_.InvocationInfo.

.PARAMETER GetErrorException

Get error record exception details as represented by $_.Exception.

.PARAMETER GetErrorInnerException

Get error record inner exception details as represented by $_.Exception.InnerException. Will retrieve all inner exceptions if there is more than one.

.INPUTS

System.Array.

Accepts an array of error records.

.OUTPUTS

System.String

Displays the error record details.

.EXAMPLE

Resolve-Error

.EXAMPLE

Resolve-Error -Property *

.EXAMPLE

Resolve-Error -Property InnerException

.EXAMPLE

Resolve-Error -GetErrorInvocation:$false

.NOTES

.LINK

https://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [AllowEmptyCollection()]
        [Array]$ErrorRecord,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateNotNullorEmpty()]
        [String[]]$Property = ('Message', 'InnerException', 'FullyQualifiedErrorId', 'ScriptStackTrace', 'PositionMessage'),
        [Parameter(Mandatory = $false, Position = 2)]
        [Switch]$GetErrorRecord = $true,
        [Parameter(Mandatory = $false, Position = 3)]
        [Switch]$GetErrorInvocation = $true,
        [Parameter(Mandatory = $false, Position = 4)]
        [Switch]$GetErrorException = $true,
        [Parameter(Mandatory = $false, Position = 5)]
        [Switch]$GetErrorInnerException = $true
    )

    Begin {
        ## If function was called without specifying an error record, then choose the latest error that occurred
        If (-not $ErrorRecord) {
            If ($global:Error.Count -eq 0) {
                #Write-Warning -Message "The `$Error collection is empty"
                Return
            }
            Else {
                [Array]$ErrorRecord = $global:Error[0]
            }
        }

        ## Allows selecting and filtering the properties on the error object if they exist
        [ScriptBlock]$SelectProperty = {
            Param (
                [Parameter(Mandatory = $true)]
                [ValidateNotNullorEmpty()]
                $InputObject,
                [Parameter(Mandatory = $true)]
                [ValidateNotNullorEmpty()]
                [String[]]$Property
            )

            [String[]]$ObjectProperty = $InputObject | Get-Member -MemberType '*Property' | Select-Object -ExpandProperty 'Name'
            ForEach ($Prop in $Property) {
                If ($Prop -eq '*') {
                    [String[]]$PropertySelection = $ObjectProperty
                    Break
                }
                ElseIf ($ObjectProperty -contains $Prop) {
                    [String[]]$PropertySelection += $Prop
                }
            }
            Write-Output -InputObject ($PropertySelection)
        }

        #  Initialize variables to avoid error if 'Set-StrictMode' is set
        $LogErrorRecordMsg = $null
        $LogErrorInvocationMsg = $null
        $LogErrorExceptionMsg = $null
        $LogErrorMessageTmp = $null
        $LogInnerMessage = $null
    }
    Process {
        If (-not $ErrorRecord) {
            Return
        }
        ForEach ($ErrRecord in $ErrorRecord) {
            ## Capture Error Record
            If ($GetErrorRecord) {
                [String[]]$SelectedProperties = & $SelectProperty -InputObject $ErrRecord -Property $Property
                $LogErrorRecordMsg = $ErrRecord | Select-Object -Property $SelectedProperties
            }

            ## Error Invocation Information
            If ($GetErrorInvocation) {
                If ($ErrRecord.InvocationInfo) {
                    [String[]]$SelectedProperties = & $SelectProperty -InputObject $ErrRecord.InvocationInfo -Property $Property
                    $LogErrorInvocationMsg = $ErrRecord.InvocationInfo | Select-Object -Property $SelectedProperties
                }
            }

            ## Capture Error Exception
            If ($GetErrorException) {
                If ($ErrRecord.Exception) {
                    [String[]]$SelectedProperties = & $SelectProperty -InputObject $ErrRecord.Exception -Property $Property
                    $LogErrorExceptionMsg = $ErrRecord.Exception | Select-Object -Property $SelectedProperties
                }
            }

            ## Display properties in the correct order
            If ($Property -eq '*') {
                #  If all properties were chosen for display, then arrange them in the order the error object displays them by default.
                If ($LogErrorRecordMsg) {
                    [Array]$LogErrorMessageTmp += $LogErrorRecordMsg
                }
                If ($LogErrorInvocationMsg) {
                    [Array]$LogErrorMessageTmp += $LogErrorInvocationMsg
                }
                If ($LogErrorExceptionMsg) {
                    [Array]$LogErrorMessageTmp += $LogErrorExceptionMsg
                }
            }
            Else {
                #  Display selected properties in our custom order
                If ($LogErrorExceptionMsg) {
                    [Array]$LogErrorMessageTmp += $LogErrorExceptionMsg
                }
                If ($LogErrorRecordMsg) {
                    [Array]$LogErrorMessageTmp += $LogErrorRecordMsg
                }
                If ($LogErrorInvocationMsg) {
                    [Array]$LogErrorMessageTmp += $LogErrorInvocationMsg
                }
            }

            If ($LogErrorMessageTmp) {
                $LogErrorMessage = 'Error Record:'
                $LogErrorMessage += "`n-------------"
                $LogErrorMsg = $LogErrorMessageTmp | Format-List | Out-String
                $LogErrorMessage += $LogErrorMsg
            }

            ## Capture Error Inner Exception(s)
            If ($GetErrorInnerException) {
                If ($ErrRecord.Exception -and $ErrRecord.Exception.InnerException) {
                    $LogInnerMessage = 'Error Inner Exception(s):'
                    $LogInnerMessage += "`n-------------------------"

                    $ErrorInnerException = $ErrRecord.Exception.InnerException
                    $Count = 0

                    While ($ErrorInnerException) {
                        [String]$InnerExceptionSeperator = '~' * 40

                        [String[]]$SelectedProperties = & $SelectProperty -InputObject $ErrorInnerException -Property $Property
                        $LogErrorInnerExceptionMsg = $ErrorInnerException | Select-Object -Property $SelectedProperties | Format-List | Out-String

                        If ($Count -gt 0) {
                            $LogInnerMessage += $InnerExceptionSeperator
                        }
                        $LogInnerMessage += $LogErrorInnerExceptionMsg

                        $Count++
                        $ErrorInnerException = $ErrorInnerException.InnerException
                    }
                }
            }

            If ($LogErrorMessage) {
                $Output = $LogErrorMessage
            }
            If ($LogInnerMessage) {
                $Output += $LogInnerMessage
            }

            Write-Output -InputObject $Output

            If (Test-Path -LiteralPath 'variable:Output') {
                Clear-Variable -Name 'Output'
            }
            If (Test-Path -LiteralPath 'variable:LogErrorMessage') {
                Clear-Variable -Name 'LogErrorMessage'
            }
            If (Test-Path -LiteralPath 'variable:LogInnerMessage') {
                Clear-Variable -Name 'LogInnerMessage'
            }
            If (Test-Path -LiteralPath 'variable:LogErrorMessageTmp') {
                Clear-Variable -Name 'LogErrorMessageTmp'
            }
        }
    }
    End {
    }
}
#endregion

# Função que normaliza uma string, trocando caracteres acentuados por caracteres não-acentuados
function Convert-DiacriticCharacters {
	param(
	[string]$inputString
	)
	[string]$formD = $inputString.Normalize([System.text.NormalizationForm]::FormD)
	
	$stringBuilder = new-object System.Text.StringBuilder
	for ($i = 0; $i -lt $formD.Length; $i++) {
		$unicodeCategory = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($formD[$i])
		$nonSPacingMark = [System.Globalization.UnicodeCategory]::NonSpacingMark
		if ($unicodeCategory -ne $nonSPacingMark) {
			$stringBuilder.Append($formD[$i]) | out-null
		}
	}
	$stringBuilder.ToString().Normalize([System.text.NormalizationForm]::FormC)
}

# Função para obter o endereço IP da máquina
function Get-LocalIPAddress {
    $ipAddresses = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -ne 'Loopback Pseudo-Interface 1' } | Select-Object -ExpandProperty IPAddress
    return $ipAddresses
}


# Função para formatar o nome completo com a Capitalização correta
function Formata-Nome {
	param(
        [string]$Nome,
        [string[]]$palavrasMinusculas = @("e", "da", "de", "do", "em", "na", "no", "das", "dos"),
        [string[]]$palavrasMaiusculas = @("OAB", "STF") #Só um exemplo de palavras que deveriam ser maiúsculas num nome de pessoa
    )

    Write-Log -Message "Nome original: $Nome"

    [string]$NomeFormatado = ""

    $array_Nome = $Nome.Split()
    
    $aux = 0
    ForEach ($palavra in $array_Nome) {
        If ($aux -ne "0") {$NomeFormatado += " "}
        If ($palavrasMinusculas.Contains($palavra.ToLower())) {$NomeFormatado += $palavra.ToLower()}
        ElseIf ($palavrasMaiusculas.Contains($palavra.ToUpper())) {$NomeFormatado += $palavra.ToUpper()}
        Else {$NomeFormatado += (Get-Culture).TextInfo.ToTitleCase($palavra.ToLower())}
        $aux += 1
    }
    Write-Log -Message "Nome formatado: $NomeFormatado"
    return $NomeFormatado
 
}

# Função Get-ServerPrinters para obter a lista de impressoras de um servidor de impressão
Function Get-ServerPrinters {
<#
.SYNOPSIS

Obtém todas as impressoras instaladas em um servidorde impressão

.DESCRIPTION

A função Get-ServerPrinters utiliza o comando "net.exe view" para obter a lista de impressoras instaladas em um servidor de impressão. 
A escolha do comando "net.exe view" deve-se ao fato de que o comando do PowerShell, Get-Printer, so retorna as impressoras que o usuário
tem acesso. Com isso ele não consegue trazer todas as impressoras do servidor, mas apenas as que o usuário tem acesso.
Já o comando "net.exe view" retorna todos os compartilhamentos do servidor, trazendo assim, todas as impressoras configuradas no servidor de impressão.

.PARAMETER Server

O nome do servidor de impressão.

.OUTPUTS

A saída da função é um array com todas as impressoras do servidor

.EXAMPLE

Get-ServerPrinters -Server "IMPRESSORAS"

#>

    Param (
      [Parameter(Mandatory = $true)]
      [ValidateNotNullorEmpty()]
      [String]$Server
    )
  
    $ImpressorasServidor = @()
    $regex = "(Printer|Impress)(\d*)(-[aA-zZ]*)?"  	# filtro a ser usado para procurar impressoras no servidor de impressão
  
    # Testa a conexão com o Servidor de Impressão $Server
  If ( -not (Test-Connection $Server -Quiet)) {
    Write-Log -Message "Falha na Conexão com o Servidor: $Server" -Severity 3
    Write-Log -Message "O Servidor $Server não será utilizado para instalar Impressoras" -Severity 3
  } else { 
    Write-Log -Message "Conexão ESTABELECIDA com o Servidor: $Server" -Severity 1 
  }
  
  Try {
    # Constrói o comando como uma string
    $netViewCommand = "$envSystem32Directory\net.exe view $Server"
  
    # Comando para verificar quais são as impressoras disponíveis nos serviddores de impressão
    # O Comando GET-PRINTER só consegue enxegar no servidor as impressoras que o usuário tem acesso. Ele não trás todas as impressoras do servidor.
    #$ImpEncontradasServA = (get-printer -ComputerName $Server)
    # Executa o comando e captura a saída
    $netViewServer = Invoke-Expression $netViewCommand
  
  
    $ImpEncontradas = ($netViewServer -match $regex)	
    
    if ($ImpEncontradas) {
      Foreach ( $linha in $ImpEncontradas ){ 
        $nomeimpressora = $linha.Split(" ")[0]
        $ImpressorasServidor += $nomeimpressora
      }
    }
  } Catch { 
    Write-Log -Message "ERRO - Falha ao tentar obter a lista de impressoras do servidor $Server" -Severity 3
    Write-Log -Message "$($_.Exception.Message) " -Severity 3
  }
  
  return $ImpressorasServidor
  
  
  }
  

#region Function New-Folder
Function New-Folder {
    <#
.SYNOPSIS

Create a new folder.

.DESCRIPTION

Create a new folder if it does not exist.

.PARAMETER Path

Path to the new folder to create.

.PARAMETER ContinueOnError

Continue if an error is encountered. Default is: $true.

.INPUTS

None

You cannot pipe objects to this function.

.OUTPUTS

None

This function does not generate any output.

.EXAMPLE

New-Folder -Path "$envWinDir\System32"

.NOTES

.LINK

https://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]$Path,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Boolean]$ContinueOnError = $true
    )

    Begin {
        ## Get the name of this function and write header
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {
            If (-not (Test-Path -LiteralPath $Path -PathType 'Container')) {
                Write-Log -Message "Creating folder [$Path]." -Source ${CmdletName}
                $null = New-Item -Path $Path -ItemType 'Directory' -ErrorAction 'Stop' -Force
            }
            Else {
                Write-Log -Message "Folder [$Path] already exists." -Source ${CmdletName}
            }
        }
        Catch {
            Write-Log -Message "Failed to create folder [$Path]. `r`n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            If (-not $ContinueOnError) {
                Throw "Failed to create folder [$Path]: $($_.Exception.Message)"
            }
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion


#region Function Remove-Folder
Function Remove-Folder {
    <#
.SYNOPSIS

Remove folder and files if they exist.

.DESCRIPTION

Remove folder and all files with or without recursion in a given path.

.PARAMETER Path

Path to the folder to remove.

.PARAMETER DisableRecursion

Disables recursion while deleting.

.PARAMETER ContinueOnError

Continue if an error is encountered. Default is: $true.

.INPUTS

None

You cannot pipe objects to this function.

.OUTPUTS

None

This function does not generate any output.

.EXAMPLE

Remove-Folder -Path "$envWinDir\Downloaded Program Files"

Deletes all files and subfolders in the Windows\Downloads Program Files folder

.EXAMPLE

Remove-Folder -Path "$envTemp\MyAppCache" -DisableRecursion

Deletes all files in the Temp\MyAppCache folder but does not delete any subfolders.

.NOTES

.LINK

https://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]$Path,
        [Parameter(Mandatory = $false)]
        [Switch]$DisableRecursion,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Boolean]$ContinueOnError = $true
    )

    Begin {
        ## Get the name of this function and write header
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        If (Test-Path -LiteralPath $Path -PathType 'Container' -ErrorAction 'SilentlyContinue') {
            Try {
                If ($DisableRecursion) {
                    Write-Log -Message "Deleting folder [$path] without recursion..." -Source ${CmdletName}
                    # Without recursion we have to go through the subfolder ourselves because Remove-Item asks for confirmation if we are trying to delete a non-empty folder without -Recurse
                    [Array]$ListOfChildItems = Get-ChildItem -LiteralPath $Path -Force
                    If ($ListOfChildItems) {
                        $SubfoldersSkipped = 0
                        ForEach ($item in $ListOfChildItems) {
                            # Check whether this item is a folder
                            If (Test-Path -LiteralPath $item.FullName -PathType Container) {
                                # Item is a folder. Check if its empty
                                # Get list of child items in the folder
                                [Array]$ItemChildItems = Get-ChildItem -LiteralPath $item.FullName -Force -ErrorAction 'SilentlyContinue' -ErrorVariable '+ErrorRemoveFolder'
                                If ($ItemChildItems.Count -eq 0) {
                                    # The folder is empty, delete it
                                    Remove-Item -LiteralPath $item.FullName -Force -ErrorAction 'SilentlyContinue' -ErrorVariable '+ErrorRemoveFolder'
                                }
                                Else {
                                    # Folder is not empty, skip it
                                    $SubfoldersSkipped++
                                    Continue
                                }
                            }
                            Else {
                                # Item is a file. Delete it
                                Remove-Item -LiteralPath $item.FullName -Force -ErrorAction 'SilentlyContinue' -ErrorVariable '+ErrorRemoveFolder'
                            }
                        }
                        If ($SubfoldersSkipped -gt 0) {
                            Throw "[$SubfoldersSkipped] subfolders are not empty!"
                        }
                    }
                    Else {
                        Remove-Item -LiteralPath $Path -Force -ErrorAction 'SilentlyContinue' -ErrorVariable '+ErrorRemoveFolder'
                    }
                }
                Else {
                    Write-Log -Message "Deleting folder [$path] recursively..." -Source ${CmdletName}
                    Remove-Item -LiteralPath $Path -Force -Recurse -ErrorAction 'SilentlyContinue' -ErrorVariable '+ErrorRemoveFolder'
                }

                If ($ErrorRemoveFolder) {
                    Throw $ErrorRemoveFolder
                }
            }
            Catch {
                Write-Log -Message "Failed to delete folder(s) and file(s) from path [$path]. `r`n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
                If (-not $ContinueOnError) {
                    Throw "Failed to delete folder(s) and file(s) from path [$path]: $($_.Exception.Message)"
                }
            }
        }
        Else {
            Write-Log -Message "Folder [$Path] does not exist." -Source ${CmdletName}
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion


#region Function Copy-File
Function Copy-File {
    <#
.SYNOPSIS

Copy a file or group of files to a destination path.

.DESCRIPTION

Copy a file or group of files to a destination path.

.PARAMETER Path

Path of the file to copy. Multiple paths can be specified

.PARAMETER Destination

Destination Path of the file to copy.

.PARAMETER Recurse

Copy files in subdirectories.

.PARAMETER Flatten

Flattens the files into the root destination directory.

.PARAMETER ContinueOnError

Continue if an error is encountered. This will continue the deployment script, but will not continue copying files if an error is encountered. Default is: $true.

.PARAMETER ContinueFileCopyOnError

Continue copying files if an error is encountered. This will continue the deployment script and will warn about files that failed to be copied. Default is: $false.

.PARAMETER UseRobocopy

Use Robocopy to copy files rather than native PowerShell method. Robocopy overcomes the 260 character limit. Supports * in file names, but not folders, in source paths. Default is configured in the AppDeployToolkitConfig.xml file: $true

.PARAMETER RobocopyParams

Override the default Robocopy parameters. Default is: /NJH /NJS /NS /NC /NP /NDL /FP /IS /IT /IM /XX /MT:4 /R:1 /W:1

.PARAMETER RobocopyAdditionalParams

Append to the default Robocopy parameters. Default is: /NJH /NJS /NS /NC /NP /NDL /FP /IS /IT /IM /XX /MT:4 /R:1 /W:1

.INPUTS

None

You cannot pipe objects to this function.

.OUTPUTS

None

This function does not generate any output.

.EXAMPLE

Copy-File -Path "$dirSupportFiles\MyApp.ini" -Destination "$envWinDir\MyApp.ini"

.EXAMPLE

Copy-File -Path "$dirSupportFiles\*.*" -Destination "$envTemp\tempfiles"

Copy all of the files in a folder to a destination folder.

.NOTES

.LINK

https://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullorEmpty()]
        [String[]]$Path,
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [String]$Destination,
        [Parameter(Mandatory = $false)]
        [Switch]$Recurse = $false,
        [Parameter(Mandatory = $false)]
        [Switch]$Flatten,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Boolean]$ContinueOnError = $true,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Boolean]$ContinueFileCopyOnError = $false,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Boolean]$UseRobocopy = $False,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$RobocopyParams = '/NJH /NJS /NS /NC /NP /NDL /FP /IS /IT /IM /XX /MT:4 /R:1 /W:1',
        [String]$RobocopyAdditionalParams
        )

    Begin {
        ## Get the name of this function and write header
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header

        # Check if Robocopy is on the system
        If ($UseRobocopy) {
            If (Test-Path -Path "$env:SystemRoot\System32\Robocopy.exe" -PathType Leaf) {
                $RobocopyCommand = "$env:SystemRoot\System32\Robocopy.exe"
            }
            Else {
                $UseRobocopy = $false
                Write-Log "Robocopy is not available on this system. Falling back to native PowerShell method." -Source ${CmdletName} -Severity 2
            }
        }
        Else {
            $UseRobocopy = $false
        }
    }
    Process {
        Foreach ($srcPath in $Path) {
            Try {
                $UseRobocopyThis = $UseRobocopy
                If ($UseRobocopyThis) {
                    # Disable Robocopy if $Path has a folder containing a * wildcard
                    If ($srcPath -match '\*.*\\') {
                        $UseRobocopyThis = $false
                        Write-Log "Asterisk wildcard specified in folder portion of path variable. Falling back to native PowerShell method." -Source ${CmdletName} -Severity 2
                    }
                    # Don't just check for an extension here, also check for base name without extension to allow copying to a directory such as .config
                    If ([IO.Path]::HasExtension($Destination) -and [IO.Path]::GetFileNameWithoutExtension($Destination) -and -not (Test-Path -LiteralPath $Destination -PathType Container)) {
                        $UseRobocopyThis = $false
                        Write-Log "Destination path appears to be a file. Falling back to native PowerShell method." -Source ${CmdletName} -Severity 2
                    }
                    If ($UseRobocopyThis) {

                        # Pre-create destination folder if it does not exist; Robocopy will auto-create non-existent destination folders, but pre-creating ensures we can use Resolve-Path
                        If (-not (Test-Path -LiteralPath $Destination -PathType Container)) {
                            Write-Log -Message "Destination assumed to be a folder which does not exist, creating destination folder [$Destination]." -Source ${CmdletName}
                            $null = New-Item -Path $Destination -Type 'Directory' -Force -ErrorAction 'Stop'
                        }
                        If (Test-Path -LiteralPath $srcPath -PathType Container) {
                            # If source exists as a folder, append the last subfolder to the destination, so that Robocopy produces similar results to native Powershell
                            # Trim ending backslash from paths which can cause problems with Robocopy
                            # Resolve paths in case relative paths beggining with .\, ..\, or \ are used
                            # Strip Microsoft.PowerShell.Core\FileSystem:: from the begginning of the resulting string, since Resolve-Path adds this to UNC paths
                            $RobocopySource = (Resolve-Path -LiteralPath $srcPath.TrimEnd('\')).Path -replace '^Microsoft\.PowerShell\.Core\\FileSystem::'
                            $RobocopyDestination = Join-Path ((Resolve-Path -LiteralPath $Destination).Path -replace '^Microsoft\.PowerShell\.Core\\FileSystem::') (Split-Path -Path $srcPath -Leaf)
                            $RobocopyFile = '*'
                        }
                        Else {
                            # Else assume source is a file and split args to the format <SourceFolder> <DestinationFolder> <FileName>
                            # Trim ending backslash from paths which can cause problems with Robocopy
                            # Resolve paths in case relative paths beggining with .\, ..\, or \ are used
                            # Strip Microsoft.PowerShell.Core\FileSystem:: from the begginning of the resulting string, since Resolve-Path adds this to UNC paths
                            $ParentPath = Split-Path -Path $srcPath -Parent
                            if ([string]::IsNullOrEmpty($ParentPath)) {
                                $RobocopySource = $PWD
                            }
                            else {
                                $RobocopySource = (Resolve-Path -LiteralPath $ParentPath -ErrorAction Stop).Path -replace '^Microsoft\.PowerShell\.Core\\FileSystem::'
                            }
                            $RobocopyDestination = (Resolve-Path -LiteralPath $Destination.TrimEnd('\') -ErrorAction Stop).Path -replace '^Microsoft\.PowerShell\.Core\\FileSystem::'
                            $RobocopyFile = (Split-Path -Path $srcPath -Leaf)
                        }
                        If ($Flatten) {
                            Write-Log -Message "Copying file(s) recursively in path [$srcPath] to destination [$Destination] root folder, flattened." -Source ${CmdletName}
                            [Hashtable]$CopyFileSplat = @{
                                Path                     = (Join-Path $RobocopySource $RobocopyFile) # This will ensure that the source dir will have \* appended if it was a folder (which prevents creation of a folder at the destination), or keeps the original file name if it was a file
                                Destination              = $Destination # Use the original destination path, not $RobocopyDestination which could have had a subfolder appended to it
                                Recurse                  = $false # Disable recursion as this will create subfolders in the destination
                                Flatten                  = $false # Disable flattening to prevent infinite loops
                                ContinueOnError          = $ContinueOnError
                                ContinueFileCopyOnError  = $ContinueFileCopyOnError
                                UseRobocopy              = $UseRobocopy
                                RobocopyParams           = $RobocopyParams
                                RobocopyAdditionalParams = $RobocopyAdditionalParams
                            }
                            # Copy all files from the root source folder
                            Copy-File @CopyFileSplat
                            # Copy all files from subfolders
                            Get-ChildItem -Path $RobocopySource -Directory -Recurse -Force -ErrorAction 'SilentlyContinue' | ForEach-Object {
                                # Append file name to subfolder path and repeat Copy-File
                                $CopyFileSplat.Path = Join-Path $_.FullName $RobocopyFile
                                Copy-File @CopyFileSplat
                            }
                            # Skip to next $SrcPath in $Path since we have handed off all copy tasks to separate executions of the function
                            Continue
                        }
                        If ($Recurse) {
                            # Add /E to Robocopy parameters if it is not already included
                            if ($RobocopyParams -notmatch '/E(\s+|$)' -and $RobocopyAdditionalParams -notmatch '/E(\s+|$)') {
                                $RobocopyParams = $RobocopyParams + " /E"
                            }
                            Write-Log -Message "Copying file(s) recursively in path [$srcPath] to destination [$Destination]." -Source ${CmdletName}
                        }
                        Else {
                            # Ensure that /E is not included in the Robocopy parameters as it will copy recursive folders
                            $RobocopyParams = $RobocopyParams -replace '/E(\s+|$)'
                            $RobocopyAdditionalParams = $RobocopyAdditionalParams -replace '/E(\s+|$)'
                            Write-Log -Message "Copying file(s) in path [$srcPath] to destination [$Destination]." -Source ${CmdletName}
                        }

                        # Older versions of Robocopy do not support /IM, remove if unsupported
                        if (!((&Robocopy /?) -match '/IM\s')) {
                            $RobocopyParams = $RobocopyParams -replace '/IM(\s+|$)'
                            $RobocopyAdditionalParams = $RobocopyAdditionalParams -replace '/IM(\s+|$)'
                        }

                        If (-not (Test-Path -LiteralPath $RobocopyDestination -PathType Container)) {
                            $null = New-Item -Path $RobocopyDestination -Type 'Directory' -Force -ErrorAction 'Stop'
                        }
                        $DestFolderAttributes = (Get-Item -LiteralPath $RobocopyDestination -Force).Attributes

                        $RobocopyArgs = "$RobocopyParams $RobocopyAdditionalParams `"$RobocopySource`" `"$RobocopyDestination`" `"$RobocopyFile`""
                        Write-Log -Message "Executing Robocopy command: $RobocopyCommand $RobocopyArgs" -Source ${CmdletName}
                        $RobocopyResult = Execute-Process -Path $RobocopyCommand -Parameters $RobocopyArgs -CreateNoWindow -ContinueOnError $true -ExitOnProcessFailure $false -Passthru -IgnoreExitCodes '0,1,2,3,4,5,6,7,8'
                        # Trim the last line plus leading whitespace from each line of Robocopy output
                        $RobocopyOutput = $RobocopyResult.StdOut.Trim() -Replace '\n\s+',"`n"
                        Write-Log -Message "Robocopy output:`n$RobocopyOutput" -Source ${CmdletName}

                        Set-ItemProperty -LiteralPath $RobocopyDestination -Name Attributes -Value ($DestFolderAttributes -band (-bnot [System.IO.FileAttributes]::Directory))

                        Switch ($RobocopyResult.ExitCode) {
                            0 { Write-Log -Message "Robocopy completed. No files were copied. No failure was encountered. No files were mismatched. The files already exist in the destination directory; therefore, the copy operation was skipped." -Source ${CmdletName} }
                            1 { Write-Log -Message "Robocopy completed. All files were copied successfully." -Source ${CmdletName} }
                            2 { Write-Log -Message "Robocopy completed. There are some additional files in the destination directory that aren't present in the source directory. No files were copied." -Source ${CmdletName} }
                            3 { Write-Log -Message "Robocopy completed. Some files were copied. Additional files were present. No failure was encountered." -Source ${CmdletName} }
                            4 { Write-Log -Message "Robocopy completed. Some Mismatched files or directories were detected. Examine the output log. Housekeeping might be required." -Severity 2 -Source ${CmdletName} }
                            5 { Write-Log -Message "Robocopy completed. Some files were copied. Some files were mismatched. No failure was encountered." -Source ${CmdletName} }
                            6 { Write-Log -Message "Robocopy completed. Additional files and mismatched files exist. No files were copied and no failures were encountered meaning that the files already exist in the destination directory." -Severity 2 -Source ${CmdletName} }
                            7 { Write-Log -Message "Robocopy completed. Files were copied, a file mismatch was present, and additional files were present." -Severity 2 -Source ${CmdletName} }
                            8 { Write-Log -Message "Robocopy completed. Several files didn't copy." -Severity 2 -Source ${CmdletName} }
                            16 {
                                Write-Log -Message "Serious error. Robocopy did not copy any files. Either a usage error or an error due to insufficient access privileges on the source or destination directories.." -Severity 3 -Source ${CmdletName}
                                If (-not $ContinueFileCopyOnError) {
                                    Throw "Failed to copy file(s) in path [$srcPath] to destination [$Destination]: $($_.Exception.Message)"
                                }
                            }
                            default {
                                Write-Log -Message "Robocopy error $($RobocopyResult.ExitCode)." -Severity 3 -Source ${CmdletName}
                                If (-not $ContinueFileCopyOnError) {
                                    Throw "Failed to copy file(s) in path [$srcPath] to destination [$Destination]: $($_.Exception.Message)"
                                }
                            }
                        }
                    }
                }
                If ($UseRobocopyThis -eq $false) {
                    # If destination has no extension, or if it has an extension only and no name (e.g. a .config folder) and the destination folder does not exist
                    If ((-not ([IO.Path]::HasExtension($Destination))) -or ([IO.Path]::HasExtension($Destination) -and -not [IO.Path]::GetFileNameWithoutExtension($Destination)) -and (-not (Test-Path -LiteralPath $Destination -PathType 'Container'))) {
                        Write-Log -Message "Destination assumed to be a folder which does not exist, creating destination folder [$Destination]." -Source ${CmdletName}
                        $null = New-Item -Path $Destination -Type 'Directory' -Force -ErrorAction 'Stop'
                    }
                    # If destination appears to be a file name but parent folder does not exist, create it
                    $DestinationParent = Split-Path $Destination -Parent
                    If ([IO.Path]::HasExtension($Destination) -and [IO.Path]::GetFileNameWithoutExtension($Destination) -and -not (Test-Path -LiteralPath $DestinationParent -PathType 'Container')) {
                        Write-Log -Message "Destination assumed to be a file whose parent folder does not exist, creating destination folder [$DestinationParent]." -Source ${CmdletName}
                        $null = New-Item -Path $DestinationParent -Type 'Directory' -Force -ErrorAction 'Stop'
                    }
                    If ($Flatten) {
                        Write-Log -Message "Copying file(s) recursively in path [$srcPath] to destination [$Destination] root folder, flattened." -Source ${CmdletName}
                        If ($ContinueFileCopyOnError) {
                            $null = Get-ChildItem -Path $srcPath -File -Recurse -Force -ErrorAction 'SilentlyContinue' | ForEach-Object {
                                Copy-Item -Path ($_.FullName) -Destination $Destination -Force -ErrorAction 'SilentlyContinue' -ErrorVariable 'FileCopyError'
                            }
                        }
                        Else {
                            $null = Get-ChildItem -Path $srcPath -File -Recurse -Force -ErrorAction 'SilentlyContinue' | ForEach-Object {
                                Copy-Item -Path ($_.FullName) -Destination $Destination -Force -ErrorAction 'Stop'
                            }
                        }
                    }
                    ElseIf ($Recurse) {
                        Write-Log -Message "Copying file(s) recursively in path [$srcPath] to destination [$Destination]." -Source ${CmdletName}
                        If ($ContinueFileCopyOnError) {
                            $null = Copy-Item -Path $srcPath -Destination $Destination -Force -Recurse -ErrorAction 'SilentlyContinue' -ErrorVariable 'FileCopyError'
                        }
                        Else {
                            $null = Copy-Item -Path $srcPath -Destination $Destination -Force -Recurse -ErrorAction 'Stop'
                        }
                    }
                    Else {
                        Write-Log -Message "Copying file in path [$srcPath] to destination [$Destination]." -Source ${CmdletName}
                        If ($ContinueFileCopyOnError) {
                            $null = Copy-Item -Path $srcPath -Destination $Destination -Force -ErrorAction 'SilentlyContinue' -ErrorVariable 'FileCopyError'
                        }
                        Else {
                            $null = Copy-Item -Path $srcPath -Destination $Destination -Force -ErrorAction 'Stop'
                        }
                    }

                    If ($FileCopyError) {
                        Write-Log -Message "The following warnings were detected while copying file(s) in path [$srcPath] to destination [$Destination]. `r`n$FileCopyError" -Severity 2 -Source ${CmdletName}
                    }
                    Else {
                        Write-Log -Message 'File copy completed successfully.' -Source ${CmdletName}
                    }
                }
            }
            Catch {
                Write-Log -Message "Failed to copy file(s) in path [$srcPath] to destination [$Destination]. `r`n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
                If (-not $ContinueFileCopyOnError) {
                    return
                }
                If (-not $ContinueOnError) {
                    Throw "Failed to copy file(s) in path [$srcPath] to destination [$Destination]: $($_.Exception.Message)"
                }
            }
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion


#region Function Remove-File
Function Remove-File {
    <#
.SYNOPSIS

Removes one or more items from a given path on the filesystem.

.DESCRIPTION

Removes one or more items from a given path on the filesystem.

.PARAMETER Path

Specifies the path on the filesystem to be resolved. The value of Path will accept wildcards. Will accept an array of values.

.PARAMETER LiteralPath

Specifies the path on the filesystem to be resolved. The value of LiteralPath is used exactly as it is typed; no characters are interpreted as wildcards. Will accept an array of values.

.PARAMETER Recurse

Deletes the files in the specified location(s) and in all child items of the location(s).

.PARAMETER ContinueOnError

Continue if an error is encountered. Default is: $true.

.INPUTS

None

You cannot pipe objects to this function.

.OUTPUTS

None

This function does not generate any output.

.EXAMPLE

Remove-File -Path 'C:\Windows\Downloaded Program Files\Temp.inf'

.EXAMPLE

Remove-File -LiteralPath 'C:\Windows\Downloaded Program Files' -Recurse

.NOTES

.LINK

https://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Path')]
        [ValidateNotNullorEmpty()]
        [String[]]$Path,
        [Parameter(Mandatory = $true, ParameterSetName = 'LiteralPath')]
        [ValidateNotNullorEmpty()]
        [String[]]$LiteralPath,
        [Parameter(Mandatory = $false)]
        [Switch]$Recurse = $false,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Boolean]$ContinueOnError = $true
    )

    Begin {
        ## Get the name of this function and write header
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        ## Build hashtable of parameters/value pairs to be passed to Remove-Item cmdlet
        [Hashtable]$RemoveFileSplat = @{ 'Recurse' = $Recurse
                                          'Force'                                = $true
                                          'ErrorVariable'                        = '+ErrorRemoveItem'
        }
        If ($ContinueOnError) {
            $RemoveFileSplat.Add('ErrorAction', 'SilentlyContinue')
        }
        Else {
            $RemoveFileSplat.Add('ErrorAction', 'Stop')
        }

        ## Resolve the specified path, if the path does not exist, display a warning instead of an error
        If ($PSCmdlet.ParameterSetName -eq 'Path') {
            [String[]]$SpecifiedPath = $Path
        }
        Else {
            [String[]]$SpecifiedPath = $LiteralPath
        }
        ForEach ($Item in $SpecifiedPath) {
            Try {
                If ($PSCmdlet.ParameterSetName -eq 'Path') {
                    [String[]]$ResolvedPath += Resolve-Path -Path $Item -ErrorAction 'Stop' | Where-Object { $_.Path } | Select-Object -ExpandProperty 'Path' -ErrorAction 'Stop'
                }
                Else {
                    [String[]]$ResolvedPath += Resolve-Path -LiteralPath $Item -ErrorAction 'Stop' | Where-Object { $_.Path } | Select-Object -ExpandProperty 'Path' -ErrorAction 'Stop'
                }
            }
            Catch [System.Management.Automation.ItemNotFoundException] {
                Write-Log -Message "Unable to resolve file(s) for deletion in path [$Item] because path does not exist." -Severity 2 -Source ${CmdletName}
            }
            Catch {
                Write-Log -Message "Failed to resolve file(s) for deletion in path [$Item]. `r`n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
                If (-not $ContinueOnError) {
                    Throw "Failed to resolve file(s) for deletion in path [$Item]: $($_.Exception.Message)"
                }
            }
        }

        ## Delete specified path if it was successfully resolved
        If ($ResolvedPath) {
            ForEach ($Item in $ResolvedPath) {
                Try {
                    If (($Recurse) -and (Test-Path -LiteralPath $Item -PathType 'Container')) {
                        Write-Log -Message "Deleting file(s) recursively in path [$Item]..." -Source ${CmdletName}
                    }
                    ElseIf ((-not $Recurse) -and (Test-Path -LiteralPath $Item -PathType 'Container')) {
                        Write-Log -Message "Skipping folder [$Item] because the Recurse switch was not specified." -Source ${CmdletName}
                        Continue
                    }
                    Else {
                        Write-Log -Message "Deleting file in path [$Item]..." -Source ${CmdletName}
                    }
                    $null = Remove-Item @RemoveFileSplat -LiteralPath $Item
                }
                Catch {
                    Write-Log -Message "Failed to delete file(s) in path [$Item]. `r`n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
                    If (-not $ContinueOnError) {
                        Throw "Failed to delete file(s) in path [$Item]: $($_.Exception.Message)"
                    }
                }
            }
        }

        If ($ErrorRemoveItem) {
            Write-Log -Message "The following error(s) took place while removing file(s) in path [$SpecifiedPath]. `r`n$(Resolve-Error -ErrorRecord $ErrorRemoveItem)" -Severity 2 -Source ${CmdletName}
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion


# ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
# █                  FIM das Funções Comuns                 █
# ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
