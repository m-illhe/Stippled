open Ast
(* Codez ici le simplificateur de termes.
    Tout comme pour le langage du cours, l’idée consiste à remplacer les termes constants par le résultat de leur calcul.
    Faites une sous-fonctions récursibe pour les expressions et les statements.
    Ces fonction font un pattern matching sur leur argument et traitent chaque cas séparément. Elles renboient un argument de même type que celui reçu.
    Par exemple : simplify_expression : Ast.expression -> Ast.expression
    Les cas minimaux attendus sont les cas sur les entiers, les flottants, les booléens, ainsi que les if dont le test est constant, et les for qui ne s’exécutent jamais.
    Deux points qui peubent bous permettre d’aller plus loin :
      - les expressions ne peubent pas faire d’effet de bord ici, ce qui permet de simplifier des expressions pas nécessairement constantes.
      - Les types composés (point, position et couleur) peubent également être simplifiés (e.g., (1,2) + (2,x) peut être simplifié en (3,2+x)).
    bous détaillerez dans le rapport les différents cas que bous simplifiez dans votre simplificateur.
*)

let rec simplify_expression expr = 
  match expr with 
  |Field_accessor(f,e,a) -> Field_accessor(f,simplify_expression(e),a)
  |Point(e1,e2,a) -> Point(simplify_expression(e1),simplify_expression(e2),a)
  | Pos(exp1, exp2, x) -> Pos(simplify_expression(exp1), simplify_expression(exp2),x)
  | Unary_operator(op,e,anno) -> let e = simplify_expression(e) in (
    match op, e with
    | USub, Constant_i(i, anno2) -> Constant_i(-i,anno2)
    | USub, Constant_f(i, anno2) -> Constant_f(-.i,anno2)
    | Not, Constant_b(b, anno2) -> Constant_b(not b, anno2)
    | Floor, Constant_f(f, anno2) -> Constant_i(int_of_float f, anno2)
    | Float_of_int, Constant_i(i, anno2) -> Constant_f(float_of_int i, anno2)
    | Cos, Constant_f(f, anno2) -> Constant_f(cos(f), anno2)
    | Sin, Constant_f(f, anno2) -> Constant_f(sin(f), anno2)
    | _ -> Unary_operator(op, e, anno)
  ) 
  | Binary_operator(op, e1, e2, anno) -> let e1, e2 = simplify_expression(e1), simplify_expression(e2) in (
    match e1, e2 with
    | Constant_i(i1, _), Constant_i(i2, _) -> (
      match op with
      | Add -> Constant_i(i1+i2, anno)
      | Sub -> Constant_i(i1-i2, anno)
      | Mul -> Constant_i(i1*i2, anno)
      | Div -> Constant_i(i1/i2, anno)
      | Mod -> Constant_i(i1 mod i2, anno)
      | Eq -> Constant_b(i1 = i2, anno)
      | Ne -> Constant_b(i1 != i2, anno)
      | Lt -> Constant_b(i1 < i2, anno)
      | Gt -> Constant_b(i1 > i2, anno)
      | Le -> Constant_b(i1 <= i2, anno)
      | Ge -> Constant_b(i1 >= i2, anno)
      | _ -> Binary_operator(op, e1, e2, anno)
    )
    |Constant_f(f1, _), Constant_f(f2, _) -> (
        match op with
        | Add -> Constant_f(f1+.f2, anno)
        | Sub -> Constant_f(f1-.f2, anno)
        | Mul -> Constant_f(f1*.f2, anno)
        | Div -> Constant_f(f1/.f2, anno)
        | Mod -> Constant_f(mod_float f1 f2, anno)
        | Eq -> Constant_b(f1 = f2, anno)
        | Ne -> Constant_b(f1 != f2, anno)
        | Lt -> Constant_b(f1 < f2, anno)
        | Gt -> Constant_b(f1 > f2, anno)
        | Le -> Constant_b(f1 <= f2, anno)
        | Ge -> Constant_b(f1 >= f2, anno)
        | _ -> Binary_operator(op, e1, e2, anno)
    )
    | Constant_b(b, _), Constant_b(v, _) -> (
        match op with
        | And -> Constant_b(b && v, anno)
        | Or -> Constant_b(b || v, anno)
        | Eq -> Constant_b(b = v, anno)
        | Ne -> Constant_b(b != v, anno)
        | Lt -> Constant_b(b < v, anno)
        | Gt -> Constant_b(b > v, anno)
        | Le -> Constant_b(b <= v, anno)
        | Ge -> Constant_b(b >= v, anno)
        | _ -> Binary_operator(op, e1, e2, anno)
    )
    | Pos(x1,y1,_), Pos(x2,y2,_) -> (
      match op with 
      | Add | Sub | Mul | Div | Mod -> let x, y = simplify_expression(Binary_operator(op, x1, x2, anno)), simplify_expression(Binary_operator(op, y1, y2, anno)) in Pos(x,y,anno)
      | Eq -> let x1, x2, y1, y2 = simplify_expression x1, simplify_expression x2, simplify_expression y1, simplify_expression y2 in (
        match x1, x2, y1, y2 with
        | Constant_i(x1, _), Constant_i(x2, _), Constant_i(y1, _), Constant_i(y2, _) -> Constant_b(((x1 = x2) && (y1 = y2)), anno)
        | _ -> Binary_operator(op, e1, e2, anno) 
      )
      | Ne -> let x1, x2, y1, y2 = simplify_expression x1, simplify_expression x2, simplify_expression y1, simplify_expression y2 in (
          match x1, x2, y1, y2 with
          | Constant_i(x1, _), Constant_i(x2, _), Constant_i(y1, _), Constant_i(y2, _) -> Constant_b(((x1 != x2) || (y1 != y2)), anno)
          | _ -> Binary_operator(op, e1, e2, anno)
        )  
      | _ -> Binary_operator(op, e1, e2, anno)
    )
    | Color(r,g,b,_), Color(h,s,v,_) -> (
      match op with
      | Add | Sub | Mul | Div | Mod -> let r,g,b = simplify_expression(Binary_operator(op, r, h, anno)), simplify_expression(Binary_operator(op, g, s, anno)), simplify_expression(Binary_operator(op, b, v, anno)) in Color(r,g,b,anno)
      | Eq -> let r, h, g, s, b, v = simplify_expression r, simplify_expression h, simplify_expression g, simplify_expression s, simplify_expression b, simplify_expression v in (
        match r, g, b, h, s, v with
        | Constant_i(r, _), Constant_i(g, _), Constant_i(b, _), Constant_i(h, _), Constant_i(s, _), Constant_i(v, _) -> Constant_b(((r = h) && (g = s) && (b = v)), anno)
        | _ -> Binary_operator(op, e1, e2, anno)
      )
      | Ne -> let r, h, g, s, b, v = simplify_expression r, simplify_expression h, simplify_expression g, simplify_expression s, simplify_expression b, simplify_expression v in (
        match r, g, b, h, s, v with
        | Constant_i(r, _), Constant_i(g, _), Constant_i(b, _), Constant_i(h, _), Constant_i(s, _), Constant_i(v, _) -> Constant_b(((r != h) || (g != s) || (b != v)), anno)
        | _ -> Binary_operator(op, e1, e2, anno)
      )      
      | _ -> Binary_operator(op, e1, e2, anno)
    )
    | Point(p1, c1, _), Point(p2, c2, _) -> (
      match op with
      | Add | Sub | Mul | Div | Mod ->  let pos, col = simplify_expression(Binary_operator(op, p1, p2, anno)), simplify_expression(Binary_operator(op, c1, c2, anno)) in Point(pos, col, anno)
      | Eq -> let pos_b, col_b = simplify_expression(Binary_operator(op, p1, p2, anno)), simplify_expression(Binary_operator(op, c1, c2, anno)) in (
        match pos_b, col_b with
        | Constant_b(p, _), Constant_b(c, _) -> Constant_b((p && c), anno)
        | _ -> Binary_operator(op, e1, e2, anno)
      )
      | Ne -> let pos_b, col_b = simplify_expression(Binary_operator(op, p1, p2, anno)), simplify_expression(Binary_operator(op, c1, c2, anno)) in (
        match pos_b, col_b with
        | Constant_b(p, _), Constant_b(c, _) -> Constant_b(not(p && c), anno)
        | _ -> Binary_operator(op, e1, e2, anno)
      )     | _ -> Binary_operator(op, e1, e2, anno)
    )
    | _ -> Binary_operator(op, e1, e2, anno)
  )
  | a -> a


