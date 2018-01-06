---
layout: post
title: Chercher et manipuler du texte
date: 2018-01-06 18:00:00 +02:00
logo: automator
attachments: 
  - name: Texte-chercher-identifier.workflow
    path: processus/Texte-chercher-identifier.workflow.zip
  - name: Texte-chercher-remplacer.workflow
    path: processus/Texte-chercher-remplacer.workflow.zip
---

Il peut arriver que vous ayez besoin de manipuler du texte avec Automator.
Par exemple pour identifier des lignes contenant un mot particulier,
ou pour remplacer un mot par un autre.

Pour cela il existe differentes techniques. 
Mais le plus simple est de savoir utiliser un minimum les expressions
régulières et un langage de script.

Pour cet exemple je vais vous montrer deux exemples de manipulations :

1. Rechercher un texte et marquer chaque ligne qui le contient.
2. Rechercher un mot pour le remplacer par un autre.

### Mise en place du processus

Pour pouvoir tester rapidement notre fonction de 
recherche et remplacement de texte, nous allons devoir créer
un petit processus Automator comprenant 3 actions :

1. L'action « _Obtenir le texte indiqué_ » pour indiquer le texte dans lequel vous
   allez effectuer votre recherche.
2. Une action « _Exécuter JavaScript_ » où nous allons réaliser l'essentiel de notre
   traitement.
3. Une action « _Afficher les résultats_ » pour voir directement le 
   résultat à la fin de l'exécution. 
   Cela nous évitera de regarder les traces.

Dans la première action entrez le texte de votre choix.

L'idée étant de recherche un (ou plusieurs) mot dans une ligne de texte,
évitez d'utiliser de longs paragraphes.

Voici mon texte d'exemple :

> Remplacer les pommes par des oranges.<br>
> Manger des fraises.<br>
> Faire une tarte aux pommes.

Si vous exécutez votre processus maintenant, la dernière action
devrait vous afficher le texte de la première.

Nous pouvons passez à la suite et mettre en place notre 
fonctionnalité de recherche.

### Identifier les lignes contenant un mot particulier

Pour rechercher un mot dans un texte, nous allons utiliser un outil
disponible dans de nombreux langages de programmation : les _expressions régulières_.

Pour le dire simplement, et sans entrer dans trop de théorie, une expression régulière
est un moyen d'identifier des motifs dans un texte.

Par exemple si j'écrit :

```regexp
/pomme/
```

L'expression régulière que donnera une correspondance si le texte qu'on lui
applique contient la séquence de caractères 'pomme'.

On peut utiliser des _méta-caractères_ comme le point « . » qui correspond à 
n'importe quel caractère (sauf les fins de lignes).

Il existe également des opérateurs :

- « + » indique une répétition d'au moins une fois ce qui précède l'opérateur:
  `/a+/` correspond à « a », « aa », « aaa » et ainsi de suite.
- « * » fonctionne comme le « + » mais permet d'avoir une répétition de zéro ou plus:
  `/a*/` correspond à « a », « aa », « aaa » et ainsi de suite, _mais
  aussi_ à l'absence totale du caractère « a » : «  ».
  
Ainsi l'expression régulière `/.*pomme.*/` correspond à tout texte qui contient le mot 
« pomme ».

Si je veux faire en sorte que la recherche se limite à une seule ligne il faut l'indiquer
en utilisant les méta-caractères '^' et '$' :

- '^' désigne le début de la ligne ;
- '$' désigne la fin de la ligne.

Note expression dévient donc :

```regexp
/^.*pomme.*$/
```

Mais comme notre texte peut contenir plusieures lignes il faut aussi le préciser
en ajoutant une option à l'expression régulière.

```regexp
/^.*pomme.*$/m
```

Nous voulons également que la recherche soit réalisée sur la totalité du texte
et pas seulement la première correspondance trouvée. 
Il faut donc ajouter l'option « g » (globale).

Si vous voulez maintenant pouvoir manipuler des caractères de toutes les langues
il faut indiquer que le texte peut utiliser des caractères  [Unicode][1] avec l'option
'u'.

L'expression finale pour rechercher le mot « pomme » est donc la suivante :

```regexp
/^.*pomme.*$/gmu
```

### Coder la recherche en JavaScript

Lorsque vous avez ajouté l'action pour exécuter du JavaScript, le modèle 
propose les instructions suivantes :

```js
function run(input, parameters) {
	
	// Your script goes here

	return input;
}
```

Ces quelques lignes ne font rien de special puisque elles se 
contentent de renvoyer à l'action suivante ce qu'elles ont
reçu en entrée.

Comme la valeur reçue est une liste de texte, nous allons 
devoir appliquer la recherche sur chaque élément de cette liste.

```js
function run(input, parameters) {
  // On crée une nouvelle liste pour le résultat
  var output = [];
  
  // On parcours la liste élément par élément
  for ( current of input ) {
    var changed = current; // Comportement neutre, on ne fait rien
    // On ajoute la ligne modifiée (pas encore, mais ça viendra)
    // au résultat.
    output.push(changed);
  }

  // On transmet le résultat à l'action suivante
  return output;
}
```

