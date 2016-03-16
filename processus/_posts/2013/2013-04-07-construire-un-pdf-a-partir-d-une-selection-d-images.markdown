---
layout: post
title: "Construire un PDF à partir d’une sélection d’images"
date: 2013-04-07 12:00:00
logo: preview
attachments:
    - name: "Processus - Assembler des images dans un PDF"
      path: processus/assembler-images-dans-PDF.zip
---

Qui n’a jamais scanné une série de documents et voulu les regrouper simplement dans un seul fichier PDF pour les archiver ou les transmettre plus simplement ?

C’est tout l’objet du processus que nous allons construire ici tout en explorant un peu plus loin la technologie d’Automator.

### Objectif fonctionnel

L’objet de ce processus est d’être capable de construire un document PDF 
à partir d’une sélection de fichiers d’images.
Le fichier PDF devra être créé dans le dossier d’origine des images.
En fin de processus, l’utilisateur doit pouvoir choisir de supprimer 
les images utilisées pour construire le PDF en les plaçant dans la corbeille.

### Objectifs techniques

L’objet de ce tutoriel est de découvrir différentes fonctionnalités d’Automator 
pour sortir du cadre de la présentation générale. 
Vous allez ainsi aborder les fonctionnalités suivantes:

- Manipuler des variables pour stocker les résultats des actions.
- Intégrer des éléments AppleScript pour implémenter une action.
- Interagir avec l’utilisateur pour modifier le déroulement d’un processus.

Définir si une action doit utiliser le résultat de l’action précédente comme 
données d’entrée.

### Conception générale

L’idée initiale est de partir d’une sélection de fichiers dans le Finder.
À partir de cette sélection de fichiers, nous allons pouvoir obtenir un dossier 
dans lequel enregistrer le document PDF que nous souhaitons produire.

- La première étape consiste à définir dans quel dossier enregistrer le 
    document PDF.
- Une fois le dossier cible défini nous pouvons rassembler les images pour 
    construire le document PDF et, autant que possible, le compresser.
- Dès lors que le document PDF est créé, il faut demander quoi faire des 
    fichiers originaux. 
    Si l’utilisateur veut les supprimer, le processus doit finir en plaçant 
    les fichiers dans la corbeille.

### Où interviennent les variables…

La problématique principale de ce processus est d’utiliser l’action 
«*Nouveau PDF à partir des images*». 
Cette action accepte une liste de fichiers et renvoie un fichier PDF.
￼
{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-01.png' 
    alt="Étape 1" %}

Nous avons deux possibilités pour que le fichier résultat soit enregistré dans 
le dossier d’origine:

- Une fois le fichier PDF créé dans un endroit connu, comme le bureau, 
    il faut le déplacer dans le dossier d’origine.
- Avant de créer le fichier PDF, il faut avoir déterminé le dossier d’origine 
    et préciser à l’action que c’est dans ce dossier que le document devra 
    être créé.

Dans un cas comme dans l’autre on se trouve face à une contrainte forte des 
actions Automator: une action n’accepte qu’un seul paramètre en entrée. 
Cependant pour chacune des solutions envisageables il est nécessaire de 
spécifier deux paramètres :

1. Le dossier et le fichier PDF ;
2. Le dossier et les fichiers images.

Il n’y a pas d’autre solution que d’utiliser une variable pour stocker le 
dossier cible. 
Nous pourrons ensuite utiliser cette variable pour indiquer à l’action 
«*Nouveau PDF à partir des images*» dans quel dossier le fichier 
doit être construit.

Pour la même raison, il sera indispensable de conserver la liste des images 
sources dans une autre variable pour pouvoir ensuite les placer dans la 
corbeille si c’est le choix de l’utilisateur.

### L’intervention d’AppleScript…

Notre processus va travailler à partir d’une sélection d’images. 
Cette sélection est transmise sous la forme d’une liste de fichiers. 
Il n’y a pas vraiment un moyen pour un utilisateur du processus de spécifier 
au lancement dans quel dossier stocker le fichier PDF produit.

Nous avons donc là encore plusieurs solutions pour le choix du dossier dans 
lequel le fichier PDF doit être produit :

