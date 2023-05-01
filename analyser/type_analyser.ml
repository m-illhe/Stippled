open Util
open Ast

(*
    Réalisez ici l’analyse de type d’un programme. Faites une sous-fonction récursive pour les expressions et les statements.

    L’idée est la même que dans le langage du cours : pour chaque élément, commencez par typer ses sous-éléments. Ensuite, en fonction de l’élément et du type de ses sous-éléments, déterminez son type, et placez-le dans l’annotation qui l’accompagne.
    Seules les expressions peuvent ainsi être typées.

    Les fonctions devront manipuler un type_env qui associera chaque variable à son type. Les déclarations fixent ces types et ces types sont vérifiés lors de chaque utilisation d’une variable.

    Attention, les déclarations sont locales à un bloc, vous devez donc utiliser les fonctions Environment.add_layer et Environment.remove_layer pour le gérer.

    Cette fonction doit également effectuer les rapports d’erreur et d’avertissement dans [report].

    Ces fonction font un pattern matching sur leur argument principal et traitent chaque cas séparément. Elles font uniquement des effet de bord.
    Par exemple : type_expression : Ast.type_expr Util.Environment.t -> Util.Error_report.t -> Ast.expression -> Ast.type_expr
    (cette fonction peut également ne rien renvoyer, auquel cas vous devrez avoir une fonction auxiliaire récupérant le type d’une expression déjà typée).

    Vous pouvez également effectuer ici (en même temps ou dans une fonction séparée) une analyse d’initialisation des variables (auquel cas, il faut ajouter un argument supplémentaire à ce qui est décrit ci-dessus).

    Vous préciserez ce que vous avez traité dans votre rapport.
*)



let type_of_binop = function
  | Add | Sub | Mul | Div | Mod -> Type_int
  | Add | Sub | Mul | Div | Mod -> Type_float
  | Add | Sub | Mul | Div | Mod -> Type_pos
  | Add | Sub | Mul | Div | Mod -> Type_point
  | And | Or -> Type_bool
  | Eq | Ne | Le | Ge | Lt | Gt -> Type_bool

let is_comparison_binop = function
  | Eq | Ne | Le | Ge | Lt | Gt -> true
  | _ -> false

let type_of_unop = function 
| USub -> Type_int | USub -> Type_float | Not -> Type_bool 
| Tail -> Type_int | Cos -> Type_float  | Sin -> Type_float
| Floor -> Type_int | Floor -> Type_float | Float_of_int -> Type_int

