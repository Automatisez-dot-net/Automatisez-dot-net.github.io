---
layout: post
title: Ajouter un contact à un groupe sur iPhone et iPad
date: 2018-11-10 07:00:00 +02:00
logo: scriptable-app
attachments:
  - name: Ajouter un contact à un groupe (JavaScript pour _Shortcut_)
    url: https://raw.githubusercontent.com/automatisez/iOS-workflow/master/scriptable-app/contacts/add-contact-to-group.js
---

Voici le troisième article dans cette série consacrée à la gestion
des contacts avec _Scriptable_.
Après avoir vu comment créer et supprimer des groupes, il est temps
d’ajouter des contacts dans ces groupes.

Je vous renvoie aux deux premiers articles de cette série :

- [créer un groupe](/ios/2018/11/04/creer-un-groupe-de-contacts.html) ;
- [supprimer un groupe](/ios/2018/11/07/supprimer-un-groupe-de-contacts.html) ;

__Avertissement__ : Ce billet n’est pas une initiation à JavaScript.
    Il suppose que vous connaissez un minimum le langage.
    Si vous ne le maitrisez pas, ce n’est pas un souci. Vous pouvez vous
    contenter de copier le script tel quel.

Cet article ne sera pas une explication de texte détaillée du
programme dans sa totalité. Je vais me contenter d’expliquer certains
choix, principalement issus des contraintes propres à la
communication entre applications, temps de développement et 
bien entendu _Scriptable_ qui ajoute aussi ses limitations
spécifiques.

Les limitations générales à toute cette série d’articles
et d’outils sont peu nombreuses, mais importantes :

- _Seul le compte par défaut est pris en charge._
  Si vous utilisez plusieurs comptes de carnet d’adresses,
  les scripts ne prennent en charge que les groupes et contacts
  stockés dans le compte par défaut.
- _Seul les fiches contact individuelles sont correctement gérées._
  Impossible par exemple d’ajouter une fiche d’entreprise à un 
  groupe. Cette limitation vient principalement de l’objet
  _Contact_ de _Scriptable_ qui ne donne pas accès au champ
  correspondant.
  
Ceci étant dit, les scripts devraient vous être largement utiles
dans la plupart des cas. Si vous avez un réel besoin, il est malgré
tout possible d’imaginer des solutions de replis.

Notez cependant qu’un compte Google Exchange ne permet pas la
création d’un groupe sur le téléphone. 


### Créer le script

Pour ce troisième script, je suppose que vous avez déjà installé _Scriptable_.

Comme dans les premiers articles, créez un nouveau document dans lequel
nous allons travailler.

Le programme que nous allons construire doit être capable d’ajouter un
contact à un groupe.

Il pourra fonctionner de deux façons différentes:

1. à partir du carnet d’adresses, en utilisant la _feuille de partage_ pour
   envoyer un contact à notre script ;
