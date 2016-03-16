---
layout: post
title: "Modifier la largeur d’un lot d’images"
date: 2013-02-11 12:00:00
logo: preview
attachments:
    - name: "Service - Redimensionner largeur d'images"
      path: processus/service-redimensionne-largeur-img.zip
---

Comment faire pour adapter rapidement la taille d’une image à une largeur 
donnée?

Il est possible d’ouvrir les images dans Aperçu pour les modifier une à une, 
mais on peut faire plus vite directement en utilisant un Service à partir 
du Finder.

**Remarque:** La création de services avec Automator requiert au minimum 
Mac OS X.6 Snow Leopard.

Il existe une action Automator qui permet directement de modifier la taille. 
Créer un service qui s’appuie sur cette action est la solution la plus simple 
et la plus directe.

Le service ne traite que des fichiers images. 
Comme il modifie le fichier sans le copier, une confirmation est présentée 
à l’utilisateur pour lui expliquer les conséquences de l’action.

{% include post_image.html 
    src='/img/screenshots/2013/02-11_serv-batch-upd-img-width.png' 
    alt="Service de modification de largeur d'image par lot" %}

### Téléchargement

Le processus final sera installé par OS X dans votre dossier «*Services*» 
dans votre dossier «*Bibliothèque*» personnel ou celui du système.
