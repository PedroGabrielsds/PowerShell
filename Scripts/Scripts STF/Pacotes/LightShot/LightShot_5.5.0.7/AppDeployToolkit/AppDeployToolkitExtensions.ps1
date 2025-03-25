<#
.SYNOPSIS

PSAppDeployToolkit - Provides the ability to extend and customise the toolkit by adding your own functions that can be re-used.

.DESCRIPTION

This script is a template that allows you to extend the toolkit with your own custom functions.

This script is dot-sourced by the AppDeployToolkitMain.ps1 script which contains the logic and functions required to install or uninstall an application.

PSApppDeployToolkit is licensed under the GNU LGPLv3 License - (C) 2023 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham and Muhammad Mashwani).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details. You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

.EXAMPLE

powershell.exe -File .\AppDeployToolkitHelp.ps1

.INPUTS

None

You cannot pipe objects to this script.

.OUTPUTS

None

This script does not generate any output.

.NOTES

.LINK

https://psappdeploytoolkit.com
#>


[CmdletBinding()]
Param (
)

##*===============================================
##* VARIABLE DECLARATION
##*===============================================

# Variables: Script
[string]$appDeployToolkitExtName = 'PSAppDeployToolkitExt'
[string]$appDeployExtScriptFriendlyName = 'App Deploy Toolkit Extensions'
[version]$appDeployExtScriptVersion = [version]'3.9.3'
[string]$appDeployExtScriptDate = '02/05/2023'
[hashtable]$appDeployExtScriptParameters = $PSBoundParameters

##*===============================================
##* FUNCTION LISTINGS
##*===============================================

# <Your custom functions go here>


