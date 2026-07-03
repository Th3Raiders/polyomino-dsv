<h1 align="center">Dans le cadre de mon stage de licence</h1>

# Énumération des polyominos reposant sur les grammaires algébriques ( Méthode DSV )
On propose ici, une implémentation fonctionnelle en OCaml de la méthode DSV(Delest-Viennot) pour énumérer des polyominos au travers de grammaires algébriques.

Fait durant mon stage de recherche au **GR2IF** ( Groupe de Recherche Rouennais en Informatique Fondamentale), Université de Rouen.

# Qu'est-ce qu'un polyomino ? 
Les polyominos sont des figures géométriques discrètes formées de cellules carées connexes.
Leur énumération est un problème central en combinatoire, avec des applications en physique statistique, modèle de percolation, modélisation de repliement de protéines ou bien en informatique dans des problèmes de compression ou de pavage.




**À ce jour, il est impossible d'énumérer tout les polyominos**. Le nombre total de polyominos de périmètre n croît exponentiellement, et aucune formule close ni série génératrice n'est connue pour la classe entière.
C'est un problème ouvert depuis 60 ans.
La méthode DSV ne résout pas ce problème général, elle offre un cadre pour énumérer certaines **sous-classes bien choisies**.

# La méthode DSV
La méthode DSV consiste a établir une bijection entre les mots générés par une grammaire algébrique et des polyominos.
Dès lors que cette bijection est établie, il s'agit de traduire la grammaire en un systeme d'équations sur les séries formelles.
Pour chaque non-terminal A(i), on obtient une équation :

Ce système est ensuite résolu par substitution, point fixe ou méthode du noyau pour obtenir une expression explicite de F(X,Y), dont on prouve qu'elle est une série algébrique.

# Caractéristiques
- Définir une grammaire algébrique avec les terminaux,non terminaux et epsilon.
- Générer tout les mots d'une grammaire selon des bornes configurables.
- Filtrage parametrées à l'aide de fonction de mesure et de bornes
- Prends en compte la recursivité et les grammaires ambiguie, afin de ne pas déborder sur la pile.

