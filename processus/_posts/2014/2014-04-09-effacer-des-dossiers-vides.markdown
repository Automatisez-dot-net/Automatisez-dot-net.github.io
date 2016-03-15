---
layout: post
title: "Effacer des dossiers vides"
date: 2014-04-09 12:00:00 +01:00
logo: files
ibooks_intro: 
attachments: 
  - name: effacer-dossiers-vides.workflow (fichier Zip)
    path: processus/effacer-dossiers-vides.workflow.zip
---

J’ai récemment fait un peu de rangement dans mon disque dur. 
Après de nombreux déplacements de fichiers et suppression de doublons, 
je me suis retrouvé avec une arborescence complexe de dossiers dont la plupart 
étaient vides. 
Comment faire le tri et ne conserver que les dossiers non vides?

<div class="alert alert-info">
<strong>Remarque:</strong>
Ce processus utilise des commandes de terminal.
</div>

La création de ce processus se fait deux étapes:

1. L’utilisateur choisit le dossier dans lequel on va chercher les 
    dossiers vides; 
2. Après confirmation de la suppression, une commande Shell est exécutée pour 
    retrouver les dossiers vides et les supprimer. 

L’enchainement des actions est donné ci-dessous:

1. L’utilisateur doit commencer par indiquer le dossier à partir duquel on va 
    rechercher des dossiers vides. 
2. Les dossiers choisis sont enregistrés dans une variable pour un usage 
    ultérieur. 
3. Une alerte demande à l’utilisateur de confirmer la suppression des dossiers 
    vides qui seront trouvés. 
4. Une commande Shell « find » est appelée pour chercher les dossiers vides 
    et les effacer. 

Attention, la commande find cherche les dossiers vraiment vides. 
Si elle ne fonctionne pas c’est que le dossier contient peut-être des fichiers 
cachés comme le `.DS_Store` utilisé par le Finder.
￼
{% include post_image.html 
    src='/img/screenshots/2014/04-09_process-effacer-dossiers-vides.workflow.png' 
    alt='Processus pour effacer les dossiers vides' %}

### Installation

<div class="alert alert-info">
Vous pouvez installer ce processus où vous le souhaitez. 
Il sera ouvert avec Automator.
Il est aussi possible d’enregistrer ce processus comme une application.
</div>