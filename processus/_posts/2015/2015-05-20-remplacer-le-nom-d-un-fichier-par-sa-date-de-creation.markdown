---
layout: post
title: "Remplacer le nom d'un fichier par sa date de création"
date: 2015-05-20 12:00:00 +01:00
logo: files
ibooks_intro: > # Message shown next to link to iBooks Store
    Ce processus vous a plus? 
    N’hésitez pas à en apprendre plus en lisant «&nbsp;Automatisez sous Mac&nbsp;»...
---

Automator permet très facilement d'ajouter la date et l'heure de création 
d'un fichier à son nom. 
Mais comment remplacer complètement le nom par la date et l'heure?

C'est ce que nous allons voir.

Disons que nous avons un fichier «*document.txt*».

L’objectif est donc de renommer ce fichier en quelque chose comme 
«*150522_121300.txt*» ou:

- «*150522*» est la date de création au format année, mois et jour.
- «*121300*» est l’heure de création du fichier.

Le premier réflexe serait de chercher une action qui permette d’obtenir la date 
et l’heure de création d’un fichier.

**Mais Automator ne propose, par défaut, aucune action de ce genre.**

Il est possible, en revanche, d’ajouter ces informations au nom d’un fichier 
directement en utilisation l’action «*renommer les éléments du Finder*»

Il existe plusieurs façons de le faire, mais l’action 
«*renommer les éléments du Finder*» permet aussi de remplacer le nom du fichier. 
Il suffit d’échanger le nom du fichier avec la date et l’heure de création dans 
le format qui nous intéresse.

Notre processus va devoir donc faire les actions suivantes:

1. Ajouter la date de création à la fin du nom de fichier pour obtenir « document_150522.txt ».
2. Ajouter l’heure de création à la fin du nom de fichier pour obtenir « document_150522_121300.txt ».
3. La dernière étape consiste à supprimer « document_ » dans le nom.

C’est cette dernière étape qui est un peu plus délicate. Il existe deux solutions:

1. On supprime le nom du fichier dès le début pour le renommer directement « .txt ». Ce n’est pas une excellente solution, car en cas de soucis les fichiers dont le nom commence par un point sont invisibles dans le Finder. Donc en cas de problème, le fichier serait difficile à retrouver.
2. On remplace le nom du fichier dès le début par une valeur connue, mais la plus unique possible. Pour cela, on peut utiliser la date et l’heure courante ou une valeur aléatoire. Je préfère dans mon cas la seconde option.

Donc, la première chose à faire est de remplacer le nom du fichier par une valeur connue et aléatoire. La logique du processus devient donc la suivante

1. stocker dans une variable une valeur aléatoire qui sera le nouveau nom du fichier.
2. On remplace « document_» dans le nom par la valeur aléatoire.
3. Ajouter la date de création à la fin du nom de fichier pour obtenir « ALEATOIRE_150522.txt ».
4. Ajouter l’heure de création à la fin du nom de fichier pour obtenir « ALEATOIRE_150522_121300.txt ».
5. La dernière étape consiste à supprimer « ALEATOIRE_ » dans le nom

### Construisons le processus

Pour commencer, ouvrez Automator et créez un nouveau processus simple et ajoutez les actions suivantes:

1. Faites glisser le fichier à renommer au début du fichier. 
    Cela ajoute l’action «*obtenir les éléments du Finder indiqué*».
2. Ajoutez l’action « définir la valeur de la variable » pour stocker une 
    référence sur ce fichier. Nommez la variable «*fichier*».

Pour construire une valeur aléatoire, nous allons ajouter deux actions:

1. De la bibliothèque des variables, cherchez la variable 
    «*identifiant aléatoire*» ou «*nombre aléatoire*». 
    L’un ou l’autre fonctionnera pour notre processus.
2. Faites glisser la variable dans l’éditeur.
3. L’action «*obtenir la valeur de la variable*» est alors ajoutée pour la 
    variable choisie.
4. Pensez, d’un clic droit (ou Ctrl+clic) sur le titre de l’action à ignorer 
    le résultat de l’action précédente. 
    Sinon le fichier va s’ajouter au résultat aléatoire. 
    Ce que nous cherchons à éviter.
5. Ajoutez maintenant l’action «*définir la valeur de la variable*» et 
    enregistrez cette valeur dans une variable nommée «*NomTemporaire*».
￼
{% include post_image.html 
    src='/img/screenshots/2015/05-20_File-rename-with-creation-date-01.png' 
    alt='Créer un nom temporaire pour le fichier' %}


Et voilà, nous avons un nom temporaire utilisable pour un premier changement 
de nom du fichier.

1. Pour appliquer ce premier changement de nom, ajoutez l’action 
    «*renommer des éléments du Finder*».
2. Dans le premier champ, qui définit le fonctionnement de l’action, choisissez
    «*nommer un seul élément*».
3. Pour le nom, sélectionnez la valeur «*nom de base seulement*» pour ne pas 
    toucher à l’extension de fichier.
4. Dans le champ qui définit la nouvelle valeur du nom de fichier, faites 
    glisser la variable *NomTemporaire*.
￼
{% include post_image.html 
    src='/img/screenshots/2015/05-20_File-rename-with-creation-date-02.png' 
    alt='Seconde étape' %}

Il ne reste plus qu’à ajouter la date et l’heure de création du fichier.

Ajoutez une nouvelle action «*renommer les éléments du Finder*».

Le mode de fonctionnement doit être «*ajouter date ou heure*».

Sélectionnez la valeur voulue (création, modification, etc.) et les options 
d’affichage. La date doit s’afficher après le nom et en être séparée par un 
caractère de soulignement.

Répétez ces 3 dernières actions, mais pour l’heure.

Si vous exécutiez le processus maintenant vous auriez un fichier nommé 
comme «*ALEATOIRE_150522_131200.txt*». 
Il reste la dernière étape: effacer la partie aléatoire du nom.

Ajoutez une nouvelle action «*renommer les éléments du Finder*».

Le mode de fonctionnement doit être «*remplacer du texte*» dans le nom de 
base uniquement.

Laissez bien la valeur de remplacement totalement vide.

Et voilà, votre processus fini devrait ressemble à ce qui suit :
￼
{% include post_image.html 
    src='/img/screenshots/2015/05-20_File-rename-with-creation-date-03.png' 
    alt='Processus complet' %}

### Pour conclure

Et voilà, vous avez maintenant un processus complet. Vous devrez lui apporter 
quelques améliorations:

1. Ce processus ne fonctionne que pour un seul fichier à la fois.
2. Il serait bien de supprimer la première action pour utiliser soit la 
    sélection du Finder, soit transformer le processus en service.

Si vous voulez pouvoir traiter plusieurs fichiers, il faut intégrer une boucle.
J’aurais tendance à faire les modifications suivantes:

Transformer le processus en une application qui ne traitera que le premier 
fichier transmis.

Créez un autre processus, service ou application qui accepte plusieurs fichiers 
et appelle le premier en passant chaque fichier un par un. 
Cela permet de boucler simplement sur une liste de fichiers et éventuellement 
de faire les changements de nom en parallèle.


