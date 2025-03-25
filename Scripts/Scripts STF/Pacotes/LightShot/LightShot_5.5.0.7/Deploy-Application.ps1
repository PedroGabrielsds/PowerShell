<#
.SYNOPSIS

PSApppDeployToolkit - This script performs the installation or uninstallation of an application(s).

.DESCRIPTION

- The script is provided as a template to perform an install or uninstall of an application(s).
- The script either performs an "Install" deployment type or an "Uninstall" deployment type.
- The install deployment type is broken down into 3 main sections/phases: Pre-Install, Install, and Post-Install.

The script dot-sources the AppDeployToolkitMain.ps1 script which contains the logic and functions required to install or uninstall an application.

PSApppDeployToolkit is licensed under the GNU LGPLv3 License - (C) 2023 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham and Muhammad Mashwani).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details. You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

.PARAMETER DeploymentType

The type of deployment to perform. Default is: Install.

.PARAMETER DeployMode

Specifies whether the installation should be run in Interactive, Silent, or NonInteractive mode. Default is: Interactive. Options: Interactive = Shows dialogs, Silent = No dialogs, NonInteractive = Very silent, i.e. no blocking apps. NonInteractive mode is automatically set if it is detected that the process is not user interactive.

.PARAMETER AllowRebootPassThru

Allows the 3010 return code (requires restart) to be passed back to the parent process (e.g. SCCM) if detected from an installation. If 3010 is passed back to SCCM, a reboot prompt will be triggered.

.PARAMETER TerminalServerMode

Changes to "user install mode" and back to "user execute mode" for installing/uninstalling applications for Remote Desktop Session Hosts/Citrix servers.

.PARAMETER DisableLogging

Disables logging to file for the script. Default is: $false.

.EXAMPLE

powershell.exe -Command "& { & '.\Deploy-Application.ps1' -DeployMode 'Silent'; Exit $LastExitCode }"

.EXAMPLE

powershell.exe -Command "& { & '.\Deploy-Application.ps1' -AllowRebootPassThru; Exit $LastExitCode }"

.EXAMPLE

powershell.exe -Command "& { & '.\Deploy-Application.ps1' -DeploymentType 'Uninstall'; Exit $LastExitCode }"

.EXAMPLE

Deploy-Application.exe -DeploymentType "Install" -DeployMode "Silent"

.INPUTS

None

You cannot pipe objects to this script.

.OUTPUTS

None

This script does not generate any output.

.NOTES

Toolkit Exit Code Ranges:
- 60000 - 68999: Reserved for built-in exit codes in Deploy-Application.ps1, Deploy-Application.exe, and AppDeployToolkitMain.ps1
- 69000 - 69999: Recommended for user customized exit codes in Deploy-Application.ps1
- 70000 - 79999: Recommended for user customized exit codes in AppDeployToolkitExtensions.ps1

.LINK

https://psappdeploytoolkit.com
#>


[CmdletBinding()]
Param (
    [Parameter(Mandatory = $false)]
    [ValidateSet('Install', 'Uninstall', 'Repair')]
    [String]$DeploymentType = 'Install',
    [Parameter(Mandatory = $false)]
    [ValidateSet('Interactive', 'Silent', 'NonInteractive')]
    [String]$DeployMode = 'Interactive',
    [Parameter(Mandatory = $false)]
    [switch]$AllowRebootPassThru = $false,
    [Parameter(Mandatory = $false)]
    [switch]$TerminalServerMode = $false,
    [Parameter(Mandatory = $false)]
    [switch]$DisableLogging = $false
)

