
(* This generated code requires the following version of MenhirLib: *)

let () =
  MenhirLib.StaticVersion.require_20211128

module MenhirBasics = struct
  
  exception Error
  
  let _eRR : exn =
    Error
  
  type token = 
    | Y_accessor
    | X_accessor
    | USUB
    | TYPE_POS
    | TYPE_POINT
    | TYPE_LIST
    | TYPE_INT
    | TYPE_FLOAT
    | TYPE_COLOR
    | TYPE_BOOL
    | TAIL
    | SUB
    | STRING of (
# 12 "parser/Parser.mly"
       (string)
# 31 "parser/Parser.ml"
  )
    | SIN
    | SEMICOLON
    | Red_accessor
    | R_PAR
    | R_CUR_BRK
    | Position_accessor
    | OR
    | NOT
    | NE
    | MUL
    | MOD
    | L_PAR
    | L_CUR_BRK
    | LT
    | LE
    | INT of (
# 10 "parser/Parser.mly"
       (int)
# 51 "parser/Parser.ml"
  )
    | IF
    | ID of (
# 9 "parser/Parser.mly"
       (string)
# 57 "parser/Parser.ml"
  )
    | HEAD
    | Green_accessor
    | GT
    | GE
    | FOREACH
    | FOR
    | FLOOR
    | FLOAT_OF_INT
    | FLOAT of (
# 11 "parser/Parser.mly"
       (float)
# 70 "parser/Parser.ml"
  )
    | EQ
    | EOF
    | ELSE
    | DOT
    | DIV
    | Color_accessor
    | COS
    | COMMA
    | Blue_accessor
    | BOOL of (
# 13 "parser/Parser.mly"
       (bool)
# 84 "parser/Parser.ml"
  )
    | AND
    | ADD
  
end

include MenhirBasics

# 1 "parser/Parser.mly"
  
    open Ast

    (*Le parseur doit générer des Ast.program.
    Pour les annotation, il vous suffit de créer l’annotation avec [Annotation.create $loc] qui sera ce qu’il vous faut dans tous les cas : $loc est un paramètre qui correspond aux positions délimitant la chaîne de caractères parsée par la règle où il est utilisé, ce qui est exactement ce qu’il faut mettre dans l’annotation.*)

# 100 "parser/Parser.ml"

