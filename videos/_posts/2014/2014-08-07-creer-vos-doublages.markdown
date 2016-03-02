---
layout: post_video
title:  "Créer facilement vos doublages"
date:   2014-08-07 12:00:00 +0100
logo:   workflow
youtube_id: ias9gOFPoTU
---

Vous voulez agrémenter vos présentation et vos vidéos avec autre chose que votre voix ?
Rien de plus facile que faire un petit casting en utilisant les voix de synthèse d'OS X. 
À l'aide d'un service, *construit avec Automator*,  vous pourrez facilement 
transformer un script. 

Cette vidéo vous présente comment faire.

Vous vous demandez peut-être comment il est possible d’enregistrer 
un doublage de vidéo en utilisant, simplement, la synthèse vocale de votre Mac.

C’est, en effet, ce que j’ai pu faire dans la vidéo précédente. 
Ma réponse est bien entendu : *utilisez Automator !*

Dans cette nouvelle vidéo, réalisée avec un Mac tournant avec OS X, 
version 10.9, je vais vous montrer comment il est facile de créer un service 
pour cela. 

Lançons maintenant Automator...

### Création

Créez un nouveau processus.

Dans la feuille de dialogue, sélectionnez le type « service » pour votre 
nouveau processus.

Après validation, vous êtes dans l’éditeur d’Automator.

Les caractéristiques de votre service sont définies dans le bandeau situé en 
haut de la zone d’édition. 
Votre service doit accepter du texte. 
Il doit aussi être accessible sur n’importe quelle application. 
Les autres options ne seront pas utiles pour cet exemple.

Ajoutons maintenant l’action « Convertir du texte en fichier audio » 
en la cherchant dans la bibliothèque d’actions.

Ajoutez-la dans l’éditeur, puis, dans les options de l’action, 
cochez la case pour que l’action s’affiche lors du déroulement du processus.

Nous allons maintenant personnaliser le nom du fichier produit par cette action.
Notez que les fichiers seront enregistrés sur le Bureau du Mac.

Allez dans la bibliothèque des variables. 
Cherchez la variable qui donne la date du jour. 
Faites la glisser dans le champ texte de l’action pour définir le nom de fichier. 
Ajoutez un espace, puis répétons la manœuvre pour la variable de l’heure courante.

Nous pouvons maintenant ajouter un nom commun comme « doublage ».

Il ne reste plus qu’à personnaliser le format utilisé pour la date en cliquant 
sur le champ, puis sur « modifier... ». 
Dans la liste des formats, choisissez le format personnalisé. 
Sélectionnez les valeurs pour avoir l’année sur 4 chiffres, le mois et le jour 
sur 2 chiffres, le tout séparé par des tirets. 
Vous pouvez aussi changer le nom du champ et le remplacer par « date » 
pour qu’il soit plus court.

Répétez cette manipulation pour l’heure en affichant heures, minutes et secondes.

Le service est maintenant prêt, il ne reste plus qu’à l’enregistrer avec 
le nom « enregistrer comme doublage ».

### Vérifier

Retournons maintenant dans l’éditeur TextEdit pour vérifier si notre service est 
bien disponible et fonctionne comme nous nous y attendons.

Avec un clic droit, ou Contrôle + clic si vous n’avez qu’un bouton, 
affichez le menu des services et sélectionnez celui que nous venons d’ajouter.

Dans les options, choisissez une voix francophone qui vous convienne.

Cliquez sur le bouton « Continuer » pour valider le choix et générer un 
fichier audio.

Vous pouvez voir ce nouvel enregistrement apparaitre sur le bureau.

En l’ouvrant avec coup d’œil, nous pouvons vérifier que le résultat correspond 
à nos attentes.

### Pilotage au clavier

Pour finir, il ne nous reste plus qu’à ajouter un raccourci clavier pour 
accéder rapidement à cette nouvelle fonctionnalité.

Ouvrez l’application Préférences puis le panneau des réglages du clavier. 

Dans la liste des raccourcis qui sont définis pour les services, cherchez 
celui que nous venons de créer.

Il ne reste plus qu’à lui ajouter une combinaison de touches : dans mon cas, 
j’utilise Options, Commande et majuscule avec la touche « E ».

Un petit retour dans TextEdit permet de tester rapidement ce nouveau raccourci.

### Conclusion

Il semblerait bien que tout aille pour le mieux. 
Vous pouvez maintenant agrémenter facilement vos vidéos et présentations avec 
une voix de synthèse.

J’espère que vous trouverez une utilité à cette astuce et que vous saurez 
l’utiliser pour distinguer un peu vos présentations.
