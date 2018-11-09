---
layout: post
title: Ajouter un contact à un groupe sur iPhone et iPad
date: 2018-11-09 07:00:00 +02:00
logo: scriptable-app
---

Voici le troisième article dans cette série consacrée à la gestion
des contact avec _Scriptable_.
Après avoir vu comment créer et supprimer des groupes, il est temps
d'ajouter des contacts dans ces groupes.

Je vous renvoie aux deux premiers articles de cette série:

- [créer un groupe](/ios/2018/11/04/creer-un-groupe-de-contacts.html) ;
- [supprimer un groupe](/ios/2018/11/07/supprimer-un-groupe-de-contacts.html) ;

__Avertissement__ : Ce billet n’est pas une initiation à JavaScript.
    Il suppose que vous connaissez un minimum le langage.
    Si vous ne le maitrisez pas, ce n’est pas un souci. Vous pouvez vous
    contenter de copier le script tel quel.

Cet article ne sera pas une explication de texte détaillée du
programme dans sa totalité. Je vais me contenter d'expliquer certains
choix, principalement issus des contraites propres à la
communication entre applications, temps de développement et 
bien entendu _Scriptable_ qui ajoute aussi ses limitations
spécifiques.

Les limitations générales à toute cette série d'articles
et d'outils sont peu nombreuses, mais importantes:

- _Seul le compte par défaut est pris en charge._
  Si vous utilisez plusieurs comptes de carnet d'adresses,
  les scripts ne prennent en charge que les groupes et contacts
  stockés dans le compte par défaut.
- _Seul les fiches contact individuelles sont correctement gérées._
  Impossible par exemple d'ajouter une fiche d'entreprise à un 
  groupe. Cette limitation viens principalement de l'objet
  _Contact_ de _Scriptable_ qui ne donne pas accès au champ
  correspondant.
  
Ceci étant dit, les scripts devraient vous être largement utiles
dans la plupart des cas. Si vous avez un réel besoin il est malgré
tout possible d'imaginer des solutions de replis.

Notez cependant, qu'un compte Google Exchange ne permet pas la
création d'un groupe sur le téléphone. 


### Créer le script

Pour ce troisième script, je suppose que vous avez déjà installé _Scriptable_.

Comme dans les premiers articles, créez un nouveau document dans lequel
nous allons travailler.

Le programme que nous allons construire doit être capable d'ajouter un
contact à un groupe.

Il pourra fonctionner de deux façons différentes:

1. à partir du carnet d'adresse, en utilisant la _feuille de partage_ pour
   envoyer un contact à notre script ;
