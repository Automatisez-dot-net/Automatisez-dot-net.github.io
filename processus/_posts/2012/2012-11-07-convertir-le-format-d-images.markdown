---
layout: post
title: Convertir le format d'images
date: 2012-11-07 12:00:00
logo: preview
attachments:
    - name: "Service convertir vers JPEG"
      path: processus/service-convert-vers-jpeg.zip
---

Vous avez une série de captures écrans stockées dans le format PNG, ou des 
documents numérisés en TIFF, et vous voulez les transformer en JPEG rapidement 
pour les envoyer par email ou les publier sur un blog?

Faites-vous un service pour ça !

<div class="alert alert-warning">
Remarque&nbsp;: La création de services avec Automator requiert au minimum 
Mac OS X.6 Snow Leopard.
</div>

Il est souvent utile de transformer une série d’images dans un autre format 
pour pouvoir les publier ou les échanger.

Si passer par Aperçu ou tout autre outil de traitement d’image est possible, 
cela impose une action manuelle pour chaque image à traiter.

Ce que je vous propose avec ce petit service c’est d’avoir cette fonctionnalité 
directement au bout de votre souris par un clic droit dans le Finder.

Comment fonctionne ce service?

1. Les fichiers images sélectionnés dans le Finder sont copiés dans un dossier 
    placé sur votre bureau.
2. Le service applique alors une action de transformation qui permet de choisir 
    le format cible (JPEG, TIFF, etc.).
3. Si le dossier n’existe pas sur le bureau il sera créé.

Tel que le processus réalise une conversion en JPEG de façon transparente. 
Si vous souhaitez avoir le choix au moment de l’appel au service, il suffit 
de cocher l’option «*Afficher cette action si le processus est exécuté*» 
pour l’action «*Modifier le type des images*».

**Remarque:** Il est possible d’améliorer ce service en s’assurant que chaque 
fichier converti est placé dans le même fichier que l’original.

**Téléchargement**

Le processus final sera installé par OS X dans votre dossier «*Services*» dans 
votre dossier «*Bibliothèque*» personnel ou celui du système.
￼
{% include post_image.html 
    src='/img/screenshots/2012/11-07_serv-convert-img-format.png' 
    alt="Service de conversion de format d'images" %}