let rec type_expr report type_env init_env expr  =
  match expr with
  | Constant_i(_, annotation) -> (Annotation.get_type (Annotation.set_type annotation Type_int))
  | Constant_f(_, annotation) -> (Annotation.get_type (Annotation.set_type annotation Type_float))
  | Constant_b(_, annotation) -> (Annotation.get_type (Annotation.set_type annotation Type_bool))
  | Pos(x,y,annotation) -> (let tx, ty = type_expr report type_env init_env x, type_expr report type_env init_env y in (
    match tx, ty with
    | Some Type_int, Some Type_int -> Annotation.get_type (Annotation.set_type annotation Type_pos)
    | _,_ -> Error_report.add_error report (Format.sprintf "Only type int to declare a position", Annotation.get_pos annotation); None
  ))
  | Color(r,g,b,annotation) -> ( let tr,tg,tb = type_expr report type_env init_env r, type_expr report type_env init_env g, type_expr report type_env init_env b  in (
    match tr, tg, tb with 
    | Some Type_int, Some Type_int, Some Type_int -> (Annotation.get_type(Annotation.set_type annotation Type_color))
    | _,_,_ -> Error_report.add_error report (Format.sprintf "Only type int to declare a color", Annotation.get_pos annotation); None
    ))
  | Point(p,c,annotation) -> ( let p, c = type_expr report type_env init_env p, type_expr report type_env init_env c in (
    match p,c with 
    | Some Type_pos, Some Type_color -> (Annotation.get_type(Annotation.set_type annotation Type_point))
    | _,_ -> Error_report.add_error report (Format.sprintf "Need one position and one color to declare a Point ", Annotation.get_pos annotation); None
  ))
  | Binary_operator(op, exp1, exp2, annotation) -> ( let tex1, tex2 = type_expr report type_env init_env exp1, type_expr report type_env init_env exp2 in (
    match tex1, tex2 with 
    | Some t1, Some t2 when (t1 = t2) -> (
      match op with
      | Add | Sub | Mul | Div | Mod ->  if ((t1 <> Type_int) && (t1 <> Type_float) && (t1 <> Type_pos) && (t1 <> Type_color) && (t1 <> Type_point)) then (Error_report.add_error report (Format.sprintf " You can't perform Add, Sub, Mul, Div or Mod on other type that Int, Float, Position, Color or Point ", Annotation.get_pos annotation); None) else (Annotation.get_type (Annotation.set_type annotation t1))
      | Eq | Ne -> (Annotation.get_type (Annotation.set_type annotation Type_bool))
      | And | Or -> if (( t1 <> Type_bool)) then (Error_report.add_error report (Format.sprintf "you can perform And, Or juste on a Boolean type", Annotation.get_pos annotation); None ) else (Annotation.get_type (Annotation.set_type annotation Type_bool))
      | Lt | Gt | Le | Ge -> if ((t1 <> Type_int) && (t1 <> Type_bool) && (t1 <> Type_float)) then (Error_report.add_error report (Format.sprintf "you can perform Lt, Gt, Le or Ge only on int, float or bool", Annotation.get_pos annotation); None ) else (Annotation.get_type (Annotation.set_type annotation t1))
      )
    | Some t1, Some t2 -> Error_report.add_error report (Format.sprintf "you can't apply a binary operator with 2 same type ", Annotation.get_pos annotation); None
    | _,_ -> Error_report.add_error report (Format.sprintf "Unable to determine type of experssion", Annotation.get_pos annotation); None
  ))
  | Unary_operator(op, exp, annotation) -> (let te =  type_expr report type_env init_env exp in(
    match op, te with 
    | Not, Some Type_bool ->  (Annotation.get_type (Annotation.set_type annotation Type_bool))
    | Head, Some (Type_list(t)) -> (Annotation.get_type (Annotation.set_type annotation t))
    | Tail, Some (Type_list(t)) -> (Annotation.get_type (Annotation.set_type annotation (Type_list t)))
    | Floor, Some Type_float -> (Annotation.get_type (Annotation.set_type annotation Type_int))
    | Float_of_int, Some Type_int -> (Annotation.get_type (Annotation.set_type annotation Type_float))
    | Sin, Some Type_float | Cos, Some Type_float  -> (Annotation.get_type (Annotation.set_type annotation Type_float))
    | USub, Some Type_int -> (Annotation.get_type (Annotation.set_type annotation Type_int))
    | USub, Some Type_float -> (Annotation.get_type (Annotation.set_type annotation Type_float))
    | _,_ -> Error_report.add_error report (Format.sprintf "Just the types int, float, bool or list can be perform by Unary_operator", Annotation.get_pos annotation); None
  ))

  | Variable(name, annotation) -> 
    (match Environment.get type_env name with 
      | Some(t) -> 
          if (t <> Type_bool && t <> Type_int && t <> Type_float && t <> Type_pos && t <> Type_point && t <> Type_color) then 
            begin
              Error_report.add_error report (Format.sprintf "this type is not exist", Annotation.get_pos annotation);
              None
            end
          else 
            let t = Annotation.get_type (Annotation.set_type annotation t) in
            begin
              match Environment.get init_env name with
              | Some true -> ()
              | _ ->
                  Error_report.add_warning report
                    (Format.sprintf "%s might be uninitialized" name, Ast.Annotation.get_pos annotation);
                  Util.Environment.add init_env name true
            end;
            t
      | None -> 
          begin
            Error_report.add_error report (Format.sprintf "The variable %s is not declared" name, Annotation.get_pos annotation);
            None
          end
    )
  (* | Variable(name, annotation) -> 
    (match Environment.get type_env name with 
      |Some(t) -> if ((t <> Type_bool) &&  (t <> Type_int) && (t <> Type_float) && (t <> Type_pos) && (t <> Type_point) && (t <> Type_color) )then 
        Error_report.add_error report (Format.sprintf"this type is not exist", Annotation.get_pos annotation); None
      | Some (t) -> let t = Annotation.get_type ((Annotation.set_type annotation t))in 
                    (match Environment.get init_env name with
                        | Some true -> ()
                        | _ ->
                          Error_report.add_warning report
                            (Format.sprintf "%s might be uninitialized" name, Ast.Annotation.get_pos annotation); None
                            (Util.Environment.add init_env name true)) t
      | _ -> Error_report.add_error report (Format.sprintf"The variable %s is not declared" name, Annotation.get_pos annotation); None 
    ) *)
  | Field_accessor(accessor, var , annotation ) -> (let tvar = type_expr report type_env init_env var in (
    match tvar, accessor with 
    | Some Type_pos, (X_accessor | Y_accessor) | Some Type_color, (Red_accessor | Blue_accessor | Green_accessor)  -> (Annotation.get_type (Annotation.set_type annotation (Type_int)))
    | Some Type_point, (Color_accessor) -> (Annotation.get_type (Annotation.set_type annotation (Type_color)))
    | Some Type_point, (Position_accessor) -> (Annotation.get_type (Annotation.set_type annotation (Type_pos)))  
    | _,_ -> Error_report.add_error report (Format.sprintf"accesseurs incompatibles avec cette varaiable", Annotation.get_pos annotation); None 
  ))
  | List(list, annotation) -> (
    match Annotation.get_type annotation with
  | Some t -> Some t
  | _ ->
      match list with
      | [] -> None
      | [x] ->
          let xt = type_expr report type_env init_env x in
          (match xt with
          | Some t -> Some (Type_list t)
          | _ ->
              Error_report.add_error report ("Unable to determine type of the list", Annotation.get_pos annotation);
              None)
      | x::xs ->
          let xt = type_expr report type_env init_env x in
          let xs_type = type_expr report type_env init_env (List (xs, annotation)) in
          (match xt, xs_type with
          | _, None -> None
          | Some tx, Some (Type_list tl) when tx = tl -> Some (Type_list tl)
          | Some tx, Some (Type_list tl) ->
              Error_report.add_error report (Format.sprintf "Non homogenous list (list type: %s, value type: %s)" (Ast.string_of_type_expr tl) (Ast.string_of_type_expr tx), Annotation.get_pos annotation);
              None
          | _, _ ->
              Error_report.add_error report ("Unable to get list or value type", Annotation.get_pos annotation);
              None)
                        )
  | Cons(value,list,annotation) -> 
    let value_type = type_expr report type_env init_env value in
    let list_type = type_expr report type_env init_env list in
    match value_type, list_type with
    | Some tv, Some (Type_list tl) when tv = tl ->
        Annotation.get_type (Annotation.set_type annotation (Type_list tv))
    | Some tv, Some (Type_list tl) ->
        Error_report.add_error report (Format.sprintf "Non homogeneous append (list type: %s, value type: %s)" (Ast.string_of_type_expr tl) (Ast.string_of_type_expr tv), Annotation.get_pos annotation);
        None
    | Some tv, _ ->
        (match list with
        | List([], _) ->
            Annotation.get_type (Annotation.set_type annotation (Type_list tv))
        | List(lst, _) when List.length lst != 0 ->
            Error_report.add_error report ("Unknown error!", Annotation.get_pos annotation);
            None
        | _ ->
            Error_report.add_error report (Format.sprintf "This is not a list! %s" (Ast.string_of_expression list), Annotation.get_pos annotation);
            None)
    | _ ->
        Error_report.add_warning report ("Unable to determine list or value type", Annotation.get_pos annotation);
        None
  


