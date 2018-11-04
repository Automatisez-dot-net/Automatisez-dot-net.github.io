---
layout: post
title: Créer un groupe de contacts sur iPhone et iPad
date: 2018-11-04 16:00:00 +02:00
logo: scriptable-app
---

Vous l’aurez surement remarqué, il n’est pas possible de créer des groupes
dans l’application _Contacts_ sur iOS. Elle ne vous permet pas plus de supprimer
vos groupes de contacts.

Si vous utilisez les groupes pour organiser vos différents contacts,
vous avez certainement ragé contre Apple qui vous oblige à passer par
un ordinateur pour créer ces groupes.

Dans cet article je vais vous montrer comment écrire deux courts programmes
avec _SCriptable_ qui vont vous permettre d’ajouter ces fonctions à votre appareil :

- un premier script pour créer un groupe de contacts ;
- un second script pour supprimer un groupe ;
- un dernier script pour associer des contacts à vos groupes.

__Avertissement__ : Cet article n’est pas une initiation à JavaScript.
    Il suppose que vous connaissez un minimum le langage.
    Si vous ne le maitrisez pas, ce n’est pas un souci. Vous pouvez vous
    contenter de copier le script tel quel.


### Créer votre script

Nous allons créer le premier script :
1. Commencez par installer l’application 
  [_Scriptable_](https://itunes.apple.com/us/app/scriptable/id1405459188) 
2. Lancez l’application et ajoutez un nouveau script.
3. L’éditeur va s’ouvrir pour vous permettre de commencer à coder et 
   à configurer votre nouveau script.

Nous allons construire un court programme interactif qui va agir en deux étapes :

1. un dialogue demande le nom du groupe à créer ;
2. le groupe est ajouté à vos contacts.


### Créer un groupe

#### Le cœur du script

Le script que nous voulons écrire suit les étapes suivantes :

```JavaScript
let groupName = await askForGroupName();

if ( null !== groupName ) {
  let group = createGroup(ContactsContainer.default(), groupName);
}
```

La première ligne appelle une fonction `askForGroupName()` qui va 
ouvrir un dialogue pour vous demander le nom d’un groupe.

Vous aurez surement remarqué que l’appel de la fonction est précédé par le
mot clé `await`. Beaucoup de fonctions de _Scriptable_ retournent des 
promesses (`Promise`), c’est-à-dire qu’elles ne sont pas exécutées
immédiatement.

Le mot clé `await` permets d’attendre que la promesse soit terminée.

Le script va ensuite créer le groupe uniquement si la valeur obtenue 
n’est pas la constante `null`.

Il faut évidemment commencer par coder la fonction `askForGroupName()`.

#### Le dialogue pour demander le nom

La fonction qui va demander le nom du groupe utilise un dialogue.
Comme cette fonction utilise la méthode `present()` sur le dialogue,
elle doit attendre la réponse. Le mot clé `await` est donc utilisé.

Le souci est qu’une fonction ne peut pas utiliser ce mot clé sans être
elle-même une fonction asynchrone. C’est pour cela que la fonction en
déclarée avec le mot clé `async`.

Si l’utilisateur choisit le bouton d’annulation, la valeur de retour est
`-1`.

Dans le cas contraire, on va chercher la valeur du premier champ texte
du dialogue pour avoir le nom du groupe.

C’est donc le nom du groupe ou la valeur `null` qui est renvoyé à la fin de 
la fonction.

```JavaScript
async function askForGroupName() {
  let dialog = createTextPrompDialog(
    "Nouveau groupe", 
    "Donnez un nom au groupe que vous voulez créer avec ce contact.", 
    "nom de groupe", 
    "mongroupe", 
    "Annuler", 
    "Créer un groupe"
    );
  
  let groupName = null; 
  let response = await dialog.present();
  
  if ( response >= 0 ) {
    groupName = dialog.textFieldValue(0);
  }
  
  return groupName;
};
``` 

__Note__ : Je ne détaille pas la fonction `createTextPrompDialog()`. 
    Elle est fournie avec le script et ne fait rien de plus que construire un
    dialogue avec les éléments indiqués. Ce n’est qu’une utilisation des
    objets fournis dans _Scriptable_.


#### Création du groupe

Notre script a demandé le nom du groupe à l’utilisateur.
Il ne reste plus qu’à le créer dans la base de données des contacts.

Pour cela, _Scriptable_ met à votre disposition des classes spécifiques :

- `ContactContainer` représente un compte pour gérer vos contacts, 
  typiquement iCloud.
- `Contact` représente un contact dans la base de données ;
- `ContactsGroup` permet d’interagir avec les groupes de contacts.

```JavaScript
function createGroup(container, groupName) {
  let group = new ContactsGroup();
  group.name = groupName;
  
  ContactsGroup.add(group, container.identifier);  
  Contact.persistChanges()
  .then((data) => {
    console.log(`Group created successfully: ${ group.name }`);
  })
  .catch((error) => {
    console.log(`Failed to create group ${error}`);
    let alert = createAlertDialog(
      "Erreur", 
      "Erreur. Verifiez que votre compte par défault pour les contacts est bien iCloud.", 
      "OK"
    );
    alert.present() ;
  });

  return group;
}
```

La fonction `createGroup()` va utiliser un compte pour y créer un group de contacts.

Dans les deux premières lignes la fonction crée un object `ContactsGroup`
et défini son nom à partir du second paramètre d’appel.

Le groupe est ensuite ajouté au compte indiqué. Cet ajout se fait par
un appel à la méthode `add()` de la classe `ContactsGroup`. C’est une méthode
de classe, statique, et non pas une méthode d’objet.

La modification doit ensuite être enregistrée et pour cela on doit appeller la
méthode `persistChanges()` de la classe `Contact`. 

Cette méthode renvoie évidemment une promesse. Mais comme je veux pouvoir 
afficher un message en cas d’erreur, je n’utilise pas le mot clé `await`.

L’appel de la méthode `then()` passe une fonction qui sera appelée lorsque
la promesse termine son exécution.

L’appel de la méthode `catch()` passe une fonction qui sera appelée en cas
d’erreur lors de l’enregistrement.

Une erreur peut en effet se produire si le compte n’autorise pas la création
de group, comme un compte Google Exchange.

#### Le Script complet

Vous pouvez copier directement ce script dans _Scriptable_ pour ajouter l'action.

Le script complet:

```JavaScript
function createTextPrompDialog(title, message, fieldLabel, fieldDefault, cancelLabel, actionLabel) {
  let dialog = new Alert();
  
  dialog.title = title;
  dialog.message = message;
  
  dialog.addTextField(fieldLabel, fieldDefault);
  dialog.addAction(actionLabel);
  dialog.addCancelAction(cancelLabel);
  
  return dialog;
}

function createAlertDialog(title, message, cancelLabel) {
  let dialog = new Alert();
  
  dialog.title = title;
  dialog.message = message;
  
  dialog.addCancelAction(cancelLabel);
  
  return dialog;
}

/** Prompt user with an alert asking for new group name.
 *
 * If user's select the cancel option, the null value will be returned.
 * 
 * If user confirms, the group name will be returned.
 */
async function askForGroupName() {
  let dialog = createTextPrompDialog(
    "Nouveau groupe", 
    "Donnez un nom au groupe que vous voulez créer avec ce contact.", 
    "nom de groupe", 
    "mongroupe", 
    "Annuler", 
    "Créer un groupe"
    );
  
  let groupName = null; 
  let response = await dialog.present();
  
  if ( response >= 0 ) {
    groupName = dialog.textFieldValue(0);
  }
  
  return groupName;
};


/** Create a group with single member in the specified container.
 */
function createGroup(container, groupName) {
  let group = new ContactsGroup();
  group.name = groupName;
  
  ContactsGroup.add(group, container.identifier);  
  Contact.persistChanges()
  .then((data) => {
    console.log(`Group created successfully: ${ group.name }`);
  })
  .catch((error) => {
    console.log(`Failed to create group ${error}`);
    let alert = createAlertDialog("Erreur", "Erreur. Verifiez que votre compte par défault pour les contacts est bien iCloud.", "OK")
    alert.present();
  });

  return group;
}


let groupName = await askForGroupName();

if ( null !== groupName ) {
  let group = createGroup(ContactsContainer.default(), groupName);
}
```


### Bilan

Vous avez maintenant un script pour créer un groupe en utilisant l’application
_Scriptable_.

Nous verrons dans un prochain article comment supprimer un groupe devenu
inutile.

