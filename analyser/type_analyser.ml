open Util
open Ast

(*
    Réalisez ici l’analyse de type d’un programme. Faites une sous-fonction récursive pour les expressions et les statements.

    L’idée est la même que dans le langage du cours : pour chaque élément, commencez par typer ses sous-éléments. Ensuite, en fonction de l’élément et du type de ses sous-éléments, déterminez son type, et placez-le dans l’annotation qui l’accompagne.
    Seules les expressions peuvent ainsi être typées.

    Les fonctions devront manipuler un environnement qui associera chaque variable à son type. Les déclarations fixent ces types et ces types sont vérifiés lors de chaque utilisation d’une variable.

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

let rec type_expr report (expr, annotation) =
  let pos = Annotation.get_pos annotation in
  match expr with 
  | Constant_i(_,_) -> Annotation.set_type annotation Type_int
  | Constant_f(_,_) -> Annotation.set_type annotation Type_float
  | Constant_b(_,_) -> Annotation.set_type annotation Type_bool
  | Pos(_,_,_) -> Annotation.set_type annotation Type_pos
  | Color(_,_,_,_) -> Annotation.set_type annotation Type_color
  | Point(_,_,_) -> Annotation.set_type annotation Type_point
  (* | List(_,_) -> Annotation.set_type Type_list *)


(* let rec type_statement report (statement, annotation) =
  let pos = Annotation.get_pos annotation in
    match statement with *)
    (* | Variable_declaration(name,ty) -> Variable_declaration(name,type_expr ty) *)

let type_analyser report program =
  let type_environment = Environment.new_environment () in
  Environment.add type_environment "x" Type_int;
  Error_report.add_warning report
    ("sample_warning", (Lexing.dummy_pos, Lexing.dummy_pos));
  match program with _ -> ()
