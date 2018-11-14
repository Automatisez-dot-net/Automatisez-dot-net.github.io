---
layout: post
title: Un système simple pour traduire vos scripts Scriptable
date: 2018-11-14 22:00:00 +02:00
logo: scriptable-app
---

Si vous avez l'intention de partager vos scripts pour _Scriptable_
sur internet, il sera utile de prévoir un mécanisme 
pour traduire les différents messages présentés à l'écran. 
C'est un tel système que je vous propose dans ce court article.

### Comment ça marche ?

L'idée est de pouvoir obtenir facilement une chaine de texte
dans la langue de l'utilisateur.

Je vous propose un système qui se construit sur deux éléments:

1. un objet pour définir les différents chaines de texte
2. une fonction pour obtenir la chaine qui correspond 
   à la langue de l'utilisateur.
   
#### Spécifier vos textes

Définir un ensemble de chaines traduites:

```JavaScript
let msg = {
  'hello': {
    'fr-FR': "Bonjour",
    'en-FR': "Hello",
    '*':     "--Hello--"
  },
  'bye': {
    '*': "Bye!"
  }
};
```

Cet objet défini deux textes différents:

- 'hello'
- 'bye'

On associe à chaque texte un objet dont les clés sont les langues
et la valeur contient la traduction. La clé de langue '*' sera utilisée
pour le texte _par défaut_.

Si vous voulez simplement proposer le français et l'anglais,
vous utiliserez 'fr-FR' pour le français et '*' pour l'anglais.

Dans cet exemple je n'ai qu'une traduction française 'fr-FR' et 'en-FR'
pour le premier texte.
En revanche, le second texte n'est pas traduit en français.

#### Obtenir un texte traduit

L'objectif est d'avoir une fonction simple et un appel compact mais lisible.

```JavaScript
msg.i18n('hello');
```

On appelle la fonction `i18n()` (pour _internationalisation_).

Oui, on appelle cette fonction comme une méthode sur l'objet `msg`.
Si vous n'avez pas l'habitude du JavaScript cela peut vous étonner, mais
il n'y a rien d'exotique à ajouter des méthodes sur des classes existantes.

### L'implémentation

La mise en œuvre de cette fonction est relativement courte pour pouvoir
la dupliquer dans vos différents scripts.

La fonction est ajoutée comme une méthode sur le prototype
de la classe `Object`. Elle n'a qu'un paramètre, la clé qui identifie
le texte.

```JavaScript
Object.prototype.i18n = function (key) {
  if ( 'undefined' === typeof this[key] ) {
    console.log(`Missing key ${key}`);
    Script.complete();
  }

  let langs = Device.preferredLanguages();
  langs.push('*');
 
  let msg;
  while ( 'undefined' === typeof msg && (langs.length > 0) ) {
    msg = this[key][langs.shift()];
  }
  
  return msg;
};
```

Le début de la fonction vérifie simplement que la clé
du texte est bien dans l'objet que vous utilisez. Si ce n'est
pas le cas une erreur est affichée dans la console et le
script s'arrète.

L'étape suivante construit une liste de code.de langues
à partir de celles définies sur l'appareil. 
On prend soin d'ajouter la clé `*` pour avoir
le code par défaut.

Dans la dernière partie, on récupère la valeur du texte pour les
différentes langues de cette liste jusqu'à trouver une
valeur qui soit définie.

C'est ce fonctionnement qui permet de retomber sur le texte
par défaut.

Enfin, le texte trouvé est renvoyé.

