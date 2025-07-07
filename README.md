# Mini compilador (interpretador)

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

<img width="1327" height="1128" alt="Image" src="https://github.com/user-attachments/assets/f0bdee4f-f734-4f3c-aee4-aad452dd53db" />


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
