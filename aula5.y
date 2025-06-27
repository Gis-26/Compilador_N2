%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>	

// nodetype variables
// 1 - int
// 2 - float
// 3 - string
// 4 - int array
// 5 - float array
	
typedef struct vars {
    int nodetype;
    char name[50];
    union {
        int ival;
        double fval;
        char sval[100];
        int *iarr;
        double *farr;
    } value;
    int arr_size;
    struct vars *prox;
} VARI;
	
VARI *ins(VARI *l, char n[], int type) {
    VARI *new = (VARI*)malloc(sizeof(VARI));
    strcpy(new->name, n);
    new->nodetype = type;
    new->prox = l;
    return new;
}
	
VARI *ins_array(VARI *l, char n[], int type, int size) {
    VARI *new = (VARI*)malloc(sizeof(VARI));
    strcpy(new->name, n);
    new->nodetype = type + 3; // 4 for int array, 5 for float array
    new->arr_size = size;
    if (type == 1) // int array
        new->value.iarr = (int*)malloc(size * sizeof(int));
    else // float array
        new->value.farr = (double*)malloc(size * sizeof(double));
    new->prox = l;
    return new;
}
	
VARI *srch(VARI *l, char n[]) {
    VARI *aux = l;
    while (aux != NULL) {
        if (strcmp(n, aux->name) == 0)
            return aux;
        aux = aux->prox;
    }
    return NULL;
}

typedef struct ast {
    int nodetype;
    struct ast *l;
    struct ast *r;
} Ast;

typedef struct numval {
    int nodetype;
    union {
        int ival;
        double fval;
    } value;
} Numval;

typedef struct strval {
    int nodetype;
    char sval[100];
} Strval;

typedef struct varval {
    int nodetype;
    char var[50];
    int index; // for arrays
} Varval;

typedef struct flow {
    int nodetype;
    Ast *cond;
    Ast *tl;
    Ast *el;
} Flow;

typedef struct symasgn {
    int nodetype;
    char s[50];
    Ast *v;
    int index;
    int type; // 1 for int, 2 for float, 3 for string
} Symasgn;

typedef struct decl {
    int nodetype;
    char s[50];
    int type; // 1 for int, 2 for float, 3 for string
    int arr_size; // 0 for non-array
} Decl;

VARI *l1 = NULL;

Ast *newast(int nodetype, Ast *l, Ast *r) {
    Ast *a = (Ast*)malloc(sizeof(Ast));
    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    return a;
}

Ast *newnum_int(int d) {
    Numval *a = (Numval*)malloc(sizeof(Numval));
    a->nodetype = 'I';
    a->value.ival = d;
    return (Ast*)a;
}

Ast *newnum_float(double d) {
    Numval *a = (Numval*)malloc(sizeof(Numval));
    a->nodetype = 'F';
    a->value.fval = d;
    return (Ast*)a;
}

Ast *newstr(char *s) {
    Strval *a = (Strval*)malloc(sizeof(Strval));
    a->nodetype = 'S';
    strcpy(a->sval, s);
    return (Ast*)a;
}

Ast *newvar(char *name) {
    Varval *a = (Varval*)malloc(sizeof(Varval));
    a->nodetype = 'V';
    strcpy(a->var, name);
    a->index = -1;
    return (Ast*)a;
}

Ast *newvar_array(char *name, int index) {
    Varval *a = (Varval*)malloc(sizeof(Varval));
    a->nodetype = 'A';
    strcpy(a->var, name);
    a->index = index;
    return (Ast*)a;
}

Ast *newflow(int nodetype, Ast *cond, Ast *tl, Ast *el) {
    Flow *a = (Flow*)malloc(sizeof(Flow));
    a->nodetype = nodetype;
    a->cond = cond;
    a->tl = tl;
    a->el = el;
    return (Ast*)a;
}

Ast *newcmp(int cmptype, Ast *l, Ast *r) {
    Ast *a = (Ast*)malloc(sizeof(Ast));
    a->nodetype = '0' + cmptype;
    a->l = l;
    a->r = r;
    return a;
}

