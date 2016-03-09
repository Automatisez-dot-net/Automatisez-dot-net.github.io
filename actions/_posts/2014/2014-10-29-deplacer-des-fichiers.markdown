---
layout: post
title: "Déplacer des fichiers"
date: 2014-10-29
logo: files
attachments:
    - name: Processus déplacement de fichiers
      path: processus/2014-10_Wkf-PhotoTriage.zip
---

Cet article vous présente un processus qui permet de réorganiser une arborescence de fichiers en les déplaçant d'un dossier vers un autre.

L'idée a été directement inspirée par la question d'un usager du forum Developpez.net.

### Le problème

La [question posée](http://www.developpez.net/forums/d1478022/systemes/apple/applescript/action-fichiers-dossier-sous-dossier-automator-applescript/)
cet utilisateur consistait à déplacer un ensemble d’images à partir d’un 
dossier vers le dossier parent. 
Une opération simple mais à réaliser sur près de 5000 dossiers identiques... 
c’est directement une opération à essayer d’automatiser !

Dans le dossier de base, on a un grand nombre de dossiers, tous numérotés 
de 1 à 5000.

Dans chaque dossier nommé par un chiffre, on a un autre dossier «*vrac*», 
dans lequel sont stockées des photos.

{% include post_image.html 
    src='/img/screenshots/2014/10-29_billet_automator_avant.png' 
    alt='Structure avant le traitement' %}

L’action à réaliser dans chaque dossier numéroté est simple :

1. Déplacer les images de chaque dossier «*vrac*» dans le dossier numéro.
2. Supprimer le dossier « vrac ».

{% include post_image.html 
    src='/img/screenshots/2014/10-29_billet_automator_apres.png' 
    alt='Structure après le traitement' %}

### Comment procéder ?

Il est important de bien séparer les tâches. Nous allons donc réaliser deux processus :

1. Un premier processus qui va réaliser le déplacement des images et la suppression du dossier «*vrac*».
2. Un second processus qui va appeler le premier pour chaque dossier numéroté.

### Premier processus, le déplacement des fichiers

Le processus est de type application pour accepter un dossier en début de traitement.

Ce dossier va être conservé dans une variable «*dossier_base*». 
On recherche ensuite le dossier contenant les images en parcourant son contenu. 
Dans mon exemple je ne conserve que les dossiers dont le nom est «*vrac*». 
Le dossier ainsi identifié est lui aussi conservé dans une seconde variable : «*dossier_origine*».

{% include post_image.html 
    src='/img/screenshots/2014/10-29_Bouger_vers_parent-part_1.png' 
    alt='Premier processus, le déplacement des fichiers' %}

La seconde étape consistera à extraire la liste des images dans le dossier d’origine. On combine donc deux actions :

1. «*Obtenir le contenu de dossiers*» pour récupérer tous les fichiers.
2. «*Filtrer les éléments du Finder*» pour ne retenir que les images.

Suivant les cas, cette seconde action peut ne pas être utile si vous souhaitez conserver l’ensemble du contenu. À vous de voir quels sont vos critères.

Pour réaliser le déplacement des images, il suffit alors d’ajouter l’action «*déplacer des éléments du Finder*» en spécifiant la variable *dossier_base* comme dossier de destination.

Les images sont maintenant en dehors du dossier d’origine, dossier que nous pouvons maintenant déplacer dans la poubelle. 

 Ajoutez donc l’action « placer des éléments du Finder dans la corbeille ». Cette dernière action va conclure le premier processus.

{% include post_image.html 
    src='/img/screenshots/2014/10-29_Bouger_vers_parent-part_2.png' 
    alt='Premier processus, le déplacement des fichiers' %}

### Second processus

Le second processus peut être un processus simple. 
La première action doit définir le dossier dans lequel se trouvent tous les dossiers à traiter. 

Pour les besoins de l’exemple, je me contente de spécifier ce dossier directement avec l’action « obtenir les éléments du Finder indiqués ». Mon dossier de test est situé sur le bureau.

Les actions suivantes vont récupérer le contenu de ce dossier en ne gardant que les dossiers. Ajoutez donc les actions suivantes :

1. «*Obtenir le contenu des dossiers*» pour récupérer le contenu. Cette action pourrait utiliser une sélection interactive.
2. «*Filtrer les éléments du Finder*» pour ne retenir que les dossiers. Dans mon exemple j’exclus explicitement le dossier «*_modèle_*» que j’utilise pour reconstruire mon jeu d’exemples. 

**Note:** avec les processus à télécharger vous avez quelques photos ainsi qu’un processus «*00 - Construire les dossiers*» qui va dupliquer le dossier *_modèle_* en une douzaine d’exemplaires. Cela vous permet de facilement tester les processus plusieurs fois.

Après ce début classique, ajoutez une action «*choisir dans la liste*». Celle-ci permet de voir sur quels dossiers les processus vont être exécutés. Cette étape n’est pas indispensable mais donne un peu de retour à l’utilisateur.

Enfin, pour la dernière action, il vous faut appliquer le premier processus sur chaque dossier trouvé. Pour cela, ajoutez l’action «*lancer un processus*».

C’est cette action qui va permettre de réaliser le traitement. Vous pouvez même dérouler plusieurs processus en parallèle. 

{% include post_image.html 
    src='/img/screenshots/2014/10-29_Traiter_les_triages.png' 
    alt='Second processus, traitement des photos' %}

Vous avez maintenant deux processus complets.

Attention, si vous déplacez le premier processus, il sera nécessaire de le sélectionner à nouveau dans la dernière action.

### Conclusion

Et voilà, avec deux processus il est relativement simple de manipuler des fichiers pour les déplacer d’un dossier à un autre.

Le processus qui est joint aux exemples illustre l’utilisation des boucles dans un processus. Jetez-y un œil. J’espère que vous y trouverez de l’inspiration pour d’autres processus.
