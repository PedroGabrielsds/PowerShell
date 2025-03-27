<#

.SYNOPSIS
PSAppDeployToolkit - This script performs the installation or uninstallation of an application(s).

.DESCRIPTION
- The script is provided as a template to perform an install, uninstall, or repair of an application(s).
- The script either performs an "Install", "Uninstall", or "Repair" deployment type.
- The install deployment type is broken down into 3 main sections/phases: Pre-Install, Install, and Post-Install.

The script imports the PSAppDeployToolkit module which contains the logic and functions required to install or uninstall an application.

PSAppDeployToolkit is licensed under the GNU LGPLv3 License - (C) 2025 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham, Muhammad Mashwani, Mitch Richters, Dan Gough).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details. You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

.PARAMETER DeploymentType
The type of deployment to perform.

.PARAMETER DeployMode
Specifies whether the installation should be run in Interactive (shows dialogs), Silent (no dialogs), or NonInteractive (dialogs without prompts) mode.

NonInteractive mode is automatically set if it is detected that the process is not user interactive.

.PARAMETER AllowRebootPassThru
Allows the 3010 return code (requires restart) to be passed back to the parent process (e.g. SCCM) if detected from an installation. If 3010 is passed back to SCCM, a reboot prompt will be triggered.

.PARAMETER TerminalServerMode
Changes to "user install mode" and back to "user execute mode" for installing/uninstalling applications for Remote Desktop Session Hosts/Citrix servers.

.PARAMETER DisableLogging
Disables logging to file for the script.

.EXAMPLE
powershell.exe -File Invoke-AppDeployToolkit.ps1 -DeployMode Silent

.EXAMPLE
powershell.exe -File Invoke-AppDeployToolkit.ps1 -AllowRebootPassThru

.EXAMPLE
powershell.exe -File Invoke-AppDeployToolkit.ps1 -DeploymentType Uninstall

.EXAMPLE
Invoke-AppDeployToolkit.exe -DeploymentType "Install" -DeployMode "Silent"

.INPUTS
None. You cannot pipe objects to this script.

.OUTPUTS
None. This script does not generate any output.

.NOTES
Toolkit Exit Code Ranges:
- 60000 - 68999: Reserved for built-in exit codes in Invoke-AppDeployToolkit.ps1, and Invoke-AppDeployToolkit.exe
- 69000 - 69999: Recommended for user customized exit codes in Invoke-AppDeployToolkit.ps1
- 70000 - 79999: Recommended for user customized exit codes in PSAppDeployToolkit.Extensions module.

.LINK
https://psappdeploytoolkit.com

#>

[CmdletBinding()]
param
(
    [Parameter(Mandatory = $false)]
    [ValidateSet('Install', 'Uninstall', 'Repair')]
    [PSDefaultValue(Help = 'Install', Value = 'Install')]
    [System.String]$DeploymentType,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Interactive', 'Silent', 'NonInteractive')]
    [PSDefaultValue(Help = 'Interactive', Value = 'Interactive')]
    [System.String]$DeployMode,

    [Parameter(Mandatory = $false)]
    [System.Management.Automation.SwitchParameter]$AllowRebootPassThru,

    [Parameter(Mandatory = $false)]
    [System.Management.Automation.SwitchParameter]$TerminalServerMode,

    [Parameter(Mandatory = $false)]
    [System.Management.Automation.SwitchParameter]$DisableLogging
)


##================================================
## MARK: Variables
##================================================

$adtSession = @{
    # App variables.
    AppVendor = ''								# Nome do Fabricante do Aplicativo (Ex.: Adobe)
    AppName = ''								# Nome do Aplicativo (Ex.: Acrobat Reader)
    AppVersion = '' 							# Versão do Aplicativo (Ex.: 1.0)
    AppArch = 'X64'								# Arquitetura (Valores: X86, X64, X86-X64)
    AppLang = 'PT-BR'							# Idioma (Valores: PT-BR, EN)
    AppRevision = '01'							# Número da Revisão de Pacote do Aplicativo
    AppSuccessExitCodes = @(0)                  # Código de retorno de exito
    AppRebootExitCodes = @(1641, 3010)          # Código de retorno para Reniciar Máquina
    AppScriptVersion = '1.0.0'					# Versão do Script 
    AppScriptDate = '2025-02-25'				# ATENÇÃO! Data da criação do Pacote no formato AAAA-MM-DD
    AppScriptAuthor = '<author name>'			# Nome do Autor do Pacote

    # Install Titles (Only set here to override defaults set by the toolkit).
    InstallName = ''
    InstallTitle = ''

    # Script variables.
    DeployAppScriptFriendlyName = $MyInvocation.MyCommand.Name
    DeployAppScriptVersion = '4.0.6'
    DeployAppScriptParameters = $PSBoundParameters
}

