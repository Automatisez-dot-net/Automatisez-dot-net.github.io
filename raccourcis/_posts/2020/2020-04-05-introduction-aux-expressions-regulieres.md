---
layout: post
title: Les Expressions régulières en 10 minutes
date: 2020-04-05 17:01:00 +02:00
logo: shortcut-app
attachments: 
  - name: SMS à un groupe (raccourcis)
    url: https://www.icloud.com/shortcuts/3ee01c9e43804cb1aafea4539e2a226d
---

Dans le tuto [envoyer des SMS à un groupe][mainArticle] j’utilise une 
_expression régulière_ pour extraire les mobiles d’une liste de 
numéros de téléphone.
<br>
Je vous ai lancé ça sans prendre le temps de définir la nature d’une expression
régulière. Je vous l’ai posée là, sans la décortiquer, ni aucune explication.
Voici donc cet article qui se présente comme une _bonus track_ pour détailler 
comment cette expression fonctionne. 
<br>
J’espère ainsi vous donner envie d’aller plus loin et d’exploiter cet outil.
Même si, dans les grandes lignes, leur compréhension ne pose pas de difficulté 
particulière, elles combinent puissance et utilité.


### Petit Rappel


Pour identifier les numéros de téléphone mobile, j’utilise
l’action « **faire correspondre à** ».

Cette action utilise un outil particulièrement utile et relativement simple 
à comprendre avec un minimum d’effort :
les _[expressions régulières][regexp]_. 

C’est un outil capable d’identifier des motifs spécifiques dans une suite 
de caractères.

L’expression qui est utilisée dans [notre raccourci][mainArticle] est la suivante :

  ```^(\+33\s)?0?[67][0-9.\s]+```


Le résultat de l’action sera la liste des textes pour lesquels une 
correspondance au motif (l’expression régulière) a été trouvée.


### Comprendre la correspondance de texte

Avec cet article, mon objectif n’est pas de vous faire maitriser totalement 
les expressions régulières.
Le sujet est assez large et il faudrait bien plus que ces quelques paragraphes.

J’espère tout de même vous donner quelques bases pour comprendre les plus simples,
voire créer les vôtres.

Commençons par apprendre les rudiments de la lecture.


#### Lire une expression régulière


Une expression régulière permet de décrire de façon _synthétique_
un motif de texte. Dans une telle expression, chaque caractère correspond :

- à lui même ;
- à un _opérateur_ qui s’applique au motif qui le précède ;


##### Un motif simple

La forme la plus simple d’un motif est une suite de caractères.
Par exemple, l’expression régulière `abc` va correspondre, entre autres, aux
textes ci-dessous :

- « abc », qui est exactement la valeur indiquée par le motif.
- « chercher abc un texte », car le motif est inclus dans le texte.
- mais aussi « le motif abc est dans abc ».

_Important_, dans ce dernier exemple l’action « **faire correspondre à** »
va renvoyer deux correspondances : 
une pour chaque fois où le motif a été identifié.

Si les expressions régulières se limitaient à ce genre de suite, elles ne
seraient pas très utiles.

Il est possible de construire un motif plus complexe en utilisant :

- des caractères spéciaux ;
- des opérateurs.

