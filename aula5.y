%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror(char *s) {
    printf("Erro: %s\n", s);
}

typedef enum { INT, FLOAT, STRING,VETOR} Tipo_vars;

typedef struct vars {
    char name[50];
    Tipo_vars tipo;
    union {
        int inter;
        float flo;
        char str[50];
        struct {
            double *vet;
            int tamanho;
        } vetor;
    } valor;
    struct vars *prox;
} VARS;

VARS *ins_float(VARS *l, char n[], float v) {
    VARS *new = malloc(sizeof(VARS));
    strcpy(new->name, n);
    new->tipo = FLOAT;
    new->valor.flo = v;
    new->prox = l;
    return new;
}

VARS *ins_int(VARS *l, char n[], int v) {
    VARS *new = malloc(sizeof(VARS));
    strcpy(new->name, n);
    new->tipo = INT;
    new->valor.inter = v;
    new->prox = l;
    return new;
}

VARS *ins_string(VARS *l, char n[], char v[]) {
    VARS *new = malloc(sizeof(VARS));
    strcpy(new->name, n);
    new->tipo = STRING;
    strncpy(new->valor.str, v, sizeof(new->valor.str)-1);
    new->prox = l;
    return new;
}

VARS *ins_vetor(VARS *l, char n[], int tamanho) {
    VARS *new = malloc(sizeof(VARS));
    if (!new) {
        perror("malloc failed");
        exit(EXIT_FAILURE);
    }
    strcpy(new->name, n);
    new->tipo = VETOR;
    new->valor.vetor.vet = malloc(tamanho * sizeof(double));
    if (!new->valor.vetor.vet) {
        perror("malloc failed");
        free(new);
        exit(EXIT_FAILURE);
    }
    new->valor.vetor.tamanho = tamanho;
    new->prox = l;
    return new;
}

// buscar variavel na lista de variaveis

VARS *srch(VARS *l, char n[]) {
VARS *aux = l;
 while (aux != NULL) {
        if (strcmp(n, aux->name) == 0)
            return aux;
        aux = aux->prox;
    }
   return aux;  
}

//liberar o vetor e a lista de variaveis

void free_vars(VARS *l) {
    while (l) {
        VARS *temp = l;
        l = l->prox;
        if (temp->tipo == VETOR) free(temp->valor.vetor.vet);
        free(temp);
    }
}

// acessar o vetor

VARS *v = srch(lista, "nomeDoVetor");
if (v && v->tipo == VETOR) {
    for (int i = 0; i < v->valor.vetor.tamanho; i++) {
        printf("%f ", v->valor.vetor.vet[i]);
    }
}

/*O node type serve para indicar o tipo de nó que está na árvore. Isso serve para a função eval() entender o que realizar naquele nó*/
typedef struct ast { /*Estrutura de um nó*/
	int nodetype;
	struct ast *l; /*Esquerda*/
	struct ast *r; /*Direita*/
}Ast; 

typedef struct numval { /*Estrutura de um número*/
	int nodetype;
	double number;
}Numval;

typedef struct varval { /*Estrutura de um nome de variável, nesse exemplo uma variável é um número no vetor var[26]*/
	int nodetype;
	char var[50];
	int size;
}Varval;

/*	
typedef struct varval_array { //Estrutura de um nome de variável, nesse exemplo uma variável é um número no vetor var[26]
	int nodetype;
	char var[50];
	int size;
}Varval_array;	
*/
	
typedef struct texto { /*Estrutura de um texto*/
	int nodetype;
	char txt[50];
}TXT;	
	
typedef struct flow { /*Estrutura de um desvio (if/else/while)*/
	int nodetype;
	Ast *cond;		/*condição*/
	Ast *tl;		/*then, ou seja, verdade*/
	Ast *el;		/*else*/
}Flow;

typedef struct symasgn { /*Estrutura para um nó de atribuição. Para atrubior o valor de v em s*/
	int nodetype;
	char s[50];
	Ast *v;
	int pos;
}Symasgn;


VARI *l1; /*Variáveis*/
VARI *aux;

Ast * newast(int nodetype, Ast *l, Ast *r){ /*Função para criar um nó*/

	Ast *a = (Ast*) malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	a->l = l;
	a->r = r;
	return a;
}
 
