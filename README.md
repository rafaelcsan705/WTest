# WTest

Challenge desenvolvido por Rafael Santos.

Como testar:

Sugiro que testem este projeto num iPhone físico e não no simulador.

Eu testei este projeto no meu iPhone 12 Pro Max e fez o download total do ficheiro CSV e guardou na Core Data com sucesso.

Num simulador do Xcode o projeto para após começar o download, penso que seja pela forma que estou a usar para gravar os dados na CoreData porque optei por manter a MainThread disponível para o utilizador navegar.

Anteriormente estava a conseguir interromper o download e assim que voltava a abrir a aplicação ele continuava o download, neste momento por vezes a aplicação fecha e não consegui perceber o problema, contudo, ao voltar a abrir, ela conclui o download.


Dificuldades:

O facto de já não estar a trabalhar com Swift neste último ano, fez com que tivesse algumas dificuldades em desenvolver algumas funcionalidades e isso fez com que perdesse ainda mais tempo e o projeto não esteja tão bom como queria.

Inicialmente tive dificuldades ao gravar o ficheiro csv e aceder aos dados porque nunca o tinha feito, depois o que tive mais dificuldade foi sem dúvida a pesquisa da SearchBar e CoreData, já o tinha feito em outros projetos, mas desta vez tive muitas dificuldades porque nunca tinha usado CoreData.

Não consegui validar todas as opções como pediam na SearchBar, funciona se procurarmos por localidades ou por código postais, mas os dois juntos não funcionam.

Gostaria de ter melhorado imenso a pesquisa da SearchBar mas não consegui mesmo e lamento por isso.

Outra coisa que não consegui foi a ProgressBar, não estava a conseguir atualizar o valor ao mesmo tempo que fazia o download.


Pontos Negativos:

O código não está bem organizado e optei por deixar tudo na MainViewController, eu gosto de ter o código todo separado e organizado, mas queria tanto terminar o quanto antes que acabei por deixar assim.

Estou a utilizar Arrays, não queria, queria ter aproveitado a CoreData mas como nunca tinha utilizado anteriormente, não sabia como o fazer da melhor forma, isso fez com que o projeto ficasse mais lento e pesado.

Contudo, é possível o utilizador navegar na TableView enquanto faz download.

A SearchBar não está a funcionar como pediram, queria garantir todos os casos que pediram, mas não consegui.

O código postal não está a negrito, eu sei que podia usar um MutableString mas estava tão focado na SearchBar que acabei por abdicar disso.

Pontos Positivos:

A meu ver, não estando a trabalhar com Swift no último ano, já foi bom para mim voltar a desenvolver um projeto porque adoro mesmo trabalhar com iOS.

Conseguir apresentar todos os dados, fazer download e guardar na Core Data, eu quis que fosse possível visualizar a lista ao mesmo tempo que faz download porque não queria que aplicação tivesse bloqueada enquanto fazia download.

Nota: 

Lamento imenso não ter corrido tão bem, queria ter entregado na Sexta-Feira, mas só consegui hoje (sábado, 13 de março de 2021) e mesmo assim não está como queria.

Queria melhorar a SearchBar, não utilizar Arrays, usar apenas CoreData e tornar a aplicação ainda mais rápida.

Apesar de não ter corrido tão bem, eu adoro mesmo trabalhar com iOS e gostaria de poder trabalhar convosco e se me derem essa oportunidade irei dar sempre o meu melhor.


Cumprimentos,
Rafael Santos