Il se trouve que les caractères spéciaux ne peuvent pas être utilisés tels quels 
dans un motif.
On donc doit les précéder d’un « `\` » pour utiliser le vrai caractère.

Ce « `\` » sert aussi de préfixe à certains _méta-caractères_, c’est à 
dire qui désigne non pas un seul caractère, mais une famille de symboles.


##### Quelques opérateurs

`^` désigne le début d’une ligne/texte, il ne correspond à aucun caractère.
Son pendant est le `$` pour la fin de ligne/texte.

Les signes `+` et `?` sont les opérateurs les plus simples et les plus utiles :

- `+` pour un motif répété au moins une fois : <br>
     `a+` correspond à « a », « aaa », mais pas à « ab ».
- `?` pour un motif optionnel ou présent _au plus_ une fois :<br>
     `ab?` correspond à « a » et « ab ».


##### Métacaractères

Le `.` désigne n’importe quel caractère :<br>
`a.c` correspondra à « abc », « axc », mais pas à « ac », ni « abbbc ».

Dans notre expression, on utilise deux autres métacaractères :

- `\s` représente tout type d’espace ;
- `\d` représente un chiffre.


##### Groupes

Utiliser les opérateurs `+` ou `?`c’est bien, mais d’un usage limité avec 
un seul caractère…

`\+33?` ne permet pas d’identifier le préfixe « +33 » puisque le `?`
ne s’applique qu’au symbole qui le précède.
Il correspond aux textes « +3 » ou « +33 », mais ce n’est pas ce qu’on veut.

On peut élargir l’application d’un opérateur en encadrant avec des parenthèses,
`(` et `)`, le motif sur lequel il doit s’appliquer.

Dans cette situation, il est donc indispensable de désigner le motif pour
ensuite lui appliquer l’opérateur `?` :

`(+33\s)?`

Dans cet exemple, l’opérateur `?` s’applique donc au motif `+33\s`.


##### Famille de caractères

`[` et `]` permettent de définir une série d’alternatives de symboles :

- Il permet des raccourcis comme les intervalles de symboles.
  `[0-9]` désigne un chiffre de 0 à 9
- Mais on peut aussi ajouter n’importe quel caractère
   

### Et notre motif de téléphone ?

Petit rappel, nous identifions les numéros de portable avec l’expression 
régulière ci-dessous :

  ```^(\+33\s)?0?[67][0-9.\s]+```

Je peux essayer de vous la traduire en français, mais le 
plus simple peut-être de commencer par faire un dessin.

{% include img_svg.html 
    svgSrc="/img/2020/04/regex-visual.svg" 
    imgSrc="/img/2020/04/regex-visual.png" 
    alt="visualisation graphique d’une expression régulière" %}

- Le numéro peut commencer par un groupe qui représente le préfixe international 
  optionnel de la France.
  Il est composé un signe « + » suivi du nombre « 33 » et d’un espace
  de séparation.
- Après cet éventuel préfixe se trouve le numéro proprement dit qui peut, 
  ou non, commencer par un « 0 », mais dont le premier chiffre doit être 
  un 6 ou un 7. 
  Le reste du numéro est une série
  de chiffres éventuellement séparés par des espaces ou des points

**Note : ** Les diagrammes d’expression peuvent être construits avec l’outil
 en ligne [regexper.com][regExper].


#### Adapter l’expression pour d’autres pays

_Cette expression ne fonctionne qu’avec les numéros français, dont le préfixe
international est le **+33**._

Vous pouvez adapter l’expression à un autre pays en changeant cette partie :

- le numéro de préfixe du pays, par exemple _+41_ pour la Suisse ;
- les premiers chiffres attendus pour un portable dans ce pays : 
  [pour la Suisse][suissePrefixesMobiles]
  les numéros mobiles commencent par _74_, _75_, _76_, _77_, _78_ et _79_.

Pour les mobiles suisses, l’expression régulière serait donc :

  ```^(\+41\s) ? 7[4-9][0-9.\s]+``` ([diagramme][reMobilesSuisse2])


### Pour finir

J’espère que cette rapide introduction vous aura donné envie d’en apprendre
un peu plus sur les expressions régulières.

C’est un outil puissant qui peut vous faciliter grandement la vie.

Je vous propose un petit challenge personnel :
_explorez une des deux autres actions qui utilisent les expressions régulières_.

Cherchez _correspondance_ dans la liste des actions. 
Vous devriez trouver deux nouvelles actions :

- « **Remplacer le texte** » ;
- « **Obtenir le groupe du texte correspondant** ».

La première va vous permettre de remplacer du texte en vous appuyant, éventuellement,
sur des expressions régulières pour la recherche.

La seconde action fonctionne en combinaison avec « **correspondre au texte** » 
et l’utilisation de groupes dans l’expression régulière.
Lorsque vous avez défini un groupe dans votre motif, vous pouvez récupérer sa
valeur avec cette action.

Et voilà un tout nouvel éventail de possibilités qui s’ouvre à vous.
Amusez-vous bien avec les correspondances par expression régulière.


[regexp]: https://fr.wikipedia.org/w/index.php?title=Expression_régulière
[regExper]: https://regexper.com/
[visualRegEx]: https://regexper.com/#%5E%28%5C%2B33%5Cs%29%3F0%3F%5B67%5D%5B0-9.%5Cs%5D%2B
[suissePrefixesMobiles]: https://en.wikipedia.org/wiki/Telephone_numbers_in_Switzerland
[reMobilesSuisse1]: https://regexper.com/#%5E%28%5C%2B41%5Cs%29%3F%2874%7C75%7C76%7C77%7C78%7C79%29%5B0-9.%5Cs%5D%2B
[reMobilesSuisse2]: https://regexper.com/#%5E%28%5C%2B41%5Cs%29%3F7%5B4-9%5D%5B0-9.%5Cs%5D%2B

[mainArticle]: /raccourcis/2020/04/05/envoyer-des-sms-a-un-groupe.html