- Sur le bureau, charge à l’utilisateur de le ranger dans le dossier de son choix.
- Dans un dossier standard comme le dossier des documents de l’utilisateur. 
    Mais si une fenêtre Finder n’est pas ouverte sur ce dossier, 
    l’utilisateur risque de se demander si le processus a bien réalisé son travail.
- Dans le dossier d’origine des images. C’est à mon avis le meilleur choix  
    puisque ce dossier a toutes les chances d’être visible dans le Finder.

Nous devons donc obtenir le dossier des fichiers sélectionnés. 
Mais il n’existe pas d’action qui accepte une liste de fichiers pour la 
transformer en une liste de dossiers. 
C’est ce que nous allons donc devoir réaliser à l’aide de quelques 
lignes d’AppleScript.
￼
{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-02.png' 
    alt="Étape 2" %}

Ce petit bout de script va extraire le chemin du dossier pour chaque chemin 
de fichier et renverra le premier de cette liste.

### L’intervention de l’utilisateur dans le flot du processus…

En toute fin de notre processus, nous voulons laisser le choix à l’utilisateur 
de déplacer les images sources dans la corbeille.

Une action est toute prête pour ce genre d’action et s’appelle tout 
naturellement «*Demander une confirmation*».
￼
{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-03.png' 
    alt="Étape 3" %}

Le principe de cette action est simple :

- Un dialogue pose une question à l’utilisateur;
- En cas de réponse positive, le processus poursuit son exécution;
- En cas de réponse négative, le processus est interrompu.

### Mettre en pratique la conception

Commencez par lancer Automator. 
Vous n’allez utiliser aucun point de départ pour ce processus, 
choisissez donc un processus «*Personnalisé*».

Vous devez maintenant être face à votre éditeur de processus. 
La bibliothèque d’actions ouverte.

### Stocker la sélection du Finder dans une variable

Commencez par récupérer dans votre processus l’ensemble des fichiers 
sélectionnés dans le Finder.

1. Recherchez l’action «*Obtenir les éléments Finder sélectionnés*» 
    en tapant dans la zone de recherche des actions quelque chose 
    comme «*finder sélect*».
2. Faites glisser cette action dans l’éditeur pour l’ajouter à votre processus.
￼
{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-04.png' 
    alt="Étape 4" %}

Nous allons définir la variable «*Images source*» à partir de la liste des 
fichiers sélectionnés par l’utilisateur. 
Elle sera construire directement à partir du résultat de cette première action.

1. Ajoutez, toujours en suivant la même méthode, l’action 
    «*Définir la valeur de la variable*» en cherchant «*def var*».
2. Dans le champ «*Variable*», choisissez l’option «*Nouvelle variable…*» 
    pour ajouter une nouvelle variable.
3. Dans le petit dialogue, saisissez le nom «*Images source*» 
    pour notre variable.
￼
{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-05.png' 
    alt="Étape 5" %}

La nouvelle variable doit être affichée dans la zone du bas. 
Si ce n’est pas le cas, assurez-vous que la liste des variables est bien 
affichée en cliquant sur le bouton entouré d’un cercle.

{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-06.png' 
    alt="Étape 6" %}

### Extraire le chemin des images avec AppleScript

Vous allez maintenant pouvoir transmettre la valeur de cette variable à un 
script AppleScript pour extraire le dossier.

1. Ajoutez à votre processus une action «*Exécuter un script AppleScript*».
2. Ajoutez à la suite une nouvelle action «*Définir la valeur de la variable*» 
    pour une nouvelle variable que nous allons appeler «*Dossier source*».
￼
{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-07.png' 
    alt="Étape 7" %}

Nous devons maintenant écrire un petit script capable de parcourir la liste des 
fichiers, d’extraire pour chacun le chemin de leur dossier et de retourner 
une de ces valeurs.

``` AppleScript
on run {input, parameters}
 tell application "Finder"
   set listeChemins to {}
   repeat with unElement in input
     copy (POSIX path of ((folder of unElement) as alias)) to end of listeChemins
   end repeat
 end tell
        
 return first item in listeChemins
end run
```

Ce script utilise l’application Finder pour extraire le chemin de chacun des 
fichiers reçus en paramètres dans la variable «*input*»:

```repeat with unElement in input … end repeat```

Définis une boucle pour parcourir la liste des fichiers

```folder of unElement```

Récupère le dossier de l’élément courant de la liste.

```POSIX path of …```

