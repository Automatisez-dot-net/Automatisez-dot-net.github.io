---
layout: post
title: Supprimer des fichiers par lots
date: 2015-10-12 12:00:00 +01:00
logo: files
attachments: 
  - name: Effacer-les-PNG.app
    path: processus/Effacer-les-PNG.app.zip
---

Vous avez peut-être besoin de supprimer des fichiers temporaires de façon régulière ?
Cette petite application devrait vous aider.

Ce processus est relativement simple : on lui fournit une liste de dossiers à 
traiter et il efface tous les fichiers qui correspondent à un critère précis.

Dans mon cas, j’utilise ce processus pour effacer des images au format PNG 
que je génère de façon dynamique. 
Pour faire le vide, je peux utiliser cette application pour faire le ménage 
et ne conserver que mes fichiers d’origine.

Pour commencer, j’ai créé un processus de type « application ». 
Je le garde à portée de main dans mon dossier de travail.

J’aurais aussi pu opter pour un service, mais je préfère ne pas polluer 
mon menu contextuel avec des entrées que je n’utilise que de façon ponctuelle.

Le processus final ressemble est ci-dessous :

{% include post_image.html src='/img/screenshots/2015/supprimer-fichiers-par-lots.jpg' alt='Le processus au complet.' %}


La première action consiste à stocker les noms de dossiers dans une variable 
pour pouvoir la réutiliser.

Dans un second temps, j’utilise quelques lignes d’AppleScript pour 
m’assurer que la liste de dossiers ne contient pas de valeurs vides. 
Cette étape est probablement optionnelle. J’essaye juste d’éviter de faux positifs.

J’affiche ensuite un dialogue de confirmation. 
Comme je pense n’utiliser qu’un seul dossier à la fois, 
je mets son chemin dans le titre du dialogue.

**Note** : Si, vous avez besoin de manipuler plus de dossiers il faudra 
imaginer une option plus complexe, comme laisser l’utilisateur choisir 
dans une liste les dossiers à traiter.

Si l’utilisateur confirme l’action, je récupère le contenu du dossier 
d’entrée et des sous-dossiers et j’envoie le tout à une action de filtrage 
pour ne conserver que les fichiers images ayant l’extension « PNG ».

La suite est naturellement à envoyer le tout directement dans la corbeille du Mac.

Pour finir proprement le processus, j’affiche une notification à l’utilisateur 
pour l’avertir que le ménage est terminé.

Et voilà comment, en quelques étapes, il est possible de faire un ménage rapide 
de quelques dossiers.

Vous avez moyen d'améliorer ce processus assez facilement. 
Commencez par rendre l'action de filtrage interactive. 
Cela vous donnera les moyens d'avoir un comportement plus personnalisable. 
Un autre changement possible serait de demander à l'utilisateur de sélectionner 
les dossiers à traiter au début.

À vous de faire vos choix. Amusez-vous bien.