let rec type_statement type_env init_env report statement =
    match statement with 
    | Print(e,a) -> (let _ = type_expr report type_env init_env e in ());
    | Draw(e,a) -> (let _ = type_expr report type_env init_env e in ());
    | Variable_declaration (name,typ,a) ->
      (if (Util.Environment.is_def_in_current_layer type_env name) then
        Util.Error_report.add_error report
          (Format.sprintf "%s was already defined in current bloc" name,Ast.Annotation.get_pos a)
      else (
        Util.Environment.add type_env name typ;
        Util.Environment.add init_env name false))
    | Block(sl,a) -> (Environment.add_layer type_env;
                    Environment.add_layer init_env;
                    List.iter (type_statement type_env init_env report) sl;
                    Environment.remove_layer type_env;
                    Environment.remove_layer init_env)
    | IfThenElse (test, i_if, i_else,a) ->
                      ( let t = type_expr report type_env init_env test in
                          if t <> Some(Type_bool) then
(                            Error_report.add_error report
                              ( Format.sprintf "Type of test is instead of bool",( Ast.Annotation.get_pos a) );)
                          else
                            type_statement type_env init_env  report i_if;
                            type_statement type_env init_env report i_else;
                            )
   | For (name,e1,e2,e3, body,a ) ->
                        if not(Util.Environment.is_def_in_current_layer type_env name) then
                          Util.Error_report.add_error report
                            (Format.sprintf "%s not define in current bloc" name,Ast.Annotation.get_pos a)
                        else
                        let t,t1,t2 = (type_expr report type_env init_env e2),(type_expr report type_env init_env e1),(type_expr report type_env init_env e3) in
                        (if t <> Some(Type_bool) || (t1 <> Some(Type_float) && t1 <> Some(Type_int)) || (t2 <> Some(Type_float) && t2 <> Some(Type_int)) then
                          (Error_report.add_error report
                            ( Format.sprintf "Type of test is instead ",(Ast.Annotation.get_pos a) );)
                        else 
                        type_statement type_env init_env report body)

    | Assignment(var_name, value, assi_anno) -> 
      (match var_name with
        | Variable(name, anno) -> (let variable_type = Environment.get type_env name in
            match variable_type, value with
              | Some Type_list(_), List([], _) -> ()
              | Some t,_ -> if(( Some t <> (type_expr report type_env init_env value))) then Error_report.add_error report (Format.sprintf "operation not available" , Annotation.get_pos assi_anno)
              | _ -> Error_report.add_error report (Format.sprintf "Variable %s undefined" name, Annotation.get_pos anno))
        | Field_accessor(field,_,anno) -> (let field_type, value_type = type_expr report type_env init_env var_name, type_expr report type_env init_env value in 
            match field_type, value_type with
              | Some ft, Some vt when (ft=vt) -> ()
              | Some _, Some vt -> Error_report.add_error report (Format.sprintf "Type %s is invalide for %s fiel accessor" (Ast.string_of_type_expr vt) (Ast.string_of_field_accessor field), Annotation.get_pos anno)
              | _ -> Error_report.add_error report ("Unable to determine type", Annotation.get_pos anno))
              | _ -> Error_report.add_error report ("Error in Assigment first argument is not a variable", Annotation.get_pos assi_anno))

let type_analyser report program =
  let type_environment,init_environment = Environment.new_environment (),Environment.new_environment () in
    match program with
    | Program(args, statement) -> type_statement type_environment init_environment report statement
