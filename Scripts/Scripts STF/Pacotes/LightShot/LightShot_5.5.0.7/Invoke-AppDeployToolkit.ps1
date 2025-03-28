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
    AppVendor = 'Skillbrains'
    AppName = 'LightShot'
    AppVersion = '5.5.0.7'
    AppArch = 'X64'
    AppLang = 'PT-BR'
    AppRevision = '02'
    AppSuccessExitCodes = @(0)
    AppRebootExitCodes = @(1641, 3010)
    AppScriptVersion = '1.0.0'
    AppScriptDate = '2025-03-24'
    AppScriptAuthor = 'ricardo.m.sousa'

    # Install Titles (Only set here to override defaults set by the toolkit).
    InstallName = ''
    InstallTitle = ''

    # Script variables.
    DeployAppScriptFriendlyName = $MyInvocation.MyCommand.Name
    DeployAppScriptVersion = '4.0.6'
    DeployAppScriptParameters = $PSBoundParameters
}

function Install-ADTDeployment
{

		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   PRÉ-INSTALAÇÃO  ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = "Pre-$($adtSession.DeploymentType)"

		#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
		#  █        INÍCIO dos comandos de PRÉ-INSTALAÇÃO            █  
		#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  
			

			## Fecha o LightShot de forma silenciosa antes de iniciar a instalação.
			Show-ADTInstallationWelcome -CloseProcesses 'Lightshot' -Silent 

    		## Mostra a Mensagem de Progresso (com a mensagem padrão)
	    	Show-ADTInstallationProgress -StatusMessage "Instalando $($adtSession.AppName) $($adtSession.AppVersion)"



		#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
		#  █         FIM dos comandos de PRÉ-INSTALAÇÃO              █  
		#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤    INSTALAÇÃO     ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = $adtSession.DeploymentType

		## Faz a instalação automática (Zero-config) de instaladores MSI, com ou sem MST e/ou MSP
		## ATENÇÃO - Esta instalação automática do MSI só funcionará se a variável $appName estiver VAZIA!
		## Caso contrário ela não tentará realizar a instalação pelo MSI automaticamente
        If ($adtSession.UseDefaultMsi) {
            [Hashtable]$ExecuteDefaultMSISplat = @{ Action = 'Install'; Path = $adtSession.DefaultMsiFile }; If ($defaultMstFile) {
                $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile)
            }
            Start-ADTMsiProcess ; If ($defaultMspFiles) {
                $defaultMspFiles | ForEach-Object { Start-ADTMsiProcess -Action 'Patch' -FilePath $_ }
            }
        }

		#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
		#  █           INÍCIO dos comandos de INSTALAÇÃO             █  
		#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  


			## Instalação do LightShot com parametro de instalação silenciosa e não reiniciar o computador.
			Start-ADTProcess -FilePath "$($adtSession.DirFiles)\setup-lightshot.exe" -ArgumentList "/VERYSILENT /NORESTART" -WindowStyle Hidden



		#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
		#  █            FIM dos comandos de INSTALAÇÃO               █  
		#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 
	

		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   PÓS-INSTALAÇÃO  ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = "Post-$($adtSession.DeploymentType)"

		#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
		#  █        INÍCIO dos comandos de PÓS-INSTALAÇÃO            █  
		#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  
			
			## <COLOQUE AQUI AS TAREFAS DE PÓS-INSTALAÇÃO> ▼▼


			$GetScheduledTaskInfo = "$($adtSession.DirSupportFiles)\FuncaoGetScheduledTaskInfo.ps1"

			. $GetScheduledTaskInfo

			#Verificar se existe a tarefa "Updater" e se existir apaga-la!
			$Tarefas_Agendadas = Get-ScheduledTaskInfo

			If ($Tarefas_Agendadas.Count -gt 0) {
				
				$Tarefa_LightShot = $Tarefas_Agendadas | Where-Object {$_.Command -like "*Skillbrains*"}

				If ($Tarefa_LightShot.Count -gt 0) {

					#Write-Host "Tarefas agendadas do LightShot encontradas!" -BackgroundColor Black -ForegroundColor Green
					Write-ADTLogEntry -Message "Tarefas agendadas do LightShot encontradas!" -Severity 0

					Try {

						Unregister-scheduledtask -taskname $Tarefa_LightShot.name -Confirm:$false
						#Write-Host "Tarefas agendadas do LightShot excluida com sucesso!" -BackgroundColor Black -ForegroundColor Green
						Write-ADTLogEntry "Tarefas agendadas do LightShot excluida com sucesso!" -Severity 0
					
					} Catch {

						#Write-Host "Não foi possivel excluir a tarefa agendada do LightShot" -BackgroundColor Black -ForegroundColor Red
						Write-ADTLogEntry "Não foi possivel excluir a tarefa agendada do LightShot" -Severity 3

					}
				}

			} Else {

				#Write-Host "Não foi possivel coletar as informações de tarefas agendadas" -BackgroundColor Black -ForegroundColor Red
				Write-ADTLogEntry "Não foi possivel coletar as informações de tarefas agendadas" -Severity 3

			}

			## Rotina para executar o inventario no cliente quando a variável $roda_inventario é definida como 'SIM'
			If ($roda_inventario -ieq 'SIM') {
				Invoke-ADTSCCMTask -ScheduleID 'HardwareInventory' ## Executa o Inventário de Hardware no cliente
				Invoke-ADTSCCMTask -ScheduleID 'SoftwareInventory' ## Executa o Inventário de Software no cliente
			}
			
		#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
		#  █         FIM dos comandos de PÓS-INSTALAÇÃO              █  
		#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


    }

