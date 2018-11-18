---
layout: post
title: Gérer les membres d'un groupe sur iPhone et iPad
date: 2018-11-15 10:00:00 +02:00
logo: scriptable-app
attachments:
  - name: Gérer les contacts d'un group (JavaScript pour Raccourcis)
    url: https://raw.githubusercontent.com/automatisez/iOS-workflow/master/scriptable-app/contacts/manage-group-member.js
---

Voici le quatrième article de cette série consacrée à la gestion
des contacts avec _Scriptable_.
Nous avons vu comment créer et supprimer un groupe. 
Le script précédent indiquait comment ajouter un contact à un groupe.
Nous allons maintenant voir comment enlever un contact d’un groupe.

Je vous renvoie aux deux premiers articles de cette série :

- [créer un groupe](/ios/2018/11/04/creer-un-groupe-de-contacts.html) ;
- [supprimer un groupe](/ios/2018/11/07/supprimer-un-groupe-de-contacts.html) ;
- [ajouter un contact à un groupe](/ios/2018/11/10/ajouter-un-contact-a-un-groupe.html) ;

__Avertissement__ : Ce billet n’est pas une initiation à JavaScript.
    Il suppose que vous connaissez un minimum le langage.
    Si vous ne le maitrisez pas, ce n’est pas un souci. Vous pouvez vous
    contenter de copier le script tel quel.

Il n’est pas question de se lancer dans une explication ligne à ligne
du script. Je vais me limiter à expliquer son 
fonctionnement et le détailler pour les parties vraiment différentes

### Le fonctionnement du script

#### Fonctionnement

Cet utilitaire vous propose un fonctionnement en deux étapes :

1. La _sélection du groupe_ dont vous voulez gérer les contacts
2. La _gestion_ des contacts du groupe choisi.

{% include post_image.html 
    src='/img/screenshots/2018/11-15_grp-contacts-manage-1.png' 
    alt="Sélection d'un groupe de contacts" %}

La gestion des contacts se résume à deux actions :

1. _retirer_ un membre du groupe ;
2. _remettre_ un membre que vous venez d’enlever du groupe.

Lorsqu’un contact est enlevé du groupe, il reste affiché, mais
avec un état différent. L’action possible est alors indiquée
à côté de l’icône d’état.

{% include post_image.html 
    src='/img/screenshots/2018/11-15_grp-contacts-manage-2.png' 
    alt="Retirer ou remettre un contact dans le groupe." %}

Comme le contact reste affiché dans le groupe, vous pouvez le 
toucher une seconde fois pour l’ajouter à nouveau au groupe.

Cet outil ne vous permet pas d’ajouter au groupe un contact qui
n’y est pas déjà.

#### Implémentation

La structure centrale du script est la suivantres:

```JavaScript
let container = await ContactsContainer.default();
    
async function groupSelected(group) {
  if ( null !== group ) {
    console.log(`Group: ${group.name}`);
    let members = await Contact.inGroups([ group ]);
    let orderedMembers = orderContacts(members);
    
    manageGroupMembers(container, group, members);
  }
};
    
await selectContactGroup(container, groupSelected);
```

La première action `selectContactGroup()` va construire une liste des
groupes et l’affiche pour que vous sélectionniez celui à que vous
voulez gérer.

Dans la fonction `groupSelected()` le script récupère la liste
des membres, l’ordonne par ordre alphabétique avant d’appeler
`manageGroupMembers()` pour passer à l’étape de gestion des membres.

### Récupérer les membres du groupe choisi

Pour clarifier rapidement cette partie du code, vous pouvez
récupérer la liste des contacts d’un groupe avec cet appel :

```JavaScript
let members = await Contact.inGroups([ group ]);
```

La méthode étant asynchrone l'utilisation d'`await` est obligatoire.

Le tri des contacts est assez basique et utilise simplement 
la fonction `sort()`.

```JavaScript
function orderContacts(contacts) {
  contacts.sort(
    (c1, c2) => { return c1.familyName.localeCompare(c2.familyName); }
  );
  
  return contacts;
}
```

La fonction utilise la fonction `localeCompare()` avec le champ
`familyName`. Libre à vous d'améliorer ce tri avec votre propre
technique de tri.

### Afficher la liste des groupes

C'est la fonction `selectContactGroup()` qui va récupérer la liste de groupes
pour l'afficher.

```JavaScript
async function selectContactGroup(container, selectedFn) {
  let allGroups     = await ContactsGroup.all([ container ]);
  let orderedGroups = orderGroups(allGroups);
  
  let groupSelectionHandler = (index) => {
    let group = orderedGroups[index];
    selectedFn(group);
  };
  
  let groupTable = await createGroupTable(orderedGroups, groupSelectionHandler);
  
  groupTable.present();
}
```

Rien de bien original dans cette fonction. 
Elle récupère la liste des groupes avec la méthode `ContactsGroup.all()`
puis les ordonne par nom avec `orderGroups()`.

Comme dans les scripts précédents, une fonction se charge de construire
une liste `UITable`. 

Le second paramètre est une fonction appelée lorsqu’une ligne est sélectionnée.
Son argument est un numéro de ligne. 
Nous construisons donc une petite fonction dans `groupSelectionHandler` pour 
traduire ce numéro en abject groupe et la passer à la vraie fonction de 
traitement.