Try {
    ## Set the script execution policy for this process
    Try {
        Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop'
    }
    Catch {
    }

    ##*===============================================
    ##* DECLARAÇÃO DE VARIÁVEIS
    ##*===============================================
    ## Variables: Application
    [String]$appVendor = 'Skillbrains'					# Nome do Fabricante do Aplicativo (Ex.: Adobe)
    [String]$appName = 'LightShot'						# Nome do Aplicativo (Ex.: Acrobat Reader)
    [String]$appVersion = '5.5.0.7'						# Versão do Aplicativo (Ex.: 1.0)
    [String]$appArch = 'X64'							# Arquitetura (Valores: X86, X64, X86-X64)
    [String]$appLang = 'PT-BR'							# Idioma (Valores: PT-BR, EN)
    [String]$appRevision = '02'							# Número da Revisão de Pacote do Aplicativo
    [String]$appScriptVersion = '1.0.0'					# Versão do Script 
    [String]$appScriptDate = '04/01/2024'				# Data da criação do Pacote
    [String]$appScriptAuthor = 'ricardo.m.sousa'		# Nome do Autor do Pacote

	## Variáveis específicas para o STF
	[string]$roda_inventario = 'NAO'  					# Valores possíveis: SIM e NAO - Define se o cliente deve executar ou nao o inventario após a instalação
	[string]$versao_customizacao = '1.4' 				# Versão do script "Deploy-Application.ps1" customizado pelo STF
	
    ##*===============================================
    ## Variables: Install Titles (Only set here to override defaults set by the toolkit)
    [String]$installName = ''
    [String]$installTitle = ''

    ##* NÃO MODIFIQUE A SEÇÃO ABAIXO
    #region DoNotModify

    ## Variables: Exit Code
    [Int32]$mainExitCode = 0

    ## Variables: Script
    [String]$deployAppScriptFriendlyName = 'Deploy Application'
    [Version]$deployAppScriptVersion = [Version]'3.9.3'
    [String]$deployAppScriptDate = '02/05/2023'
    [Hashtable]$deployAppScriptParameters = $PsBoundParameters

    ## Variables: Environment
    If (Test-Path -LiteralPath 'variable:HostInvocation') {
        $InvocationInfo = $HostInvocation
    }
    Else {
        $InvocationInfo = $MyInvocation
    }
    [String]$scriptDirectory = Split-Path -Path $InvocationInfo.MyCommand.Definition -Parent

    ## Dot source the required App Deploy Toolkit Functions
    Try {
        [String]$moduleAppDeployToolkitMain = "$scriptDirectory\AppDeployToolkit\AppDeployToolkitMain.ps1"
        If (-not (Test-Path -LiteralPath $moduleAppDeployToolkitMain -PathType 'Leaf')) {
            Throw "Module does not exist at the specified location [$moduleAppDeployToolkitMain]."
        }
        If ($DisableLogging) {
            . $moduleAppDeployToolkitMain -DisableLogging
        }
        Else {
            . $moduleAppDeployToolkitMain
        }
    }
    Catch {
        If ($mainExitCode -eq 0) {
            [Int32]$mainExitCode = 60008
        }
        Write-Error -Message "Module [$moduleAppDeployToolkitMain] failed to load: `n$($_.Exception.Message)`n `n$($_.InvocationInfo.PositionMessage)" -ErrorAction 'Continue'
        ## Exit the script, returning the exit code to SCCM
        If (Test-Path -LiteralPath 'variable:HostInvocation') {
            $script:ExitCode = $mainExitCode; Exit
        }
        Else {
            Exit $mainExitCode
        }
    }

    #endregion
    ##* NÃO MODIFIQUE A SEÇÃO ACIMA
    ##*===============================================
    ##* FIM DA DECLARAÇÃO DE VARIÁVEIS
    ##*===============================================

	##*===============================================
	##* INICIO DO CORPO DO SCRIPT 
	##*===============================================

    If ($deploymentType -ine 'Uninstall' -and $deploymentType -ine 'Repair') {

		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   PRÉ-INSTALAÇÃO  ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Pre-Installation'

		#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
		#  █        INÍCIO dos comandos de PRÉ-INSTALAÇÃO            █  
		#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  
			

			## Fecha o LightShot de forma silenciosa antes de iniciar a instalação.
			Show-InstallationWelcome -CloseApps 'Lightshot' -Silent

    		## Mostra a Mensagem de Progresso (com a mensagem padrão)
	    	Show-InstallationProgress -StatusMessage "Instalando $appName $appVersion"



		#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
		#  █         FIM dos comandos de PRÉ-INSTALAÇÃO              █  
		#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤    INSTALAÇÃO     ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Installation'

		## Faz a instalação automática (Zero-config) de instaladores MSI, com ou sem MST e/ou MSP
		## ATENÇÃO - Esta instalação automática do MSI só funcionará se a variável $appName estiver VAZIA!
		## Caso contrário ela não tentará realizar a instalação pelo MSI automaticamente
        If ($useDefaultMsi) {
            [Hashtable]$ExecuteDefaultMSISplat = @{ Action = 'Install'; Path = $defaultMsiFile }; If ($defaultMstFile) {
                $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile)
            }
            Execute-MSI @ExecuteDefaultMSISplat; If ($defaultMspFiles) {
                $defaultMspFiles | ForEach-Object { Execute-MSI -Action 'Patch' -Path $_ }
            }
        }

		#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
		#  █           INÍCIO dos comandos de INSTALAÇÃO             █  
		#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  


			## Instalação do LightShot com parametro de instalação silenciosa e não reiniciar o computador.
			Execute-Process -Path "$dirFiles\setup-lightshot.exe" -Parameters "/VERYSILENT /NORESTART" -WindowStyle Hidden



		#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
		#  █            FIM dos comandos de INSTALAÇÃO               █  
		#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 
	

		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   PÓS-INSTALAÇÃO  ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Post-Installation'

		#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
		#  █        INÍCIO dos comandos de PÓS-INSTALAÇÃO            █  
		#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  
			

			## <COLOQUE AQUI AS TAREFAS DE PÓS-INSTALAÇÃO>


			## Rotina para executar o inventario no cliente quando a variável $roda_inventario é definida como 'SIM'
			If ($roda_inventario -ieq 'SIM') {
				Invoke-SCCMTask 'HardwareInventory' ## Executa o Inventário de Hardware no cliente
				Invoke-SCCMTask 'SoftwareInventory' ## Executa o Inventário de Software no cliente
			}
			
		#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
		#  █         FIM dos comandos de PÓS-INSTALAÇÃO              █  
		#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


    }
	ElseIf ($deploymentType -ieq 'Uninstall') {

		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ PRÉ-DESINSTALAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Pre-Uninstallation'

		#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
		#  █       INÍCIO dos comandos de PRÉ-DESINSTALAÇÃO          █ 
		#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

			## Exemplo 1
			## Mostra uma mensagem inicial, fecha automaticamente o Internet Explorer após uma contagem regressiva de 60 segundos
			#Show-InstallationWelcome -CloseApps 'iexplore' -CloseAppsCountdown 60
			
			## Mostra a Mensagem de Progresso (com a mensagem padrão)
		    Show-InstallationProgress -StatusMessage "Desinstalando $appName $appVersion"

			## <COLOQUE AQUI AS TAREFAS DE PRÉ-DESINSTALAÇÃO>

			
		#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
		#  █        FIM dos comandos de PRÉ-DESINSTALAÇÃO            █  
		#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 

		
		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤   DESINSTALAÇÃO   ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Uninstallation'

        ## Handle Zero-Config MSI Uninstallations
        If ($useDefaultMsi) {
            [Hashtable]$ExecuteDefaultMSISplat = @{ Action = 'Uninstall'; Path = $defaultMsiFile }; If ($defaultMstFile) {
                $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile)
            }
            Execute-MSI @ExecuteDefaultMSISplat
        }

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █          INÍCIO dos comandos de DESINSTALAÇÃO           █ 
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

		## <COLOQUE AQUI AS TAREFAS DE DESINSTALAÇÃO>

		## Desinstalação do LightShot com parametro silenciosa e não reiniciar o computador.
		Execute-Process -Path "$envProgramFilesX86\Skillbrains\lightshot\unins000.exe" -Parameters "/VERYSILENT /NORESTART" -WindowStyle Hidden
	        
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █          FIM dos comandos de DESINSTALAÇÃO              █
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ PÓS-DESINSTALAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Post-Uninstallation'

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █       INÍCIO dos comandos de PÓS-DESINSTALAÇÃO          █  
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

       
        ## Refresh the Windows Explorer Shell, which causes the desktop icons and the environment variables to be reloaded.
        #Update-Desktop

        ## Verifica se a pasta do LightShot existe e caso exista remove
        If (Test-Path "$envProgramFilesX86\Skillbrains\") { Remove-Folder -Path "$envProgramFilesX86\Skillbrains\" }
        

		## Rotina para executar o inventario no cliente quando a variável $roda_inventario é definida como 'SIM'
		If ($roda_inventario -ieq 'SIM') {
			Invoke-SCCMTask 'HardwareInventory' ## Executa o Inventário de Hardware no cliente
			Invoke-SCCMTask 'SoftwareInventory' ## Executa o Inventário de Software no cliente
		}
	
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █        FIM dos comandos de PÓS-DESINSTALAÇÃO            █  
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 

    }
    ElseIf ($deploymentType -ieq 'Repair') {
		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ PRÉ-REPARAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Pre-Repair'

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █       INÍCIO dos comandos de PRÉ-REPARAÇÃO              █  
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  


		## <COLOQUE AQUI AS TAREFAS DE PRÉ-REPARAÇÃO>
	
	

	
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █        FIM dos comandos de PRÉ-REPARAÇÃO                █  
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ REPARAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Repair'

        ## Handle Zero-Config MSI Repairs
        If ($useDefaultMsi) {
            [Hashtable]$ExecuteDefaultMSISplat = @{ Action = 'Repair'; Path = $defaultMsiFile; }; If ($defaultMstFile) {
                $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile)
            }
            Execute-MSI @ExecuteDefaultMSISplat
        }

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █       INÍCIO dos comandos de REPARAÇÃO                  █  
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

		## <COLOQUE AQUI AS TAREFAS DE REPARAÇÃO>
	
	

	
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █        FIM dos comandos de REPARAÇÃO                    █  
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


		#  ╔╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤═══════════════╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╤╗
		#  ╟┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┤ PÓS-REPARAÇÃO ├┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼┼╢ 
		#  ╚╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧═══════════════╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╧╝ 

        [String]$installPhase = 'Post-Repair'

	#  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
	#  █       INÍCIO dos comandos de PÓS-REPARAÇÃO              █  
	#  ▼  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▼  

		## <COLOQUE AQUI AS TAREFAS DE PÓS-REPARAÇÃO>
	
	

	
	#  ▲  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ▲ 
	#  █        FIM dos comandos de PÓS-REPARAÇÃO                █  
	#  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ 


    }
    ##*===============================================
    ##* END SCRIPT BODY
    ##*===============================================

    ## Call the Exit-Script function to perform final cleanup operations
    Exit-Script -ExitCode $mainExitCode
}
Catch {
    [Int32]$mainExitCode = 60001
    [String]$mainErrorMessage = "$(Resolve-Error)"
    Write-Log -Message $mainErrorMessage -Severity 3 -Source $deployAppScriptFriendlyName
    Show-DialogBox -Text $mainErrorMessage -Icon 'Stop'
    Exit-Script -ExitCode $mainExitCode
}
