(* représentation algébrique des symboles d'une grammaire. *)
type symbole =
  | Terminal of char
  | NonTerminal of char
  | Epsilon


(* une grammaire algébrique est définie par : un axiome et des règles*)
type grammaire = {
  axiome: char;
  regle: (char * symbole list list) list;
}

(* constructeur d'une grammaire à partir de son axiome et de ses règles *)
let create_grammar (ax : char) (r : (char * symbole list list) list) = {
  axiome = ax;
  regle = r;
}

(* grammar_to_string g : renvoie la grammaire g sous forme de chaine de caractère*)
(*
let grammar_to_string (g : grammaire) : string =
  let symbole_to_string = function
    | Terminal c -> String.make 1 c
    | NonTerminal c -> String.make 1 c
    | Epsilon -> "ε"
  in

  let production_to_string prod =
    if prod = [] then "ε"
    else String.concat "" (List.map symbole_to_string prod)
  in

  let regle_to_string (nt, prods) =
    let left = String.make 1 nt in
    let right = String.concat " | " (List.map production_to_string prods) in
    left ^ " -> " ^ right
  in

  let terminaux = "Terminaux : {" ^ String.concat ", "
    (List.map (String.make 1) g.alpha_term) ^ "}\n" in
  let non_terminaux = "Non-terminaux : {" ^ String.concat ", "
    (List.map (String.make 1) g.alpha_nterm) ^ "}\n" in
  let axiome_str = "Axiome : " ^ String.make 1 g.axiome ^ "\n" in
  let regles = "Règles :\n  " ^
    String.concat "\n  " (List.map regle_to_string g.regle) in

  terminaux ^ non_terminaux ^ axiome_str ^ regles

*)



(* amm_prods_from_nt : retourne toutes les productions associées au non-terminal n dans la grammaire g. 
	Si n n'apparaît pas dans les règles, retourne la liste vide. *)
let all_prods_from_nt (n : char) (g : grammaire) : symbole list list =
  match List.find_opt (fun (nt, _) -> nt = n) g.regle with
  | Some (_, prods) -> prods
  | None -> []


(* iter_aux ; génère tous les mots dérivables depuis le non-terminal nt
   dont les mesures fl restent sous les bornes bl tout au long de la dérivation.
   Les bornes se décrémentent à chaque non-terminal développé,
   ce qui garantit la terminaison même pour les grammaires récursives. *)
let iter_aux (nt: char) (fl: (string -> int) list) (bl: int list) (g: grammaire) : string list =
  
  let valide mot bl =
    List.for_all2 (fun f b -> f mot <= b) fl bl
  in

  let rec aux symbols mot bl =
    if not (valide mot bl) then []
    else
      match symbols with
      | [] -> [mot]
      | Epsilon :: tl -> aux tl mot bl
      | Terminal c :: tl ->
          aux tl (mot ^ String.make 1 c) bl
      | NonTerminal nt' :: tl ->
          let prods = all_prods_from_nt nt' g in
          (* On décrémente chaque borne à chaque dérivation *)
          let bl' = List.map (fun b -> b - 1) bl in
          List.concat_map (fun prod ->
            aux (prod @ tl) mot bl'
          ) prods
  in
  List.flatten (List.map (fun prod -> aux prod "" bl) (all_prods_from_nt nt g))

(* iter : génère tous les mots du langage de g 
   satisfaisant les contraintes fl et bl,triés et sans doublons.*)
let iter (g: grammaire) (fl: (string -> int) list) (bl: int list) : string list =
  List.sort_uniq String.compare (iter_aux g.axiome fl bl g)



(* grammaire g2 : langage { a^n b^n | n >= 0 } : correspond aux polyominos parallélogrammes rectangulaires. *)
let g2 = create_grammar
  'S'
  [
    ('S', [
      [Terminal 'a'; NonTerminal 'S'; Terminal 'b'];
      [Epsilon]
    ])
  ]

(* grammaire g3 : expressions arithmétiques simples. Sert de grammaire de test, elle ne représente pas de polyominos. *)
let g3 = create_grammar
  'E'
  [
    ('E', [
      [NonTerminal 'E'; Terminal '+'; NonTerminal 'E'];
      [Terminal '('; NonTerminal 'E'; Terminal ')'];
      [Terminal 'a'];
      [Epsilon]
    ])
  ]








(* Fonctions de mesure sur les mots.*)
(* À l'exemple la fonction largueur, ne s'interesse uniquement qu'aux mots de dyck*)


(* Toujours zero : utilisé uniquement pour activer le décrément de bl afin de borner le nombre de dérivations indépendamment du mot *)
let toujours_zero _ = 0 

(* Idem toujours_zero, alias sémantique *)
let nb_deriv _ = 0