Nous sommes prêt à ajouter notre recherche de texte.

Si le mot recherché est trouvé, nous voulons simplement
ajouter la mention « // ICI des 🍏 » en fin de ligne.

Comme nous voulons conserver la ligne initiale, il faut encore modifier 
un peu notre expression régulière.

Nous allons demander à l'expression régulière de se souvenir
du contenu de la ligne en l'encadrant par des parenthèses :

```regexp
/^(.*pomme.*)$/gmu
```

Le contenu entre parenthèses pourra être récupéré après 
le test de correspondance en utilisant des variables numérotées.

Ainsi, `$1` contient la première correspondance (la seule dans notre cas).
Si vous avez plusieurs groupes de parenthèses vous pourrez récupérer le
contenu avec les variables `$2`, `$3`, etc.

Pour effectuer la recherche et l'insertion nous allons utiliser le
remplacement de correspondance. Si l'expression régulière correspond,
nous allons remplacer la ligne par la valeur précédente suivi par
la mention voulue.

Pour cela nous utiliseront la méthode `replace` disponible sur 
les valeur textuelles :

```js
current.replace( 
  /^(.*pomme.*)$/gmu,
  '$1 // ICI des 🍏'
);
```

Cette fonction se contente de rechercher les lignes qui correspondent 
à l'expression régulière indiquée comme premier paramètre.

Le second paramètre indique par quoi une correspondance doit être remplacée.
En l'occurence on indique `$1` pour le contenu de la ligne, suivi par la mention.

Il ne reste plus à mettre ce résultat dans notre variable `changed`.

Le résultat final ressemble à ce qui suit :

```JavaScript
function run(input, parameters) {
  var output = [];
  
  for ( current of input ) {
    var changed = 
	  current.replace( 
	    /^(.*pomme.*)$/gmu, 
		'$1 // ICI des 🍏'
	  );
    output.push(changed);
  }

  return output;
}
```

Vous pouvez exécuter votre processus qui est maintenant complet.

Vous devriez avoir le résultat suivant :

{% include post_image.html 
    src='/img/screenshots/2018/01-06_Texte-chercher-identifier.png' 
    alt="Processus pour chercher un mot et identifier les lignes le contenant." %}

Et voilà comment modifier un texte pour rechercher du contenu et
ajouter un commentaire à la fin de chaque ligne ou le texte a été
trouvé.

Même si cela est relativement simple à comprendre, nous allons maintenant
voir comment remplacer un mot par un autre.

### Remplacer un mot dans un texte

Disons que nous voulons maintenant remplacer le mot « pomme » par « poire »
dans notre texte.

Vous imaginez que nous allons à nouveau utiliser la fonction `replace` 
mais en changeant les paramètres.

Effectivement, pour trouver le mot il suffit de l'indiquer dans l'expression
régulière:

```regexp
/pomme/gu,  
```

Dans ce cas il y peu de chance de trouver de faux positifs.
Mais si vous chercher le mot « cherche », l'expression `/cherche/``
pourrait trouver une correspondance avec « recherche », « chercher », etc.

Nous allons donc indiquer que le mot recherché doit être encadré
par des limites de mots. Pour cela il faut utiliser l'expression `\b`
(pour _boundary_, c'est à dire limite).

```regexp
/\bpomme\b/gu,  
```

Mais si vous voulez trouver soit « pomme » au singulier,
soit « pommes » au pluriel, il faut indique un « s » final:

Et pour indiquer que ce caractère est optionnel, on utilise 
l'opérateur `?`.

```regexp
/\bpomme(s?)\b/gu,  
```

Vous aurez surement remarqué que j'ai ajouté des parenthèses.
C'est pour pouvoir récupérer le « s » s'il était présent et le 
replacer sur le mot de remplacement.

```js
current.replace(
  /\bpomme(s?)\b/gu,  
  'poire$1'
);
```

Et voilà comment remplacer des pommes par des poires dans 
notre texte. Le « s » du pluriel est bien ajouté après le 
mot s'il était présent en utilisant la valeur capturée 
par les parenthèses `$1`.

Et voilà comment modifier notre premier processus. 
Le résultat final doit ressembler à ce qui suit :

{% include post_image.html 
    src='/img/screenshots/2018/01-06_Texte-chercher-remplacer.png' 
    alt="Processus pour chercher un mot et le remplacer par un autre." %}


### Conclusion

Il resterait beaucoup à dire sur l'utilisation des expressions régulières.

Elles offrent de nombreuses possiblités.

Mais vous avez les bases pour les utiliser dans des cas d'utilisation les 
plus simples.

L'exemple que je vous ait donné utilise le JavaScript, mais
vous pouvez opter pour AppleScript ou un autre langage de script
comme Perl, Python ou Ruby. À vous de choisir celui qui vous est
le plus familier.


[1]: https://fr.wikipedia.org/wiki/Unicode
