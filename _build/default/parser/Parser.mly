%{
    open Ast
%}

%token EOF
%token TYPE_POINT
%token TYPE_COLOR
%token TYPE_POS
%token IF
%token THEN
%token ELSE
%token WHILE
%token FOR
%token L_PAR
%token R_PAR
%token L_CUR_BRK
%token R_CUR_BRK
%token L_SQ_BRK
%token R_SQ_BRK
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token ADD_F
%token SUB_F
%token MUL_F
%token DIV_F
%token MOD_F
%token AND
%token OR
%token NOT
%token EQ
%token NEQ
%token LT
%token GT
%token LEQ
%token GEQ
%token COMMA
%token SEMICOLON
%token ASSIGN
%token DEF
%token DOT
%token PRINT
%token SIZE
%token RETURN
%token TYPE_INT
%token TYPE_FLOAT
%token TYPE_BOOL
%token VAR
%token <string> ID
%token <string> STRING
%token <int> INT
%token <float> FLOAT
%token <bool> BOOL
%left ADD SUB MUL DIV MOD ADD_F SUB_F MUL_F DIV_F MOD_F AND OR 
%nonassoc EQ NEQ LT GT LEQ GEQ
%nonassoc USUB
%nonassoc UNOT
%nonassoc RET 

%start <Result_parser.t> main

%%

main:
| l = function_list EOF { Program (List.rev l) (*Le List.rev est là si vous construisez la liste à l’envers (ce qui arrive si vous le faites avec une associativité à gauche (si vous voulez que l’arbre reste petit)). Si vous la construisez dans le bon sens, retirez le List.rev.*)}
| i = instruction EOF { Instruction i }
| e = expression EOF { Expression e }

function_list:
| func {[$1]}
| func function_list {[$1] @ $2}
|  {[]}
| COMMA {[]}
// | SEMICOLON {[]}
| DEF {[]}
| DOT {[]}
// | PRINT expression {[]}
| RETURN {[]} 
| VAR {[]}
// | INT_TYP {[]}
// | TYPE_FLOAT {[]}
// | TYPE_BOOL {[]}
// | NULL_TYP {[]}
// | L_PAR expression R_PAR {[]}
| L_CUR_BRK expression R_CUR_BRK {[]}
| EOF { (*À retirer -- ici pour éviter les warnings avant de commencer*) []}

func:
| type_base ID L_PAR arg_list R_PAR DEF L_CUR_BRK instr_bloc R_CUR_BRK {Func_decl($1, $2, $4, $8)}

instr_bloc:
| L_CUR_BRK list_of_instruction R_CUR_BRK {Block($2)}

instruction:
| L_CUR_BRK instruction R_CUR_BRK {Block [$2]}
| ID ASSIGN expression {Affect($1, $3)}
| IF expression THEN instruction ELSE instruction {IfThenElse($2, $4, $6)}
| WHILE expression instruction {While($2, $3)}
| ID L_SQ_BRK expression R_SQ_BRK ASSIGN expression {Affect_array($1, $3, $6)}
| TYPE_INT ID L_SQ_BRK expression R_SQ_BRK {Array_decl(TInt, $2, $4)}
| TYPE_FLOAT ID L_SQ_BRK expression R_SQ_BRK {Array_decl(TFloat, $2, $4)}
| TYPE_BOOL ID L_SQ_BRK expression R_SQ_BRK {Array_decl(TBool, $2, $4)}
| L_CUR_BRK list_of_instruction R_CUR_BRK {Block($2)}
| instruction SEMICOLON {$1}

expression:
| i = INT { Cst_i i }
| i = ID {Var i}
| i = STRING {Var i}
| i = FLOAT {Cst_f i}
| i = BOOL {Cst_b i}
| expression ADD expression {Binop(Add, $1, $3)}
| expression SUB expression {Binop(Sub, $1, $3)}
| expression MUL expression {Binop(Mul, $1, $3)}
| expression DIV expression {Binop(Div, $1, $3)}
| expression MOD expression {Binop(Mod, $1, $3)}
| expression ADD_F expression {Binop(Add_f, $1, $3)}
| expression SUB_F expression {Binop(Sub_f, $1, $3)}
| expression MUL_F expression {Binop(Mul_f, $1, $3)}
| expression DIV_F expression {Binop(Div_f, $1, $3)}
| expression MOD_F expression {Binop(Mod_f, $1, $3)}
| expression AND expression {Binop(And, $1, $3)}
| expression OR expression {Binop(Or, $1, $3)}
| expression EQ expression {Binop(Eq, $1, $3)} 
| expression NEQ expression {Binop(Neq, $1, $3)}
| expression LT expression {Binop(Lt, $1, $3)}
| expression GT expression {Binop(Gt, $1, $3)}
| expression LEQ expression {Binop(Leq, $1, $3)}
| expression GEQ expression {Binop(Geq, $1, $3)}
| NOT expression %prec UNOT {Unop(Not, $2)}
| SUB expression %prec USUB {Unop(UMin, $2)}
| SUB_F expression %prec USUB {Unop(UMin_f, $2)}
| ID DOT SIZE {Size_tab($1)}
| ID L_SQ_BRK expression R_SQ_BRK {Array_val($1, $3)}
| L_PAR expression R_PAR {$2}

list_of_instruction:
| instruction  {[$1]}
| instruction list_of_instruction {[$1] @ $2}
| {[]}


arg_list:
| argument {[$1]}
| argument COMMA arg_list {[$1] @ $3}
| {[]}

argument:
| VAR types ID {Reference($2, $3)}
| types ID {Value($1, $2)}

type_base:
| TYPE_INT {TInt}
| TYPE_FLOAT {TFloat}
| TYPE_BOOL{TBool}