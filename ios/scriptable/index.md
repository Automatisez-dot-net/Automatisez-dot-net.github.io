---
layout: page
title: Scriptable pour iOS
order: -1
category: ios
header_banner: banner-mangue.jpg
logo: scriptable-app
download_url:
    - name: Scriptable
      url: https://scriptable.app
      description: L'application _Scriptable_ vous permet d'utiliser ECMAScript (JavaScript)
                   pour automatiser des tâches sur iOS.
---

_Scriptable_ c'est quoi ?

_Scriptable_ est une application qui vous permet d'écrire en 
JavaScript (ECMAScript) des programmes.

### Présentation

Cette application utilise l'implémentation de JavaScript intégrée à iOS, le 
moteur qui fait tourner les scripts sur les sites internet dans Safari.

Il vous permet d'écrire des programmes dans ce langage qui est très largement
répandu et assez simple.

Lorsque vous lancer _Scriptable_ vous trouverez une grille qui liste les différents 
scripts que vous avez installé sur votre terminal. 

__Important__: 
l'application est _gratuite_ mais vous pouvez soutenir
le développeur avec un petit pourboire via un achat intégré.
Si vous utilisez régulièrement l'application je vous encourage à montrer
à l'auteur [Simon B. Støvring](https://twitter.com/simonbs).


### L'écran d'accueil

L'interface est minimale: une seule barre d'outils avec un accès aux réglages
et un bouton «__+__» pour ajouter un nouveau script.

{% include post_image.html 
    src='/img/screenshots/apps/scriptable/scriptable-app-home.png' 
    alt="L'écran principal de Scriptable." %}

1. Les réglages de l'application;
2. Ajout d'un nouveau script.

Les scripts sont alors disponibles à travers l'application ou à travers
l'extension de la feuille de partage d'iOS.


### L'éditeur de scripts

L'éditeur de script est divisé en trois parties:

1. la barre d'outils;
2. l'éditeur;
3. la console.

{% include post_image.html 
    src='/img/screenshots/apps/scriptable/scriptable-app-editor.png' 
    alt="L'éditeur de script dans Scriptable." %}

1. «_done_» retourne à l'écran principal;
2. le bouton pour lancer un script;
3. le bouton de partage;
4. l'accès aux réglages du script;
5. l'accès à la documentation de _Scriptable_;
6. la zone d'édition;
7. la console où vous pouvez afficher le déroulement d'un script, des erreurs
   ou des traces de développement.

### Intégration à iOS

_Scriptable_ s'intègre parfaitement à iOS de deux façons:

1. _Siri_: chaque script peut être ajouté comme un raccourci Siri.
2. _Feuille de partage_: les scripts qui acceptent des données de la feuille de 
   partage seront automatiquement disponibles.

#### Intégration à Siri

Vous pouvez associer une phrase pour déclencher un script en utilisant
Siri.

Vous devez enregistrer cette phrase dans les réglages du script comme 
indiqué dans les copies écran ci-dessous.

{% include post_image.html 
    src='/img/screenshots/apps/scriptable/scriptable-app-siri.png' 
    alt="Ajouter un script à Siri" %}

#### Activez _Scriptable_ dans la feuille de partage

Lorque vous affichez la feuille de partage et que _Scriptable_
n'est pas disponible, vous devez l'activer, comme n'importe quelle
autre application.

{% include post_image.html 
    src='/img/screenshots/apps/scriptable/scriptable-app-share-conf.png' 
    alt="Activez Scriptable dans la feuille de partage." %}

1. allez en fin de liste et sélectionnez le bouton «_autres..._»;
2. activez l'élément «_run script_»;
3. fermez la configurationpour revenir à la feuille de partage.

À partir de ce moment l'application doit être disponible comme extension
de partage.

#### Accès à _Scriptable_ dans la feuille de partage

Dans la feuille de partage il faut simplement sélectionner 
«_run script_» pour afficher la grilles des scripts compatibles 
avec l'objet sélectionné.

Touchez le script à lancer.

{% include post_image.html 
    src='/img/screenshots/apps/scriptable/scriptable-app-share.png' 
    alt="Accès à vos scripts dans la feuille de partage" %}

__Remarque__: certains scripts utilisent plus de ressources que ce qui est
mis à disposition à une extension de partage. Si un script ne fonctionne 
pas correctement vous devrez activer l'option «_always run in app_».