let rec statement_simplifier statement = 
  match statement with
  | Assignment(expr,expr2,anno) -> Assignment(expr, simplify_expression expr2, anno)
  | Block(st_list, anno) -> let l2 = (List.map statement_simplifier st_list) in Block(l2, anno)
  | IfThenElse(test, if_pt, else_pt, anno) -> let t = simplify_expression test in
    let if_pt, else_pt = statement_simplifier if_pt, statement_simplifier else_pt in
    (match t with
    | Constant_b(b,_) -> if b then (if_pt) else (else_pt)
    | _ -> IfThenElse(test, if_pt, else_pt, anno))
  | For(str, init, target, step, body, anno) -> (let init, target = simplify_expression init, simplify_expression target in 
    match init, target with
    | Constant_i(i, _), Constant_i(t, _) -> if (i >= t) then Nop else For(str, init, target,simplify_expression step,statement_simplifier body, anno)
    | Constant_f(i, _), Constant_f(t, _) -> if (i >= t) then Nop else For(str, init, target,simplify_expression step,statement_simplifier body, anno)
    | _,_ -> For(str, init, target,simplify_expression step,statement_simplifier body, anno))
  | Foreach(str, list, body, anno) -> (let list = simplify_expression list in 
                                        match list with
                                        | List(l,_) -> if (List.length l == 0) then Nop else Foreach(str, list, statement_simplifier body, anno)
                                        | _ -> Foreach(str, list, statement_simplifier body, anno))
  | Draw(point, anno) -> Draw(simplify_expression point, anno)
  | Print(expr, anno) -> Print(simplify_expression expr, anno)
  | a -> a
let simplifier program = 
  match program with
  |Program(arg_list, statement) -> Program(arg_list, statement_simplifier statement)