function Uninstall-ADTDeployment
{

		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ PRÉ-DESINSTALAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = "Pre-$($adtSession.DeploymentType)"

		#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
		#  █       INÍCIO dos comandos de PRÉ-DESINSTALAÇÃO          █ 
		#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

			  ## <COLOQUE AQUI AS TAREFAS DE PRÉ-DESINSTALAÇÃO> ▼▼

			## Exemplo 1
			## Mostra uma mensagem inicial, fecha automaticamente o Internet Explorer após uma contagem regressiva de 60 segundos
			#Show-InstallationWelcome -CloseApps 'iexplore' -CloseAppsCountdown 60
			
			## Mostra a Mensagem de Progresso (com a mensagem padrão)
		    Show-ADTInstallationProgress -StatusMessage "Desinstalando $($adtSession.AppName) $($adtSession.AppVersion)"

			

			
		#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
		#  █        FIM dos comandos de PRÉ-DESINSTALAÇÃO            █  
		#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 

		
		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   DESINSTALAÇÃO   ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = $adtSession.DeploymentType

        ## Handle Zero-Config MSI Uninstallations
        If ($adtSession.UseDefaultMsi) {
            [Hashtable]$ExecuteDefaultMSISplat = @{ Action = 'Uninstall'; Path = $adtSession.DefaultMsiFile }; If ($defaultMstFile) {
                $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile)
            }
            Start-ADTMsiProcess 
        }

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █          INÍCIO dos comandos de DESINSTALAÇÃO           █ 
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

		## <COLOQUE AQUI AS TAREFAS DE DESINSTALAÇÃO> ▼▼

		## Desinstalação do LightShot com parametro silenciosa e não reiniciar o computador.
		Start-ADTProcess -FilePath "$envProgramFilesX86\Skillbrains\lightshot\unins000.exe" -ArgumentList "/VERYSILENT /NORESTART" -WindowStyle Hidden
	        
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █          FIM dos comandos de DESINSTALAÇÃO              █
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ PÓS-DESINSTALAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = "Post-$($adtSession.DeploymentType)"

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █       INÍCIO dos comandos de PÓS-DESINSTALAÇÃO          █  
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

		## <COLOQUE AQUI AS TAREFAS DE PÓS-DESINSTALAÇÃO> ▼▼

		#Apagar todos o registros da tarefa updater do "Regedit (Editor de registro)!"
		$Caminho_Regedit_LightShot = "HKLM:HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Skillbrains"

		Remove-ADTRegistryKey -Key $Caminho_Regedit_LightShot -Recurse

        ## Refresh the Windows Explorer Shell, which causes the desktop icons and the environment variables to be reloaded.
        #Update-Desktop

        ## Verifica se a pasta do LightShot existe e caso exista remove
        If (Test-Path "$envProgramFilesX86\Skillbrains\") { Remove-ADTFolder -Path "$envProgramFilesX86\Skillbrains\" }
        

		## Rotina para executar o inventario no cliente quando a variável $roda_inventario é definida como 'SIM'
		If ($roda_inventario -ieq 'SIM') {
			Invoke-ADTSCCMTask -ScheduleID 'HardwareInventory' ## Executa o Inventário de Hardware no cliente
			Invoke-ADTSCCMTask -ScheduleID 'SoftwareInventory' ## Executa o Inventário de Software no cliente
		}
	
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █        FIM dos comandos de PÓS-DESINSTALAÇÃO            █  
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 

    }

function Repair-ADTDeployment
{
		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ PRÉ-REPARAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = "Pre-$($adtSession.DeploymentType)"

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █       INÍCIO dos comandos de PRÉ-REPARAÇÃO              █  
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  


		## <COLOQUE AQUI AS TAREFAS DE PRÉ-REPARAÇÃO> ▼▼
	
	

	
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █        FIM dos comandos de PRÉ-REPARAÇÃO                █  
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ REPARAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = $adtSession.DeploymentType

        ## Handle Zero-Config MSI Repairs
        If ($adtSession.UseDefaultMsi) {
            [Hashtable]$ExecuteDefaultMSISplat = @{ Action = 'Repair'; Path = $adtSession.DefaultMsiFile; }; If ($defaultMstFile) {
                $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile)
            }
            Start-ADTMsiProcess 
        }

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █       INÍCIO dos comandos de REPARAÇÃO                  █  
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

		## <COLOQUE AQUI AS TAREFAS DE REPARAÇÃO> ▼▼
	
	

	
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █        FIM dos comandos de REPARAÇÃO                    █  
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ PÓS-REPARAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        $adtSession.InstallPhase = "Post-$($adtSession.DeploymentType)"

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █       INÍCIO dos comandos de PÓS-REPARAÇÃO              █  
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

		## <COLOQUE AQUI AS TAREFAS DE PÓS-REPARAÇÃO> ▼▼
	
	

	
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