module Tables = struct
  
  include MenhirBasics
  
  let token2terminal : token -> int =
    fun _tok ->
      match _tok with
      | ADD ->
          52
      | AND ->
          51
      | BOOL _ ->
          50
      | Blue_accessor ->
          49
      | COMMA ->
          48
      | COS ->
          47
      | Color_accessor ->
          46
      | DIV ->
          45
      | DOT ->
          44
      | ELSE ->
          43
      | EOF ->
          42
      | EQ ->
          41
      | FLOAT _ ->
          40
      | FLOAT_OF_INT ->
          39
      | FLOOR ->
          38
      | FOR ->
          37
      | FOREACH ->
          36
      | GE ->
          35
      | GT ->
          34
      | Green_accessor ->
          33
      | HEAD ->
          32
      | ID _ ->
          31
      | IF ->
          30
      | INT _ ->
          29
      | LE ->
          28
      | LT ->
          27
      | L_CUR_BRK ->
          26
      | L_PAR ->
          25
      | MOD ->
          24
      | MUL ->
          23
      | NE ->
          22
      | NOT ->
          21
      | OR ->
          20
      | Position_accessor ->
          19
      | R_CUR_BRK ->
          18
      | R_PAR ->
          17
      | Red_accessor ->
          16
      | SEMICOLON ->
          15
      | SIN ->
          14
      | STRING _ ->
          13
      | SUB ->
          12
      | TAIL ->
          11
      | TYPE_BOOL ->
          10
      | TYPE_COLOR ->
          9
      | TYPE_FLOAT ->
          8
      | TYPE_INT ->
          7
      | TYPE_LIST ->
          6
      | TYPE_POINT ->
          5
      | TYPE_POS ->
          4
      | USUB ->
          3
      | X_accessor ->
          2
      | Y_accessor ->
          1
  
  and error_terminal =
    0
  
  and token2value : token -> Obj.t =
    fun _tok ->
      match _tok with
      | ADD ->
          Obj.repr ()
      | AND ->
          Obj.repr ()
      | BOOL _v ->
          Obj.repr _v
      | Blue_accessor ->
          Obj.repr ()
      | COMMA ->
          Obj.repr ()
      | COS ->
          Obj.repr ()
      | Color_accessor ->
          Obj.repr ()
      | DIV ->
          Obj.repr ()
      | DOT ->
          Obj.repr ()
      | ELSE ->
          Obj.repr ()
      | EOF ->
          Obj.repr ()
      | EQ ->
          Obj.repr ()
      | FLOAT _v ->
          Obj.repr _v
      | FLOAT_OF_INT ->
          Obj.repr ()
      | FLOOR ->
          Obj.repr ()
      | FOR ->
          Obj.repr ()
      | FOREACH ->
          Obj.repr ()
      | GE ->
          Obj.repr ()
      | GT ->
          Obj.repr ()
      | Green_accessor ->
          Obj.repr ()
      | HEAD ->
          Obj.repr ()
      | ID _v ->
          Obj.repr _v
      | IF ->
          Obj.repr ()
      | INT _v ->
          Obj.repr _v
      | LE ->
          Obj.repr ()
      | LT ->
          Obj.repr ()
      | L_CUR_BRK ->
          Obj.repr ()
      | L_PAR ->
          Obj.repr ()
      | MOD ->
          Obj.repr ()
      | MUL ->
          Obj.repr ()
      | NE ->
          Obj.repr ()
      | NOT ->
          Obj.repr ()
      | OR ->
          Obj.repr ()
      | Position_accessor ->
          Obj.repr ()
      | R_CUR_BRK ->
          Obj.repr ()
      | R_PAR ->
          Obj.repr ()
      | Red_accessor ->
          Obj.repr ()
      | SEMICOLON ->
          Obj.repr ()
      | SIN ->
          Obj.repr ()
      | STRING _v ->
          Obj.repr _v
      | SUB ->
          Obj.repr ()
      | TAIL ->
          Obj.repr ()
      | TYPE_BOOL ->
          Obj.repr ()
      | TYPE_COLOR ->
          Obj.repr ()
      | TYPE_FLOAT ->
          Obj.repr ()
      | TYPE_INT ->
          Obj.repr ()
      | TYPE_LIST ->
          Obj.repr ()
      | TYPE_POINT ->
          Obj.repr ()
      | TYPE_POS ->
          Obj.repr ()
      | USUB ->
          Obj.repr ()
      | X_accessor ->
          Obj.repr ()
      | Y_accessor ->
          Obj.repr ()
  
  and default_reduction =
    (2, "$")
  
  and error =
    (53, "\000\000\000\000\000 \000\000\000\000\000\000\000\000\000\000\000\000\000\000")
  
  and start =
    1
  
  and action =
    ((8, "U\000\000"), (4, "p"))
  
  and lhs =
    (1, "@")
  
  and goto =
    ((2, "\192"), (2, "\192"))
  
  and semantic_action =
    [|
      (fun _menhir_env ->
        let _menhir_stack = _menhir_env.MenhirLib.EngineTypes.stack in
        let {
          MenhirLib.EngineTypes.state = _menhir_s;
          MenhirLib.EngineTypes.semv = _1;
          MenhirLib.EngineTypes.startp = _startpos__1_;
          MenhirLib.EngineTypes.endp = _endpos__1_;
          MenhirLib.EngineTypes.next = _menhir_stack;
        } = _menhir_stack in
        let _1 : unit = Obj.magic _1 in
        let _endpos__0_ = _menhir_stack.MenhirLib.EngineTypes.endp in
        let _startpos = _startpos__1_ in
        let _endpos = _endpos__1_ in
        let _v =
          let _endpos = _endpos__1_ in
          let _startpos = _startpos__1_ in
          let _loc = (_startpos, _endpos) in
          (
# 27 "parser/Parser.mly"
      ( Program([],Block([],Annotation.create _loc)) )
# 365 "parser/Parser.ml"
           : (Ast.program))
        in
        {
          MenhirLib.EngineTypes.state = _menhir_s;
          MenhirLib.EngineTypes.semv = Obj.repr _v;
          MenhirLib.EngineTypes.startp = _startpos;
          MenhirLib.EngineTypes.endp = _endpos;
          MenhirLib.EngineTypes.next = _menhir_stack;
        });
    |]
  
  and trace =
    None
  
