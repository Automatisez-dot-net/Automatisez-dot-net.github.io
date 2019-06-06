---
layout: post
title: macOS 10.14 Mojave et les actions Automator
date: 2019-06-06 20:00:00 +02:00
logo: automator
---

La version 10.14 de macOS (Mojave) a apporté un petit changement
dans la façon de gérer les actions de tierce partie dans Automator.
Quels sont ces changements et quelles actions devez-vous prendre ?

Je vais essayer dans cet article de vous présenter rapidement ces 
petits changements.

## Automator refuse les actions tierces

En effet, avant de pouvoir utiliser une action tierce, c’est à dire
qui n’est pas fournie par Apple, il est nécessaire d’autoriser
_explicitement_ l’utilisation de ces actions.

Vous allez vous retrouver face à deux situations :

1. Automator refuse d’insérer une action ;
2. Un processus existant refuse d’afficher une action.

En cas de refus vous aurez souvent un message d’erreur indiquant que 
le code de l’action ne peut pas être chargé. 

Si l’action est dans un processus que vous aviez défini dans une version
précédente du système, vous ne verrez pas l’action dans le processus.
Elle sera remplacée temporairement par une boite qui indique pourquoi l’action
est inactive :

{% include post_image.html 
    src='/img/screenshots/2019/06-06-disabled-action-in-process.png' 
    alt="si les actions tierces ne sont pas autorisées, elles sont remplacées dans processus existants par un message informatif." %}


La toute première fois, Automator vous demandera d’autoriser les actions
tierces, mais si vous refusez cette alerte ne devrait plus se présenter.

Pas d’inquiétude, si vous n’avez pas autorisé les actions lors de cette 
première demande,  il est possible d’activer les actions ultérieurement.

Dans Automator, allez dans le menu « _Automator_ » et sélectionnez 
« _Actions Automator de tierce partie_ ». 
Le dialogue vous détaille pourquoi Apple vous demande cette autorisation
et ce que peuvent _potentiellement_ faire les actions.

{% include post_image.html 
    src='/img/screenshots/2019/06-06-enable-3rd-party-actions.png' 
    alt="Alerte indiquant que les actions tierces doivent être autorisées." %}

Pensez bien à cocher l’option qui vous permet d’activer ces actions, un choix à 
confirmer avec le bouton « _OK_ ».


## Certains processus doivent être autorisés

Un second niveau de sécurité est venu s’incruster sur macOS. 
Il s’agit des autorisations d’accès.

Ces autorisations s’appliquent aux processus qui sont construits
comme des applications (extension « .app »)
comme les _services_ ou les _commandes dictées_.

Si, par exemple, vous installez un processus de type « commande dictée »,
vous allez souvent voir que le système ne l’exécute pas lorsque vous prononcez 
la phrase de déclenchement et que vous voyez qu’elle a pourtant été bien reconnue.

Vous allez alors voir une alerte comme celle qui suit :

{% include post_image.html 
    src='/img/screenshots/2019/06-06-voice-command-auth-request.png' 
    alt="Alerte indiquant quel processus cherche à utiliser un accès particulier. Le bouton 'ouvrir préférences système' permet de basculer dans les réglages." %}

Cette alerte vous détaille quel processus demande une autorisation et
pour quel usage.

Vous pouvez alors cliquer sur le bouton « _ouvrir Préférences Système_ »
pour autorisez aller le processus.

{% include post_image.html 
    src='/img/screenshots/2019/06-06-voice-command-a11y-auth-prefs.png' 
    alt="Les Préférences Système de sécurité et confidentialité" %}

Cette autorisation est spécifiée dans les « _Préférence Système_ »,
dans le panneau « _sécurité et confidentialité_ ».

Choisissez la catégorie dans la liste de gauche : 
ici l’accès aux fonctions d’accessibilité.

Vous pouvez évidemment retirer l’autorisation à un processus à tout moment.

-----

Voilà pour une mise cette courte mise au point sur Mojave et Automator.

Les contraintes de sécurité impactent autant les actions que vos processus.

Si vous constatez qu’un processus ne semble pas s’exécuter sans avoir de détails
particuliers, c’est peut-être qu’il lui manque des autorisations.
