---
layout: post
title: "Ouvrir un site dans Chrome"
date: 2014-05-12 12:00:00
logo: safari
youtube_id: 6Imb-3SX2a0
---

Un service qui vous permet de basculer de Safari à Chrome en ouvrant 
automatiquement la page affichée dans Safari. 
Un moyen simple de profiter du plug-in Flash de Chrome et ne pas avoir 
à l’installer sur votre Mac.

### Il était une fois Flash. Sans Flash.

Dans cet article, je vais commencer par un aveu: 
depuis deux ans et demi, j’ai une machine sans plug-in Flash installé. 
Et je m’en porte très bien.

Vous vous demandez certainement comment je fais pour profiter des vidéos sur 
YouTube et ailleurs. 
Dans les cas, de plus en plus rares, ou une version HTML5 n’est pas proposée, 
je bascule dans Google Chrome.

En effet, le navigateur de Google a la particularité de pouvoir afficher du 
contenu Flash sans avoir besoin du plug-in du même nom. 
Une caractéristique bien pratique lorsqu’il s’agit de limiter les risques en 
matière de sécurité, car, oui, Flash est régulièrement la victime de failles 
plus ou moins importantes.

Vous me direz certainement qu’il est probablement pénible de devoir ouvrir 
une adresse, se rendre compte que cela ne fonctionne pas, et copier l’URL 
pour l’ouvrir sur Chrome. 

Effectivement, si je devais faire cela à chaque fois je pourrais trouver 
cela pénible. Mais vous oubliez les services et Automator !

Je vais vous montrer comment en quelques clics il est facile de basculer de 
Safari à Chrome, tout cela avec un peu d’AppleScript et un service construit 
avec Automator.

### Créons le service...

Ouvrez Automator pour créer un nouveau service.

Configurez ce nouveau service pour qu’il accepte des URL en entrée et soit 
accessible uniquement dans Safari.

Ajoutez une action pour exécuter de l’AppleScript et remplacer le script par 
le suivant:

``` AppleScript
on run {input, parameters}
    tell application "Google Chrome"
        activate
        open locationinput
    end tell
    return input
end run
```

Le script fini devrait ressembler à ce qui suit :

{% include post_image.html 
    src='/img/screenshots/2014/05-12_Serv-Ouvrir-dans-Chrome.png' 
    alt="Le processus au complet" %}

Et voilà, il ne vous reste plus qu’à enregistre votre service et le tester. 

### Configurez un raccourci clavier

S’il est pratique de pouvoir accéder facilement à un service via le menu de 
l’application courante, ce n’est pas toujours le moyen le plus rapide. 
Un bon raccourci clavier est souvent plus rapide et plus simple.

Pour cela, ouvrez l’application des *Préférences* et dans le panneau des 
réglages du clavier ajoutez un raccourci pour votre service. 
Si vous ne savez pas faire, la manipulation est visible dans la vidéo 
associée à cet article.

{% include youtube.html video_id=page.youtube_id %}

### Testez

Ouvrez une page de YouTube dans Safari et allez sur la page d’une des vidéos. 
Vous devriez pouvoir utiliser le menu des service ou directement votre nouveau 
raccourci clavier, pour basculer vers Chrome tout en ouvrant la même page.

Et voilà comment en quelques lignes il est possible de créer un service simple 
plutôt utile. 
