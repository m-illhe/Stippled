%{
    open Ast

    (*Le parseur doit générer des Ast.program.
    Pour les annotation, il vous suffit de créer l’annotation avec [Annotation.create $loc] qui sera ce qu’il vous faut dans tous les cas : $loc est un paramètre qui correspond aux positions délimitant la chaîne de caractères parsée par la règle où il est utilisé, ce qui est exactement ce qu’il faut mettre dans l’annotation.*)
%}

%token IF
%token ELSE
%token FOR
%token FOREACH

%token TYPE_INT
%token TYPE_FLOAT
%token TYPE_BOOL
%token TYPE_POS
%token TYPE_COLOR
%token TYPE_POINT
%token TYPE_LIST

%token FLOAT_OF_INT
%token COS
%token SIN

%token IN
%token FLOOR
%token TO
%token FROM

%token HEAD
%token TAIL
%token STEP
%token DOT

%token AND
%token OR
%token NOT

%token BEGIN
%token END
%token DRAW
%token COPY
%token PRINT

%token EQ
%token NE
%token LT
%token GT
%token LE
%token GE
%token CONS
%token COMMA
%token SEMICOLON

%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token L_SQ_BRK
%token R_SQ_BRK
%token L_PAR
%token R_PAR

%token X_ACCESSOR
%token Y_ACCESSOR
%token BLUE_ACCESSOR
%token RED_ACCESSOR
%token GREEN_ACCESSOR

%token <int> INT
%token <float> FLOAT
%token <bool> BOOL
%token <string> ID
%token EOF


%nonassoc IF
%nonassoc ELSE
%left AND OR CONS
%left EQ NE LT GT LE GE
%left ADD SUB 
%left MUL DIV MOD
%nonassoc NOT DOT

%start <program> main
%%

main:
| LT args = argument_list GT e = statement EOF { Program(List.rev args, e)}
| e = statement EOF { Program([], e)}
| EOF{Program([], Block([], Annotation.create $loc))}




type_expr:
| TYPE_INT   { Type_int }
| TYPE_FLOAT   { Type_float }
| TYPE_BOOL   { Type_bool }
| TYPE_POS   { Type_pos }
| TYPE_COLOR   { Type_color }
| TYPE_POINT   { Type_point }
| TYPE_LIST L_PAR t = type_expr R_PAR { Type_list (t) }


expression:
| i = INT {Constant_i (i,Annotation.create $loc) }
| f = FLOAT {Constant_f (f,Annotation.create $loc) }
| b = BOOL {Constant_b (b,Annotation.create $loc) }
| id = ID {Variable (id,Annotation.create $loc) }
| TYPE_POS L_PAR exp1 = expression COMMA exp2 = expression R_PAR {Pos (exp1,exp2,Annotation.create $loc) }
| TYPE_COLOR L_PAR exp1 = expression COMMA exp2 = expression COMMA exp3 = expression R_PAR {Color (exp1,exp2,exp3,Annotation.create $loc) }
| TYPE_POINT L_PAR exp1 = expression COMMA exp2 = expression R_PAR {Point (exp1,exp2,Annotation.create $loc) }
| exp1 = expression b=binary_operator exp2 = expression {Binary_operator (b,exp1,exp2,Annotation.create $loc) }
| u = unary_operator L_PAR exp1 = expression R_PAR {Unary_operator (u,exp1,Annotation.create $loc) }
| u = not exp1 = expression {Unary_operator (u,exp1,Annotation.create $loc) } %prec NOT
| exp1 = expression DOT f=field_accessor {Field_accessor (f,exp1,Annotation.create $loc) } 
| L_SQ_BRK le =expression_list R_SQ_BRK {List (le,Annotation.create $loc) }
| exp1 = expression CONS exp2 = expression {Cons (exp1,exp2,Annotation.create $loc) }
| L_PAR e = expression R_PAR { e }


statement_list:
| t = statement_list s = statement { s::t }
| { [] }

expression_list:
| expr = expression { [expr] }
| expr = expression COMMA t = expression_list  { expr::t }
| { [] }

argument_list:
| t = argument_list SEMICOLON a = argument { t@[a] }
| a = argument {a :: []}
| { [] }


statement:

| COPY L_PAR exp1 = expression COMMA exp2 = expression R_PAR SEMICOLON {Assignment (exp1,exp2,Annotation.create $loc) }
| COPY L_PAR exp1 = expression COMMA exp2 = expression R_PAR  {Assignment (exp1,exp2,Annotation.create $loc) }

| te = type_expr L_PAR id = ID R_PAR SEMICOLON {Variable_declaration (id,te,Annotation.create $loc) }
| te = type_expr L_PAR id = ID R_PAR {Variable_declaration (id,te,Annotation.create $loc) }


| BEGIN sl = statement_list END SEMICOLON {Block (List.rev sl,Annotation.create $loc) }
| BEGIN sl = statement_list END {Block (List.rev sl,Annotation.create $loc) }

| IF e = expression  s1 = statement ELSE s2 = statement  {IfThenElse (e,s1,s2,Annotation.create $loc) }
| IF e = expression  s1 = statement {IfThenElse(e,s1,(Nop), Annotation.create $loc)}

| FOR name = ID FROM e1 = expression TO e2 = expression STEP e3 = expression  s = statement {For (name,e1,e2,e3,s,Annotation.create $loc) }
| FOREACH name= ID IN e = expression s = statement {Foreach (name,e,s,Annotation.create $loc) }

| DRAW L_PAR e = expression R_PAR SEMICOLON { Draw (e,Annotation.create $loc) }
| DRAW L_PAR e = expression R_PAR { Draw (e,Annotation.create $loc) }

| PRINT L_PAR e = expression R_PAR SEMICOLON { Print(e, Annotation.create $loc ) }
| PRINT L_PAR e = expression R_PAR { Print(e,Annotation.create $loc ) }



argument:
| te = type_expr  name = ID  {Ast.Argument (name,te,Annotation.create $loc)} 


// program:
// | al = argument_list s = statement {Ast.Program ((List.rev al),s)} 

%inline binary_operator:
| ADD   { Add }
| SUB   { Sub }
| MUL   { Mul }
| DIV   { Div }
| MOD   { Mod }
| AND   { And }
| OR    { Or }
| EQ    { Eq }
| NE   { Ne }
| LT    { Lt }
| GT    { Gt }
| LE   { Le }
| GE   { Ge }

%inline unary_operator:
| HEAD   { Head }
| TAIL   { Tail }
| FLOOR   { Floor }
| FLOAT_OF_INT   { Float_of_int }
| COS    { Cos }
| SIN    { Sin }
| SUB   { USub }

%inline not:
| NOT   { Not } 

%inline field_accessor:
| TYPE_COLOR { Color_accessor }
| TYPE_POS { Position_accessor }
| X_ACCESSOR { X_accessor }
| Y_ACCESSOR  { Y_accessor }
| BLUE_ACCESSOR  { Blue_accessor }
| RED_ACCESSOR { Red_accessor }
| GREEN_ACCESSOR { Green_accessor }