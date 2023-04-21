
{
    open Parser
    exception Error of string
}

let digit = ['0'-'9']
let alphanum = ['a'-'z' 'A'-'Z' '0'-'9' '\'' '_']

rule token = parse
    | eof               { EOF }
    | _ as s            { let pos = Lexing.lexeme_start_p lexbuf in raise (Error(Format.sprintf "Line %d, char %d ,Read: '%c'. It is not an acceptable character" pos.pos_lnum (pos.pos_cnum - pos.pos_bol +1) s)) }
    | (digit)+ "." (digit)* as s {FLOAT(try float_of_string s with Failure _ -> raise (Error(s)) )}
    | (digit)+ as s     { INT(try int_of_string s with Failure _ -> raise (Error(s)) )}
    | "\"" ([^ '\"']* as s) "\""  { STRING(s) }
    | ['a'-'z' 'A'-'Z'] (alphanum)* as s  { ID(s) }
    | "if"              { IF } 
    | "else"            { ELSE }
    | "for"             { FOR }
    | "foreach"         { FOREACH }
    | "Int"             { TYPE_INT }
    | "Float"           { TYPE_FLOAT }
    | "Bool"            { TYPE_BOOL }
    | "Pos"             { TYPE_POS }
    | "Color"           { TYPE_COLOR }
    | "Point"           { TYPE_POINT }
    | "List"            { TYPE_LIST }
    | "true"            { BOOL(true) }
    | "false"           { BOOL(false) }
    | "+"               { ADD }
    | "-"               { SUB }
    | "*"               { MUL }
    | "/"               { DIV }
    | "%"               { MOD }
    | "&&"              { AND }
    | "||"              { OR }
    | "="               { EQ }
    | "<>"              { NE }
    | "<"               { LT }
    | ">"               { GT }
    | "<="              { LE }
    | ">="              { GE }
    | "-"               { USUB }  
    | "Not"             { NOT }
    | "Head"            { HEAD }
    | "Tail"            { TAIL }
    | "Floor"           { FLOOR }
    | "Float_of_int"    { FLOAT_OF_INT }
    | "Cos"             { COS }
    | "Sin"             { SIN }
    | ";"               { SEMICOLON }
    | "("               { L_PAR }
    | ")"               { R_PAR }
    | "{"               { L_CUR_BRK }
    | "}"               { R_CUR_BRK }
    | ","               { COMMA }
    | "."               { DOT }
    | "Color_accessor"  { Color_accessor }
    | "Position_accessor"  { Position_accessor }
    | "X"               { X_accessor }
    | "Y"               { Y_accessor }
    | "Blue"            { Blue_accessor }
    | "Red"             { Red_accessor }
    | "Green"           { Green_accessor }