2. à partir d’un _raccourcis_ capable d’appeler notre script
   en utilisant le système des [callback URL](http://x-callback-url.com)

Le fonctionnement du script sera le suivant:

1. _Identifier le contact reçu_: en effet, la feuille de partage envoi une
   fiche contact sous la forme d’une [VCard](https://fr.m.wikipedia.org/wiki/VCard).
   Quant à l’utilisation de _Raccourcis_, rien ne permet d’envoyer une VCard ou
   une référence interne à la base de données des contacts.
2. _Afficher les groupes_ associés au compte par défaut.
3. L’utilisateur doit _sélectionner un groupe_ pour indiquer où
   le contact doit être envoyé.

Nous allons commencer par utiliser la feuille de partage pour utiliser 
ce script. Cela vous permet d’appeler le script directement à partir de 
l’application _Contacts_.

{% include post_image.html 
    src='/img/screenshots/2018/11-09_contact-1-share.png' 
    alt="La feuille de partage d’un contact" %}

Après avoir sélectionné «_Run script_», vous devrez choisir le script 
dans la liste disponible.

{% include post_image.html 
    src='/img/screenshots/2018/11-09_contact-2-add-to-group.png' 
    alt="Les scripts disponibles dans l'extension de partage." %}


### Traiter le contact en entrée

Nous devons donc gérer deux scénarios:

1. utilisation par la feuille de partage ;
2. appel direct par une URL en suivant le protocol X-Callback.

Dans le premier cas, c'est l'objet `args` qui contiendra, 
sous la forme d'un texte, la description VCard du contact.

Seules les informations publiques de la VCard sont donc disponibles.
Sans l'identifiant interne du contact pour le récupérer dans la base
de données, nous sommes donc obligés de parcourir tous les contacts
pour ne retenir que ceux qui semblent correspondre.

Pour cela, la logique est simple: on recherche un contact qui a le 
même nom et prénom que la fiche reçue. C'est limitatif en cas 
d'homonyme et oblige à avoir ces deux informations.

Dans le second cas, nous allons devoir passer nos propres informations 
sur le contact dans l'URL sous la forme de paramètres.

Si notre script à une URL d'appel comme celle-ci:

`scriptable:///run?scriptName=Ajouter%20le%20contact%20a%CC%80%20un%20groupe`

L'URL contient déjà un paramètre: le nom du script `scriptName`.

Nous ajouterons deux paramètres supplémentaires:

- `ln` pour _lastname_ le nom patronyme;
- `fn` pour _firstname_ le prénom.

Par simplicité, on considèrera que si la liste des arguments
disponibles dans `arg` est vide, il faut considérer que le script
est appelé par l’URL. Libre à vous d’ajouter d’autres cas.

Dans les deux cas, nous allons construire un objet qui représente
un _résumé_ de la fiche contact :

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
- dans le cas de la feuille de partage, c'est
  `buildInputFromShareSheet()` qui est appelée.

Cette seconde fonction se contente de transformer la liste des
arguments textuels (l'objet `arg.plainTexts`) en résumé de contact.
Elle appelle donc la fonction `getContactFromVCard()` sur chaque 
valeur pour extraire les informations à partir de la représentation
de la VCard.

Notez que je choisis de construire une liste pour simplement
faciliter les évolutions qui permettraient de gérer plusieurs
contacts en entrée. Un changement facile à réaliser sur l'appel par
URL.


### Identifier la correspondance dans la base de données

Comme je l'ai expliqué, l'une des contraintes est de se limiter
aux contacts individuels dont les noms et prénoms sont
correctement renseignés.

À partir de la liste des différents résumés de contacts, nous allons 
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
données d’entrée du script.

Nous commençons par gérer les cas d’erreurs, à savoir une
fiche d’entreprise ou des correspondances multiples.

Mais si une seule fiche est trouvée pour le contact, nous pouvons 
maintenant continuer le script et demander à l’utilisateur de
sélectionner un groupe.


### Présenter la liste des groupes

Pour sélectionner un groupe, nous devons commencer par obtenir la
liste des groupes dans le compte par défaut.

La liste sera affichée dans une liste avec le nombre de membres sur le côté.

{% include post_image.html 
    src='/img/screenshots/2018/11-09_contact-3-group-list.png' 
    alt="La liste des groupes de contacts." %}

Nous allons procéder en trois étapes :

1. Nous allons récupérer la liste des groupes ;
2. Les groupes seront utilisés pour construire la liste, une `UITable` ;
3. La liste sera affichée pour laisser l’utilisateur sélectionner un groupe.

La fonction `selectContactGroup()` est responsable de cette étape.

```JavaScript
async function selectContactGroup(container, selectedFn) {
  let allGroups = await ContactsGroup.all([ container ]);
  
  let orderedGroups = orderGroups(allGroups);
  
  let groupSelectionHandler = (index) => { /* Un peu de patience... */ };
  
  let groupTable = await createGroupTable(orderedGroups, groupSelectionHandler);
  
  groupTable.present();
}
```

La première action consiste à obtenir la liste des groupes dans le compte
par défaut. Il aura été passé dans le premier argument `container`.

La fonction `orderGroups()` est ensuite utilisée pour trier ces groupes
par ordre alphabétique.

Avant de construire l’interface graphique, il faut prévoir comment
comment nous allons traiter la sélection de l’utilisateur. 

Lorsqu’une ligne est sélectionnée, c’est le numéro de la ligne qui est 
passé en paramètre à la fonction qui répond à l’évènement.
C’est pour cette raison que nous allons devoir transformer le numéro de 
ligne en objet _ContactsGroup_. 

C’est la raison d’être de la fonction `groupSelectionHandler`.
Elle sera codée comme ceci :

```JavaScript
let groupSelectionHandler = (index) => {
  let group = orderedGroups[index];
  selectedFn(group);
};
```

La création de la table est similaire à ce que nous avons déjà fait dans
le script précédent. Nous utiliserons toujours une fonction `createGroupTable()`
et `createGroupRow()`

### Ajouter le contact au groupe choisi

Il ne reste donc plus qu’à ajouter le contact dans le groupe choisi par
l’utilisateur.

Pour ajouter le groupe, nous allons écrire une fonction `addContactToGroup()`.
Cette fonction accepte deux paramètres :

1. le contact à ajouter ;
2. le groupe de destination.

```JavaScript
function addContactToGroup(contact, group) {
  group.addMember(contact)
  
  Contact.persistChanges()
  .then((data) => {
    console.log(`Contact ${ contact.familyName } added to group ${ group.name }.`); 
    Script.complete();
  })
  .catch((error) => {
    console.log(`Failed to add contact to group. ${error}`);
    let alert = createAlertDialog("Erreur", "Erreur. Verifiez que votre compte par défault pour les contacts est bien iCloud.", "OK")
    alert.present().then(
      () => { Script.complete(); }, 
      () => { Script.complete(); }
    );
  });
}
```

Pour ajouter le contact, la fonction utilise la méthode `addMember()`.

Mais cette modification n’est définitive que lorsqu’elle est 
enregistrée dans la base de données des contacts. 
Pour cela il faut appeler la méthode `persistChanges()` sur la classe
`Contact`.

Comme la valeur retournée est une promesse, nous passons ensuite
une fonction pour gérer le succès avec `then()` et une pour afficher un
message en cas d’erreur avec `catch()`.

L’appel `Script.complete()` permet à _Scriptable_ d’indiquer à _Siri_ 
ou _Raccourcis_ que le script est terminé.

### Le script complet

Vous pouvez télécharger le script complet avec cet article ou le
copier à partir d'ici:

```JavaScript
// ===== ENTRY POINT

let allContact = [];

// We can be called from the share sheet or callback-url

if ( 0 === args.all.length ) {
  // CASE 1: no arguments from share sheet, check if we are called from XCallback URL
  allContact = buildInputFromCallbackURL();
}
else {
  // CASE 2: We were called from share sheet, just get the VCards and convert them to internal object
  allContact = buildInputFromShareSheet()
}

// Currently share sheet only provide a single contact, but just try to be safe 
// by looping on all items, just in case.
//
for ( contactProps of allContact ) {
  if ( null !== contactProps.org && ('' === contactProps.firstName) ) {
    // Error: Only Cie name, no family name we might not find proper contact
    // TODO: we shall expose tome error here
  }
  
  let contacts = await findContacts(contactProps);
  
  if ( contacts.length === 0 ) {
    // No match found
    let alert = createAlertDialog(
      "Erreur", 
      `Aucun contact correspondant n'a été trouvé dans le compte par défaut. 
      Avez-vous sélectionné un contact entreprise ou votre compte par défault est-il différent de iCloud ?`, 
      "Annuler"
    );
    alert.presentAlert();
  }
  else if ( contacts.length > 1 ) {
    // More than one match
    let alert = createAlertDialog(
      "Erreur", 
      `Plusieurs contacts portent le même nom et prénom dans le compte par défaut.`, 
      "Annuler"
    );
    alert.presentAlert();
  }
  else {
    // Only one match
    let container = await ContactsContainer.default();
    
    let groupSelectedHandler = (group) => {
      console.log(`Group select: ${group}`);
      if ( null !== group ) {
        addContactToGroup(contacts[0], group);
      }
    };
    
    await selectContactGroup(container, groupSelectedHandler);
  }
}

// ===== INPUT HANDLING

/** Extract contact first name/last name from input and build a contact summary.
 * 
 * We expect to have two parameters from URL:
 * - `fn` for base64-encoded firstname
 * - `ln` for base64-encoded lastname
 */
function buildInputFromCallbackURL() {
  let params = URLScheme.allParameters();
  
  let lastnameB64  = params["ln"];
  let firstnameB64 = params["fn"];
  
  // We do not use this
  // let baseURL = params["x-success"]
  
  let lastnameData  = Data.fromBase64String(lastnameB64);
  let firstnameData = Data.fromBase64String(firstnameB64);
  
  let lastname  = lastnameData.toRawString();
  let firstname = firstnameData.toRawString();
  
  console.log(`Importing contact:\n${firstname} ${lastname}`);
  
  let contact = ContactProp();
  contact.firstName = firstname;
  contact.lastName  = lastname;
  
  return [ contact ];
}


/** Extract contact first/last nam from argument list provided by share sheet
 */
function buildInputFromShareSheet() {
  return args.plainTexts.map((arg) => {
    return getContactFromVCard(arg);
  });
}


// ===== CONTACT INTERACTION

/** Internal contact summary object.
 */
function ContactProp() {
  let contact = {
    org: null, // Not provided in Contact object
    fn:  null, // Full display name, formatted for display
    firstName: '',
    lastName: ''
  };
  
  return contact;
};


/** As share sheet provide a simple VCard we have to find matching contact ourselves.
 *
 * Without internal Contact.id property value we have to make a guess 
 * on the matching contact.
 *
 * This function just parses VCard to get main identification properties. 
 */
function getContactFromVCard(text) {
  let contact = ContactProp();
  
  let singleValueRE = /^(FN|ORG):(.+)$/i;
  let namesRE = /^N:(.+)$/i;
  let lines = text.split(/\r\n|\r|\n/);
  
   lines.forEach((line) => {
     if ( singleValueRE.test(line) ) {
       let matches = line.match(singleValueRE);
       let key   = matches[1].toLowerCase().trim();
       let value = matches[2].trim();
       
       contact[key] = value;
     }
     else if ( namesRE.test(line) ) {
       let matches = line.match(namesRE);
       let parts = matches[1].split(';');
       let lastName  = parts[0].trim();
       let firstName = parts[1].trim();
       
       contact['firstName'] = firstName;
       contact['lastName']  = lastName;
     }
   });
 
  return contact;  
}


/** Using core contact properties try to find matching contact.
 */
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


// ===== UI UTILITIES

/** Create a simple alert dialog.
 */
function createAlertDialog(title, message, cancelLabel) {
  let dialog = new Alert();
  
  dialog.title = title;
  dialog.message = message;
  
  dialog.addCancelAction(cancelLabel);
  
  return dialog;
}


// ===== TABLE OF GROUPS

/** Create a simple UITableRow for a group
 *
 * @param group 
 *        ContactsGroup object
 * @param selectFn 
 *        Function to call when group is selected `(group: ContactsGroup) => { ... }`
 */
async function createGroupRow(group, selectFn) { 
  let row = new UITableRow();
  row.height = 50;

  let members = await Contact.inGroups([group]);
  
  let nameCell = UITableCell.text(group.name);
  nameCell.leftAligned();
  
  let countCell = UITableCell.text(`${ members.length } contacts`)
  countCell.rightAligned();
  
  row.addCell(nameCell);
  row.addCell(countCell);

  row.onSelect = selectFn;
  
  return row;
}


/** Build a UITable to present a list of ContactsGroup.
 */
async function createGroupTable(groups, selectFn) {
  let table = new UITable();
  
  for ( group of groups ) {
    let row = await createGroupRow(group, selectFn);
    table.addRow(row);
  }
  
  return table;
}


// ===== CONTACT GROUP UTILITY

/** Order an array of ContactsGroup by their name.
 */
function orderGroups(groups) {
  groups.sort(
    (g1, g2) => { return g1.name.localeCompare(g2.name); }
  );
  
  return groups;
}


/** Show a list of groups and ask user to select one
 *
 * @param container
 *        The ContactsContainer that groups are part of.
 * @param selectedFn
 *.       Function that will be called when a group gets selected.
 *.       This function accepts a single ContactsGroup parameter.
 */
async function selectContactGroup(container, selectedFn) {
  let allGroups = await ContactsGroup.all([ container ]);
  
  let orderedGroups = orderGroups(allGroups);
  
  // We build a small function to map row number to group object
  // as this is the kind of parameter expected by the selectedFn parameter.
  let groupSelectionHandler = (index) => {
    let group = orderedGroups[index];
    selectedFn(group);
  };
  
  let groupTable = await createGroupTable(orderedGroups, groupSelectionHandler);
  
  groupTable.present();
}


/** Add the specified contact to the specified group.
 *
 * @param contact: Contact
 * @param group: ContactsGroup
 * @param container: ContactsGroup
 */
function addContactToGroup(contact, group) {
  group.addMember(contact)
  
  Contact.persistChanges()
  .then((data) => {
    console.log(`Contact ${ contact.familyName } added to group ${ group.name }.`); 
    Script.complete();
  })
  .catch((error) => {
    console.log(`Failed to add contact to group. ${error}`);
    let alert = createAlertDialog("Erreur", "Erreur. Verifiez que votre compte par défault pour les contacts est bien iCloud.", "OK")
    alert.present().then(
      () => { Script.complete(); }, 
      () => { Script.complete(); }
    );
  });
}
```


### Bilan


Avec ce script vous pouvez facilement ajouter un contact à un groupe, soit à partir de la feuille de partage, soit en appelant le script avec une URL.

Nous verrons dans un dernier article comment fonctionne un script qui nous 
permettra de visualiser les membres d’un groupe pour pouvoir supprimer
des membres.