Ast *newasgn(char *s, Ast *v, int type, int index) {
    Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
    a->nodetype = '=';
    strcpy(a->s, s);
    a->v = v;
    a->index = index;
    a->type = type;
    return (Ast*)a;
}

Ast *newdecl(char *s, int type, int arr_size) {
    Decl *a = (Decl*)malloc(sizeof(Decl));
    a->nodetype = 'D';
    strcpy(a->s, s);
    a->type = type;
    a->arr_size = arr_size;
    return (Ast*)a;
}

void eval(Ast *a);

void eval_decl(Decl *d) {
    if (d->arr_size == 0) {
        l1 = ins(l1, d->s, d->type);
    } else {
        l1 = ins_array(l1, d->s, d->type, d->arr_size);
    }
}

double eval_num(Ast *a) {
    if (a->nodetype == 'I') {
        return ((Numval*)a)->value.ival;
    } else if (a->nodetype == 'F') {
        return ((Numval*)a)->value.fval;
    } else if (a->nodetype == 'V') {
        VARI *v = srch(l1, ((Varval*)a)->var);
        if (v->nodetype == 1) return v->value.ival;
        else return v->value.fval;
    } else if (a->nodetype == 'A') {
        Varval *vv = (Varval*)a;
        VARI *v = srch(l1, vv->var);
        if (v->nodetype == 4) return v->value.iarr[vv->index];
        else return v->value.farr[vv->index];
    } else if (a->nodetype == '+') {
        return eval_num(a->l) + eval_num(a->r);
    } else if (a->nodetype == '-') {
        return eval_num(a->l) - eval_num(a->r);
    } else if (a->nodetype == '*') {
        return eval_num(a->l) * eval_num(a->r);
    } else if (a->nodetype == '/') {
        return eval_num(a->l) / eval_num(a->r);
    } else if (a->nodetype == 'M') {
        return -eval_num(a->l);
    } else {
        printf("Error: invalid numeric expression\n");
        return 0;
    }
}

int eval_int(Ast *a) {
    return (int)eval_num(a);
}

char* eval_str(Ast *a) {
    if (a->nodetype == 'S') {
        return ((Strval*)a)->sval;
    } else if (a->nodetype == 'V') {
        VARI *v = srch(l1, ((Varval*)a)->var);
        if (v->nodetype == 3) return v->value.sval;
        else {
            printf("Error: variable is not a string\n");
            return "";
        }
    } else {
        printf("Error: invalid string expression\n");
        return "";
    }
}

int eval_bool(Ast *a) {
    if (a->nodetype >= '1' && a->nodetype <= '6') {
        double l = eval_num(a->l);
        double r = eval_num(a->r);
        switch(a->nodetype) {
            case '1': return l > r;
            case '2': return l < r;
            case '3': return l != r;
            case '4': return l == r;
            case '5': return l >= r;
            case '6': return l <= r;
        }
    }
    return 0;
}

void eval(Ast *a) {
    if (!a) return;
    
    switch(a->nodetype) {
        case 'D': eval_decl((Decl*)a); break;
        
        case '=': {
            Symasgn *s = (Symasgn*)a;
            VARI *v = srch(l1, s->s);
            if (!v) {
                printf("Error: variable not declared\n");
                break;
            }
            
            if (s->index == -1) { // regular variable
                if (s->type == 1) v->value.ival = eval_int(s->v);
                else if (s->type == 2) v->value.fval = eval_num(s->v);
                else if (s->type == 3) strcpy(v->value.sval, eval_str(s->v));
            } else { // array
                if (v->nodetype == 4) v->value.iarr[s->index] = eval_int(s->v);
                else v->value.farr[s->index] = eval_num(s->v);
            }
            break;
        }
        
        case 'I': // if
            if (eval_bool(((Flow*)a)->cond)) {
                eval(((Flow*)a)->tl);
            } else if (((Flow*)a)->el) {
                eval(((Flow*)a)->el);
            }
            break;
            
        case 'W': // while
            while (eval_bool(((Flow*)a)->cond)) {
                eval(((Flow*)a)->tl);
            }
            break;
            
        case 'P': // print number
            printf("%g\n", eval_num(((Flow*)a)->tl));
            break;
            
        case 'Y': // print string
            printf("%s\n", eval_str(((Flow*)a)->tl));
            break;
            
        case 'L': // statement list
            eval(a->l);
            eval(a->r);
            break;
            
        case 'R': // read number
            break;
            
        case 'T': // read string
            break;
            
        default:
            printf("Error: unknown statement type\n");
    }
}