Je ne détaille pas les fonctions utilisées pour construire la liste proprement
dite, elles sont similaires à ce que nous avons vu dans les articles précédents.

### Afficher la liste des membres

C’est la fonction `manageGroupMembers()` qui prend en charge la suite des
évènements. 
Elle va construire une liste intermédiaire d’objets `GroupMember`
qui gardent :

- une référence `group` sur le `ContactsGroup` ; 
- `contact` qui référence l’object `Contact` ;
- et un indicateur `isMember` sur la présence dans le groupe.

```JavaScript
function GroupMember(group, contact) {
  let member = {
    group: group,
    contact: contact,
    isMember: true
  };
  
  return member;
}
```

L’intérêt de cette liste est de préserver la liste des contacts pour
pouvoir les retirer mais aussi les réinsérer dans le groupe.

Si l’on ne manipulait que les contacts, une fois supprimés, nous n’aurions
plus le contact dans la liste et ne serions plus capables de le réintégrer.

```JavaScript
async function manageGroupMembers(container, group, contacts) {
  let memberList = contacts.map(
    (contact) => { return GroupMember(group, contact); }
  );
  
  let selectHandler = (member, complete) => {
    // A FAIRE...
  };
  
  let table = await createMembersTable(memberList, selectHandler);
  table.present();
}
```

Le reste de la fonction consiste à créer une fonction pour
gérer la sélection d’un contact et réaliser l’action appropriée.

Cette fonction est utilisée avec la liste des contacts pour construire la
liste de contacts avec `createMembersTable()` et l’afficher avec
`table.present()`.

### Gérer le retrait et l'ajout d'un contact

Détaillons un peu la fonction qui gère la sélection d'un contacts.

```JavaScript
let selectHandler = (member, complete) => {
  if ( member.isMember ) {
    removeContactFromGroup(member.contact, group, () => { 
      member.isMember = false; 
      complete();
    });
  }
  else {
    addContactToGroup(member.contact, group, () => { 
      member.isMember = true; 
      complete();
    });
  }
};
```

Cette fonction vérifie l’état du contact par rapport au groupe.

Si le contact est dans le groupe (`isMember`est vrai), on retire le contact
du groupe avec `removeContactFromGroup()`. 
Au contraire, s’il a été retiré on va l’ajouter à nouveau avec 
`addContactToGroup()`.

Les fonctions sont asynchrones. On doit donc passer une fonction à exécuter
en cas de succès.

#### Gérer la sélection au niveau de la table

Cette fonction va modifier l'état et appeler à son tour une fonction de 
terminaison. Cette fonction est définie au moment de la création de la table.

```JavaScript
async function createMembersTable(members, selectFn) {
  let table = new UITable();
  
  let selectedFn = (rowIndex) => {
    let member = members[rowIndex];
    selectFn(member, () => { 
      refreshMembersTable(table, members, selectedFn);
    });
  };
  
  await refreshMembersTable(table, members, selectedFn);
  
  return table;
}
```

En effet, en plus de traduire un numéro de ligne en contact, cette fonction 
doit reconstruire la liste des contacts pour afficher le nouvel état, et
l'action disponible, lorsque l'ajout ou la suppression est terminé.

#### La fonction de retrait

```JavaScript
function removeContactFromGroup(contact, group, complete) {
  group.removeMember(contact);
  
  Contact.persistChanges()
  .then((data) => {
    complete();
  })
  .catch((error) => {
    let alert = createAlertDialog(
      text.i18n('error'),
      text.i18n('error.msg.remove'),
      text.i18n('ok')
      );
    alert.present();
  });
}
```

L’essentiel du travail est réalisé par `removeMember()`, mais doit être
validé par `Contact.persistChanges()`.

La fonction `complete` est appelé en cas de succès pour rafraichir
le contenu de la table. 
Dans le cas inverse, un message d’erreur est affiché.

#### La fonction d'ajout

```JavaScript
function addContactToGroup(contact, group, complete) {
  group.addMember(contact)
  
  Contact.persistChanges()
  .then((data) => {
    complete();
  })
  .catch((error) => {
    let alert = createAlertDialog(
      text.i18n('error'),
      text.i18n('error.msg.restore'),
      text.i18n('ok')
      );
    alert.present();
  });
}
```

C’est la fonction `addMember()` qui va réaliser l’action, mais elle doit encore
être validée par `Contact.persistChanges()`.

Dans ce cas aussi, un message d’erreur est affiché si l’ajout ne 
fonctionne pas. 

### Bilan

Le script complet est disponible en téléchargement avec cet article.

Nous avons écrit un total de quatre scripts pour gérer les contacts
directement sur iPhone.

{% include post_image.html 
    src='/img/screenshots/2018/11-15_grp-contacts-manage-0.png' 
    alt="Les scripts de gestion de contacts." %}

Nous verrons dans d’autres articles comment intégrer ces scripts avec
_Raccourcis_ pour proposer une intégration peut-être plus adaptée.

Évidemment ces scripts ne peuvent pas rivaliser avec une application native
du point de vue ergonomique. Mais au moins vous savez ce qui est proposé et 
vous avez les informations pour personnaliser ces outils.

N’hésitez pas à me parler de vos améliorations.