#region Function STF_Test-AdminLocal - 01
Function STF_Test-AdminLocal() {
<#
.SYNOPSIS
    Testa se o usuário que está executando o script é Adminstrador da máquina.
.DESCRIPTION
	Testa se o usuário que está executando o script é Adminstrador da máquina. Essa função serve para evitar que alguma outra função possa verificar se o usuário tem permissão de admisntrador e assim evitar que ações sejam feitas caso o usuário não tenha a devida permissão.
.EXAMPLE
	STF_Test-AdminLocal
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: https://gallery.technet.microsoft.com/scriptcenter/3aa9d51a-44af-4d2a-aa44-6ea541a9f721
.LINK
	http://psappdeploytoolkit.com
#>
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			Return ([security.principal.windowsprincipal] [security.principal.windowsidentity]::GetCurrent()).isinrole([Security.Principal.WindowsBuiltInRole] "Administrator") 
			Write-Log -Message "Verificando se o usuário tem permissão de Adminstrador na máquina" -Source ${CmdletName}
		}
		Catch {	
			[int32]$returnCode = 70000 # Necessita de permissão de Adminstrador
			[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar verificar se o usuário é Adminstrador local"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode
		}
	}
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Set-VariavelPath - 02
Function STF_Set-VariavelPath() {
<#
.SYNOPSIS
	Seta a variável de ambiente PATH do computador
.DESCRIPTION
	Seta a variável de ambiente PATH do computador com o valor especificado.
.PARAMETER Caminho
	Caminho(s) a ser(em) setado(s) na variável de ambiente PATH.
Multiplos caminhos devem ser separados por ";"
.EXAMPLE
	STF_Set-VariavelPath -Caminho 'C:\Windows;C:\Windows\System32'
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: https://gallery.technet.microsoft.com/scriptcenter/3aa9d51a-44af-4d2a-aa44-6ea541a9f721
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding(SupportsShouldProcess=$TRUE)] 
	
	Param (
		[parameter(Mandatory=$True,  
		ValueFromPipeline=$True, 
		Position=0)] 
		[String[]]$Caminho 
	)
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			$private:returnCode = $null

			STF_Test-AdminLocal

			Try {
				# Update the Environment Path 
				if ( $PSCmdlet.ShouldProcess($Caminho) ) {
					Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $Caminho 
					# Show what we just did 
					Write-Log -Message "Novo PATH: $Caminho" -Source ${CmdletName}
					Return $Caminho 
				} 
			}
			Catch {
				[int32]$returnCode = 70001 # Erro ao tentar atualizar a variável de ambiente PATH
				[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar atualizar a variável de ambiente `$ENV:PATH"
				Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
				Exit-Script -ExitCode $returnCode
			}
		}
		Catch {}
	}
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Add-VariavelPath - 03
Function STF_Add-VariavelPath() {
<#
.SYNOPSIS
	Adiciona uma pasta à variável de ambinete PATH já existente.
.DESCRIPTION
	Verifica se o caminho a ser adicionado existe e caso exista, adiciona ao PATH atual da máquina
.PARAMETER Caminho
	Caminho a ser adicioando
.EXAMPLE
	STF_Add-VariavelPath -Caminho 'C:\Program Files (X86)|Java\JRE8\Bin'
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: https://gallery.technet.microsoft.com/scriptcenter/3aa9d51a-44af-4d2a-aa44-6ea541a9f721
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding(SupportsShouldProcess=$TRUE)] 
	
	Param (
		[parameter(Mandatory=$True,  
		ValueFromPipeline=$True, 
		Position=0)] 
		[String[]]$Caminho 
    ) 
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			$private:returnCode = $null
			
			STF_Test-AdminLocal

			$OldPath=STF_Get-VariavelPath
			Write-Log -Message "Antigo PATH: $OldPath" -Source ${CmdletName}
			
			# See if a new Folder has been supplied 
			If (!$Caminho) { 
				[int32]$returnCode = 70002 # Não foi passado o caminho. $ENV.PATH inalterado.
				[string]$extensionErrorMessage = "Error Code [$returnCode] - Nenhum caminho foi fornecido para ser adicionado ao PATH"
				Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
				Exit-Script -ExitCode $returnCode
			} 
 
			# See if the new Folder exists on the File system 
			If (!(Test-Path $Caminho)) { 
				[int32]$returnCode = 70003 # O Caminho fornecido não existe na máquina
				[string]$extensionErrorMessage = "Error Code [$returnCode] - O caminho fornecido não existe. Não pode ser adicionado ao `$ENV:PATH"
				Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
				Exit-Script -ExitCode $returnCode
			} 
 
			# PRECISA SER REESCRITA. Pode causar falso positivo se procurar parte de um path
			# See if the new Folder is already IN the Path 
 			$PathasArray=($Env:PATH).split(';') 
			If ($PathasArray -contains $Caminho -or $PathAsArray -contains $Caminho+'\') { 
				[string]$extensionErrorMessage = 'O caminho já existe em $ENV:PATH'
				Write-Log -Message $extensionErrorMessage -Severity 2 -Source ${CmdletName}
				#Exit-Script -ExitCode $returnCode
				Return $extensionErrorMessage
			} 

			#If (!($Caminho[-1] -match '\')) { $Newpath=$Newpath+'\'} 

			# Set the New Path 
			$NewPath=$OldPath+';'+$Caminho 
			Write-Log -Message "Novo PATH: $NewPath" -Severity 2 -Source ${CmdletName}
			if ( $PSCmdlet.ShouldProcess($Caminho) ) { 
				Try {
					#Remove a ocorrência de ";;" no Path
					$newPath = $newPath -replace ";;", ";"

					Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $newPath 
					Write-Log -Message 'Variável de ambiente $ENV:PATH atualizada' -Source ${CmdletName}
					# Show our results back to the world 
					Return $NewPath  
				} 
				Catch {
				[int32]$returnCode = 70004 # Erro ao tentar adicionar o novo caminho ao $ENV:PATH
				[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar adicionar o novo caminho ao `$ENV:PATH"
				Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
				Exit-Script -ExitCode $returnCode
				}
			}
		}
		Catch {}
	}
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Get-VariavelPath - 04
Function STF_Get-VariavelPath() {
<#
.SYNOPSIS
	Retorna a variável de ambiente PATH da máquina
.DESCRIPTION
	Retorna a variável de ambiente PATH da máquina. Essa função pode ser utilizada por outras funções como por exemplo STF_Add-VariavelPath e STF_Remove-VariavelPath
.EXAMPLE
	STF_Get-VariavelPath
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: https://gallery.technet.microsoft.com/scriptcenter/3aa9d51a-44af-4d2a-aa44-6ea541a9f721
.LINK
	http://psappdeploytoolkit.com
#>
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			Write-Log -Message 'Lendo a variável de ambiente $ENV:PATH' -Source ${CmdletName}
			Return (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path 
		}
		Catch {	
			[int32]$returnCode = 70005 # Erro ao tentar obter a variável de ambiente $env:PATH do sistema
			[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar obter a variável de ambiente $env:PATH do sistema"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode

		}
	}
	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Remove-VariavelPath - 05
Function STF_Remove-VariavelPath() {
<#
.SYNOPSIS
	Remove um caminho do PATH da máquina.
.DESCRIPTION
	Verifica se um determinado caminho existe no PATH da máquina. Caso encontre o caminho, essa função remove esse caminho do PATH
.PARAMETER Caminho
	Caminho a ser removido do PATH.
.EXAMPLE
	STF_Remove-VariavelPath -Caminho 'C:\Program Files (X86)\Java\JRE8\Bin'
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: https://gallery.technet.microsoft.com/scriptcenter/3aa9d51a-44af-4d2a-aa44-6ea541a9f721
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding(SupportsShouldProcess=$TRUE)] 
	
	Param (
		[parameter(Mandatory=$True,  
		ValueFromPipeline=$True, 
		Position=0)] 
		[String[]]$Caminho 
    ) 
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			$private:returnCode = $null
			[boolean]$AtualizaPath = $false
			
			STF_Test-AdminLocal

			$oldPath=STF_Get-VariavelPath
			
			
			# REESCRITURA DA ROTINA DE REMOCAO
			[string]$NovoPath = ""
 			#$PathasArray=($Env:PATH).split(';') 
 			$PathasArray = $oldPath.split(';') 

			foreach ($linha in $PathasArray) {
				If (($linha -like $Caminho) -or ($linha -like $Caminho+'\')) {
					$AtualizaPath = $true
					Write-Log -Message "Caminho encontrado no PATH: [$linha]" -Source ${CmdletName}
				} else {
					$NovoPath += $linha+';'
				}
				If (($linha -eq '\') -or ($linha -eq '')) { 
					If ($linha -eq '\') {Write-Log -Message "Limpando Lixo no PATH:   `";\;`" --> `";`"" -Source ${CmdletName}}
					#If ($linha -eq '') {Write-Log -Message "Limpando Lixo no PATH:   `";;`" --> `";`"" -Source ${CmdletName}}
				}
			}

			# Atualizando a variável de ambiente Path 
			if ( $PSCmdlet.ShouldProcess($Caminho) -and ($AtualizaPath) ) { 
				Try {
					#Remove a ocorrência de ";;" no Path
					$NovoPath = $NovoPath -replace ";;", ";"

					Write-Log -Message "Novo PATH: $NovoPath" -Severity 2 -Source ${CmdletName}
					Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $NovoPath 
					Write-Log -Message 'Variável de ambiente $ENV:PATH atualizada' -Source ${CmdletName}
				}
				Catch {
					[int32]$returnCode = 70006 # Erro ao tentar atualizar o novo caminho ao $ENV:PATH
					[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar atualizar o novo caminho ao `$ENV:PATH"
					Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
					Exit-Script -ExitCode $returnCode
				}
			# Show what we just did 
			Return $NovoPath 
			}
		}
		Catch {
		}

	}	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Add-VariavelAmbiente - 06
Function STF_Add-VariavelAmbiente {
<#
.SYNOPSIS
	Adiciona uma nova variável de ambiente.
.DESCRIPTION
    Adiciona uma nova variável de ambiente. 
    As variáveis de ambiente podem ser de 3 tipos: "User", "Machine" ou "Process"
        User:    Variável de Ambiente apenas od usuário
        Machine: Variável de ambinete do computador e válida para todos os usuários
        Process: variável apenas poara o prcoesso corrente.
.PARAMETER Nome
	Nome da Variável de ambiente.
.PARAMETER Valor
	Valor da variável de ambiente.
.PARAMETER Tipo
	Tipo da variável de ambiente. 
    As variáveis de ambiente podem ser de 3 tipos: "User", "Machine" ou "Process"
        User:    Variável de Ambiente apenas od usuário
        Machine: Variável de ambinete do computador e válida para todos os usuários
        Process: variável apenas poara o prcoesso corrente.
.EXAMPLE
	STF_Add-VariavelAmbiente -Nome 'UNOPATH' -Valor 'C:\Program Files\java\jre\bin' -Tipo 'Machine'
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
	
#>
	[Cmdletbinding()] 
	
	Param (
		[Parameter(Mandatory=$True,Position=0)] 
		[String[]]$Nome,
		[Parameter(Mandatory=$true,Position=1)]
		[String[]]$Valor,
		[Parameter(Mandatory=$true,Position=2)]
		[String[]]$Tipo
	) 
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			$private:returnCode = $null
			
			
			Switch ($Tipo) {
				"User" {
					Write-Log -Message "Variável de ambiente $Nome é do tipo USER" -Source ${CmdletName}
				}
				"Machine" {
					Write-Log -Message "Variável de ambiente $Nome é do tipo MACHINE" -Source ${CmdletName}
				}
				"Process" {
					Write-Log -Message "Variável de ambiente $Nome é do tipo PROCESS" -Source ${CmdletName}
				}
				default {
					[int32]$returnCode = 70007 # Tipo de variável desconhecido
					[string]$extensionErrorMessage = "Error Code [$returnCode] - Tipo de variável de ambiente desconhecido"
					Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
					Exit-Script -ExitCode $returnCode
				}
			}
			
			[Environment]::SetEnvironmentVariable("$Nome", "$Valor", "$Tipo")

			Write-Log -Message "Variável de ambiente $Nome criada com sucesso" -Source ${CmdletName}

		}
		Catch {
			[int32]$returnCode = 70008 # Erro ao tentar criar variável de ambiente
			[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar criar variável de ambiente"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode

		}

	}	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Remove-VariavelAmbiente - 07
Function STF_Remove-VariavelAmbiente {
<#
.SYNOPSIS
	Remove uma variável de ambiente.
.DESCRIPTION
	Remove uma variável de ambiente. 
    As variáveis de ambiente podem ser de 3 tipos: "User", "Machine" ou "Process"
        User:    Variável de Ambiente apenas od usuário
        Machine: Variável de ambinete do computador e válida para todos os usuários
        Process: variável apenas poara o prcoesso corrente.
.PARAMETER Nome
	Nome da Variável de ambiente.
	.PARAMETER Tipo
	Tipo da variável de ambiente. 
    As variáveis de ambiente podem ser de 3 tipos: "User", "Machine" ou "Process"
        User:    Variável de Ambiente apenas od usuário
        Machine: Variável de ambinete do computador e válida para todos os usuários
        Process: variável apenas poara o prcoesso corrente.
.EXAMPLE
	STF_Remove-VariavelAmbiente -Nome 'UNOPATH' -Tipo 'Machine'
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
	
#>
	[Cmdletbinding()] 
	
	Param (
		[Parameter(Mandatory=$True,Position=0)] 
		[String[]]$Nome,
		[Parameter(Mandatory=$true,Position=1)]
		 [System.EnvironmentVariableTarget]$Tipo
	) 
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			$private:returnCode = $null
			
			
			Switch ($Tipo) {
				"User" {
					Write-Log -Message "Variável de ambiente $Nome é do tipo USER" -Source ${CmdletName}
				}
				"Machine" {
					Write-Log -Message "Variável de ambiente $Nome é do tipo MACHINE" -Source ${CmdletName}
				}
				"Process" {
					Write-Log -Message "Variável de ambiente $Nome é do tipo PROCESS" -Source ${CmdletName}
				}
				default {
					[int32]$returnCode = 70009 # Tipo de variável desconhecido
					[string]$extensionErrorMessage = "Error Code [$returnCode] - Tipo de variável de ambiente desconhecido"
					Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
					Exit-Script -ExitCode $returnCode
				}
			}
			
			[Environment]::SetEnvironmentVariable("$Nome", '', "$Tipo")

			Write-Log -Message "Variável de ambiente $Nome removida com sucesso" -Source ${CmdletName}

		}
		Catch {
			[int32]$returnCode = 70010 # Erro ao tentar remover a variável de ambiente
			[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar remover variável de ambiente"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode

		}

	}	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Set-PermissaoArquivos - 08
Function STF_Set-PermissaoArquivos {
<#
.SYNOPSIS
Concede permissão em uma pasta ou arquivo utilizando o comando CALCS do Windows
.DESCRIPTION
	Define a permissão de acesso em uma pasta ou arquivo para um usuário ou grupo 
.PARAMETER Caminho
	Caminho completo do arquivo ou da pasta
.PARAMETER Nome
	Nome do usuário ou grupo a ser concedido o acesso
.PARAMETER Permissao
	Permissão ser concedida. Os valores possíveis são:
		F = Controle Total (Full Control)
		C = Alterar (Change)
		R = Ler (Readonly)
		W = Gravar (Write)
.PARAMETER Recursivo
	Aplica a permissão em todos os objetos da pasta e nos subdiretórios. O Default é: $false
.EXAMPLE
	STF_Set-PermissaoArquivos -Caminho 'C:\Program Files\RainMeter' -Nome "Usuários Autenticados" -Permissao "F" -Recursivo
.EXAMPLE
	STF_Set-PermissaoArquivos -Caminho 'C:\temp\arquivo.txt' -Nome "rede\joao" -Permissao "C"
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
	
#>
	[Cmdletbinding()] 
	
	Param (
		[Parameter(Mandatory=$True)] 
		[String[]]$Caminho,
		[Parameter(Mandatory=$true)]
		[String[]]$Nome,
		[Parameter(Mandatory=$true)]
		[String[]]$Permissao,
		[Parameter(Mandatory=$false)]
		[switch]$Recursivo = $false
	) 
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			$private:returnCode = $null

			Switch ($Permissao) {
				"F" { Write-Log -Message "[CACLS] Permissão a ser aplicada em $Caminho [CONTOLE TOTAL]" -Source ${CmdletName} }
				"C" { Write-Log -Message "[CACLS] Permissão a ser aplicada em $Caminho [ALTERAR]" -Source ${CmdletName} }
				"R" { Write-Log -Message "[CACLS] Permissão a ser aplicada em $Caminho [LER]" -Source ${CmdletName} }
				"W" { Write-Log -Message "[CACLS] Permissão a ser aplicada em $Caminho [GRAVAR]" -Source ${CmdletName} }
				default {
					[int32]$returnCode = 70011 # Parâmetro de Permissão inválido
					[string]$extensionErrorMessage = "Error Code [$returnCode] - [CACLS] Parâmetro Permission [$Permissao] inválido"
					Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
					Exit-Script -ExitCode $returnCode
				}
			}

			If ( (Test-Path -Path $Caminho) -eq $false ){
				[int32]$returnCode = 70012 # Parâmetro Path inválido
				[string]$extensionErrorMessage = "Error Code [$returnCode] - [CACLS] Parâmetro Path [$Caminho] inválido"
				Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
				Exit-Script -ExitCode $returnCode
			}

			
			If ($Recursivo) {
				Write-Log -Message "[CACLS] As permissões serão aplicadas de forma recursiva [$Caminho]." -Source ${CmdletName}
				$Parametro_Recursivo = "/T"
			}
			Else {
				Write-Log -Message "[CACLS] As permissões serão aplicadas apenas em [$Caminho]." -Source ${CmdletName}
				$Parametro_Recursivo = ""
			}
			
			
			# Concede aos "Usuários Autenticados" permissão de modificação na pasta do RainMeter
			Execute-Process -Path "$envWinDir\System32\cacls.exe" -Parameters  "`"$Caminho`" /E /C $Parametro_Recursivo /G `"$Nome`":$Permissao" -WindowStyle 'Hidden'
			
			Write-Log -Message "[CACLS] Concedido a permissão [$Permissao] a [$Caminho] para [$Nome]" -Source ${CmdletName}
	
		}
		Catch {
			[int32]$returnCode = 70013 # Erro ao tentar conceder permissão
			[string]$extensionErrorMessage = "Error Code [$returnCode] - [CACLS] Erro ao tentar conceder permissão a $Nome em $Caminho"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode

		}

	}	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Set-PermissaoArquivosICACLS - 09
Function STF_Set-PermissaoArquivosICACLS {
<#
.SYNOPSIS
Concede permissão em uma pasta ou arquivos utilizando o comando ICALCS do Windows.
.DESCRIPTION
	Definie a permissão de acesso em uma pasta ou arquivo para um usuário ou grupo 
.PARAMETER Caminho
	Caminho do arquivo ou da pasta
.PARAMETER Nome
	Nome do usuário ou grupo a ser concedido o acesso
.PARAMETER Permissao
	Permissão ser concedida. Os valores possíveis são:
		F - Controle Total (Full Control)
		M - Alterar (Modify)
		RX - Ler e Executar (Read and eXecute)
		R - Ler (Readonly)
		W - Gravar (Write-Only)
.EXAMPLE
	STF_Set-ICALCS -Caminho 'C:\Program Files\RainMeter' -Nome "Usuários Autenticados" -Permissao "F" 
.EXAMPLE
	STF_Set-ICALCS -Caminho 'C:\temp\arquivo.txt' -Nome "rede\joao" -Permissao "C"
.NOTES
    Autor: Regis Proença Picanço
    Versão: 1.0
    Data de criação/modificação: 05/04/2018
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
	
#>
	[Cmdletbinding()] 
	
	Param (
		[Parameter(Mandatory=$True)] 
		[String[]]$Caminho,
		[Parameter(Mandatory=$true)]
		[String[]]$Nome,
		[Parameter(Mandatory=$true)]
		[String[]]$Permissao
	) 
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			$private:returnCode = $null

			Switch ($Permissao) {
				"F" { Write-Log -Message "[ICACLS] Permissão a ser aplicada em $Caminho [CONTOLE TOTAL]" -Source ${CmdletName} }
				"M" { Write-Log -Message "[ICACLS] Permissão a ser aplicada em $Caminho [ALTERAR]" -Source ${CmdletName} }
				"R" { Write-Log -Message "[ICACLS] Permissão a ser aplicada em $Caminho [LER]" -Source ${CmdletName} }
				"RX" { Write-Log -Message "[ICACLS] Permissão a ser aplicada em $Caminho [LER e EXECUTAR]" -Source ${CmdletName} }
				"W" { Write-Log -Message "[ICACLS] Permissão a ser aplicada em $Caminho [GRAVAR]" -Source ${CmdletName} }
				default {
					[int32]$returnCode = 70014 # Parâmetro de Permissão inválido
					[string]$extensionErrorMessage = "Error Code [$returnCode] - [ICACLS] Parâmetro Permission [$Permissao] inválido"
					Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
					Exit-Script -ExitCode $returnCode
				}
			}
			If ( (Test-Path -Path $Caminho) -eq $false ){
				[int32]$returnCode = 70015 # Parâmetro Path inválido
				[string]$extensionErrorMessage = "Error Code [$returnCode] - [ICACLS] Parâmetro Path [$Caminho] inválido"
				Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
				Exit-Script -ExitCode $returnCode
			}
			
			# Concede aos "Usuários Autenticados" permissão de modificação na pasta do RainMeter
			Execute-Process -Path "$envWinDir\System32\icacls.exe" -Parameters  "`"$Caminho`" /grant:r `"$Nome`":(OI)(CI)$Permissao /C" -WindowStyle 'Hidden'
			Write-Log -Message "[ICACLS] Concedido a permissão [$Permissao] a [$Caminho] para [$Nome]" -Source ${CmdletName}
		}
		Catch {
			[int32]$returnCode = 70016 # Erro ao tentar conceder permissão
			[string]$extensionErrorMessage = "Error Code [$returnCode] - [ICACLS] Erro ao tentar conceder permissão a $Nome em $Caminho"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode
		}
	}	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Set-DescricaoWindows - 10
Function STF_Set-DescricaoWindows {
<#
.SYNOPSIS
	Altera a descrição do windows em uma ou varias maquinas.
.DESCRIPTION
	Altera a descrição do windows em uma ou varias maquinas lendo o nome das maquinas e a descrição de um arquivo CSV.
    O arquivo CSV deve ter apenas duas colunas uma coluna HOST  e outra coluna DESCRICAO.
    A descriçao do windows 7, 8, 8.1 ou 10 de arquitetura x86 ou x64 ficam na mesma chave de registro.
    Sendo necesssário apenas alterar O valor da chave "srvcomment" que fica no caminho:
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters\
    O valor da chave "srvcomment" e a descrição do windows.
.PARAMETER Arquivo
	Caminho completo para o arquivo csv. 
    Ex.: "C:\temp\Descricao.csv" ou "\\ARQUIVOS\BDS\ESTACOES\Softwares\Descricao.Windows\Descricao_STI.csv"
.EXAMPLE
	STF_Set-DescricaoWindows -Arquivo "C:\Temp\Descricao_STI.CSV"
.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0
    Data de criação/modificação: 
    Fonte: https://gallery.technet.microsoft.com/scriptcenter/Script-Altera-chave-de-7f513f74#content
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding()] 
	
	Param (
        [Parameter(Mandatory=$True,Position=0,HelpMessage='Insira o caminho completo para o arquivo de texto')] 
		[String[]]$Arquivo
	) 
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
        # Armazena o paramento passado na chamada função 
        $ArquivoCSV = $Arquivo
        # Importa o arquivo CSV  
        $csv = Import-Csv $ArquivoCSV

        # Faz um loop lendo cada linha do arquivo CSV
        foreach($line in $csv) 
        { 
            
            Try {
                # Indica qual e o cabeçalho do arquivo CSV
                $ComputadorDescricao = $line.'HOST;DESCRICAO'
                # Variavél para armazena o nome do computador Ex: ETI079723 
                $Computador = $ComputadorDescricao.Split(";")[0]
                # Variavél para armazena a descrição da maquina Ex: STI/CINT/SIMIC
                $Descricao = $ComputadorDescricao.Split(";")[1]
                
                # Abre o registro de uma maquinas   
                $Arreg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Computador)
                # Informa passa qual o caminho da chave a ser alterada.
                $Arrkey="SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" 
                # Abre a chave de registro da maquina desejada
                $ArregKey = $Arreg.OpenSubKey($Arrkey,$True)
                
                # Verifica qual a descrição da maquina
                $DescricaoAtual = $ArregKey.GetValue('srvcomment')
            
                # Verifica se a descrição da maquina e a mesma do arquivo CSV.
                # Caso seja igual a descrição apenas escreve no log a mensagem: "O computador ETI079723 está com a descriçao correta"
                # Caso seja diferente e alterado a descrição da maquina e escreve no log
                If ($DescricaoAtual -eq $Descricao) {  
                    STF_Modify-ArquivoTexto -Path "$ArquivoCSV" -RemoveLine -Text "$Computador" -Partial $True 
                    Write-Log -Message "O computador $Computador está com a descriçao correta" #-Source ${CmdletName}

                }               
                Else
                {
                    # Altera a descrição
                    $Arregkey.SetValue('srvcomment',$Descricao,'String') 
                    Write-Log -Message "Escreveu no computador $Computador a descriçao: $Descricao" #-Source ${CmdletName}
                    STF_Modify-ArquivoTexto -Path "$ArquivoCSV" -RemoveLine -Text "$Computador" -Partial $True 
                }
                           
           }
           Catch {
                # Se por algum motivo não seja possivel alterar a descrição do windows 
                # em uma determinada maquina vai ser escrito no log a mensagem: "Não foi possivel alterar a descrição do computador: ETI079723" 
                $Computador = $ComputadorDescricao.Split(";")[0]
                [int32]$returnCode = 70017 # Erro ao tentar escrever no registro a descrição do windows
                [string]$extensionErrorMessage = "Error Code [$returnCode] - Não foi possivel alterar a descrição do computador: $Computador"
                Write-Log -Message $extensionErrorMessage -Severity 2 -Source ${CmdletName}
            
           }

         }
		}
		Catch {
            Write-Log -Message $Arquivo -Severity 3 -Source ${CmdletName}
			[int32]$returnCode = 70018 # Erro ao tentar alterar a Descrição do Windows
			[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar alterar a Descrição do Windows"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode


		}

	}	

	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Modify-ArquivoTexto - 11
