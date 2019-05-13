---
layout: post
title: Une application macOS en JavaScript ?
date: 2019-05-13 06:00:00 +02:00
logo: js-jxa
attachments: 
  - name: "jxa-droplet.app (Zip de 56Ko)"
    path: "scripts/jxa-droplet.app.zip"
---

AppleScript n'est pas la seule solution pour construire des scripts
sur macOS.
Vous pouvez parfaitement utiliser JavaScript, mais il peut être un
peu plus difficile de s'y mettre.

_Paradoxal ?_ Pas tant que ça. 

AppleScript profite de son ancienneté et accumule un nombre vraiment
important de ressources et d'exemples.

Au contraire, JavaScript souffre du complexe du cadet et ne profite pas
du même niveau de littérature.

D'autres inconvénients plombent l'intérêt pour JXA, mais ce n'est pas 
le sujet de cet article.

## JavaScript pour l'Automatisation (JXA)

JavaScript est donc un langage « alternatif » à AppleScript.

Vous pouvez facilement écrire des scripts avec l'_Éditeur de Scripts_.
Si par défault c'est encore AppleScript qui est le langage par défaut, 
vous pouvez basculer en JavaScript en choisissant ce langage dans l'éditeur:

{% include post_image.html 
    src='/img/screenshots/2019/05-13_edit-script.png' 
    alt="Choisissez JavaScript ou AppleScript dans l'éditeur" %}

Les préférences permettent de choisir le langage par défaut :

{% include post_image.html 
    src='/img/screenshots/2019/05-13_edit-script-prefs.png' 
    alt="Définir le langage par défaut pour l'Éditeur de Scripts" %}

Commencez par créer un script vide et sélectionnez JavaScript
pour le langage de programmation.

## Écrire une application autonome en JavaScript

Les scripts commencent généralement par deux actions :
1. récupérer l'application courante ;
2. activer les extensions standard de script pour cette application.

Cela se traduit par les deux lignes suivantes :

```JavaScript
var app = Application.currentApplication();
app.includeStandardAdditions = true;
```

Un script JavaScript répond aux même _handlers_ qu'en AppleScript.

Ainsi, lorsque votre script est éxécuté c'est la fonction `run()` qui
va être appelée.

**Note :**
Cette fonction est obligatoire. Mais si vous ne la définissez pas, 
c'est la totalité du script qui sera utilisée comme corps de cette fonction
`run()` et la première série d'instructions du script sera exécutée.

Ajoutez donc une fonction pour gérer le lancement de l'application :

```JavaScript
function run(argv) {
    app.displayAlert('Run: ' + JSON.stringify(argv));
}
```

Mais pour l'instant vous n'avez qu'un script.

Pour transformer ce script en application vous devez l'exporter :
1. Dans le menu _Fichier_, sélectionnez l'élément _Enregistrer..._
2. Indiquez bien le format « application ».

{% include post_image.html 
    src='/img/screenshots/2019/05-13_01-enregistrer-app.png' 
    alt="Enregistrez votre script comme application" %}

Notez qu'à partir du moment où votre script est une application, il
devient possible d'afficher un volet latéral sur la droite:

{% include post_image.html 
    src='/img/screenshots/2019/05-13_02-bundle-content.png' 
    alt="Le contenu de votre application" %}

À partir de ce volet vous pouvez ajouter des bibliothèques de scripts,
rédiger la description du script et lui associer un icône personnalisé.


## Transformer l'application en « droplet »

Avec une _droplet_ AppleScript il est facile de traiter des documents simplement
en les glissant sur l'icône du script.

On peut faire la même chose en JavaScript en ajoutant un _handler_ 
`openDocuments()`.

**Note :** C'est une différence avec AppleScript où le même handler est nommé
`on open`.

```JavaScript
function openDocuments(docs) {
    app.displayAlert('Open: ' + docs.join(' ; '));
}
```

Cependant, si vous essayer de déposer un fichier sur votre script vous verrez 
qu'il refuse tout type de documents.

C'est là que les choses se compliquent un peu et qu'il faut sortir de l'éditeur de
scripts.


## Accepter l'ouverture de documents

En effet, la fonction `openDocuments()`ne sera jamais appelée si votre 
application n'indique pas quels sont les types de fichiers qu'elle accepte 
de manipuler.

Vous devez modifier, _manuellement_, le fichier de propriétés (plist) 
dans le dossier de votre application.

En effet, si vous ne le savez pas, une application sur macOS n'est rien d'autre
qu'un dossier avec l'extension « .app ». Les dossiers présentés comme de 
simples fichiers par le Finder sont appelés des _bundles_.

Chaque application est décrite, sans son dossier bundle, par un ensemble de
propriétés dans un fichier « Info.plist ».

Affichez votre script dans le Finder, et avec un clic secondaire, affichez le 
contenu du paquet (_bundle_).
Vous devriez voir un fichier « Info.plist ».

{% include post_image.html 
    src='/img/screenshots/2019/05-13_03-finder-bundle-content.png' 
    alt="Le contenu du dossier de votre application" %}

Dans ce fichier il vous faut ajouter la clé `CFBundleDocumentTypes` 
et lui associer une liste de types, par exemple :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleAllowMixedLocalizations</key>
	<true/>
	<key>CFBundleDevelopmentRegion</key>
	<string>English</string>
        ...
	<key>CFBundleDocumentTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeName</key>
			<string>Fichiers</string>
			<key>LSHandlerRank</key>
			<string>Default</string>
			<key>LSItemContentTypes</key>
			<array>
				<string>public.file</string>
			</array>
		</dict>
	</array>
        ...
</dict>
```

Ouvrez le fichier avec un éditeur de texte simple. 
TextEdit fait parfaitement l'affaire tant que vous rester sur du texte brut.

Le texte après `CFBundleTypeName` est purement descriptif. 
Mais utilisez un terme commun et compréhensible.

La valeur associée à `LSItemContentTypes` est une liste de `<string>`.
Le plus simple est généralement de se limiter à une des valeus suivantes :

- `public.image`: une image
- `public.text`: un fichier texte
- `public.file`: n'importe quel type de fichier

Enregistrez le fichier et normalement vous devriez pouvoir faire glisser
tout type de fichier sur l'icône de votre script.

## Conclusion

Vous avez maintenant un squelette d'application prêt à l'emploi et il ne vous 
reste plus qu'à remplir les blancs pour ajouter votre propre code.

Nous verrons dans de futurs articles des exemples pratiques de scripts.

