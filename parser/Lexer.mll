{
    open Parser
    exception Error of string
}
let digit = ['0'-'9']
let alphanum = ['a'-'z' 'A'-'Z' '0'-'9' '\'' '_']

rule token = parse
    | '\n'              { Lexing.new_line lexbuf ; token lexbuf }
    | "//" [^ '\n']* '\n' {Lexing.new_line lexbuf; token lexbuf}
    | "/*"              {commentary lexbuf}
    | "If"              { IF } 
    | "Else"            { ELSE }
    | "For"             { FOR }
    | "Foreach"         { FOREACH }
    | "Int"             { TYPE_INT }
    | "Float"           { TYPE_FLOAT }
    | "Bool"            { TYPE_BOOL }
    | "Pos"             { TYPE_POS }
    | "Color"           { TYPE_COLOR }
    | "Point"           { TYPE_POINT }
    | "List"            { TYPE_LIST }
    | "True"            { BOOL(true) }
    | "False"           { BOOL(false) }
    | "Pi"              { PI }
    | "Float_of_int"    { FLOAT_OF_INT }
    | "And"              { AND }
    | "Or"              { OR }
    | "Not"             { NOT }
    | "Begin"              { BEGIN }
    | "End"             { END }
    | "Draw"              { DRAW }
    | "Copy"              { COPY }
    | "Print"              { PRINT }
    | "Cos"             { COS }
    | "Sin"             { SIN }
    | "In"             { IN }
    | "Floor"             { FLOOR }
    | "To"             { TO }
    | "From"             { FROM }
    | "Head"            { HEAD }
    | "Tail"            { TAIL }
    | "Step"            { STEP }
    | ";"               { SEMICOLON }
    | "("               { L_PAR }
    | ")"               { R_PAR }
    | "["               { L_SQ_BRK }
    | "]"               { R_SQ_BRK }
    | ","               { COMMA }
    | "+"               { ADD }
    | "-"               { SUB }
    | "*"               { MUL }
    | "/"               { DIV }
    | "%"               { MOD }
    | "="               { EQ }
    | "<>"              { NE }
    | "<"               { LT }
    | ">"               { GT }
    | "<="              { LE }
    | ">="              { GE }
    | "::"              { CONS }
    | "."               { DOT }
    | "X"               { X_ACCESSOR }
    | "Y"               { Y_ACCESSOR }
    | "Blue"            { BLUE_ACCESSOR }
    | "Red"             { RED_ACCESSOR }
    | "Green"           { GREEN_ACCESSOR }


    | [' ' '\t' '\r']   {token lexbuf}
    | (digit)* "." (digit)* as s {FLOAT(try float_of_string s with Failure _ -> raise (Error(s)) )}
    | (digit)+ as s     { INT(try int_of_string s with Failure _ ->(let pos = Lexing.lexeme_start_p lexbuf in raise (Error(Format.sprintf "Line %d, char %d ,Read: '%s'. It is not a valid integer" pos.pos_lnum (pos.pos_cnum - pos.pos_bol +1) s)) ))}
    | eof               { EOF }
    | ['a'-'z' 'A'-'Z'] (alphanum)* as s  { ID(s) }
    | _ as s            { let pos = Lexing.lexeme_start_p lexbuf in raise (Error(Format.sprintf "Line %d, char %d ,Read: '%c'. It is not an acceptable character" pos.pos_lnum (pos.pos_cnum - pos.pos_bol +1) s)) }
    
    and commentary = parse
    | '\n'      {Lexing.new_line lexbuf; commentary lexbuf}
    | "*/"      { token lexbuf }
    | _ { commentary lexbuf }