---
layout: post
title: "Enlever la transparence d'une image"
date: 2014-10-15 12:00:00
logo: preview
attachments:
    - name: "service - Supprimer le canal Alpha d'une image (ZIP)"
      path: processus/serv_images-supprimer-le-canal-alpha.zip
---

Voici un petit service simple pour enlever rapidement la transparence sur une 
image au format PNG.

Ce service est extrêmement simple et utilise la conversion entre format pour 
enlever la transparence et retrouver ensuite une image au format PNG.

Vous pouvez télécharger le service directement ou le créer vous même comme ceci:

1. Créez un nouveau service qui accepte les images.
2. Ajoutez une action pour convertir l'image au format BMP.
3. Ajoutez une action pour convertir à nouveau l'image au format PNG.

Et voilà, le service est fini.
￼
{% include post_image.html 
    src='/img/screenshots/2014/10-15_serv-img-drop-transparency.png' 
    alt="Le processus au complet" %}

Vérifiez bien que le service est correctement enregistré dans le dossier 
«*Services*» dans le dossier «*Bibliothèques*» de votre dossier personnel, 
ou celui de la racine de votre disque système.

Attention, si votre image comporte réellement des zones translucides, 
elle seront transformées pour apparaitre sur un fond noir.