<#
   ╔═════════════════════════════════════════════════════════╗
   ║        DICAS de Comandos para usar no Script            ║
   ╙  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ╜
   ▼                                                         ▼  
        ▬▬▬► Fase PRÉ-INSTALAÇÃO / PRÉ-DESINSTALAÇÃO ◄▬▬▬

    ## Fecha o aplicativo (Acrobat)
	Show-ADTInstallationWelcome -CloseProcesses 'acrobat', 'AcroRd32', 'acrocef' -Silent 
    
    ## Fecha os aplicativos 'Certification Expiration Check Utility' e o 'Navegador Firefox'. Neste formato é possível colocar a descrição do aplicativo a ser fechado
    Show-ADTInstallationWelcome -CloseProcesses @{ Name = 'aetcrss1'; Description = 'Certification Expiration Check Utility' }, @{ Name = 'firefox'; Description = 'Navegador Firefox' } -Silent
    
    ## Mostra a Mensagem de Progresso (com a mensagem padrão)
    Show-ADTInstallationProgress 
    
    ## Remove um atalho (ou arquivo) em C:\Users\Public\Desktop
    If (Test-Path -Path "$envCommonDesktop\Notepad++.lnk") { Remove-ADTFile -Path "$envCommonDesktop\Notepad++.lnk" -Recurse }

        ▬▬▬►     Fase INSTALAÇÃO / DESINSTALAÇÃO     ◄▬▬▬

    ## INSTALA um aplicativo EXE com argumentos (Notepad++)
    Start-ADTProcess -FilePath "$($adtSession.DirFiles)\npp.$($adtSession.AppVersion).Installer.x64.exe" -ArgumentList "/S" -WindowStyle Hidden 

    ## INSTALA um aplicativo MSI com TRANSFORM (Calibre)
    Start-ADTMsiProcess -Action Install -FilePath "$($adtSession.DirFiles)\calibre-64bit-$($adtSession.AppVersion).msi" -Transforms "$($adtSession.DirFiles)\calibre-64bit-$($adtSession.AppVersion).mst" -ArgumentList " /qn /norestart"

    ## DESINSTALA um aplicaitvo MSI pelo PRODUCTCODE
    Start-ADTMsiProcess -Action 'Uninstall' -ProductCode '{32019BE2-E62F-48CF-B274-2521588B83D8}'

    ## DESINSTALA um aplicativo MSI pelo Nome (Calibre)
    Uninstall-ADTApplication -Name 'Calibre' -AdditionalArgumentList "/qn" -ApplicationType MSI

    ## DESINSTALA um aplicaitvo EXE (Client Configuration Manager)
    Start-ADTProcess -FilePath "$($adtSession.DirFiles)\ccmsetup.exe" -ArgumentList '/uninstall' -WindowStyle 'Hidden'

    ## APLICA Patch de atualização MSP em um MSI
    Start-ADTMspProcess -FilePath "$($adtSession.DirFiles)\MSP\AcrobatClassicx64Upd2400130187.msp"

        ▬▬▬► Fase PÓS-INSTALAÇÃO / PÓS-DESINSTALAÇÃO ◄▬▬▬

    ## Cria um atalho em C:\Users\Public\Desktop
    New-ADTShortcut -Path "$envCommonDesktop\Notepad++.lnk" -TargetPath "$envProgramFiles\Notepad++\notepad++.exe" -IconLocation "$envProgramFiles\Notepad++\notepad++.exe" -Description "Notepad++" -WorkingDirectory "$envProgramFiles\Notepad++\"
   
    ## Copia arquivo para uma pasta 
    Copy-ADTFile -Path "$($adtSession.DirFiles)\BizagiModeler.exe.config" -Destination "$envProgramFiles\Bizagi\Bizagi Modeler" -Recurse 

    ## Concede Permissão de LEITURA e ESCRITA para "USUÁRIOS AUTENTICADOS" (SID S-1-5-11) na pasta de Plugins do NotePad++
    Set-ADTItemPermission -Path "$envProgramFiles\Notepad++\plugins" -User "*S-1-5-11" -Permission ListDirectory,CreateFiles,CreateDirectories,Write,Delete,Read,Modify -Inheritance ObjectInherit,ContainerInherit

    ## Mostra uma mensagem no final falando que a inntalação foi bem sucedida. É bom pra usar em aplicativos que ficam na Central de Software
    Show-ADTInstallationPrompt -Message "$($adtSession.AppName) $($adtSession.AppVersion) foi instalado com sucesso no seu computador! `n`nClique OK para finalizar." -MessageAlignment 'Left' -ButtonRightText 'OK' -Icon Information -NoWait 			

    ## Atualiza o Shell do Windows Explorer, o que faz com que os ícones da área de trabalho e as variáveis ​​de ambiente sejam recarregados.
    Update-ADTDesktop 

    ## Executa o Inventário de Hardware do SCCM. Deve ser colocado em todos os softawares licenciados ou que precisem que o inventário esteja sempre bem atualizado.
	Invoke-ADTSCCMTask -ScheduleID 'HardwareInventory' 

    ## Remove uma chave de Regitro recursivamente
    Remove-ADTRegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider' -Recurse

    ## Cria uma chave de Registro
    Set-ADTRegistryKey -Key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WSDPrintDevice' -Name 'Tag' -Type 'DWord' -Value '40'
    
    #Executa um aplicativo com as credenciais do usuário logado
	Start-ADTProcessAsUser -Path "$envProgramFiles\Rainmeter\Rainmeter.exe"

    ## Cria chaves de Registro no HK_CURRENT_USER de todos os usuários da máquina
    Invoke-ADTAllUsersRegistryAction -ScriptBlock {
        Set-ADTRegistryKey -Key 'HKCU\Software\Microsoft\Office\14.0\Common' -Name 'qmenable' -Value 0 -Type DWord -SID $_.SID
        Set-ADTRegistryKey -Key 'HKCU\Software\Microsoft\Office\14.0\Common' -Name 'updatereliabilitydata' -Value 1 -Type DWord -SID $_.SID
    }


   ▲                                                         ▲ 
   ╓  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ╖
   ║                                                         ║
   ╚═════════════════════════════════════════════════════════╝
