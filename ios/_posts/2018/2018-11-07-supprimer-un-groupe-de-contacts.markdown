---
layout: post
title: Supprimer un groupe de contacts sur iPhone et iPad
date: 2018-11-07 07:00:00 +02:00
logo: scriptable-app
---

Nouvel épisode dans la série d’articles sur _Scriptable_.
Nous allons découvrir dans cet exemple comment supprimer un groupe de contacts.

Dans ce second article, après avoir vu comment 
[créer un groupe](/ios/2018/11/04/creer-un-groupe-de-contacts.html), 
nous allons écrire un script pour supprimer un groupe toujours avec 
_Scriptable_.

__Avertissement__ : Cet billet n’est pas une initiation à JavaScript.
    Il suppose que vous connaissez un minimum le langage.
    Si vous ne le maitrisez pas, ce n’est pas un souci. Vous pouvez vous
    contenter de copier le script tel quel.


### Créer le script

Nous allons créer le premier script :

1. Commencez par installer l’application 
  [_Scriptable_](https://itunes.apple.com/us/app/scriptable/id1405459188) 
2. Lancez l’application et créez un nouvel élément.
3. L’éditeur va s’ouvrir pour vous permettre de commencer à coder et 
   à configurer votre nouveau script.

Nous allons construire un court programme interactif qui va agir en deux étapes :

1. l’utilisateur va devoir choisir un groupe à supprimer 
   dans la liste de tous les groupes ;
2. le groupe sélectionné sera supprimé.

Le corps du script que nous allons écrire comprend les instructions suivantes :

```JavaScript
let container = await ContactsContainer.default();
let allGroups = await ContactsGroup.all([ container ]);
let orderedGroups = orderGroups(allGroups);
let groupTable = await createGroupTable(orderedGroups);

groupTable.present();
```

Sur les deux premières lignes, on récupère `container` le compte par défaut 
pour les contacts et `allGroups` pour la liste de tous les groupes du compte.

Notez que les fonctions renvoient des promesses et que nous utilisons donc 
`await` pour attendre la résolution de celle-ci.

Dans un second temps on ordonne les groupes dans l’ordre alphabétique
en appelant une fonction `orderGroups()` que nous allons écrire.

Enfin, la dernière étape consiste à appeler une méthode `createGroupTable()`
pour construire une liste (un composant _UITable_ natif sur iOS) pour afficher 
la liste des groupes.

Tous les éléments sont maintenant en place. Il ne reste plus qu’à afficher le
tableau et gérer la sélection de l’utilisateur.

_Vous vous demandez où se trouve notre code pour gérer la sélection ?_

Il est intégré dans le code qui construit la table. 
Nous verrons comment cela fonctionne ci-dessous.


### Trier les groupes par nom

Le tri de la liste des objets _ContactsGroup_ n’a rien de complexe.

Il faut utiliser la fonction `sort()` standard en lui passant la fonction
de comparaison.

Pour comparer les noms j’utilise `localeCompare()` qui permet de tenir compte
des spécificités de langues. La fonction compare les noms des groupes entre eux.

```JavaScript
function orderGroups(groups) {
  groups.sort(
    (g1, g2) => { return g1.name.localeCompare(g2.name); }
  );
  
  return groups;
}
```

### Afficher la liste des groupes

#### Construire la table

Pour afficher la liste des groupes, il faut construire un tableau qui va afficher 
deux informations :

1. le nom du groupe ;
2. le nombre de contacts qu’il contient.

La fonction qui construit la table est très simple. Elle se contente de
parcourir la liste des groupes, qui est déjà triée, et elle ajoute pour chacun 
une nouvelle ligne de tableau.

La création de ces lignes est déléguée à une autre fonction : `createGroupRow()`.
Cette fonction est asynchrone, on utilise donc `await` pour attendre le résultat.

```JavaScript
async function createGroupTable(groups) {
  let table = new UITable();
  
  for ( group of groups ) {
    let row = await createGroupRow(group);
    table.addRow(row);
  }
  
  return table;
}
```

#### Construire une ligne de la table

Chaque ligne de tableau est construite à partir de cellules. Nous allons créer
une cellule pour le nom, et une autre pour le nombre de contacts.

```JavaScript
async function createGroupRow(group) {
  let row = new UITableRow();
  row.height = 50;

  let members = await Contact.inGroups([group]);
  
  let nameCell = UITableCell.text(group.name);
  nameCell.leftAligned();
  
  let countCell = UITableCell.text(`${ members.length } contacts`)
  countCell.rightAligned();
  
  row.addCell(nameCell);
  row.addCell(countCell);

  return row;
}
```

La fonction commence par créer un objet `UITableRow` pour la ligne de tableau.
On indique que la ligne doit faire 50 points de haut, le calcul automatique 
n’étant pas encore géré.

On doit ensuite obtenir le nombre de membres dans le groupe.
Pour cela c’est la fonction `inGroup()`, méthode statique de la classe `Contact`
qui est appelée. La fonction étant asynchrone, nous devons encore utiliser `await`.

Il ne reste plus qu’à créer les deux cellules `nameCell` et `countCell`
en ajustant l’alignement du texte dans les deux cellules.

Une fois les cellules ajoutées à l’objet `row` on peut renvoyer ce dernier.


### Récupérer la sélection du groupe

Il est maintenant temps de prendre en charge la sélection du groupe.

Cette sélection est réalisée lorsque l’utilisateur touche la ligne correspondante dans la table.

Il faut réagir à cet évènement et déclencher la suppression du groupe.

Le code de gestion de la sélection d’une ligne doit être attaché à l’objet 
`UITableRow` dans la propriété `onSelect`.

La fonction de gestion de sélection accepte un paramètre : 
le numéro de la ligne sélectionnée.


```JavaScript
async function createGroupRow(group) {

  // ... ajoutez ceci

  row.onSelect = (number) => {
    confirmDeleteGroup(group);
  }
  
  return row;
}
```

Comme vous pouvez le voir dans le code ci-dessus, le gestionnaire de sélection
appelle la méthode `confirmDeleteGroup()`. Nous allons détailler cette méthode
ci-dessous.


### Supprimer le groupe dans la base de contacts

Lorsque l’utilisateur sélectionne un groupe à supprimer,
nous allons commencer par lui demander de confirmer l’action de suppression.

Ce n’est que s’il confirme que nous réaliserons vraiment
la suppression.


#### Demander une confirmation

Pour demander la confirmation, on doit créer un objet `Alert`.

L’alerte est configurée en précisant son titre, un message qui rappelle le nom
du groupe sélectionné.

On doit ensuite ajouter un bouton pour une action destructive avec 
`addDestructiveAction()`. 
L’action d’annulation est ajoutée avec `addCancelAction()`.

L’alerte est affichée de façon asynchrone. 
Lorsque la promesse est résolue, on appellera la fonction indiquée à la méthode
`then()`.

Notre fonction récupère la réponse qui indique le numéro du bouton sélectionné.
Si la réponse est négative, c’est l’annulation qui a été sélectionnée.

Ce n’est donc que si la réponse est différente que l’on appellera la fonction
`deleteGroup()`.


```JavaScript
function confirmDeleteGroup(group) {
  let alert = new Alert();
  
  alert.title = "Confirmation";
  alert.message = `Vous aller supprimer le groupe de contacts "${ group.name }".`;
  
  alert.addDestructiveAction("Supprimer le groupe");
  alert.addCancelAction("Annuler");
    
  alert.presentAlert()
  .then((response) => {
    if ( -1 != response ) {
      deleteGroup(group);
    }
  });
}
```

Voyons maintenant comment coder la fonction de suppression `deleteGroup()`.


#### Supprimer le groupe

Pour supprimer un groupe, il suffit d’appeler la méthode `delete()`
sur la classe `ContactsGroup`. 

Le plus important est ensuite de valider la modification en appelant 
`persistChanges()` sur la classe `Contact` pour assurer la sauvegarde.

La fonction renvoie une promesse. Nous devons donc spécifier une fonction 
de traitement à la méthode `then()`. La gestion des erreurs sera prise en charge 
dans la fonction transmise à `catch()`.

En cas de succès, rien ne sera fait. On se contente d’afficher l’information dans
la console.

En cas d’erreur, on affichera une alerte pour avertir l’utilisateur.

```JavaScript
function deleteGroup(group) {
  ContactsGroup.delete(group);
  
  Contact.persistChanges()
  .then((data) => {
    console.log(`Group ${ group.name } successfully deleted.`);
  })
  .catch((error) => {
    console.log(`Failed to delete group ${error}`);
    let alert = createAlertDialog("Erreur", "Erreur. Verifiez que votre compte par défault pour les contacts est bien iCloud.", "OK")
    alert.present();
  });
}
```

### Le Script complet

Vous pouvez copier directement ce script dans _Scriptable_ pour ajouter l'action.

Le script complet:

```JavaScript

function createAlertDialog(title, message, cancelLabel) {
  let dialog = new Alert();
  
  dialog.title = title;
  dialog.message = message;
  
  dialog.addCancelAction(cancelLabel);
  
  return dialog;
}


function deleteGroup(group) {
  ContactsGroup.delete(group);
  
  Contact.persistChanges()
  .then((data) => {
    console.log(`Group ${ group.name } successfully deleted.`);
  })
  .catch((error) => {
    console.log(`Failed to delete group ${error}`);
    let alert = createAlertDialog("Erreur", "Erreur. Verifiez que votre compte par défault pour les contacts est bien iCloud.", "OK")
    alert.present();
  });
}

  
function confirmDeleteGroup(group) {
  let alert = new Alert();
  
  alert.title = "Confirmation";
  alert.message = `Vous aller supprimer le groupe de contacts "${ group.name }".`;
  
  alert.addDestructiveAction("Supprimer le groupe");
  alert.addCancelAction("Annuler");
    
  alert.presentAlert()
  .then((response) => {
    if ( -1 != response ) {
      deleteGroup(group);
    }
  });

}
  
  
function contactDisplayName(contact) {
  let name = null;
  
  if ( contact.familyName ) {
    name = contact.familyName;
    if ( contact.givenName ) {
      name = name + ' ' + contact.givenName;
    }
  }
  
  return name;
}
  
async function createGroupRow(group) {
  let row = new UITableRow();
  row.height = 50;

  let members = await Contact.inGroups([group]);
  
  let nameCell = UITableCell.text(group.name);
  nameCell.leftAligned();
  
  let countCell = UITableCell.text(`${ members.length } contacts`)
  countCell.rightAligned();
  
  row.addCell(nameCell);
  row.addCell(countCell);

  row.onSelect = (number) => {
    confirmDeleteGroup(group);
  }
  
  return row;
}

async function createGroupTable(groups) {
  let table = new UITable();
  
  for ( group of groups ) {
    let row = await createGroupRow(group);
    table.addRow(row);
  }
  
  return table;
}

function orderGroups(groups) {
  groups.sort(
    (g1, g2) => { return g1.name.localeCompare(g2.name); }
  );
  
  return groups;
}


let container = await ContactsContainer.default();
let allGroups = await ContactsGroup.all([container]);
let orderedGroups = orderGroups(allGroups);
let groupTable = await createGroupTable(orderedGroups);

groupTable.present();


```


### Bilan

Pour ce second exemple de script _Scriptable_ nous avons construit un moyen
simple pour supprimer un groupe.

Nous avions déjà vu comment en ajouter un.

Dans la troisième et dernière partie de cette série, nous verrons comment
gérer les membres d’un groupe.