Ast * newvari(int nodetype, char nome[50]) {			/*Função de que cria uma nova variável*/
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	strcpy(a->var,nome);
	return (Ast*)a;
}

Ast * newarray(int nodetype, char nome[50], int tam) {			/*Função de que cria uma nova variável*/
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	strcpy(a->var,nome);
	a->size = tam;
	return (Ast*)a;
}	
	
Ast * newtext(int nodetype, char txt[500]) {			/*Função de que cria uma nova variável*/
	TXT *a = (TXT*) malloc(sizeof(TXT));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	strcpy(a->txt,txt);
	return (Ast*)a;
}	
	
Ast * newnum(double d) {			/*Função de que cria um novo número*/
	Numval *a = (Numval*) malloc(sizeof(Numval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'K';
	a->number = d;
	return (Ast*)a;
}	
	
Ast * newflow(int nodetype, Ast *cond, Ast *tl, Ast *el){ /*Função que cria um nó de if/else/while*/
	Flow *a = (Flow*)malloc(sizeof(Flow));
	if(!a) {
		printf("out of space");
	exit(0);
	}
	a->nodetype = nodetype;
	a->cond = cond;
	a->tl = tl;
	a->el = el;
	return (Ast *)a;
}

Ast * newcmp(int cmptype, Ast *l, Ast *r){ /*Função que cria um nó para testes*/
	Ast *a = (Ast*)malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
	exit(0);
	}
	a->nodetype = '0' + cmptype; /*Para pegar o tipe de teste, definido no arquivo.l e utilizar na função eval()*/
	a->l = l;
	a->r = r;
	return a;
}

Ast * newasgn(char s[50], Ast *v) { /*Função para um nó de atribuição*/
	Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
	if(!a) {
		printf("out of space");
	exit(0);
	}
	a->nodetype = '=';
	strcpy(a->s,s);
	a->v = v; /*Valor*/
	//printf ("aqui:%lf\n",((VARI*)a->v)->valor);
	return (Ast *)a;
}

Ast * newasgn_a(char s[50], Ast *v, int indice) { /*Função para um nó de atribuição*/
	Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
	if(!a) {
		printf("out of space");
	exit(0);
	}
	a->nodetype = '=';
	strcpy(a->s,s);
	a->v = v; /*Valor*/
	a->pos = indice;
	return (Ast *)a;
}
	
	
Ast * newValorVal(char s[]) { /*Função que recupera o nome/referência de uma variável, neste caso o número*/
	
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'N';
	strcpy(a->var,s);
	return (Ast*)a;
}
	
Ast * newValorVal_a(char s[], int indice) { /*Função que recupera o nome/referência de uma variável, neste caso o número*/
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'n';
	strcpy(a->var,s);
	a->size = indice;
	
	return (Ast*)a;
}	

Ast * newValorValS(char s[50]) { /*Função que recupera o nome/referência de uma variável, neste caso o número*/
	
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'Q';
	strcpy(a->var,s);
	return (Ast*)a;
	
}
	
char * eval2(Ast *a) { /*Função que executa operações a partir de um nó*/
		VARI *aux1;
		char *v2;
		
			switch(a->nodetype) {
			
			case 'Q':
				aux1 = srch(l1,((Varval *)a)->var);
				return aux1->valors;
				break;

			default: printf("internal error: bad node %c\n", a->nodetype);
					break;
		}
		
	return v2;
	}


double eval(Ast *a) { /*Função que executa operações a partir de um nó*/
	double v; 
	char v1[50];
	char *v2;
	VARI * aux1;
	if(!a) {
		printf("internal error, null eval");
		return 0.0;
	}
	switch(a->nodetype) {
		case 'K': v = ((Numval *)a)->number; break; 	/*Recupera um número*/
		case 'N': 
			aux1 = srch(l1,((Varval *)a)->var);
			v = aux1->valor;
			break;
		
		case 'n':
			
			aux1 = srch(l1,((Varval *)a)->var);
			v = aux1->vet[((Varval *)a)->size];
			break;
		
		case '+': v = eval(a->l) + eval(a->r); break;	/*Operações "árv esq   +   árv dir"*/
		case '-': v = eval(a->l) - eval(a->r); break;	/*Operações*/
		case '*': v = eval(a->l) * eval(a->r); break;	/*Operações*/
		case '/': v = eval(a->l) / eval(a->r); break; /*Operações*/
		case 'M': v = -eval(a->l); break;				/*Operações, número negativo*/
	
		case '1': v = (eval(a->l) > eval(a->r))? 1 :  0; break;	/*Operações lógicas. "árv esq   >   árv dir"  Se verdade 1, falso 0*/
		case '2': v = (eval(a->l) < eval(a->r))? 1 :  0; break;
		case '3': v = (eval(a->l) != eval(a->r))? 1 : 0; break;
		case '4': v = (eval(a->l) == eval(a->r))? 1 : 0; break;
		case '5': v = (eval(a->l) >= eval(a->r))? 1 : 0; break;
		case '6': v = (eval(a->l) <= eval(a->r))? 1 : 0; break;

		case '10': v = (eval(a->l) . eval(a->r))? 1 : 0; break;	/*Simbolos ainda preciso ver se é isso mesmo*/
		case '11': v = (eval(a->l) , eval(a->r))? 1 : 0; break;
		case '12': v = (eval(a->l) # eval(a->r))? 1 : 0; break;
		case '13': v = (eval(a->l) : eval(a->r))? 1 : 0; break;
		case '14': v = (eval(a->l) ? eval(a->r))? 1 : 0; break;
		case '15': v = (eval(a->l) ! eval(a->r))? 1 : 0; break;
		case '16': v = (eval(a->l) % eval(a->r))? 1 : 0; break;
		
		case '=':
			v = eval(((Symasgn *)a)->v); /*Recupera o valor*/
			aux = srch(l1,((Symasgn *)a)->s);
			
			//printf ("AQUI %d\n",((Varval *)aux)->nodetype);
			
			if(aux->nodetype == 1){ //lembrar de verificar os demais tipos
				aux->valor = v;
				//printf ("%lf\n",v);
			}
			else
				aux->vet[((Symasgn *)a)->pos] = v; //inserção no vetor
			break;
		
		case 'I':						/*CASO IF*/
			if (eval(((Flow *)a)->cond) != 0) {	/*executa a condição / teste*/
				if (((Flow *)a)->tl)		/*Se existir árvore*/
					v = eval(((Flow *)a)->tl); /*Verdade*/
				else
					v = 0.0;
			} else {
				if( ((Flow *)a)->el) {
					v = eval(((Flow *)a)->el); /*Falso*/
				} else
					v = 0.0;
				}
			break;
			
		case 'W':
			//printf ("WHILE\n");
			v = 0.0;
			if( ((Flow *)a)->tl) {
				while( eval(((Flow *)a)->cond) != 0){
					v = eval(((Flow *)a)->tl);
					}
			}
		break;
			
		case 'L': eval(a->l); v = eval(a->r); break; /*Lista de operções em um bloco IF/ELSE/WHILE. Assim o analisador não se perde entre os blocos*/
		
		case 'P': 	v = eval(a->l);		/*Recupera um valor*/
					printf ("%.2f\n",v);
					break;  			/*Função que imprime um valor*/
		
		case 'S': 	scanf("%lf",&v);
					aux1 = srch(l1,((Varval *)a)->var);
					aux1->valor = v;
					break;
		
		case 'T': 	scanf("%s",v1);
					aux1 = srch(l1,((Varval *)a)->var);
					strcpy(aux1->valors,v1);
					break;			
		
		case 'Y':	
					v2 = eval2(a->l);		/*Recupera um valor STR*/
					printf ("%s\n",v2); break;  /*Função que imprime um valor (string)*/
					break;
					
		case 'V': 	l1 = ins(l1,((Varval*)a)->var);
					break;
		case 'a':	
					l1 = ins_a(l1,((Varval*)a)->var,((Varval*)a)->size);
					break;
			
		default: printf("internal error: bad node %c\n", a->nodetype);
				break;
				
	}
	return v;
}
%}

%union {
    int inter;
    float flo;
    char str[50];
    int fn;
}

%token <flo> NUM
%token <str> VARS TEXTO STRING
%token <inter> INT
%token <flo> FLOAT
%token <fn> CMP SIMB

%token INI FIM IF ELSE WHILE PRINT DECL SCAN PRINTT SCANS

%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%precedence NEG

%%

prog:  INICIO cod FIM;

cod: stmt {eval($1);}  /*Inicia e execução da árvore de derivação*/
    | cod stmt {eval($2);}	 /*Inicia e execução da árvore de derivação*/
	;
	
/*Funções para análise sintática e criação dos nós na AST*/	
/*Verifique q nenhuma operação é realizada na ação semântica, apenas são criados nós na árvore de derivação com suas respectivas operações*/
	
stmt: IF '(' exp ')' '{' list '}' %prec IFX {$$ = newflow('I', $3, $6, NULL);}
	| IF '(' exp ')' '{' list '}' ELSE '{' list '}' {$$ = newflow('I', $3, $6, $10);}
	| WHILE '(' exp ')' '{' list '}' {$$ = newflow('W', $3, $6, NULL);}

	| VARS '=' exp %prec VARPREC { $$ = newasgn($1,$3);}
	| VARS '['NUM']' '=' exp {$$ = newasgn_a($1,$6,$3);}

	| DECL VARS	 %prec DECLPREC { $$ = newvari('V',$2);}
	| DECL VARS '['NUM']'	{ $$ = newarray('a',$2,$4);}
	
	| PRINT '(' exp ')' 	{$$ = newast('P',$3,NULL);}
	| PRINTT '(' exp1 ')' 	{$$ = newast('Y',$3,NULL);}
	| SCAN '('VARS')'		{$$ = newvari('S',$3);}
	| SCANS '('VARS')'		{$$ = newvari('T',$3);}
	;

list: stmt {$$ = $1;}
		| list stmt { $$ = newast('L', $1, $2);	}
		;	

stmt: IF '(' exp ')' '{' list '}' %prec IFX {$$ = newflow('I', $3, $6, NULL);}
	| IF '(' exp ')' '{' list '}' ELSE '{' list '}' {$$ = newflow('I', $3, $6, $10);}
	| WHILE '(' exp ')' '{' list '}' {$$ = newflow('W', $3, $6, NULL);}

	| VARS '=' exp %prec VARPREC { $$ = newasgn($1,$3);}
	| VARS '['NUM']' '=' exp {$$ = newasgn_a($1,$6,$3);}

	| DECL VARS	 %prec DECLPREC { $$ = newvari('V',$2);}
	| DECL VARS '['NUM']'	{ $$ = newarray('a',$2,$4);}
	
	| PRINT '(' exp ')' 	{$$ = newast('P',$3,NULL);}
	| PRINTT '(' exp1 ')' 	{$$ = newast('Y',$3,NULL);}
	| SCAN '('VARS')'		{$$ = newvari('S',$3);}
	| SCANS '('VARS')'		{$$ = newvari('T',$3);}
	;

list: stmt {$$ = $1;}
		| list stmt { $$ = newast('L', $1, $2);	}
		;	
exp: 
	 exp '+' exp {$$ = newast('+',$1,$3);}		/*Expressões matemáticas*/
	|exp '-' exp {$$ = newast('-',$1,$3);}
	|exp '*' exp {$$ = newast('*',$1,$3);}
	|exp '/' exp {$$ = newast('/',$1,$3);}
	|exp CMP exp {$$ = newcmp($2,$1,$3);}		/*Testes condicionais*/
	|'(' exp ')' {$$ = $2;}
	|'-' exp %prec NEG {$$ = newast('M',$2,NULL);}
	|NUM 	{$$ = newnum($1);}						/*token de um número*/
	
	|VARS 	%prec VET {$$ = newValorVal($1);}		/*token de uma variável*/
	|VARS '['NUM']' {$$ = newValorVal_a($1,$3);}				/*token de uma variável*/
	;

exp1: 
	VARS {$$ = newValorValS($1);}				
	;
%%
#include "lex.yy.c"

int main() {
    yyin = fopen("entrada.txt", "r");
    if (!yyin) {
        printf("Erro ao abrir arquivo\n");
        return 1;
    }
    yyparse();
    fclose(yyin);
    return 0;
}