#>

function Install-ADTDeployment
{
    ##================================================
    ## MARK: Pre-Install
    ##================================================
    $adtSession.InstallPhase = "Pre-$($adtSession.DeploymentType)"

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █        INÍCIO dos comandos de PRÉ-INSTALAÇÃO            █  
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

    ## Mostra a Mensagem de Progresso (com a mensagem padrão)
    Show-ADTInstallationProgress 


#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █         FIM dos comandos de PRÉ-INSTALAÇÃO              █  
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


    ##================================================
    ## MARK: Install
    ##================================================
    $adtSession.InstallPhase = $adtSession.DeploymentType

    ## Handle Zero-Config MSI installations.
    if ($adtSession.UseDefaultMsi)
    {
        $ExecuteDefaultMSISplat = @{ Action = $adtSession.DeploymentType; FilePath = $adtSession.DefaultMsiFile }
        if ($adtSession.DefaultMstFile)
        {
            $ExecuteDefaultMSISplat.Add('Transform', $adtSession.DefaultMstFile)
        }
        Start-ADTMsiProcess @ExecuteDefaultMSISplat
        if ($adtSession.DefaultMspFiles)
        {
            $adtSession.DefaultMspFiles | Start-ADTMsiProcess -Action Patch
        }
    }

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █           INÍCIO dos comandos de INSTALAÇÃO             █  
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  



#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █            FIM dos comandos de INSTALAÇÃO               █  
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 
    ##================================================
    ## MARK: Post-Install
    ##================================================
    $adtSession.InstallPhase = "Post-$($adtSession.DeploymentType)"

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █        INÍCIO dos comandos de PÓS-INSTALAÇÃO            █  
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  
    

    
#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █         FIM dos comandos de PÓS-INSTALAÇÃO              █  
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 

}

function Uninstall-ADTDeployment
{
    ##================================================
    ## MARK: Pre-Uninstall
    ##================================================
    $adtSession.InstallPhase = "Pre-$($adtSession.DeploymentType)"

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █       INÍCIO dos comandos de PRÉ-DESINSTALAÇÃO          █ 
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

    ## Mostra a Mensagem de Progresso (com a mensagem padrão)
    Show-ADTInstallationProgress 


#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █        FIM dos comandos de PRÉ-DESINSTALAÇÃO            █  
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 
    ##================================================
    ## MARK: Uninstall
    ##================================================
    $adtSession.InstallPhase = $adtSession.DeploymentType

    ## Handle Zero-Config MSI uninstallations.
    if ($adtSession.UseDefaultMsi)
    {
        $ExecuteDefaultMSISplat = @{ Action = $adtSession.DeploymentType; FilePath = $adtSession.DefaultMsiFile }
        if ($adtSession.DefaultMstFile)
        {
            $ExecuteDefaultMSISplat.Add('Transform', $adtSession.DefaultMstFile)
        }
        Start-ADTMsiProcess @ExecuteDefaultMSISplat
    }

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █          INÍCIO dos comandos de DESINSTALAÇÃO           █ 
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  


        
#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █          FIM dos comandos de DESINSTALAÇÃO              █
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


    ##================================================
    ## MARK: Post-Uninstallation
    ##================================================
    $adtSession.InstallPhase = "Post-$($adtSession.DeploymentType)"

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █       INÍCIO dos comandos de PÓS-DESINSTALAÇÃO          █  
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

 

#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █        FIM dos comandos de PÓS-DESINSTALAÇÃO            █  
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 
}