end

module MenhirInterpreter = struct
  
  module ET = MenhirLib.TableInterpreter.MakeEngineTable (Tables)
  
  module TI = MenhirLib.Engine.Make (ET)
  
  include TI
  
  module Symbols = struct
    
    type _ terminal = 
      | T_error : unit terminal
      | T_Y_accessor : unit terminal
      | T_X_accessor : unit terminal
      | T_USUB : unit terminal
      | T_TYPE_POS : unit terminal
      | T_TYPE_POINT : unit terminal
      | T_TYPE_LIST : unit terminal
      | T_TYPE_INT : unit terminal
      | T_TYPE_FLOAT : unit terminal
      | T_TYPE_COLOR : unit terminal
      | T_TYPE_BOOL : unit terminal
      | T_TAIL : unit terminal
      | T_SUB : unit terminal
      | T_STRING : (
# 12 "parser/Parser.mly"
       (string)
# 409 "parser/Parser.ml"
    ) terminal
      | T_SIN : unit terminal
      | T_SEMICOLON : unit terminal
      | T_Red_accessor : unit terminal
      | T_R_PAR : unit terminal
      | T_R_CUR_BRK : unit terminal
      | T_Position_accessor : unit terminal
      | T_OR : unit terminal
      | T_NOT : unit terminal
      | T_NE : unit terminal
      | T_MUL : unit terminal
      | T_MOD : unit terminal
      | T_L_PAR : unit terminal
      | T_L_CUR_BRK : unit terminal
      | T_LT : unit terminal
      | T_LE : unit terminal
      | T_INT : (
# 10 "parser/Parser.mly"
       (int)
# 429 "parser/Parser.ml"
    ) terminal
      | T_IF : unit terminal
      | T_ID : (
# 9 "parser/Parser.mly"
       (string)
# 435 "parser/Parser.ml"
    ) terminal
      | T_HEAD : unit terminal
      | T_Green_accessor : unit terminal
      | T_GT : unit terminal
      | T_GE : unit terminal
      | T_FOREACH : unit terminal
      | T_FOR : unit terminal
      | T_FLOOR : unit terminal
      | T_FLOAT_OF_INT : unit terminal
      | T_FLOAT : (
# 11 "parser/Parser.mly"
       (float)
# 448 "parser/Parser.ml"
    ) terminal
      | T_EQ : unit terminal
      | T_EOF : unit terminal
      | T_ELSE : unit terminal
      | T_DOT : unit terminal
      | T_DIV : unit terminal
      | T_Color_accessor : unit terminal
      | T_COS : unit terminal
      | T_COMMA : unit terminal
      | T_Blue_accessor : unit terminal
      | T_BOOL : (
# 13 "parser/Parser.mly"
       (bool)
# 462 "parser/Parser.ml"
    ) terminal
      | T_AND : unit terminal
      | T_ADD : unit terminal
    
    type _ nonterminal = 
      | N_main : (Ast.program) nonterminal
    
  end
  
  include Symbols
  
  include MenhirLib.InspectionTableInterpreter.Make (Tables) (struct
    
    include TI
    
    include Symbols
    
    include MenhirLib.InspectionTableInterpreter.Symbols (Symbols)
    
    let terminal =
      fun t ->
        match t with
        | 0 ->
            X (T T_error)
        | 1 ->
            X (T T_Y_accessor)
        | 2 ->
            X (T T_X_accessor)
        | 3 ->
            X (T T_USUB)
        | 4 ->
            X (T T_TYPE_POS)
        | 5 ->
            X (T T_TYPE_POINT)
        | 6 ->
            X (T T_TYPE_LIST)
        | 7 ->
            X (T T_TYPE_INT)
        | 8 ->
            X (T T_TYPE_FLOAT)
        | 9 ->
            X (T T_TYPE_COLOR)
        | 10 ->
            X (T T_TYPE_BOOL)
        | 11 ->
            X (T T_TAIL)
        | 12 ->
            X (T T_SUB)
        | 13 ->
            X (T T_STRING)
        | 14 ->
            X (T T_SIN)
        | 15 ->
            X (T T_SEMICOLON)
        | 16 ->
            X (T T_Red_accessor)
        | 17 ->
            X (T T_R_PAR)
        | 18 ->
            X (T T_R_CUR_BRK)
        | 19 ->
            X (T T_Position_accessor)
        | 20 ->
            X (T T_OR)
        | 21 ->
            X (T T_NOT)
        | 22 ->
            X (T T_NE)
        | 23 ->
            X (T T_MUL)
        | 24 ->
            X (T T_MOD)
        | 25 ->
            X (T T_L_PAR)
        | 26 ->
            X (T T_L_CUR_BRK)
        | 27 ->
            X (T T_LT)
        | 28 ->
            X (T T_LE)
        | 29 ->
            X (T T_INT)
        | 30 ->
            X (T T_IF)
        | 31 ->
            X (T T_ID)
        | 32 ->
            X (T T_HEAD)
        | 33 ->
            X (T T_Green_accessor)
        | 34 ->
            X (T T_GT)
        | 35 ->
            X (T T_GE)
        | 36 ->
            X (T T_FOREACH)
        | 37 ->
            X (T T_FOR)
        | 38 ->
            X (T T_FLOOR)
        | 39 ->
            X (T T_FLOAT_OF_INT)
        | 40 ->
            X (T T_FLOAT)
        | 41 ->
            X (T T_EQ)
        | 42 ->
            X (T T_EOF)
        | 43 ->
            X (T T_ELSE)
        | 44 ->
            X (T T_DOT)
        | 45 ->
            X (T T_DIV)
        | 46 ->
            X (T T_Color_accessor)
        | 47 ->
            X (T T_COS)
        | 48 ->
            X (T T_COMMA)
        | 49 ->
            X (T T_Blue_accessor)
        | 50 ->
            X (T T_BOOL)
        | 51 ->
            X (T T_AND)
        | 52 ->
            X (T T_ADD)
        | _ ->
            assert false
    
    and nonterminal =
      fun nt ->
        match nt with
        | 1 ->
            X (N N_main)
        | _ ->
            assert false
    
    and lr0_incoming =
      (8, "\000V\003")
    
    and rhs =
      ((8, "\003V"), (2, "\024"))
    
    and lr0_core =
      (2, "\024")
    
    and lr0_items =
      ((16, "\000\000\004\001\000\001"), (2, "\027"))
    
    and nullable =
      "\000"
    
    and first =
      (53, "\000\000\000\000\000 \000\000\000\000\000\001\000\000")
    
  end) (ET) (TI)
  
end

let main =
  fun lexer lexbuf ->
    (Obj.magic (MenhirInterpreter.entry `Legacy 0 lexer lexbuf) : (Ast.program))

module Incremental = struct
  
  let main =
    fun initial_position ->
      (Obj.magic (MenhirInterpreter.start 0 initial_position) : (Ast.program) MenhirInterpreter.checkpoint)
  
end