Transforme le chemin à partir du formalisme Mac vers le formalisme Unix.

```copy … to end of listeChemin```

Ajoute ce chemin Unix à la fin de la liste des chemins.

La dernière liste du script retourne le premier élément de la liste construite. 
Cette valeur de retour sera transmise à l’action suivante pour initialiser 
notre variable «*Dossier source*».


### Construire le fichier PDF

La dernière étape consiste à créer notre fichier PDF. 
Commencez par réinjecter la liste des fichiers sélectionnés dans le processus. 
Vous pourriez simplement ajouter l’action «*Obtenir la valeur de la variable*», 
mais pour cette opération il est tout aussi simple de faire simplement glisser 
la variable dans le processus.

{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-08.png' 
    alt="Étape 8" %}

**Attention:** cette action est placée après celle qui définit la valeur de 
    «*Dossier source*». 
    Elle ne doit pas utiliser la valeur de sortie de cette action.

Prenez bien soin de ne pas reprendre la sortie de l’action précédente en 
utilisant le menu contextuel (bouton droit de la souris) et l’élément 
«*Ignorer l’entrée*».

{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-09.png' 
    alt="Étape 9" %}

Une fois l’option sélectionnée vous ne devriez plus avoir le lien entre 
les deux actions.

Ajoutez maintenant les actions:

- «*Nouveau PDF à partir des images*».
- «*Compresser les images dans un fichier PDF*».

Il faut maintenant paramétrer votre construction de fichier PDF.

Pour définir le dossier de destination il faut faire glisser la variable 
*Dossier source* sur le champ «*Enregistrer la sortie dans*».

{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-10.png' 
    alt="Étape 10" %}
￼
L’action de compression n’est pas forcément utile si vos images sont déjà 
compressées. En revanche si vous manipulez des fichiers TIFF sans compression 
vous gagnerez un peu d’espace.

Choisissez une compression JPEG en qualité moyenne. C’est généralement suffisant.

Vous voilà maintenant avec un document PDF.

La dernière étape de notre processus consiste à demander à l’utilisateur s’il 
faut déplacer les fichiers sources dans la corbeille.


### Faire le ménage

Commencez par demander son avis à l’utilisateur. 
Ajoutez donc une action «*Demander une confirmation*» à la fin du processus.

- Le message doit poser la question à l’utilisateur.
- Une explication doit suivre pour détailler le comportement du script en 
    fonction de la réponse.
- Personnalisez le texte du bouton d’annulation.
- Personnalisez le texte du bouton OK avec un message explicitant l’action 
    qui sera réalisée.

{% include post_image.html 
    src='/img/screenshots/2013/04-07_process-img-to-pdf_03-11.png' 
    alt="Étape 11" %}

Si l’utilisateur choisir le bouton d’annulation le processus est arrêté. 
Il ne poursuit que si l’utilisateur clique sur le bouton de validation.

Pour supprimer les fichiers d’origine, il faut reprendre la variable qui 
identifie les fichiers transmis au processus. 
Cette liste doit ensuite être passée à une action qui mettra les fichiers 
dans la corbeille.

1. Faites glisser la variable «*Fichiers source*» à la fin du script pour 
    ajouter une action «*Obtenir la valeur de la variable*».
2. Par simple précaution, assurez-vous que cette action ignore le résultat 
    de celle qui la précède.
3. Faites maintenant glisser l’action 
    «*Placer des éléments du Finder dans la corbeille*».

### C’est fini

Et voilà, le processus est fini. Copiez maintenant un ensemble d’images dans un dossier puis lancez le processus à partir d’Automator en utilisant l’exécution par étapes.

Vous pouvez passer chaque action du processus en cliquant sur le bouton d’étape au fur et à mesure. Cela vous permet de visualiser les résultats de chaque étape.

À la fin, le dialogue de confirmation de suppression est affiché. Choisissez de supprimer les images et vérifiez qu’elles sont bien déplacées dans la corbeille.

Si au contraire vous annulez la suppression, le dossier des images contiendra vos images de départ et le document PDF produit.

Vous pouvez sauver le processus comme service accessible à partir du Finder ou du menu des scripts selon vos préférences.

Voilà votre nouveau processus achevé.

### Téléchargement

Le processus est fourni sous la forme d'un processus simple. Vous pouvez le convertir en application ou en service si vous le souhaiter.