int yylex();
void yyerror(char *s) {
    printf("%s\n", s);
}

%}

%union{
    float flo;
    int fn;
    int inter;
    char str[50];
    Ast *a;
}

%token <flo> NUM
%token <str> VARS
%token FIM IF ELSE WHILE PRINT PRINTT SCAN SCANS
%token INT FLOAT STRING
%token <fn> CMP

%right '='
%left '+' '-'
%left '*' '/'
%left CMP

%type <a> exp num_exp str_exp stmt list prog

%nonassoc IFX VARPREC DECLPREC NEG VET

%%

val: prog FIM
    ;

prog: stmt { eval($1); }
    | prog stmt { eval($2); }
    ;
    
stmt: 
    | IF '(' exp ')' '{' list '}' %prec IFX { $$ = newflow('I', $3, $6, NULL); }
    | IF '(' exp ')' '{' list '}' ELSE '{' list '}' { $$ = newflow('I', $3, $6, $10); }
    | WHILE '(' exp ')' '{' list '}' { $$ = newflow('W', $3, $6, NULL); }
    
    | INT VARS { $$ = newdecl($2, 1, 0); }
    | FLOAT VARS { $$ = newdecl($2, 2, 0); }
    | STRING VARS { $$ = newdecl($2, 3, 0); }
    | INT VARS '[' NUM ']' { $$ = newdecl($2, 1, (int)$4); }
    | FLOAT VARS '[' NUM ']' { $$ = newdecl($2, 2, (int)$4); }
    
    | VARS '=' num_exp { $$ = newasgn($1, $3, 1, -1); }
    | VARS '=' exp { $$ = newasgn($1, $3, 2, -1); }
    | VARS '=' str_exp { $$ = newasgn($1, $3, 3, -1); }
    | VARS '[' NUM ']' '=' num_exp { $$ = newasgn($1, $6, 1, (int)$3); }
    | VARS '[' NUM ']' '=' exp { $$ = newasgn($1, $6, 2, (int)$3); }
    
    | PRINT '(' num_exp ')' { $$ = newast('P', $3, NULL); }
    | PRINTT '(' str_exp ')' { $$ = newast('Y', $3, NULL); }
    | SCAN '(' VARS ')' { /* Implement read */ }
    | SCANS '(' VARS ')' { /* Implement read string */ }
    ;

list: stmt { $$ = $1; }
    | list stmt { $$ = newast('L', $1, $2); }
    ;
    
exp: 
    num_exp { $$ = $1; }
    | str_exp { $$ = $1; }
    ;
    
num_exp:
    num_exp '+' num_exp { $$ = newast('+', $1, $3); }
    | num_exp '-' num_exp { $$ = newast('-', $1, $3); }
    | num_exp '*' num_exp { $$ = newast('*', $1, $3); }
    | num_exp '/' num_exp { $$ = newast('/', $1, $3); }
    | num_exp CMP num_exp { $$ = newcmp($2, $1, $3); }
    | '(' num_exp ')' { $$ = $2; }
    | '-' num_exp %prec NEG { $$ = newast('M', $2, NULL); }
    | NUM { $$ = newnum_float($1); }
    | VARS { $$ = newvar($1); }
    | VARS '[' NUM ']' { $$ = newvar_array($1, (int)$3); }
    ;
    
str_exp:
    VARS { $$ = newvar($1); }
    | '"' VARS '"' { $$ = newstr($2); }
    ;

%%

#include "lex.yy.c"

int main() {
    yyin = fopen("entrada.txt", "r");
    if (!yyin) {
        printf("Error: cannot open input file\n");
        return 1;
    }
    yyparse();
    fclose(yyin);
    return 0;
}