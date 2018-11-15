---
layout: post
title: Gérer les membres d'un groupe sur iPhone et iPad
date: 2018-11-14 10:00:00 +02:00
logo: scriptable-app
attachments:
  - name: Gérer les contacts d'un group (JavaScript pour _Shortcut_)
    url: https://raw.githubusercontent.com/automatisez/iOS-workflow/master/scriptable-app/contacts/manage-group-member.js
---

Voici le quatrième article de cette série consacrée à la gestion
des contacts avec _Scriptable_.
Nous avons vu comment créer et supprimer un groupe. 
Le script précédent indiquait comment ajouter un contact à un groupe.
Nous allons maintenant voir comment enlever un contact d'un groupe.

Je vous renvoie aux deux premiers articles de cette série :

- [créer un groupe](/ios/2018/11/04/creer-un-groupe-de-contacts.html) ;
- [supprimer un groupe](/ios/2018/11/07/supprimer-un-groupe-de-contacts.html) ;
- [ajouter un contact à un groupe](/ios/2018/11/10/ajouter-un-contact-a-un-groupe.html) ;

__Avertissement__ : Ce billet n’est pas une initiation à JavaScript.
    Il suppose que vous connaissez un minimum le langage.
    Si vous ne le maitrisez pas, ce n’est pas un souci. Vous pouvez vous
    contenter de copier le script tel quel.

Il n'est pas question de se lancer dans une explication ligne à ligne
du script que je vous propose ici. Je vais me limiter à expliquer le 
fonctionnement et le détailler pour les parties vraiment différents

### Le fonctionnement du script

Cet utilitaire vous propose un fonctionnement en deux étapes:

1. La _sélection du groupe_ dont vous voulez gérer les contacts
2. La _gestion_ des contacts du groupe choisi.

La gestion des contacts se résume à deux actions:

1. _retirer_ un membre du groupe;
2. _remettre_ un membre que vous venez d'enlever du groupe.

Lorsqu'un contact est enlevé du groupe il reste affiché, mais
avec un état différent. L'action possible est alors indiquée
à coté de l'icône d'état.

Comme le contact reste affiché dans le groupe, vous pouvez le 
toucher une seconde fois pour l'ajouter à nouveau au groupe.

Cet outil ne vous permet pas d'ajouter au groupe un contact qui
n'y est pas déjà.

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
groupes et l'affiche pour que vous sélectionniez celui à que vous
voulez gérer.

Dans la fonction `groupSelected()` le script récupère la liste
des membres, l'ordonne par ordre alphabétique avant d'appeler
`manageGroupMembers()` pour passer à l'étape de gestion des membres.

### Récupérer les membres du groupe choisi

Pour clarifier rapidement cette partie du code, vous pouvez
récupérer la liste des contacts d'un groupe avec cet appel:

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

### Afficher la liste des membres

### Gérer le retrait et l'ajout d'un contact

### Le script complet

### Bilan
