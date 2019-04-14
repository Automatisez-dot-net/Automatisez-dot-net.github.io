---
layout: post
title: Un service pour créer une copie datée d'un fichier
date: 2019-04-14 00:00:00 +02:00
logo: automator
attachments: 
  - name: "Service Fichier - copie datée.workflow"
    path: "processus/Service Fichier - copie datee.workflow.zip"
---

Pour éviter de perdre un document important, [parmi quelques astuces][1], 
Audrey propose de créer une copie datée d’un fichier.
Je vous indique dans cet article comment réaliser cette copie de façon très 
simple en vous appuyant sur une action rapide
écrite avec Automator et un peu de JavaScript.

### Objectif

L’objectif de ce service est de pouvoir rapidement créer un
double d’un document en lui ajoutant une date, celle du jour,
dans son nom.

Ainsi un fichier « _mon roman.rtf_ » sera modifié en 
« _mon roman 2019-04-14.rtf_ » si j’utilise le processus aujourd’hui.

Cela permet de toujours repartir sur une nouvelle copie, sans risquer de perdre
le travail des jours précédents en cas de pépin.

Ce n'est pas assez clair ? Regardez comment utiliser ce processus en images dans
la vidéo suivantes :

{% include youtube.html video_id="qKsteCNFoLE" %}


### Mise en place du processus

Lancez Automator et créez une action rapide.

Les actions rapides sont une version étendue des « Services » tel qu’ils
existaient avant macOS Mojave.

Ce type de processus peut être utilisée dans le menu des services, 
dans le _Finder_ mais aussi dans la Touch Bar des MacBook Pro qui en disposent.

Nous n’allons ajouter qu’une seule action à notre processus :
« _Exécuter JavaScript_ »

Cette action va être décomposée en parties bien distinctes dont le rôle
sera défini comme suit :

1. une fonction `run()` qui constitue le point d’entrée de notre script.
   c’est cette fonction qui sera appelée par Automator.
2. une fonction `buildDateText()` qui va être utilisée pour transformer la
   date d’aujourd’hui dans un format court « 2019-04-14 ».
3. une dernière fonction `buildNewName()` qui va insérer dans le nom d’un 
   fichier la date du jour. Si le nom contient déjà une date, elle sera 
   remplacée.

### La fonction principale _run()_

Pour réaliser la copie du fichier, nous allons utiliser directement
les interfaces de programmation de macOS : Cocoa.
C'est l'objet _NSFileManager_ qui va s'occuper de la copie.

Pour cela, notre code doit importer les fonctions de Cocoa,
récupérer une référence sur l'objet du gestionnaire de fichiers.

Le début de notre script est donc ce qui suit :

```javascript
'use strict';
ObjC.import('Cocoa');
```

La première ligne demande à JavaScript d’être un peu plus rigoureux sur
la façon d’écrire du code.

La seconde importe la bibliothèque _Cocoa_ dans notre script.

```javascript
const fileManagerApp = $.NSFileManager.defaultManager;

function run(input, parameters) { /* A REMPLIR */ }
```

Enfin, nous allons utiliser l'objet `$` qui est un pont entre JavaScript
et les interfaces de programmations Objective-C. Nous utilisons ici
le pont [JXA](https://en.wikipedia.org/wiki/AppleScript#JavaScript_for_Automation).

Avec `$.NSFileManager.defaultManager` nous allons donc récupérer une référence
sur l’objet partagé du gestionnaire de fichiers en Cocoa.

Il faut maintenant remplir le corps de la fonction `run()`.

```javascript
function run(input, parameters) {
  // La tableau pour le noms des fichiers créés
  const output = [];
  // La date du jour au format "AAAA-MM-JJ"
  const today = buildDateText(new Date());

  // Pour chaque élément passé en entrée de l'action
  input.forEach( current => {
    // On récupère le chemin original du fichier
    const sourcePath = current.toString();
    // On le modifie pour insérer ou remplacer la date par celle du jour
    const newPath = buildNewName(sourcePath, today);

    try {
      // Utilisation du gestionnaire de fichiers pour effectuer la copie
      fileManagerApp.copyItemAtPathToPathError(sourcePath, newPath, null);
    } catch (e) {
      // En cas d'erreur on affiche le fichier concerné
      throw new Error(`Copie impossible de "${ sourcePath }": ` + e);
    }
  });

  return output;
}
```

### Construire la date avec _buildDateText()_

On va afficher la date au format ISO, ce qui donne quelque chose comme :

  « 2019-04-13T23:10:42.238Z »

Nous ne voulons que le début, donc cette expression régulière 
récupère dans un groupe la partie qui précède le `T`

```javascript
function buildDateText(date) {
  // Ne retient que la date au format 2019-04-01 
  // dans une date/heure au format ISO
  const dateOnlyRE = /(\d\d\d\d-\d\d-\d\d)(.*)$/;
	
  // À partir de la date du jour, extrait uniquement la partie date.
  const dateAsText = date.toISOString();
  const dateOnly = dateAsText.replace(dateOnlyRE, '$1');

  return dateOnly;	
}
```

### Construire le nouveau nom de fichier avec _buildNewName()_

Dernière brique de ce petit script : la construction du nom final.

On commence par construire une expression régulière qui va nous servir 
à enlever une date qui serait déjà à la fin du nom, avant l’extension de fichier.

Cette première expression régulière sera utilisée avec `replace()` pour
éliminer, le cas échéant, la date du nom initial.

Une seconde expression régulière divise le nom entre ce qui précède l’extension
et l’extension elle-même. On pourra ainsi insérer la date entre les deux.

```javascript
function buildNewName(filePath, date) {
  // Noms contenant une date au format 2019-01-01
  // Les parenthèses groupes:
  // 1. le début du nom
  // 2. la date (optionnelle)
  // 3. la fin du nom, après la date
  const removeDateRE = /^(.*)\s+(\d\d\d\d-\d\d-\d\d)(\.[^.]+)$/;

  // Le nom divisé en deux groupes: chemin et extension
  const pathRE = /^(.*)(\.[^.]+)$/;
		
  // Dans le nom de fichier, remplace la date par la date du jour
  // ou ajoute là s'il n'y avais pas de date.
  let newPath = filePath.replace(removeDateRE, `$1$3`);
  newPath = newPath.replace(pathRE, `$1 ${date}$2`);
	
  return newPath;
}
```

### Finaliser le processus

Dans le cartouche placé au début du processus, configurez-le comme suit :

- il accepte des documents ;
- il ne s’applique que dans l’application _Finder_ ;
- choisissez une icône et une couleur à votre goût pour représenter cette
  action rapide sur la Touch Bar.

Ce qui donne le processus suivant :

{% include post_image.html 
    src='/img/screenshots/2019/04-14_fichier-copie-datee.png' 
    alt="Une action rapide pour cloner et dater un document." %}


### Conclusion

Nous avons vu dans cet exemple comment utiliser JavaScript avec Cocoa
en s’appuyant sur JXA (_JavaScript for Automation_).

Vous avez utilisé quelques expressions régulières et le gestionnaire de fichiers
[_NSFileManager_][2] pour cloner rapidement un document.

J’espère que ce petit processus vous sera utile pour créer en quelques clics
une copie de travail quotidienne de votre prochain chef-d’œuvre.

N’hésitez pas à télécharger et installer cette action rapide.

[1]: https://twitter.com/AudreyCouleau/status/1116994526051278849
[2]: https://developer.apple.com/documentation/foundation/nsfilemanager
