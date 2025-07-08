# Compilador Matriz

O Compilador Matriz é um mini compilador feito em C, usando Flex e Bison, como parte da disciplina de Compiladores. Ele foi criado para processar programas escritos em uma linguagem simples, com a extensão .mtrx.

## Características

- **Tipos de variáveis**: `int`, `float`, `string`
- **Estruturas de dados**: Vetores unidimensionais
- **Estruturas de controle**: `se`/`senao`, `enquanto`
- **Operações**: Aritméticas, relacionais e lógicas
- **Entrada/Saída**: `leia()` e `escreva()`
- **Funções matemáticas**: `raiz()`
- **Comentários**: Comentários de linha `//`

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
num_int = 4
num_float = 14.67
nome = "Maria"
vet_num[0] = 7
```

### Estruturas Condicionais
```
se (num_int > 0) {
    escreva("O número é positivo")
} senao{
    escreva("O número é negativo")
se{

}senao {
    escreva("O número é zero")
}
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
escreva("Olá mundo!")
escreva(nome)
```

### Operadores

#### Aritméticos
- `+` (adição)
- `-` (subtração)
- `*` (multiplicação)
- `/` (divisão)
- `^` (exponeciação)

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
// Comentário de linha
int x  // Comentário no final do código
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
float x
float y
float a
float b
float resultado
float hipotenusa
int base
int expoente
int rest

x = 10.0
y = 5.0
a = 3.0
b = 4.0
base = 2
expoente = 3

resultado = (x + y) * (a - b) / 2.0
escreva("(x + y) * (a - b) / 2.0:")
escreva(resultado)

hipotenusa = raiz((a * a) + (b * b))
escreva("Hipotenusa:")
escreva(hipotenusa)

rest = base ^ expoente
escreva ("2 ^ 3: ")
escreva (rest)

FIM
```

## Problema: Aumento de salario (Beecrowd)

<img width="1327" height="1128" alt="Image" src="https://github.com/user-attachments/assets/f0bdee4f-f734-4f3c-aee4-aad452dd53db" />


```
float salario
float percentual
float reajuste
percentual = 0.1

escreva ("Digite o seu salario")
leia (salario)

se (salario <= 400.00) {
    percentual = 0.15
    reajuste = salario*percentual
    salario = salario + (salario*percentual)
}

 senao {
        se ((salario <= 1200.00) && (salario > 800.00)) {
            percentual = 0.10
            reajuste = salario*percentual
            salario = salario + (salario*percentual)
        } senao {
            se ((salario <= 2000.00) && (salario > 1200.00)) {
                percentual = 0.07
                reajuste = salario*percentual
                salario = salario + (salario*percentual)
            } senao {
                percentual = 0.04
                reajuste = salario*percentual
                salario = salario + (salario*percentual)
            }
        }
    }
escreva ("Novo salario: ")
escreva (salario)
escreva ("Reajuste ganho: ")
escreva (reajuste)
escreva ("Em percentual: ")
escreva (percentual*100)
escreva ("%")

FIM 
```

## 📋 Limitações

- O vetor só aceita valores númericos
- Ele não concatena a variável com a string (Quando for mostrar um resultado tem que colocar em saídas diferentes)
- Não aceita função e nem matriz
- O usúario não consegue inserir números no vetor (Apenas atribuições)
