---
layout: post
title: "Télécharger les liens dans une page web"
date: 2014-08-20 12:00:00
logo: safari
attachments:
    - name: "Service, télécharger les liens d'une page internet"
      path: processus/Service-Telecharger-les-liens.zip
---

Vous est-il arrivé d'aller récupérer de la documentation sur une page en 
devant récupérer les documents sur chaque lien, manuellement, un par un ?

Il n'y a rien de plus rébarbatif. Et lorsque je me retrouve face à un problème 
répétitif et barbant, je regarde si Automator ne peut pas venir nous aider. 
C'est ce que nous allons voir avec ce service.

### Vue d'ensemble

Nous allons construire un service pour l'application Safari.

Ce service va récupérer l'ensemble des liens de la page affichée. 
Les liens seront filtrés pour ne retenir que les URL qui nous intéressent. 
Par exemple, nous allons nous limiter aux URL qui terminent par «*.pdf*».

On peut ensuite présenter la liste pour que l'utilisateur puisse confirmer 
ceux qui doivent être téléchargés.

Pour finir, les URL retenus seront téléchargée dans un dossier préalablement 
sélectionné par l'utilisateur. Lorsque le téléchargement sera terminé, une 
notification alertera l'utilisateur.

### Créer un nouveau service

Lancer Automator et créez un nouveau service.

Dans le bandeau des propriétés du service vous devez préciser les propriétés suivantes :

- le service ne reçoit pas d'entrée : nous allons chercher directement la page 
    active.
- le service n'est disponible que dans Safari.

### Sélectionnez le dossier cible

Ajoutez l'action « demander des éléments du Finder » :

- Indiquez un message pour le dialogue de sélection. 
- La sélection initiale doit pointer vers votre dossier de téléchargement. 
    Utilisez pour cela la variable dédiée.
- Il ne doit être possible de sélection qu'un seul élément qui doit être un 
    dossier.

Ajoutez l'action «*définir la valeur de la variable*»: 
la valeur doit aller dans une nouvelle variable «*cible*».
￼
{% include post_image.html 
    src='/img/screenshots/2014/08-20_service-telecharger-liens-01.png' 
    alt="Étape 1" %}

Le processus doit ressemble à l'image précédente.

### Obtenir les URL de la page active

Ajoutez maintenant l'action «*obtenir la page Web actuelle de Safari*». 
Cette action n'a besoin d'aucun paramètre particulier.

Il faut maintenant ajouter l'action «*obtenir les adresses URL des liens des 
pages web*». 
Cette action n'a qu'une option que je vous conseille de cocher: 
se limiter aux liens du même domaine que la page.

{% include post_image.html 
    src='/img/screenshots/2014/08-20_service-telecharger-liens-02.png' 
    alt="Étape 2" %}
￼
Et voilà, votre processus à maintenant la liste de tous les liens venant 
de la page. Il ne reste plus qu'à les filtrer.

### Filtrage des URL

Nous allons maintenant filtrer les URL.

Ajoutez l'action «*filtrer les adresses URL*» pour effectuer un premier tri. 
Les critères que nous allons définir sont:

- Toutes les condition sont vraies.
- Le nom se termine par «*.pdf*».

Dans les options de l'action précisez que l'action doit s'afficher à 
l'exécution du processus. 
Cela permettra aux utilisateurs de s'adapter à la page et au contenu que 
l'on souhaite récupérer. 
Cela nous permettra de ne retenir que les liens pointant vers des documents PDF.

Ajoutez maintenant l'action «*choisir dans la liste*» pour que l'utilisateur 
puisse faire une dernier filtrage.

{% include post_image.html 
    src='/img/screenshots/2014/08-20_service-telecharger-liens-03.png' 
    alt="Étape 3" %}
￼
Et voilà, le processus a récupéré une liste d'URL. Il ne reste plus qu'à les 
télécharger.

### Télécharger et notifier

Ajoutez l'action «*télécharger les URL*». 
L'emplacement doit désigner la variable «*cible*» que nous avons défini au 
début du processus.

Cette action peut être longue pour se terminer. 
Il ne reste plus qu'a ajouter une dernière action «*afficher la notification*» 
pour avertir l'utilisateur lorsque tous les téléchargements sont achevés.
￼
{% include post_image.html 
    src='/img/screenshots/2014/08-20_service-telecharger-liens-04.png' 
    alt="Étape 4" %}

Cette fois ci le processus est terminé. 
Il ne vous reste plus qu'à l'enregistrer. 
Vérifiez bien que la destination est bien sur votre Mac et pas dans iCloud. 
Les services enregistrés dans iCloud ne sont pas utilisables.

### C'est fini

Et voilà, le service est terminé. 

Vous pouvez le tester en allant visiter le site des 
[spécifications Unicode](http://www.unicode.org/charts/). 

Allez dans le menu des services, dans le menu de l'application Safari.
Votre service devrait y être.

Il ne vous reste plus qu'à le tester.
