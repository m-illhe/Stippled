%{
    open Ast

    (*Le parseur doit générer des Ast.program.
    Pour les annotation, il vous suffit de créer l’annotation avec [Annotation.create $loc] qui sera ce qu’il vous faut dans tous les cas : $loc est un paramètre qui correspond aux positions délimitant la chaîne de caractères parsée par la règle où il est utilisé, ce qui est exactement ce qu’il faut mettre dans l’annotation.*)
%}


%token <string> ID
%token <int> INT
%token <float> FLOAT
%token <string> STRING
%token <bool> BOOL

%token IF ELSE FOR FOREACH
%token TYPE_INT TYPE_FLOAT TYPE_BOOL TYPE_POS TYPE_COLOR TYPE_POINT TYPE_LIST
%token ADD SUB MUL DIV MOD AND OR EQ NE LT GT LE GE USUB NOT HEAD TAIL FLOOR FLOAT_OF_INT COS SIN
%token SEMICOLON L_PAR R_PAR L_CUR_BRK R_CUR_BRK COMMA DOT
%token Color_accessor Position_accessor X_accessor Y_accessor Blue_accessor Red_accessor Green_accessor
%token EOF


%start <program> main
%%

main:
| EOF { Program([],Block([],Annotation.create $loc)) }