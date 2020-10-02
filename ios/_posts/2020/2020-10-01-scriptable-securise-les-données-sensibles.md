---
layout: post
title: Mettez vos données sensibles à l'abri dans Scriptable
date: 2020-10-01 22:00:00 +02:00
logo: scriptable-app
---

Vous avez certainement déjà écrit un script qui utilise un mot de passe, ou une
clé d’API. 
Et _pour commencer_ vous avez peut-être mis ces données sensibles 
directement dans votre script.
Mais ce n’est certainement pas une très bonne pratique du point de vue
de la sécurité. 
Et c’est encore pire lorsque vous avez besoin de partager ce script, que ce soit
avec un ami ou de parfaits inconnus.

-----

### Scriptable et le trousseau d’iOS

La bonne solution est de sortir ces informations sensibles de votre script.
Mais où pouvez-vous les stocker et comment pouvez-vous les récupérer ?

Sur macOS, iOS et iPadOS c’est le _Trousseau_ qui permet de stocker de façon
sécurisée vos mots de passe ou vos jetons d’API.

Comme Scriptable est une excellente application, elle offre un moyen
d’utiliser ce trousseau directement en JavaScript. 
La classe [`Keychain`][ref_keychain] vous donne les clés pour mettre les petits
secrets de vos scripts à l’abri des regards.

Le trousseau est un dictionnaire, c’est-à-dire une association entre un nom de
clé et la valeur.
C’est cette valeur qui est sécurisée et chiffrée dans le trousseau.

### Ajouter une valeur sécurisée au trousseau

Vous pouvez définir la valeur d’une clé avec la méthode `set()` :

```js
Keychain.set('nomDeClé', 'ma-va1eur-s3cr3t3');
```

Si vous essayez de définir la valeur d’une clé qui est déjà dans le trousseau,
la valeur précédente sera simplement remplacée par votre nouvelle valeur.

Vous pouvez enregistrer vos différentes clés une par une en utilisant un script
jetable.


### Lire une valeur sécurisée dans le trousseau

Lorsque vous êtes en train d’écrire votre script, vous pouvez lire vos
secrets en utilisant à nouveau la classe `Keychain`.

#### Vérifiez qu’un secret existe

Vous pouvez rapidement vérifier si une valeur est définie pour une clé donnée.
Utilisez la méthode `contains()` pour cela :

```js
if ( Keychain.contains('api-key') ) {
  // Récupérer la valeur pour utiliser une API
}
else {
  // Le secret n'est pas défini…
}
```

Lorsque le secret est absent du trousseau, vous pouvez avertir l’utilisateur
du script ou éventuellement lui demander de donner la valeur à travers un
dialogue. À vous de voir.

#### Lire un secret

La lecture d’un secret se fait assez simplement avec la méthode `get()`:

```js
if ( Keychain.contains('api-key') ) {
  // Récupérer la valeur pour utiliser une API
  let apiKey = Keychain.get('api-key');
  // …
}
```

**Attention :**
Je vous conseille de toujours vérifier que la valeur est définie.
En effet, lorsque ce n’est pas le cas, la méthode `get()` va lancer
une exception.


### Le mot de la fin

Vous n’avez plus d’excuse pour mettre un mot de passe ou un jeton d’API 
dans un script. Passez toujours par le _Trousseau_.

C’est un peu plus contraignant, mais tellement plus sûr.
Et cela vous permet de librement distribuer vos scripts sans vous poser trop de
questions.

Sachez enfin que si vous n’avez plus besoin d’une clé il vous est tout à 
fait possible de la retirer du trousseau avec la méthode `remove()`.

C’est d’ailleurs une amélioration possible pour l’application. 
Il n’est pas possible d’obtenir la liste des clés stockées dans le trousseau.
Si c’est un choix tout à fait compréhensible d’un point de vie de la sécurité, 
ce serait pourtant très utile de pouvoir vérifier que l’on n’accumule pas 
trop de secrets inutiles. Avec le temps, y faire un peu de ménage ne sera pas
du luxe.

Vous voilà équipé. Nous verrons dans un article ultérieur comment utiliser 
le trousseau dans vos _raccourcis_.


[ref_keychain]: https://docs.scriptable.app/keychain/
