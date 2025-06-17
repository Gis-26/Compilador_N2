%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror(char *s) {
    printf("Erro: %s\n", s);
}

typedef enum { TIPO_INT, TIPO_FLOAT, TIPO_STRING, VETOR} Tipo_vars;

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
    new->tipo = TIPO_FLOAT;
    new->valor.flo = v;
    new->prox = l;
    return new;
}

VARS *ins_int(VARS *l, char n[], int v) {
    VARS *new = malloc(sizeof(VARS));
    strcpy(new->name, n);
    new->tipo = TIPO_INT;
    new->valor.inter = v;
    new->prox = l;
    return new;
}

VARS *ins_string(VARS *l, char n[], char v[]) {
    VARS *new = malloc(sizeof(VARS));
    strcpy(new->name, n);
    new->tipo = TIPO_STRING;
    strncpy(new->valor.str, v, sizeof(new->valor.str)-1);
    new->valor.str[sizeof(new->valor.str)-1] = '\0';
    new->prox = l;
    return new;
}

VARS *ins_vetor(VARS *l, char n[], int tamanho) {
    VARS *new = malloc(sizeof(VARS));
    if (!new) {
        perror("malloc erro");
        exit(EXIT_FAILURE);
    }
    strcpy(new->name, n);
    new->tipo = VETOR;
    new->valor.vetor.vet = malloc(tamanho * sizeof(double));
    if (!new->valor.vetor.vet) {
        perror("malloc erro");
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
    return NULL;  
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

typedef struct ast {
	int nodetype;
	struct ast *l;
	struct ast *r;
}Ast; 

typedef struct numval {
	int nodetype;
	double number;
}Numval;

typedef struct varval {
	int nodetype;
	char var[50];
	int size;
}Varval;
	
typedef struct texto {
	int nodetype;
	char txt[50];
}TXT;	
	
typedef struct flow {
	int nodetype;
	Ast *cond;
	Ast *tl;
	Ast *el;
}Flow;

typedef struct symasgn {
	int nodetype;
	char s[50];
	Ast *v;
	int pos;
}Symasgn;

VARS *l1 = NULL;
VARS *aux;

Ast * newast(int nodetype, Ast *l, Ast *r){
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
 
Ast * newvari(int nodetype, char nome[50]) {
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	strcpy(a->var,nome);
	return (Ast*)a;
}

Ast * newarray(int nodetype, char nome[50], int tam) {
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
	
Ast * newtext(int nodetype, char txt[500]) {
	TXT *a = (TXT*) malloc(sizeof(TXT));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	strncpy(a->txt, txt, sizeof(a->txt)-1);
	a->txt[sizeof(a->txt)-1] = '\0';
	return (Ast*)a;
}	
	
Ast * newnum(double d) {
	Numval *a = (Numval*) malloc(sizeof(Numval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'K';
	a->number = d;
	return (Ast*)a;
}	
	
Ast * newflow(int nodetype, Ast *cond, Ast *tl, Ast *el){
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

Ast * newcmp(int cmptype, Ast *l, Ast *r){
	Ast *a = (Ast*)malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = '0' + cmptype;
	a->l = l;
	a->r = r;
	return a;
}

Ast * newasgn(char s[50], Ast *v) {
	Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = '=';
	strcpy(a->s,s);
	a->v = v;
	a->pos = 0;
	return (Ast *)a;
}

Ast * newasgn_a(char s[50], Ast *v, int indice) {
	Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = '=';
	strcpy(a->s,s);
	a->v = v;
	a->pos = indice;
	return (Ast *)a;
}
	
Ast * newValorVal(char s[]) {
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'N';
	strcpy(a->var,s);
	a->size = 0;
	return (Ast*)a;
}
	
Ast * newValorVal_a(char s[], int indice) {
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

Ast * newValorValS(char s[50]) {
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'Q';
	strcpy(a->var,s);
	a->size = 0;
	return (Ast*)a;
}
	
char * eval2(Ast *a) {
	VARS *aux1;
	char *v2 = NULL;
	
	switch(a->nodetype) {
		case 'Q':
			aux1 = srch(l1,((Varval *)a)->var);
			if(aux1 && aux1->tipo == TIPO_STRING)
				return aux1->valor.str;
			break;
		default: 
			printf("internal error: bad node %c\n", a->nodetype);
			break;
	}
	return v2;
}

double eval(Ast *a) {
	double v = 0.0; 
	char v1[50];
	char *v2;
	VARS * aux1;
	
	if(!a) {
		printf("internal error, null eval");
		return 0.0;
	}
	
	switch(a->nodetype) {
		case 'K': 
			v = ((Numval *)a)->number; 
			break;
			
		case 'N': 
			aux1 = srch(l1,((Varval *)a)->var);
			if(aux1) {
				if(aux1->tipo == TIPO_INT)
					v = aux1->valor.inter;
				else if(aux1->tipo == TIPO_FLOAT)
					v = aux1->valor.flo;
			}
			break;
		
		case 'n':
			aux1 = srch(l1,((Varval *)a)->var);
			if(aux1 && aux1->tipo == VETOR) {
				int idx = ((Varval *)a)->size;
				if(idx >= 0 && idx < aux1->valor.vetor.tamanho)
					v = aux1->valor.vetor.vet[idx];
			}
			break;
		
		case '+': v = eval(a->l) + eval(a->r); break;
		case '-': v = eval(a->l) - eval(a->r); break;
		case '*': v = eval(a->l) * eval(a->r); break;
		case '/': v = eval(a->l) / eval(a->r); break;
		case 'M': v = -eval(a->l); break;
	
		case '1': v = (eval(a->l) > eval(a->r))? 1 :  0; break;
		case '2': v = (eval(a->l) < eval(a->r))? 1 :  0; break;
		case '3': v = (eval(a->l) != eval(a->r))? 1 : 0; break;
		case '4': v = (eval(a->l) == eval(a->r))? 1 : 0; break;
		case '5': v = (eval(a->l) >= eval(a->r))? 1 : 0; break;
		case '6': v = (eval(a->l) <= eval(a->r))? 1 : 0; break;

		case '=':
			v = eval(((Symasgn *)a)->v);
			aux1 = srch(l1,((Symasgn *)a)->s);
			
			if(!aux1) {
				// Criar variável se não existir
				l1 = ins_float(l1, ((Symasgn *)a)->s, v);
			} else {
				if (aux1->tipo == TIPO_INT) {
    				aux1->valor.inter = (int)v;
				} else if (aux1->tipo == TIPO_FLOAT) {
    				aux1->valor.flo = v;
				} else if (aux1->tipo == VETOR) {
					int idx = ((Symasgn *)a)->pos;
					if(idx >= 0 && idx < aux1->valor.vetor.tamanho)
    					aux1->valor.vetor.vet[idx] = v;
				}
			}
			break;
		
		case 'I':
			if (eval(((Flow *)a)->cond) != 0) {
				if (((Flow *)a)->tl)
					v = eval(((Flow *)a)->tl);
				else
					v = 0.0;
			} else {
				if( ((Flow *)a)->el) {
					v = eval(((Flow *)a)->el);
				} else
					v = 0.0;
			}
			break;
			
		case 'W':
			v = 0.0;
			if( ((Flow *)a)->tl) {
				while( eval(((Flow *)a)->cond) != 0){
					v = eval(((Flow *)a)->tl);
				}
			}
			break;
			
		case 'L': 
			eval(a->l); 
			v = eval(a->r); 
			break;
		
		case 'P': 	
			v = eval(a->l);
			printf ("%.2f\n",v);
			break;
		
		case 'S': 	
			scanf("%lf",&v);
			aux1 = srch(l1,((Varval *)a)->var);
			if(aux1) {
				if(aux1->tipo == TIPO_FLOAT)
					aux1->valor.flo = v;
				else if(aux1->tipo == TIPO_INT)
					aux1->valor.inter = (int)v;
			}
			break;
		
		case 'T': 	
			scanf("%49s",v1);
			aux1 = srch(l1,((Varval *)a)->var);
			if(aux1 && aux1->tipo == TIPO_STRING) {
				strcpy(aux1->valor.str,v1);
			}
			break;			
		
		case 'Y':	
			v2 = eval2(a->l);
			if(v2)
				printf ("%s\n",v2); 
			break;
					
		case 'V': 	
			l1 = ins_float(l1,((Varval*)a)->var,0.0);
			break;
			
		case 'a':	
			l1 = ins_vetor(l1,((Varval*)a)->var,((Varval*)a)->size);
			break;
			
		default: 
			printf("internal error: bad node %c\n", a->nodetype);
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
    struct ast *a;  
}

%type <a> prog stmt list exp funcao
%token <flo> NUM
%token <str> VAR TEXTO STRING
%token <fn> CMP SIMB

%token INICIO FIM IF ELSE WHILE PRINT DECL SCAN PRINTT SCANS

%right '='
%left '+' '-'
%left '*' '/'
%left '^'
%precedence NEG
%nonassoc IFX

%%

val: INICIO prog FIM
	;

prog: stmt 		{eval($1);}
	| prog stmt {eval($2);}
	;
	
funcao: STRING {printf("%s\n",$1);}
	| exp {double result = eval($1); printf("%.2f\n",result);}
	;

stmt: IF '(' exp ')' '{' list '}' %prec IFX {$$ = newflow('I', $3, $6, NULL);}
	| IF '(' exp ')' '{' list '}' ELSE '{' list '}' {$$ = newflow('I', $3, $6, $10);}
	| WHILE '(' exp ')' '{' list '}' {$$ = newflow('W', $3, $6, NULL);}
	| VAR '=' exp {$$ = newasgn($1,$3);}
	| PRINT '(' funcao ')' { $$ = newast('P',$3,NULL);}
	;

list: stmt{$$ = $1;}
	| list stmt { $$ = newast('L', $1, $2);}
	;
	
exp: exp '+' exp {$$ = newast('+',$1,$3);}
	| exp '-' exp {$$ = newast('-',$1,$3);}
	| exp '*' exp {$$ = newast('*',$1,$3);}
	| exp '/' exp {$$ = newast('/',$1,$3);}
	| exp CMP exp {$$ = newcmp($2,$1,$3);}
	| '(' exp ')' {$$ = $2;}
	| '-' exp %prec NEG {$$ = newast('M',$2,NULL);}
	| NUM {$$ = newnum($1);}
	| VAR {$$ = newValorVal($1);}
	;

%%
#include "lex.yy.c"

int main() {
    extern FILE *yyin;
    yyin = fopen("entrada.txt", "r");
    if (!yyin) {
        printf("Erro ao abrir arquivo\n");
        return 1;
    }
    yyparse();
    fclose(yyin);
    free_vars(l1);
    return 0;
}