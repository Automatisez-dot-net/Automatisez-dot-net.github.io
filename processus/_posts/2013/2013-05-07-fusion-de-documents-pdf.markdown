---
layout: post
title: "Fusion de documents PDF"
date: 2013-05-07 12:00:00
logo: preview
attachments:
    - name: "Processus - Fusionner les PDFs"
      path: processus/fusionner-PDF.zip
---

Il m’arrive d’avoir plusieurs documents PDF que je souhaite regrouper dans 
un seul fichier.
Pour cela, j’ai construit un service simple en utilisant Automator.

**Remarque:** La création de services avec Automator requiert au minimum 
Mac OS X.6 Snow Leopard.

La création de ce service est assez simple. 
L’enchainement des actions est donné ci-dessous.
Le traitement réalisé est le suivant:

- Les fichiers sélectionnés sont triés : les critères de tri sont contrôlés
    par l’utilisateur via l’action Automator correspondante.
- Automator regroupe les fichiers et nomme le fichier résultat en incluant 
    dans le nom la date et l’heure courante.
- Automator demande ensuite où placer le fichier, 
    par défaut c’est sur le bureau.

Voici le détail des actions de ce processus :

{% include post_image.html 
    src='/img/screenshots/2013/05-07_process-merge-pdf.png' 
    alt="Étape 1" %}
￼
Le processus final sera installé par OS X dans votre dossier «*Services*» 
dans votre dossier «*Bibliothèque*» personnel ou celui du système.