2. à partir d'un _raccourcis_ capable d'appeler notre script
   en utilisant le système des [callback URL](http://x-callback-url.com)

Le fonctionnement du script sera le suivant:

1. _Identifier le contact reçu_: en efffet, la feuille de partage envoi une
   fiche contact sous la forme d'une [VCard](https://fr.m.wikipedia.org/wiki/VCard).
   Quand à l'utilisation de _Raccourcis_, rien ne permet d'envoyer une VCard ou
   un référence interne à la base de données des contacts.
2. _Afficher les groupes_ associés au compte par défault.
3. L'utilisateur doit _sélectionner un groupe_ pour indiquer où
   le contact doit être envoyé.

### Traiter le contact en entrée

Nous devons donc gérer deux scénarios:

1. utilisation par la feuille de partage ;
2. appel direct par une URL en suivant le protocol X-Callback.

Dans le premier cas, c'est l'objet `args` qui contiendra, 
sous la forme d'un texte, la description VCard du contact.

Seules les informations publique de la VCard sont donc disponibles.
Sans l'identifiant interne du contact pour le récupérer dans la base
de données, nous sommes donc obligés de parcourir tous les contacts
pour ne retenir que ceux qui ssemblent correspondre.

Pour cela, la logique est simple: on recherche un contact qui a le 
même nom et prénom que la fiche reçue. C'est limitatif en cas 
d'homonyme et oblige à avoir ces deux informations.

Dans le second cas nous allons devoir passer nos propres informations 
sur le contact dans l'URL sous la forme de paramètres.

Si notre script à une URL d'appel comme celle-ci:

`scriptable:///run?scriptName=Ajouter%20le%20contact%20a%CC%80%20un%20groupe`

L'URL contient déjà un paramètre: le nom du script `scriptName`.

Nous ajotuerons deux paramètres supplémentaires:

- `ln` pour _lastname_ le nom patronyme;
- `fn` pour _firstname_ le prénom.

Par simplicité, on considèrera que si la liste des arguments
disponibles dans `arg` est vide, il faut considérer que le script
est appelé par l'URL. Libre à vous d'ajouter d'autres cas.

Dans le deux cas, nous allons construire un object qui représente
un _résumé_ de la fiche contact:

```JavaScript
let contact = {
  org: null, // Not provided in Contact object
  fn:  null, // Full display name, formatted for display
  firstName: '',
  lastName: ''
};
```

Cet objet peut être créé en appelant la fonction `ContactProp()`.

Le début du script détermine donc dans quel cas il pense
se trouver et va construire une liste de résumé de contact à
partir de la source disponible:

- il appellera `buildInputFromCallbackURL()` pour utiliser l'URL;
- dans le cas de la feuille de partage c'est
  `buildInputFromShareSheet()` qui est appellée.

Cette seconde fonction se contente de transformer la liste des
arguments textuels (l'objet `arg.plainTexts`) en résumé de contact.
Elle appelle donc la fonction `getContactFromVCard()` sur chaque 
valeur pour extraire les informations à partir de la représentation
de la VCard.

Notez que je choisi de construire une liste pour simplement
faciliter les évolutions qui permettraient de gérer plusieurs
contacts en entrée. Un changement facile à réaliser sur l'appel par
URL.


### Identifier la correspondance dans la base de données

Comme je l'ai expliqué, l'une des contraites est de se limiter
aux contact individuels dont les noms et prénoms sont
correctement renseignés.

À partir de la liste des différents résumés de contacts nous allons 
devoir retrouver celui qui possède le même nom et même prénom.

Cette recherche est réalisée dans la fonction `findContacts()` 
qui à partir d'un tableau de résumé de contacts va renvoyer un
tableau d'objets `Contact`.

```JavaScript
async function findContacts(props) {
  let container = await ContactsContainer.default();
  let allContacts = await Contact.all([ container ]);
  
  let matches = allContacts.filter((current) => {
    let familyName = ( current.familyName ) ? current.familyName.trim() : '';
    let givenName  = ( current.givenName )  ? current.givenName.trim()  : '';
    
    let hasFamilyName = familyName.length > 0 && 0 === props.lastName.localeCompare(familyName);
    let hasGivenName  = givenName.length > 0 && 0 === props.firstName.localeCompare(givenName);
    
    let isMatching = hasFamilyName && hasGivenName;
    
    return isMatching;
  });
  
  return matches;
}
```

La fonction est définie comme asynchrone car elle doit être 
capable de récupérer le compte par défaut et la liste
des contacts qu'il stocke.

On pourrait construire cette liste à partir de promesses, 
mais la lisibilité du code serait certainement plus complexe.

Le début de notre programme va donc suivre la structure suivante:

```JavaScript
for ( contactProps of allContact ) {
  if ( null !== contactProps.org && ('' === contactProps.firstName) ) {
    // ERREUR: une VCard d'entreprise, il faudrait afficher une erreur
  }
  
  let contacts = await findContacts(contactProps);
  
  if ( contacts.length === 0 ) {
    // ERREUR: pas de correspondance trouvée
  }
  else if ( contacts.length > 1 ) {
    // ERREUR: plus d'une fiche correspondante trouvée
  }
  else {
    // OK, continuer...
  }
}
```

`allContact` est notre liste de résumés construite à partir des
données d'entrée du script.

Nous commençons par gérer les cas d'erreurs, à savoir une
fiche d'entreprise ou des correspondances multiples.

Mais si une seule fiche est trouvée pour le contact, nous pouvons 
maintenant continuer le script et demander à l'utilisateur de
sélectionner un groupe.

### Présenter la liste des groupes

### Ajouter le contact au groupe choisi

### Bilan