Function STF_Modify-ArquivoTexto {
<#
.SYNOPSIS
	Modifica linhas em um arquivo de texto. Podendo adicionar ou remover linhas.
.DESCRIPTION
    Adiciona uma linha ao final de um arquivo de texto ou localiza e remove uma linha de um arquivo de texto.
.PARAMETER Caminho
    Caminho para o arquivo de texto
.PARAMETER Adicionar
    Parâmetro para adicionar uma linha a um arquivo de texto
    Obs.: Não pode ser usado juntamene com o parâmetro Remover
.PARAMETER Remover
    Parâmetro para remover uma linha / linhas de um arquivo de texto
    Obs.: Não pode ser usado juntamene com o parâmetro Adicionar
.PARAMETER Valor
    Texto para ser adicionado ao final do arquivo ou para ser procurado no arquivo para ser removido. 
.PARAMETER Parcial
    Se o switch Remover estiver presente. 
    Se Verdadeiro, procura por parte da linha a remover.
    Se Falso, procura linha inteira. 
    Padrão $false
.PARAMETER Multiplo
    Quando o switch Remover estiver presente. 
    Se Verdadeiro, removerá todas as linhas com Texto. 
	Se Falso, remove apenas a primeira linha correspondente. Padrão $false
.EXAMPLE
    STF_Modify-ArquivoTexto -Caminho 'C:\Temp\TestFile.txt' -Adicionar -Valor 'This is some text to append'
.EXAMPLE
   STF_Modify-ArquivoTexto -Caminho "$envWinDir\System32\TextFile.log" -Remover -Valor 'Installation' -Multiplo $true
.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0
    Data de criação/modificação: 
    Fonte: http://psappdeploytoolkit.com/forums/topic/function-to-addremove-lines-from-text-file-feedback-wanted/
.LINK
	http://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,HelpMessage='Insira o caminho completo para o arquivo de texto')]
        [ValidateNotNullorEmpty()]
        [string]$Caminho,
        [Parameter(Mandatory=$true,ParameterSetName='Add')]
		[switch]$Adicionar,
        [Parameter(Mandatory=$true,ParameterSetName='Remove')]
		[switch]$Remover,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [string]$Valor,
        [Parameter(Mandatory=$false,ParameterSetName='Remove')]
        [ValidateNotNullorEmpty()]
        [boolean]$Multiplo = $false,
        [Parameter(Mandatory=$false,ParameterSetName='Remove')]
        [ValidateNotNullorEmpty()]
        [boolean]$Parcial = $false
    )

    Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {

        try {
        # Check to see if text file exists
        If (Test-Path -Path $Caminho -PathType Leaf) {
            If ($Adicionar) {
                Write-Log -Text "Adicionando o texto ""$Valor"" to [$Caminho]..." #-Source {$CmdletName}
                # Begin process of adding a line to the end of the file. We're assuming a Windows-formatted file right now
                Add-Content -Path $Caminho -Value "$Valor"
            }
            ElseIf ($Remover) {
                Write-Log -Text "Removendo o texto ""[$Valor]"" from [$Caminho]..." #-Source {$CmdletName}
                # Begin the process of finding and removing a line/lines from the file
                $TempPath = $Caminho + '.temp'
                # Make backup of text file - remove current backup if it exists
                $BackupPath = $Caminho + '.backup'
                If (Test-Path -Path $BackupPath -PathType Leaf) {
                    Remove-File -Path $BackupPath
                }
                Copy-File -Path $Caminho -Destination $BackupPath

                If ($Multiplo -eq $true) {
                    # Remove lines with multiple instances of text from file
                    If ($Parcial -eq $true) {
                        # Remove multiple lines with instances of partial string
                        $Contents = Get-Content $Caminho | Where-Object {$_ -notmatch $Valor}
                        If ($Contents) {
                            Set-Content $TempPath
                        }
                        Else {
                            echo $null >> $TempPath
                        }
                    }
                    ElseIf ($Parcial -eq $false) {
                        # Remove multiple lines with complete string match
                        $Contents = Get-Content $Caminho | Where-Object {$_ -notlike $Valor} 
                        If ($Contents) {
                            Set-Content $TempPath
                        }
                        Else {
                            echo $null >> $TempPath
                        }
                    }
                }
                ElseIf ($Multiplo -eq $false) {
                    # Remove single line from text file
                    If ($Parcial -eq $true) {
                        # Get index of first matching line with partial string match
                        $intLine = (Get-Content $Caminho | Where-Object {$_ -match $Valor} | Select-Object -First 1).ReadCount                            
                    }
                    ElseIf ($Parcial -eq $false) {
                        # Get index of first matching line with complete string match
                        Write-Host 'multiple-false partial-false'
                        $intLine = (Get-Content $Caminho | Where-Object {$_ -like $Valor} | Select-Object -First 1).ReadCount
                    }
                    If ($intLine -gt 0) {
                        Write-Log -Text "Replacing [$Valor] in line [$intLine]"
                        $fileContents = Get-Content $Caminho
                        $fileContents.Item($intLine-1) = "" # modify the array item found above - replace with empty string
                        $fileContents | Set-Content $TempPath
                    }
                    Else {
                        # No matchine line
                        Write-Log -Text "[$Valor] not found in [$Caminho]"
                        
                    }
                }
                # Remove original File and rename Temp file to match
                If (Test-Path -Path $TempPath -PathType Leaf) {
                    Remove-File -Path $Caminho
                    Rename-Item -Path $TempPath -NewName $Caminho
                }
            }
        }
        Else {
            # There is no such file - abort function
            Write-Log -Text "Arquivo [$Caminho] não existente..." # -Source {$CmdletName}
        }
        
        }
        
        Catch {
        	[int32]$returnCode = 70019 # Erro ao tentar alterar um arquivo
			[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar alterar um arquivo"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode
        }
    }
    End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Clear-DadosCacheIE - 12
Function STF_Clear-DadosCacheIE {
<#
.SYNOPSIS
	Limpa os dados em Cache do Internet Explorer

.DESCRIPTION
	Lima diversos dados em cache do Internet Explorer
    - Arquivos temporários
    - Cookies
    - Histórico do navegador
    - Dados de preenchimento de formulários
    - Senhas armazenadas
    - Configurações de addons
    - Todos os dados em cache

.PARAMETER ConfiguracoesAddOns
	Apaga arquivos e parâmetros armazenados por Add-Ons

.PARAMETER Todos
	Apaga todos os dados em cache

.PARAMETER Cookies
	Apaga Cookies

.PARAMETER DadosFormularios
		Apaga dados de formularios

.PARAMETER Historico
	Apaga histórico de navegação

.PARAMETER Senhas
	Apaga senhas armazenadas

.PARAMETER ArquivosTemporarios
	Apaga arquivos temporários do Internet Explorer

.EXAMPLE
	STF_Clear-DadosCacheIE -ArquivosTemporarios
	
.EXAMPLE
	STF_Clear-DadosCacheIE -Cookies

.EXAMPLE
	STF_Clear-DadosCacheIE -Historico

.EXAMPLE
	STF_Clear-DadosCacheIE -DadosFormularios

.EXAMPLE
	STF_Clear-DadosCacheIE -Senhas

.EXAMPLE
	STF_Clear-DadosCacheIE -Todos

.EXAMPLE
	STF_Clear-DadosCacheIE -ConfiguracoesAddOns
			
.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0
    Data de criação/modificação: 23/03/2017
    Fonte: https://gallery.technet.microsoft.com/scriptcenter/Clear-Internet-Explorer-5ee32ff6
        
.LINK
	http://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
		[Parameter(Mandatory = $false,HelpMessage = ' Delete Temporary Internet Files')]
		[switch]$ArquivosTemporarios,
		[Parameter(HelpMessage = 'Delete Cookies')]
		[switch]$Cookies,
		[Parameter(HelpMessage = 'Delete History')]
		[switch]$Historico,
		[Parameter(HelpMessage = 'Delete Form Data')]
		[switch]$DadosFormularios,
		[Parameter(HelpMessage = 'Delete Passwords')]
		[switch]$Senhas,
		[Parameter(HelpMessage = 'Delete All')]
		[switch]$Todos,
		[Parameter(HelpMessage = 'Delete Files and Settings Stored by Add-Ons')]
		[switch]$ConfiguracoesAddOns
    )

    Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {

        try {
           if ($ArquivosTemporarios) { 
               RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 8
               Write-Log -Message "Realizado limpeza nos arquivos temporarios do IE" -Severity 1 -Source ${CmdletName}
            }
	    if ($Cookies) { 
                RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 2
                Write-Log -Message "Realizado limpeza nos cookies do IE" -Severity 1 -Source ${CmdletName}
            }
	    if ($Historico) { 
                RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 1
                Write-Log -Message "Realizado limpeza no historico do IE" -Severity 1 -Source ${CmdletName}
            }
	    if ($DadosFormularios) { 
                RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 16
                Write-Log -Message "Realizado limpeza no form data do IE" -Severity 1 -Source ${CmdletName}
            }
	    if ($Senhas) { 
                RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 32 
                Write-Log -Message "Realizado limpeza de passwords do IE" -Severity 1 -Source ${CmdletName}
            }
	    if ($Todos) { 
                RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 255
                Write-Log -Message "Realizado limpeza de todos os arquivos desnessário do IE" -Severity 1 -Source ${CmdletName}
            }
	    if ($ConfiguracoesAddOns) { 
                RunDll32.exe InetCpl.cpl, ClearMyTracksByProcess 4351 
                Write-Log -Message "Realizado limpeza AddOnSettings do IE" -Severity 1 -Source ${CmdletName}
            }            
        }
        
        Catch {
        	[int32]$returnCode = 70020 # Erro ao tentar limpar arquivos desnecessário o Internet Explorer
			[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar limpar arquivos desnecessário o Internet Explorer"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode
        }
    }
    End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Test-CredencialUsuario - 13
Function STF_Test-CredencialUsuario {
<# 
.SYNOPSIS
    Testa a combinação de nome de usuário e senha de domínio está correta
.DESCRIPTION
    Este script verificará se a senha de um determinado nome de usuário está correta. Se a autenticação falhou usando o REDE\Nome de usuário e Senha fornecidos.
    O script fará algumas verificações e fornecerá algumas pistas sobre a falha na autenticação.
    Realiza as verificações:
        * O domínio é acessível.
        * Nome de usuário existe no domínio.
        * A conta está habilitada.
        * A conta está desbloqueada. 
    Esta funçao retorna os codigos de error citado no item 3 deste documento e “true” se a verificação estiver correta
.EXAMPLE
    STF_Test-CredencialUsuario
.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0 .
    Data de criação/modificação: 
    Fonte: https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Test-Domain-b71cc520
.LINK
	http://psappdeploytoolkit.com
 #> 
    [CmdletBinding()]
    Param (

    )

    Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {

        try {
            # Importa modulos do Active Directory 
            Import-Module Activedirectory

            # Limpa as variaveis usadas
            $Cred = $Null
            $DomainNetBIOS = $Null
            $UserName  = $Null
            $Password = $Null
            $msgRedeUsuario = "Por favor, insira seu nome de usuário conforme exemplo. `n`nEx:.. REDE\usuario `n`nTENTE NOVAMENTE"
            $msgDominioNaoEncontrado = "Erro: O domínio não foi encontrado: "
            $msgVerNetbios = "Certifique-se de que o nome NetBios do domínio esteja correto e seja acessível a partir deste computador"
            $msgHabilitarConta = "Habilite a conta de usuário no Active Directory, depois verifique novamente"
            $msgDesbloqueieConta = "Desbloqueie a Conta de Usuário no Active Directory, depois verifique novamente..."
            $erroFatal = "Erro fatal no pacote solicite a equipe de microinformatica para verificar"

    
            # Abre promt de login e senha amigável
            $MensagemCredencial = "Digite suas credenciais ADMINISTRATIVAS
    Ex.: REDE\usuario_A

Apenas para `"TÉCNICOS DA STI`""

            $Cred = Get-Credential -Message $MensagemCredencial
            if ($Cred -eq $Null)
            {
                Show-DialogBox -Title $msgRedeUsuario -Icon 'Information'
                [int32]$returnCode = 70021 
                [string]$extensionErrorMessage = "Error Code [$returnCode] - $msgRedeUsuario"
                Write-Log -Message $extensionErrorMessage -Severity 2 -Source ${CmdletName}
                Exit-Script	-ExitCode $returnCode
            }

            # Credenciais do usuário 
            $DomainNetBIOS = $Cred.username.Split("{\}")[0]
            $UserName = $Cred.username.Split("{\}")[1]
            $Password = $Cred.GetNetworkCredential().password

            Write-Log -Message "******************************************************************************" -Severity 1 -Source ${CmdletName}
            Write-Log -Message "Verificando Credenciais para $DomainNetBIOS\$UserName"  -Severity 1 -Source ${CmdletName}
            Write-Log -Message "******************************************************************************" -Severity 1 -Source ${CmdletName}


    
            If ($DomainNetBIOS -eq $Null -or $UserName -eq $Null ) 
            {

                Show-DialogBox -Title "Informação" -Text $msgRedeUsuario -Icon 'Information'
                [int32]$returnCode = 70021  
                [string]$extensionErrorMessage = "Error Code [$returnCode] - $msgRedeUsuario"
                Write-Log -Message $extensionErrorMessage -Severity 2 -Source ${CmdletName}
                Exit-Script	-ExitCode $returnCode
            }

            # Verifica se o domínio em questão é acessível e obtém o domínio FQDN. 
            Try
            {
                $DomainFQDN = (Get-ADDomain $DomainNetBIOS).DNSRoot
            }
            Catch
            {
                [int32]$returnCode = 70022  
                [string]$extensionErrorMessage = "Error Code [$returnCode] - $msgDominioNaoEncontrado e $msgVerNetbios"
                Write-Log -Message $msgDominioNaoEncontrado " " $_.Exception.Message -Severity 3 -Source ${CmdletName}
                Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
                Exit-Script	-ExitCode $returnCode
            }
    
            # Verifica as credenciais do usuário no domínio  
            $DomainObj = "LDAP://" + $DomainFQDN
            $DomainBind = New-Object System.DirectoryServices.DirectoryEntry($DomainObj,$UserName,$Password)
            $DomainName = $DomainBind.distinguishedName
    
            If ($DomainName -eq $Null)
            {
                Write-Log -Message "O domínio $DomainFQDN foi encontrado: True" -Severity 1 -Source ${CmdletName}
                
                $UserExist = Get-ADUser -Server $DomainFQDN -Properties LockedOut -Filter {sAMAccountName -eq $UserName}
                If ($UserExist -eq $Null) 
                {
                    [int32]$returnCode = 70023
                    [string]$extensionErrorMessage = "Error Code [$returnCode] - Nome de usuário $Username não existe no domínio $DomainFQDN."
                    Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
                    Exit-Script	-ExitCode $returnCode
                }
                Else 
                {   
                     Write-Log -Message "O usuário existe no domínio: True" -Severity 1 -Source ${CmdletName}
             
                     If ($UserExist.Enabled -eq "True")
                     {
                         Write-Log -Message "Usuário habilidado: "$UserExist.Enabled -Severity 1 -Source ${CmdletName}
                     }
                     Else
                     {
                         Show-DialogBox -Title "Informação" -Text $msgHabilitarConta -Icon 'Information'
                         [int32]$returnCode = 70024
                         Write-Log -Message "Usuário habilitado: "$UserExist.Enabled -Severity 1 -Source ${CmdletName}
                         Exit-Script -ExitCode $returnCode
                     }
                     If ($UserExist.LockedOut -eq "True")
                     {
                         Show-DialogBox -Title "Informação" -Text $msgDesbloqueieConta -Icon 'Information'
                         [int32]$returnCode = 70025
                         Write-Log -Message "Usuário bloqueado: "$UserExist.LockedOut -Severity 3 -Source ${CmdletName}
                         Exit-Script -ExitCode $returnCode
                     }
                     Else
                     {
                         Write-Log -Message "Usuário bloqueado: " $UserExist.LockedOut -Severity 3 -Source ${CmdletName}
                     }
                 }
    
                 Show-DialogBox -Title "Informação" -Text "A autenticação falhou para $DomainNetBIOS\$UserName com a senha fornecida. `n`nConfirme a senha e tente novamente ..." -Icon 'Information'
                 [int32]$returnCode = 70026
                 Write-Log -Message "Usuário bloqueado: "$UserExist.LockedOut -Severity 3 -Source ${CmdletName}
                 Exit-Script -ExitCode $returnCode
            }
     
            Else
            {
                #Show-DialogBox -Title "Informação" -Text "SUCCESS: A conta $Username autenticado com sucesso no domínio: $DomainFQDN" -Icon Information
                Write-Log -Message "SUCCESS: A conta $Username autenticado com sucesso contra o domínio: $DomainFQDN" -Severity 1 -Source ${CmdletName}
                Return $true
                #Exit-Script
            }

        }
        
        Catch {
        	[int32]$returnCode = 70027 # Erro fatal no pacote solicite a equipe de microinformatica para verificar
			[string]$extensionErrorMessage = "Error Code [$returnCode] - $erroFatal"
			Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
			Exit-Script -ExitCode $returnCode
        }
    }
    End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Add-UsuarioLocal - 14
Function STF_Add-UsuarioLocal() {
<#
.SYNOPSIS
	Cria usuário local no windows.
.DESCRIPTION
	Cria um novo usuário local no computador. 
    A senha do usuário é setada para nunca expirar.
    Caso o usuário já exista será retornado o erro 70028
.PARAMETER Usuario
	Nome do usuário a ser criado.
.PARAMETER Senha
	Senha do usuário a ser criado.
.PARAMETER Adm
	Definie se o usuário será adminstrador local ou não.
    Os valores pode ser:
    0: Usuári comum, sem acesso administrativo
    1: Usuário admininstrador local do computador.
.EXAMPLE
    STF_Add-UsuarioLocal -Usuario "Executador" -Senha "senha@STF" -Adm 1
.EXAMPLE
    STF_Add-UsuarioLocal -Usuario "Executador" -Senha "senha@STF" -Adm 0
.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0
    Data de criação/modificação: 
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding()] 
	
	Param (
		[Parameter(Mandatory=$True,Position=0)] 
		[String[]]$Usuario,
		[Parameter(Mandatory=$true,Position=1)]
		[String[]]$Senha,
		[Parameter(Mandatory=$true,Position=2)]
		[Int32[]]$Adm
	)
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
	Try {
        $Account = [ADSI]"WinNT://localhost/$Usuario,user"
        if (!($Account.Name))
        {
		    $objOu = [ADSI]"WinNT://localhost"
            $objUser = $objOU.Create("User", "$Usuario")
            $objUser.setpassword("$Senha")
            $objUser.SetInfo()
            $objUser.PasswordExpired = 0
            $objUser.SetInfo()
            $objUser.UserFlags.value = $objUser.UserFlags.value -bor 0x10000
            $objUser.SetInfo()
        
            if ($Adm -eq 1) {
                $group = [ADSI]"WinNT://localhost/Administradores,group"
                $group.Add("WinNT://$Usuario,user")
                Return 0
            }
            Return 0
        } else {
      		[int32]$returnCode = 70028 # O Usuário local: $Usuario, existe na máquina de nome: $env:COMPUTERNAME.
    		[string]$extensionErrorMessage = "Error Code [$returnCode] - O Usuário local: $Usuario, existe na máquina de nome: $env:COMPUTERNAME."
		    Write-Log -Message $extensionErrorMessage -Severity 2 -Source ${CmdletName}
            Return $returnCode
        }

	}
	Catch {
		[int32]$returnCode = 70029 # Erro ao tentar adicionar novo usuário local"
		[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar adicionar novo usuário local"
		Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
		Exit-Script -ExitCode $returnCode
	    }
	}
	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Remove-UsuarioLocal - 15
Function STF_Remove-UsuarioLocal() {
<#
.SYNOPSIS
    Remove um usuáiro local do computador.
.DESCRIPTION
    Remove um usuário local do computador caso ele exista
    A função retorna o valor 0 qunado a remoção acontece com sucesso.
    Caso o usuário local NÃO exista no computador, será retornado o erro 70028
.PARAMETER Usuario
	Nome do usuário a ser excluido.
.EXAMPLE
    STF_Remove-UsuarioLocal -Usuario "Executador"
.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0
    Data de criação/modificação: 
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding()] 
	
	Param (
		[Parameter(Mandatory=$True,Position=0)] 
		[String[]]$Usuario
	)
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
	Try {
        $Account = [ADSI]"WinNT://localhost/$Usuario,user"
        if ($Account.Name)
        {
            [ADSI]$server = "WinNT://localhost"
            $server.delete("user","$Usuario")
            Return 0
        } else {
      		[int32]$returnCode = 70030 # O Usuário local: $Usuario, NÂO existe na máquina de nome: $env:COMPUTERNAME."
    		[string]$extensionErrorMessage = "Error Code [$returnCode] - O Usuário local: $Usuario, NÂO existe na máquina de nome: $env:COMPUTERNAME."
		    Write-Log -Message $extensionErrorMessage -Severity 2 -Source ${CmdletName}
            Return $returnCode
        }


	}
	Catch {
		[int32]$returnCode = 70031 # Erro ao tentar remover novo usuário local"
		[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar remover novo usuário local"
		Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
		Exit-Script -ExitCode $returnCode
	    }
	}
	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Get-UsuarioLocal - 16
Function STF_Get-UsuarioLocal() {
<#
.SYNOPSIS
    Esta função lista os usuários locais de um computador.
.DESCRIPTION
    Esta função pesquisa num computador pelos usuários locais, 
    podendo pesquisar determinados usuários ou obter a lista completa de usuários locais do computador.
.PARAMETER UsuarioLocal
    Conta(s) de usuário(s) a ser(em) pesquisados.
    Pode-se especificar multiplos usuários separando os usuários por vírgula
.PARAMETER	Computador
    Computadores nos quais o comando é executado. O padrão é o computador local.
.PARAMETER  Credencial
    Especifica uma conta de usuário que tenha permissão para executar esta ação. 
.EXAMPLE
    STF_Get-UsuarioLocal

    Este exemplo mostra como listar todos os usuários locais no computador local.	
.EXAMPLE
    STF_Get-UsuarioLocal | Export-Csv -Path "D:\LocalUserAccountInfo.csv" -NoTypeInformation

    Este exemplo exportará o relatório para o arquivo csv. Se você anexar o parâmetro <NoTypeInformation> com o comando, ele omitirá as informações de tipo
Do arquivo CSV. Por padrão, a primeira linha do arquivo CSV contém "#TYPE" seguido do nome totalmente qualificado do tipo de objeto.
.EXAMPLE
    STF_Get-UsuarioLocal -UsuarioLocal "Administrator","Guest"

    Este exemplo mostra como listar as informações da conta local do Administrador e do Convidado no computador local.
.EXAMPLE
    STF_Get-UsuarioLocal -Credencial $(Get-Credential) -Computador "ETU012345" 

    Este exemplo lista todas as contas de usuários locais no computador remoto ETU012345.
.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0
    Data de criação/modificação: 
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding()] 
	
	Param (
	    [Parameter(Position=0,Mandatory=$false)]
	    [ValidateNotNullorEmpty()]
	    [String[]]$Computador=$Env:COMPUTERNAME,
	    [Parameter(Position=1,Mandatory=$false)]
	    [String[]]$UsuarioLocal,
	    [Parameter(Position=2,Mandatory=$false)]
	    [System.Management.Automation.PsCredential]$Credencial
	)
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
	Try {	
        $Obj = @()
        Foreach($Computer in $Computador)
        {
	        If($Credencial)
	        {
		        $AllLocalAccounts = Get-WmiObject -Class Win32_UserAccount -Namespace "root\cimv2" `
		        -Filter "LocalAccount='$True'" -ComputerName $Computer -Credential $Credential -ErrorAction Stop
	        }
	        else
	        {
		        $AllLocalAccounts = Get-WmiObject -Class Win32_UserAccount -Namespace "root\cimv2" `
		        -Filter "LocalAccount='$True'" -ComputerName $Computer -ErrorAction Stop
	        }
	
	        Foreach($LocalAccount in $AllLocalAccounts)
	        {
		        $Object = New-Object -TypeName PSObject
		
		        $Object|Add-Member -MemberType NoteProperty -Name "Name" -Value $LocalAccount.Name
		        $Object|Add-Member -MemberType NoteProperty -Name "Full Name" -Value $LocalAccount.FullName
		        $Object|Add-Member -MemberType NoteProperty -Name "Caption" -Value $LocalAccount.Caption
      	        $Object|Add-Member -MemberType NoteProperty -Name "Disabled" -Value $LocalAccount.Disabled
      	        $Object|Add-Member -MemberType NoteProperty -Name "Status" -Value $LocalAccount.Status
      	        $Object|Add-Member -MemberType NoteProperty -Name "LockOut" -Value $LocalAccount.LockOut
		        $Object|Add-Member -MemberType NoteProperty -Name "Password Changeable" -Value $LocalAccount.PasswordChangeable
		        $Object|Add-Member -MemberType NoteProperty -Name "Password Expires" -Value $LocalAccount.PasswordExpires
		        $Object|Add-Member -MemberType NoteProperty -Name "Password Required" -Value $LocalAccount.PasswordRequired
		        $Object|Add-Member -MemberType NoteProperty -Name "SID" -Value $LocalAccount.SID
		        $Object|Add-Member -MemberType NoteProperty -Name "SID Type" -Value $LocalAccount.SIDType
		        $Object|Add-Member -MemberType NoteProperty -Name "Account Type" -Value $LocalAccount.AccountType
		        $Object|Add-Member -MemberType NoteProperty -Name "Domain" -Value $LocalAccount.Domain
		        $Object|Add-Member -MemberType NoteProperty -Name "Description" -Value $LocalAccount.Description
		
		        $Obj+=$Object
	        }
	
	        If($UsuarioLocal)
	        {
		        Foreach($Account in $UsuarioLocal)
		        {
			        $Obj|Where-Object{$_.Name -like "$Account"}
		        }
	        }
	        else
	        {
		        $Obj
	        }
        }

	}
	Catch {
		[int32]$returnCode = 70032 # Erro ao tentar recuperar usuario"
		[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar recuperar usuário"
		Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
		Exit-Script -ExitCode $returnCode
	    }
	}
	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Execute-Runas - 17
Function STF_Execute-Runas() {
<#
.SYNOPSIS
    A função lê e armazena a senha de uma credencial de usuário em um arquivo de segurança criptografado

.DESCRIPTION
    A função lê e armazena a senha de uma credencial de usuário em um arquivo de segurança criptografado
    através dos parâmetros SET e GET.
    Quando o parâmetro SET é setado, a função solicita a credencial e armazena a senha em um arquivo especificado. 
    Quando o parâmetro GET é setado, a função lê a senha do arquivo de segurança especificado na variável $filename, 
    e usa o nome de usuário especificado na variável $username. 
    O armazenamento de senha em um arquivo criptografado permite que sejm executados comandos, processos ou aplicações
    utilizando outra credencial sem que o usuário tenha que digitar a senha ou mesmo conhecer a senha.

    Descrição dos codigo de retorno: 
        return 10 = "Parâmetros obrigatório Get ou SET"
        return 20 = "Não é possível inserir dois parâmentos: GET e SET"
        return 30 = "Não foi especificado o usuário. Por favor, especifique!"
 
.PARAMETER Get
    Parâmetro para ler a senha a partir de um arquivo

.PARAMETER Set
    Parâmetro para criar o arquivo de segurança criptografado com a senha do usuário

.PARAMETER Usuario
    O nome de usuário deve ser escrito em arquivo ou para ser usado com a senha extraída do arquivo.

.PARAMETER Arquivo
    Parâmetro opcional, se não informado, será criado por padrão o arquivo $Usuario.txt (sem os backspaces)

.EXAMPLE
    STF_Execute-Runas -Set -Usuario "rede\srv_remoterestart" -Arquivo "C:\Temp\file.pwd"

    Descrição
    -----------
    Este comando solicita a senha para o usuário "rede\srv_remoterestart" e salva a senha no arquivo "C:\Temp\file.pwd"

.EXAMPLE
    STF_Execute-Runas -Get -Usuario "rede\srv_remoterestart" -Arquivo "\\arquivos\bds\estacoes\scripts\password\file.pwd"

    Descrição
    -----------
    Este comando receberá a senha do arquivo.pwd no servidor de arquivos e usará isso em combinação com rede\svc_remoterestart
    Para retornar a variável $credentials que pode ser usada diretamente em outro script. Veja o próximo exemplo sobre como você pode usar
    Este script dentro de outro script.

.EXAMPLE
    Start-Process -FilePath "$envSystem32Directory\cmd.exe" -Credential (STF_Execute-Runas -Get -Usuario "$envComputerName\Executador" -Arquivo "c:\temp\executador.pwd")

    Descrição
    -----------
    Este terceiro exemplo quando você executa o comando como uma função dentro do seu script. Como o nome do arquivo foi omitido, o script será
    Procure e procure um nome de arquivo padrão neste caso .\rede_srv_remoterestart.pwd. Além disso, as funções são as mesmas que as
    Dois exemplos anteriores e permite que você use diretamente as credenciais para executar um aplicativo como uma identidade diferente.

.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0
    Data de criação/modificação: 17/07/2017
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding()] 
	
	Param (
		[Parameter(Mandatory=$false,Position=0)] 
		[string]$Usuario,

		[Parameter(Mandatory=$false,Position=1)] 
		[string]$Arquivo,

		[Parameter(Mandatory=$false,Position=2)] 
		[switch]$get,

		[Parameter(Mandatory=$false,Position=3)] 
		[switch]$set
	)
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
	Try {

        # Verifica se os paramentos foram inseridos corretamente, para que esse script seja executado, do contrário retorna o valor
	    if (!($get) -and !($set)) {
            Write-Log -Message "Parâmetros obrigatório GET ou SET" -Severity 3 -Source ${CmdletName}
            return 10
        }
	
        if (($get) -and ($set)) {
            Write-Log -Message "Não e possível inserir dois parâmetros: GET e SET" -Severity 3 -Source ${CmdletName}
            return 20
        }
	
        if (!($Usuario)) {
            Write-Log -Message "Não foi especificado o usuário. Por favor, especifique!" -Severity 3 -Source ${CmdletName}
            return 30
        }
	
        if (!($Arquivo)) {
            $Arquivo = ($Usuario -replace "\\", "_")+".pwd"
        }
	
        # Executa o GET do script, a função retorna o valor $$ se o nome do arquivo não for encontrado. Produz $credenciais que podem ser usadas
        # Em combinação com -credential
	    if ($get)
	    {
		    if (!(test-path $Arquivo)) {write-output "Arquivo $Arquivo não encontrado, saindo do script...";return}
		    $password = Get-Content $Arquivo | ConvertTo-SecureString 
		    $credential = New-Object System.Management.Automation.PsCredential($Usuario,$password)
		    $credential
		    return
	    }

        # Executa a seqüência SET do script onde a senha de caracteres vai ser escrita em um arquivo
        # A preferência Erroraction está configurada para suprimir erros quando o usuário fecha a entrada de credenciais
	    if ($set)
	    {
		    $erroractionpreference = 0
		    $credential = Get-Credential -Credential $Usuario 
		    $credential.Password | ConvertFrom-SecureString | Set-Content $Arquivo
		    return
	    }

	}
	Catch {
		[int32]$returnCode = 70033 # Erro ao tentar utilizar credenciais do usuário: $Usuario"
		[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar utilizar credenciais do usuário: $Usuario."
		Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
		Exit-Script -ExitCode $returnCode
	    }
	}
	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion

#region Function STF_Get-ArquivosAbertos - 18
Function STF_Get-ArquivosAbertos() {
<#
.SYNOPSIS
    Lista pastas e arquivos abertos no compartilhamento de uma máquina especifica 
.DESCRIPTION
    Lista pastas e arquivos abertos no compartilhamento de uma máquina especifica, que foi passado como paramento da função ao chama-lá.
.PARAMETER Computador
    Computador(es) em que serão verificados arquivos abertos.
    Para mais de um computador, separar os computadores com vírgula ","
.EXAMPLE
    STF_Get-ArquivosAbertos -Computador "ETU012345"
.EXAMPLE
    STF_Get-ArquivosAbertos -Computador "ETU012345,NOT000011,ETI999999,TER-PTO-XPTO-01"
.NOTES
    Criado por: João Wanderson Fernandes Santos
    Versão: 1.0
    Data de criação/modificação: 19/09/2017
    Fonte: 
.LINK
	http://psappdeploytoolkit.com
#>
	[Cmdletbinding()] 
	
	Param (
		[Parameter(Mandatory=$true,Position=0)] 
		[string]$Computador
	)
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
	Try {
        
        $collection = @()
        foreach ($computer in $Computador){
            $netfile = [ADSI]"WinNT://$computer/LanmanServer"

            $netfile.Invoke("Resources") | foreach {
                try{
                    $collection += New-Object PsObject -Property @{
                    Id = $_.GetType().InvokeMember("Name", ‘GetProperty’, $null, $_, $null)
                    itemPath = $_.GetType().InvokeMember("Path", ‘GetProperty’, $null, $_, $null)
                    UserName = $_.GetType().InvokeMember("User", ‘GetProperty’, $null, $_, $null)
                    LockCount = $_.GetType().InvokeMember("LockCount", ‘GetProperty’, $null, $_, $null)
                    Server = $computer}
                }
                catch{
                    if ($verbose){
                        write-warning $error[0]
                    }
                }
            }
        }
        Return $collection



	}
	Catch {
		[int32]$returnCode = 70033 # Erro ao tentar listar arquivos e pastas em um compartilhamento"
		[string]$extensionErrorMessage = "Error Code [$returnCode] - Erro ao tentar listar arquivos e pastas em um compartilhamento da maquina: $Computador."
		Write-Log -Message $extensionErrorMessage -Severity 3 -Source ${CmdletName}
		Exit-Script -ExitCode $returnCode
	    }
	}
	
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion


# Exemplo da estrutura que uma função dever ter
## Microsoft Function Naming Convention: http://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx
#region Function MODELO-DE-FUNCAO - xx
Function STF_VERBO-SUBSTANTIVO {
<#
.SYNOPSIS
A brief description of the function or script. This keyword can be used only once in each topic.

.DESCRIPTION
A detailed description of the function or script. This keyword can be used only once in each topic.

.PARAMETER
The description of a parameter. Add a ".PARAMETER" keyword for each parameter in the function or script syntax.
Type the parameter name on the same line as the ".PARAMETER" keyword. Type the parameter description on the lines following the ".PARAMETER" keyword. Windows PowerShell interprets all text between the ".PARAMETER" line and the next keyword or the end of the comment block as part of the parameter description. The description can include paragraph breaks.

.PARAMETER  <Parameter-Name>
The Parameter keywords can appear in any order in the comment block, but the function or script syntax determines the order in which the parameters (and their descriptions) appear in help topic. To change the order, change the syntax.
You can also specify a parameter description by placing a comment in the function or script syntax immediately before the parameter variable name. If you use both a syntax comment and a Parameter keyword, the description associated with the Parameter keyword is used, and the syntax comment is ignored.

.EXAMPLE
A sample command that uses the function or script, optionally followed by sample output and a description. Repeat this keyword for each example.

.INPUTS
The Microsoft .NET Framework types of objects that can be piped to the function or script. You can also include a description of the input objects.

.OUTPUTS
The .NET Framework type of the objects that the cmdlet returns. You can also include a description of the returned objects.

.NOTES
Additional information about the function or script.

.LINK
The name of a related topic. The value appears on the line below the ".LINK" keyword and must be preceded by a comment symbol # or included in the comment block.
Repeat the ".LINK" keyword for each related topic.
The "Link" keyword content can also include a Uniform Resource Identifier (URI) to an online version of the same help topic. The online version opens when you use the Online parameter of Get-Help. The URI must begin with "http" or "https".

.COMPONENT
The technology or feature that the function or script uses, or to which it is related. This content appears when the Get-Help command includes the Component parameter of Get-Help.

.ROLE
The user role for the help topic. This content appears when the Get-Help command includes the Role parameter of Get-Help.

.FUNCTIONALITY
The intended use of the function. This content appears when the Get-Help command includes the Functionality parameter of Get-Help.

#>
	[CmdletBinding()]
	Param (
	)
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
	}
	Process {
		Try {
			
		}
		Catch {
			Write-Log -Message "<error message>. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
		}
	}
	End {
		Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
	}
}
#endregion


# PROXIMAS FUNÇÕES A SEREM CRIADAS.

# Permissão no Registry
# https://support.microsoft.com/en-us/kb/245031
# https://support.microsoft.com/en-us/kb/264584
#http://www.askvg.com/windows-tip-take-ownership-permission-of-registry-keys-from-command-line/

#Descompacta arquivo ZIP
#http://www.howtogeek.com/tips/how-to-extract-zip-files-using-powershell/

# replaces strings in files using a regular expression
#http://psappdeploytoolkit.com/forums/topic/replace-filestring-extension/

# Roda comando como TrustedInstaller (ver pacote do BRS 7.0 v2)
# https://github.com/jschicht/RunAsTI 

##*===============================================
##* END FUNCTION LISTINGS
##*===============================================

##*===============================================
##* SCRIPT BODY
##*===============================================

If ($scriptParentPath) {
    Write-Log -Message "Script [$($MyInvocation.MyCommand.Definition)] dot-source invoked by [$(((Get-Variable -Name MyInvocation).Value).ScriptName)]" -Source $appDeployToolkitExtName
}
Else {
    Write-Log -Message "Script [$($MyInvocation.MyCommand.Definition)] invoked directly" -Source $appDeployToolkitExtName
}

##*===============================================
##* END SCRIPT BODY
##*===============================================
