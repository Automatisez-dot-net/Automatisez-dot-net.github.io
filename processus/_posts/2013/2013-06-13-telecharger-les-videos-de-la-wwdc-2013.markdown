---
layout: post
title: "Télécharger les vidéos de la WWDC 2013"
date: 2013-06-13 12:00:00
logo: safari
attachments:
    - name: "Application pour télécharger les vidéos de la WWDC 2013"
      path: processus/download-WWDC.app.zip
---

Comment faire travailler votre Mac pour qu'il télécharge à votre place les 
vidéos de la WWDC 2013.

Cette astuce vous évitera de perdre du temps à faire le téléchargement lien 
par lien.

La technique est applicable à tous types de page web. Il vous suffit de modifier 
le lien de départ dans la variable.

{% include youtube.html video_id='MAWctqIEfEc' %}

### Comment utiliser le script?

Lancez l'application. 
Une fenêtre va s'ouvrir sur la page des vidéos de la WWDC. 
Identifiez-vous avec votre compte développeur Apple. 
Pour avoir l'identification il vous faut cliquer sur un lien de document.
Une fois la page affichée, il vous suffit de confirmer avec le bouton OK en 
bas de la fenêtre.

Le processus va alors rechercher les liens, vous proposer de les filtrer 
(par défaut je ne retiens que les PDF et les vidéos HD). 
Modifiez le filtre si besoin, validez et sélectionnez ensuite les liens 
à télécharger.

Pensez bien à modifier le dossier de destination.

Petit conseil: pour tester ne récupérez que les PDF. 
Cela sera plus rapide. Ensuite vous pourrez vous attaquer aux vidéos.

Il n'y a aucune indication de progression. 
Il faut donc être patient et surveiller le contenu de votre dossier destination.

{% include post_image.html 
    src='/img/screenshots/2013/06-13_app-download-WWDC.png' 
    alt="Le processus" %}



**Mise à jour:**
j'ai ajouté un tri des URL avant la sélection. 
Cela facilite la recherche d'une vidéo par URL.