function Repair-ADTDeployment
{
    ##================================================
    ## MARK: Pre-Repair
    ##================================================
    $adtSession.InstallPhase = "Pre-$($adtSession.DeploymentType)"

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █       INÍCIO dos comandos de PRÉ-REPARAÇÃO              █  
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  



#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █        FIM dos comandos de PRÉ-REPARAÇÃO                █  
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


    ##================================================
    ## MARK: Repair
    ##================================================
    $adtSession.InstallPhase = $adtSession.DeploymentType

    ## Handle Zero-Config MSI repairs.
    if ($adtSession.UseDefaultMsi)
    {
        $ExecuteDefaultMSISplat = @{ Action = $adtSession.DeploymentType; FilePath = $adtSession.DefaultMsiFile }
        if ($adtSession.DefaultMstFile)
        {
            $ExecuteDefaultMSISplat.Add('Transform', $adtSession.DefaultMstFile)
        }
        Start-ADTMsiProcess @ExecuteDefaultMSISplat
    }

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █       INÍCIO dos comandos de REPARAÇÃO                  █  
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  


#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █        FIM dos comandos de REPARAÇÃO                    █  
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 
    ##================================================
    ## MARK: Post-Repair
    ##================================================
    $adtSession.InstallPhase = "Post-$($adtSession.DeploymentType)"

#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
#  █       INÍCIO dos comandos de PÓS-REPARAÇÃO              █  
#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  


#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
#  █        FIM dos comandos de PÓS-REPARAÇÃO                █  
#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 

}


##================================================
## MARK: Initialization
##================================================

# Set strict error handling across entire operation.
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
$ProgressPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue
Set-StrictMode -Version 1

# Import the module and instantiate a new session.
try
{
    $moduleName = if ([System.IO.File]::Exists("$PSScriptRoot\PSAppDeployToolkit\PSAppDeployToolkit.psd1"))
    {
        Get-ChildItem -LiteralPath $PSScriptRoot\PSAppDeployToolkit -Recurse -File | Unblock-File -ErrorAction Ignore
        "$PSScriptRoot\PSAppDeployToolkit\PSAppDeployToolkit.psd1"
    }
    else
    {
        'PSAppDeployToolkit'
    }
    Import-Module -FullyQualifiedName @{ ModuleName = $moduleName; Guid = '8c3c366b-8606-4576-9f2d-4051144f7ca2'; ModuleVersion = '4.0.6' } -Force
    try
    {
        $iadtParams = Get-ADTBoundParametersAndDefaultValues -Invocation $MyInvocation
        $adtSession = Open-ADTSession -SessionState $ExecutionContext.SessionState @adtSession @iadtParams -PassThru
    }
    catch
    {
        Remove-Module -Name PSAppDeployToolkit* -Force
        throw
    }
}
catch
{
    $Host.UI.WriteErrorLine((Out-String -InputObject $_ -Width ([System.Int32]::MaxValue)))
    exit 60008
}


##================================================
## MARK: Invocation
##================================================

try
{
    Get-Item -Path $PSScriptRoot\PSAppDeployToolkit.* | & {
        process
        {
            Get-ChildItem -LiteralPath $_.FullName -Recurse -File | Unblock-File -ErrorAction Ignore
            Import-Module -Name $_.FullName -Force
        }
    }
    & "$($adtSession.DeploymentType)-ADTDeployment"
    Close-ADTSession
}
catch
{
    Write-ADTLogEntry -Message ($mainErrorMessage = Resolve-ADTErrorRecord -ErrorRecord $_) -Severity 3
    Show-ADTDialogBox -Text $mainErrorMessage -Icon Stop | Out-Null
    Close-ADTSession -ExitCode 60001
}
finally
{
    Remove-Module -Name PSAppDeployToolkit* -Force
}

