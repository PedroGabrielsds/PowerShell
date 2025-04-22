<#

.SYNOPSIS
PSAppDeployToolkit.Extensions - Provides the ability to extend and customize the toolkit by adding your own functions that can be re-used.

.DESCRIPTION
This module is a template that allows you to extend the toolkit with your own custom functions.

This module is imported by the Invoke-AppDeployToolkit.ps1 script which is used when installing or uninstalling an application.

PSAppDeployToolkit is licensed under the GNU LGPLv3 License - (C) 2025 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham, Muhammad Mashwani, Mitch Richters, Dan Gough).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details. You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

.LINK
https://psappdeploytoolkit.com

#>

##*===============================================
##* MARK: MODULE GLOBAL SETUP
##*===============================================

# Set strict error handling across entire module.
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
$ProgressPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue
Set-StrictMode -Version 1


##*===============================================
##* MARK: FUNCTION LISTINGS
##*===============================================

function New-ADTExampleFunction
{
    <#
    .SYNOPSIS
        Basis for a new PSAppDeployToolkit extension function.

    .DESCRIPTION
        This function serves as the basis for a new PSAppDeployToolkit extension function.

    .INPUTS
        None

        You cannot pipe objects to this function.

    .OUTPUTS
        None

        This function does not return any output.

    .EXAMPLE
        New-ADTExampleFunction

        Invokes the New-ADTExampleFunction function and returns any output.
    #>

    [CmdletBinding()]
    param
    (
    )

    begin
    {
        # Initialize function.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            try
            {
            }
            catch
            {
                # Re-writing the ErrorRecord with Write-Error ensures the correct PositionMessage is used.
                Write-Error -ErrorRecord $_
            }
        }
        catch
        {
            # Process the caught error, log it and throw depending on the specified ErrorAction.
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        # Finalize function.
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}

function Add-STFPathEnvironmentVariable
{
    <#
    .SYNOPSIS
        Adiciona um caminho à variável de ambiente PATH do sistema.

    .DESCRIPTION
        Esta função adiciona um diretório especificado à variável de ambiente PATH do sistema,
        garantindo que o caminho não seja duplicado.

    .PARAMETER Path
        O caminho do diretório que será adicionado à variável de ambiente PATH.

    .EXAMPLE
        Add-STFPathEnvironmentVariable -Path "C:\Windows\System32"

        Adiciona "C:\Windows\System32" à variável de ambiente PATH do sistema, se ainda não estiver presente.
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    begin
    {
        # Inicializa a função.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            # Obtém o valor atual da variável PATH do sistema
            $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")

            # Verifica se o caminho já está presente
            if ($currentPath -split ";" -notcontains $Path)
            {
                if ($PSCmdlet.ShouldProcess("Adicionar $Path à variável PATH do sistema"))
                {
                    # Adiciona o novo caminho
                    $newPath = "$currentPath;$Path"

                    # Define a variável de ambiente PATH no sistema
                    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

                    Write-ADTLogEntry -Message "O caminho '$Path' foi adicionado à variável PATH do sistema." -Severity 0
                }
            }
            else
            {
                Write-ADTLogEntry -Message "O caminho '$Path' já está presente na variável PATH do sistema." -Severity 2
            }
        }
        catch
        {
            # Processa o erro e o registra
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        # Finaliza a função.
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}

function Remove-STFPathEnvironmentVariable
{
    <#
    .SYNOPSIS
        Remove um caminho exato da variável de ambiente PATH do sistema.

    .DESCRIPTION
        Esta função remove um diretório específico da variável de ambiente PATH do sistema,
        garantindo que apenas a correspondência exata seja excluída.

    .PARAMETER Path
        O caminho do diretório que será removido da variável de ambiente PATH.

    .EXAMPLE
        Remove-STFPathEnvironmentVariable -Path "C:\Windows"

        Remove apenas "C:\Windows" da variável PATH do sistema, sem afetar outros caminhos como "C:\Windows\System32".
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    begin
    {
        # Inicializa a função.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            # Obtém o valor atual da variável PATH do sistema
            $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine") -split ";"

            # Verifica se o caminho está presente
            if ($currentPath -contains $Path)
            {
                if ($PSCmdlet.ShouldProcess("Remover $Path da variável PATH do sistema"))
                {
                    # Remove apenas o caminho exato
                    $newPath = ($currentPath | Where-Object { $_ -ne $Path }) -join ";"

                    # Define a variável de ambiente PATH no sistema
                    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

                    Write-ADTLogEntry -Message "O caminho '$Path' foi removido da variável PATH do sistema." -Severity 0
                }
            }
            else
            {
                Write-ADTLogEntry -Message "O caminho '$Path' não foi encontrado na variável PATH do sistema." -Severity 2
            }
        }
        catch
        {
            # Processa o erro e o registra
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        # Finaliza a função.
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}

function Add-STFEnvironmentVariable
{
    <#
    .SYNOPSIS
        Adiciona ou cria uma nova variável de ambiente.

    .DESCRIPTION
        Esta função cria ou atualiza uma variável de ambiente, permitindo definir seu nome, valor e escopo (Usuário, Máquina ou Processo).

    .PARAMETER Nome
        O nome da variável de ambiente.

    .PARAMETER Valor
        O valor da variável de ambiente.

    .PARAMETER Tipo
        O tipo da variável de ambiente: "User", "Machine" ou "Process".
        - User: Variável disponível apenas para o usuário atual.
        - Machine: Variável disponível para todos os usuários do computador.
        - Process: Variável disponível apenas para o processo atual.

    .EXAMPLE
        Add-STFEnvironmentVariable -Nome "MinhaVariavel" -Valor "C:\MeusDados" -Tipo "User"

        Cria ou atualiza a variável de ambiente "MinhaVariavel" no escopo do usuário.

    .EXAMPLE
        Add-STFEnvironmentVariable -Nome "MinhaVariavelGlobal" -Valor "C:\GlobalData" -Tipo "Machine"

        Cria ou atualiza a variável de ambiente "MinhaVariavelGlobal" para todos os usuários do computador.
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Nome,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Valor,

        [Parameter(Mandatory = $true)]
        [ValidateSet("User", "Machine", "Process")]
        [string]$Tipo
    )

    begin
    {
        # Inicializa a função.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            if ($PSCmdlet.ShouldProcess("Criar ou atualizar a variável de ambiente '$Nome' no escopo '$Tipo' com o valor '$Valor'"))
            {
                # Define a variável de ambiente conforme o tipo especificado
                [System.Environment]::SetEnvironmentVariable($Nome, $Valor, $Tipo)

                Write-ADTLogEntry -Message "A variável de ambiente '$Nome' foi adicionada/atualizada com sucesso no escopo '$Tipo'." -Severity 0
            }
        }
        catch
        {
            # Processa o erro e o registra
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        # Finaliza a função.
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}

function Remove-STFEnvironmentVariable
{
    <#
    .SYNOPSIS
        Remove uma variável de ambiente.

    .DESCRIPTION
        Esta função remove uma variável de ambiente existente, permitindo especificar seu nome e escopo (Usuário, Máquina ou Processo).

    .PARAMETER Nome
        O nome da variável de ambiente a ser removida.

    .PARAMETER Tipo
        O tipo da variável de ambiente: "User", "Machine" ou "Process".
        - User: Variável disponível apenas para o usuário atual.
        - Machine: Variável disponível para todos os usuários do computador.
        - Process: Variável disponível apenas para o processo atual.

    .EXAMPLE
        Remove-STFEnvironmentVariable -Nome "MinhaVariavel" -Tipo "User"

        Remove a variável de ambiente "MinhaVariavel" no escopo do usuário.

    .EXAMPLE
        Remove-STFEnvironmentVariable -Nome "MinhaVariavelGlobal" -Tipo "Machine"

        Remove a variável de ambiente "MinhaVariavelGlobal" para todos os usuários do computador.
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Nome,

        [Parameter(Mandatory = $true)]
        [ValidateSet("User", "Machine", "Process")]
        [string]$Tipo
    )

    begin
    {
        # Inicializa a função.
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            # Obtém o valor atual da variável para verificar se existe
            $currentValue = [System.Environment]::GetEnvironmentVariable($Nome, $Tipo)

            if ($currentValue -ne $null)
            {
                if ($PSCmdlet.ShouldProcess("Remover a variável de ambiente '$Nome' do escopo '$Tipo'"))
                {
                    # Remove a variável de ambiente
                    [System.Environment]::SetEnvironmentVariable($Nome, $null, $Tipo)

                    Write-ADTLogEntry -Message "A variável de ambiente '$Nome' foi removida com sucesso do escopo '$Tipo'." -Severity 0
                }
            }
            else
            {
                Write-ADTLogEntry -Message "A variável de ambiente '$Nome' não foi encontrada no escopo '$Tipo'." -severity 2
            }
        }
        catch
        {
            # Processa o erro e o registra
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        # Finaliza a função.
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}

##*===============================================
##* MARK: SCRIPT BODY
##*===============================================

# Announce successful importation of module.
Write-ADTLogEntry -Message "Module [$($MyInvocation.MyCommand.ScriptBlock.Module.Name)] imported successfully." -ScriptSection Initialization
