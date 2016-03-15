---
layout: post
title: Détecter une insertion de disque
date: 2013-05-12 12:00:00
logo: folder
attachments:
    - name: "Detecter insertion volume"
      path: processus/detecter-insertion-volume.zip
---

Vous aimeriez déclencher un processus lorsqu'un disque externe ou une clé USB 
sont connectés à votre Mac? Voici comment faire.

Pour détecter l’insertion d’un disque externe, ou d’une clé USB, il existe une 
astuce relativement simple.

Tous les volumes sont répertoriés dans le dossier «*/Volumes*». 
À chaque insertion, un raccourci est créé dans ce dossier.

Pour détecter une insertion, il vous suffit donc de créer une action de dossier 
qui sera avertie lorsqu’un nouveau raccourci est créé dans ce dossier.

Il vous suffit ensuite de filtrer en fonction du nom du volume pour savoir 
si votre processus doit être exécuté.
￼
{% include post_image.html 
    src='/img/screenshots/2013/05-12_folderaction-detect-mount-volume.png' 
    alt="Action de dossier, détecter l'insertion d'un volume" %}

**Installation**

Ce petit exemple ne fait rien de plus que vous avertir. 
Utilisez-le comme base pour vos processus.
Comme toute action de dossier il va s'installer dans votre dossier 
«*~/Bibliothèque/Workflows/Applications/Folder Actions*»
