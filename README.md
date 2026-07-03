<h1 align="center">Dans le cadre de mon stage de licence</h1>

# Énumération des polyominos reposant sur les grammaires algébriques (Méthode DSV)

On propose ici une implémentation fonctionnelle en OCaml de la méthode DSV (Delest-Viennot)
pour énumérer des polyominos au travers de grammaires algébriques.
Réalisé durant mon stage de recherche au laboratoire **GR2IF** (Groupe de Recherche Rouennais en 
Informatique Fondamentale), Université de Rouen.

# Qu'est-ce qu'un polyomino ?

Les polyominos sont des figures géométriques discrètes formées de cellules carrées connexes.
Leur énumération est un problème central en combinatoire, avec des applications en physique 
statistique, modélisation de percolation, repliement de protéines, ou encore en informatique 
dans des problèmes de compression ou de pavage.

![Figure d'un polyomino](assets/polyomino.svg)

**À ce jour, il est impossible d'énumérer tous les polyominos.** Le nombre total de polyominos
de taille n croît exponentiellement, et aucune formule close ni série génératrice n'est connue
pour la classe entière. C'est un problème ouvert depuis plus de 60 ans.

La méthode DSV ne résout pas ce problème général, elle offre un cadre rigoureux pour énumérer
certaines **sous-classes bien choisies**.
# La méthode DSV

La méthode DSV consiste à établir une bijection entre les mots générés par une grammaire 
algébrique et des polyominos. Dès lors que cette bijection est établie, on traduit la grammaire
en un système d'équations sur les séries formelles.

Pour chaque non-terminal $A_i$, on associe une série formelle $F_i(x, y)$ où $x$ et $y$ 
marquent respectivement la largeur et la hauteur du polyomino. On obtient alors un système 
d'équations polynomiales :

$$F_1(x, y) = P_1(x, y, F_1, \dots, F_n)$$

$$\vdots$$

$$F_n(x, y) = P_n(x, y, F_1, \dots, F_n)$$

où chaque $P_i$ est un polynôme reflétant les productions de la grammaire :
- un **terminal** $a$ contribue par un facteur $x$ ou $y$ selon sa nature
- un **non-terminal** $A_j$ contribue par $F_j(x, y)$
- la **concaténation** devient un produit, l'**union** devient une somme

Par exemple, pour la grammaire $S \to aSb \mid \varepsilon$ correspondant aux 
polyominos parallélogrammes rectangulaires :

$$F(x, y) = x \cdot y \cdot F(x, y) + 1$$

Ce qui donne par résolution :

$$F(x, y) = \frac{1}{1 - xy}$$

Dans le cas général, le système est résolu par **substitution**, **point fixe** 
ou **méthode du noyau**, pour obtenir une expression explicite de $F(x,y)$.
On prouve alors que $F(x,y)$ est une **série algébrique**, ce qui constitue le 
résultat central de la méthode DSV.

# Caractéristiques

- Définir une grammaire algébrique avec terminaux, non-terminaux et epsilon
- Générer tous les mots d'une grammaire selon des bornes configurables
- Filtrage paramétré à l'aide de fonctions de mesure (`fl`) et de bornes (`bl`)
- Gestion des grammaires récursives et ambiguës sans débordement de pile

# Fonctionnement

La fonction principale **iter** prend en argument une grammaire `g`, une liste de fonctions 
de mesure `fl` et une liste de bornes `bl`, toutes deux de même longueur.

À chaque nouvelle dérivation, l'invariant **∀ i, fl[i](w) ≤ bl[i]** est vérifié.
Si l'invariant n'est plus satisfait, la branche est élagée. Cela garantit la terminaison
du programme tout en restant entièrement paramétrable.
