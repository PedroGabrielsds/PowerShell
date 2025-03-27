#-----DOT SOURCING-----

#O "Dot Sourcing" é um recurso no PowerShell que permite carregar um script externo no escopo atual de execução, o que significa que você pode acessar as funções, variáveis e outros elementos definidos nesse script diretamente no seu script principal.

#Vamos ver os detalhes de como isso funciona e por que é útil.

#O que é Dot Sourcing?
#Dot Sourcing é basicamente um comando que permite que o conteúdo de um script seja executado no escopo atual. Ao contrário de simplesmente executar um script como um processo separado, o Dot Sourcing importa as variáveis, funções e outros elementos definidos dentro do script para o escopo do script que está chamando.

#Quando você faz o Dot Sourcing, o PowerShell não inicia uma nova execução do script em um escopo separado; em vez disso, ele carrega todo o conteúdo do script diretamente no escopo atual, permitindo que você utilize funções e variáveis como se elas tivessem sido definidas no próprio script principal.

#Sintaxe do Dot Sourcing
#A sintaxe do Dot Sourcing é bem simples: você utiliza um ponto (.) seguido de um espaço e, em seguida, o caminho para o script que você deseja carregar.

Function Hello_Word {

    Write-Host "Olá mundo, chegrei Brasil!"

}