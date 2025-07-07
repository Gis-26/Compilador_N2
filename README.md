# Interpretador de Linguagem de Programação

Um interpretador simples desenvolvido em C usando Flex e Bison para análise léxica e sintática.

## 🚀 Características

- **Tipos de dados**: `int`, `float`, `string`
- **Estruturas de dados**: Vetores unidimensionais
- **Estruturas de controle**: `se`/`senao`, `enquanto`
- **Operações**: Aritméticas, relacionais e lógicas
- **Entrada/Saída**: `leia()` e `escreva()`
- **Funções matemáticas**: `raiz()` (raiz quadrada)
- **Comentários**: Suporte a comentários de linha `//`

## 📝 Sintaxe da Linguagem

### Declaração de Variáveis
```
int idade
float salario
string nome
```

### Declaração de Vetores
```
int numeros[10]
float precos[5]
```

### Atribuição
```
idade = 25
salario = 1500.50
nome = "João Silva"
numeros[0] = 100
```

### Estruturas Condicionais
```
se (idade >= 18) {
    escreva("Maior de idade")
} senao {
    escreva("Menor de idade")
}
```

### Estruturas de Repetição
```
enquanto (contador < 10) {
    escreva(contador)
    contador = contador + 1
}
```

### Entrada e Saída
```
leia(nome)
escreva("Olá,")
escreva(nome)
```

### Operadores

#### Aritméticos
- `+` (adição)
- `-` (subtração)
- `*` (multiplicação)
- `/` (divisão)

#### Relacionais
- `>` (maior que)
- `<` (menor que)
- `>=` (maior ou igual)
- `<=` (menor ou igual)
- `==` (igual)
- `!=` (diferente)

#### Lógicos
- `&&` (E lógico)
- `||` (OU lógico)

### Funções Matemáticas
```
resultado = raiz(16)  // Raiz quadrada
```

### Comentários
```
// Este é um comentário de linha
int x  // Comentário no final da linha
```

## 📚 Exemplos

### Exemplo 1: Entrada e Saída de Strings
```
string cidade
escreva("Digite o nome da cidade:")
leia(cidade)
escreva("Cidade digitada:")
escreva(cidade)
FIM
```

### Exemplo 2: Sistema de Estoque
```
int codigo
string produto
float preco
int quantidade
int opcao
int estoque[10]

escreva("Sistema de Estoque - Digite:")
escreva("1 para cadastrar produto")
escreva("2 para consultar estoque")
escreva("3 para sair")

leia(opcao)

enquanto(opcao != 3) {
    se(opcao == 1) {
        escreva("Digite o codigo (0-9):")
        leia(codigo)
        escreva("Digite a quantidade:")
        leia(quantidade)
        estoque[codigo] = quantidade
        escreva("Produto cadastrado!")
    }
    
    se(opcao == 2) {
        escreva("Digite o codigo para consulta (0-9):")
        leia(codigo)
        escreva("Estoque atual:")
        escreva(estoque[codigo])
    }
    
    escreva("Digite nova opcao (1-3):")
    leia(opcao)
}

escreva("Sistema encerrado!")
FIM
```

### Exemplo 3: Cálculos Matemáticos
```
float a
float b
float hipotenusa

a = 3.0
b = 4.0

hipotenusa = raiz((a * a) + (b * b))
escreva("Hipotenusa:")
escreva(hipotenusa)
FIM
```

## Problema

```
beecrowd | 1048
Aumento de Salário

A empresa ABC resolveu conceder um aumento de salários a seus funcionários de acordo com a tabela abaixo:


Salário	Percentual de Reajuste
0 - 400.00
400.01 - 800.00
800.01 - 1200.00
1200.01 - 2000.00
Acima de 2000.00

15%
12%
10%
7%
4%

Leia o salário do funcionário e calcule e mostre o novo salário, bem como o valor de reajuste ganho e o índice reajustado, em percentual.

Entrada
A entrada contém apenas um valor de ponto flutuante, com duas casas decimais.

Saída
Imprima 3 linhas na saída: o novo salário, o valor ganho de reajuste (ambos devem ser apresentados com 2 casas decimais) e o percentual de reajuste ganho, conforme exemplo abaixo.

Exemplo de Entrada	Exemplo de Saída
400.00

Novo salario: 460.00
Reajuste ganho: 60.00
Em percentual: 15 %

800.01

Novo salario: 880.01
Reajuste ganho: 80.00
Em percentual: 10 %

2000.00

Novo salario: 2140.00
Reajuste ganho: 140.00
Em percentual: 7 %
```

## 📋 Limitações

- Não suporta funções definidas pelo usuário
- Vetores limitados a uma dimensão
- Não há verificação de tipos em tempo de compilação
- Sem suporte a estruturas de dados complexas
- Strings têm tamanho limitado (50 caracteres)

## 🐛 Tratamento de Erros

O interpretador fornece mensagens de erro para:
- Variáveis não declaradas
- Erros de sintaxe
- Operações matemáticas inválidas (ex: raiz de número negativo)
- Problemas de acesso a vetores


## 👨‍💻 Autor

[Seu Nome] - [seu.email@exemplo.com]

