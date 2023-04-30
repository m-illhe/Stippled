open Ast
(* Codez ici le simplificateur de termes.

    Tout comme pour le langage du cours, l’idée consiste à remplacer les termes constants par le résultat de leur calcul.

    Faites une sous-fonctions récursive pour les expressions et les statements.
    Ces fonction font un pattern matching sur leur argument et traitent chaque cas séparément. Elles renvoient un argument de même type que celui reçu.
    Par exemple : simplify_expression : Ast.expression -> Ast.expression

    Les cas minimaux attendus sont les cas sur les entiers, les flottants, les booléens, ainsi que les if dont le test est constant, et les for qui ne s’exécutent jamais.

    Deux points qui peuvent vous permettre d’aller plus loin :
      - les expressions ne peuvent pas faire d’effet de bord ici, ce qui permet de simplifier des expressions pas nécessairement constantes.
      - Les types composés (point, position et couleur) peuvent également être simplifiés (e.g., (1,2) + (2,x) peut être simplifié en (3,2+x)).

    Vous détaillerez dans le rapport les différents cas que vous simplifiez dans votre simplificateur.
*)

let rec simplifier program = 
  match program with 
  | Program(args,s) -> Program(args,(simplify_instruction s))


and simplify_expr expr =
    match expr with
    | Binary_operator (op, e1, e2,ano) -> (
        match (op,  e1,  e2) with
        | Add, Constant_i (i1,_), Constant_i (i2,n2) -> Constant_i ((i1 + i2),n2)
        )

and simplify_instruction instruction =
    match instruction with
    | Assignment (name, expr,an) -> Assignment (name,(simplify_expr expr),an)
    | Block (l,an) -> Block ((List.map (fun instr -> simplify_instruction instr) l),an)



