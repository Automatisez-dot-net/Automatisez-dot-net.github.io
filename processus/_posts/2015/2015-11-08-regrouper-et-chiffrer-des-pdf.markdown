---
layout: post
title: "Regrouper et chiffrer des PDF"
date: 2015-11-08 12:00:00
logo: preview
attachments:
    - name: "PDF, regrouper et chiffrer (application)"
      path: processus/app-PDF-regrouper-et-chiffrer.zip
    - name: "PDF, regrouper et chiffrer (processus simple)"
      path: processus/wkf-PDF-regrouper-et-chiffrer.zip
---

Ce processus vous propose de protéger vos documents PDF. 
Il regroupe différents documents en un seul puis protège le document final
avec un mot de passe.

Je vous propose ce processus sous la forme d’une application et d’un processus 
simple. Mais je ne vais décrire que l’application dans cet article.

### Fonctionnement

Le processus est construit en quatre actes:

1. pour commencer, on doit définir la liste des fichiers PDF à fusionner.
2. dans un second temps, un document de synthèse est produit en rassemblant 
    tous les PDF.
3. Dans le troisième temps, on active la protection du document et on le place 
    sur le bureau.
4. le quatrième et dernier acte consiste à faire le ménage en supprimant 
    les originaux.

Voyons ceci plus en détail.

### Définir les documents à regrouper

Comme nous construisons une application, les documents PDF seront fournis à 
cette dernière en les faisant glisser sur son icône.

Lorsque l’application est lancée, elle obtient une liste de fichiers. 
La première chose à réaliser est de s’assurer que l’on ne va traiter que 
des documents PDF:

1. l’action «*filtrer les éléments du Finder*» permet de ne retenir que les 
    PDF parmi tous les fichiers reçus en entrée de l’application.
2. j’ajoute une action intermédiaire pour que l’utilisateur sélectionne 
    explicitement les fichiers à traiter.
3. la liste des fichiers est enfin enregistrée dans une variable «*docs-pdf*».
￼
{% include post_image.html 
    src='/img/screenshots/2015/11-08_PDF_regrouper-et-chiffrer-01.png' 
    alt="Étape 1" %}

### Regrouper les PDF

Une seule action suffit pour assembler des PDF en un seul document. 
Il suffit de lui ajouter une action pour définir le nom du fichier final.

Dans les options de cette dernière action, je vous conseille de cocher l’option 
«*afficher cette action si le processus est exécuté*». 
Cela permettra à l’utilisateur de choisir le nom au moment de l’exécution.
￼
{% include post_image.html 
    src='/img/screenshots/2015/11-08_PDF_regrouper-et-chiffrer-02.png' 
    alt="Étape 2" %}

### Chiffrer le PDF

Là encore, une seule action va appliquer la protection par mot de passe:

1. Ajoutez l’action «*chiffrer les documents PDF*» et cochez bien l’option 
    «*afficher cette action si le processus est exécuté*».
2. Ajoutez enfin l’action «*déplacer les éléments du Finder*» pour placer 
    ce nouveau fichier sur le bureau.

À ce stade, le processus pourrait être fini. 
Mais nous allons ajouter une dernière partie.
￼
{% include post_image.html 
    src='/img/screenshots/2015/11-08_PDF_regrouper-et-chiffrer-03.png' 
    alt="Étape 3" %}

### Faire le vide

Si vous avez choisi de protéger des documents, c’est que vous aimeriez 
probablement effacer les versions non protégées. 
La fin de cette application va faire cela en vous demandant si c’est bien 
votre choix.
￼
{% include post_image.html 
    src='/img/screenshots/2015/11-08_PDF_regrouper-et-chiffrer-04.png' 
    alt="Étape 4" %}

**Important:** 
si vous supprimez les originaux, assurez-vous d’avoir bien conservé le mot 
de passe.

### Conclusion

Vous avez maintenant une application capable de protéger vos PDF. Vous pourriez l’utiliser à travers un service ou dans un module d’impression. À vous de faire les modifications qui vous semblent les plus adaptées.

Commencez par télécharger l’application ou le processus.

**Note:**
si vous souhaitez modifier l’application, vous devrez faire glisser son 
icône sur celui de l’application Automator.
