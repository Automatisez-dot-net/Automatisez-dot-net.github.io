---
layout: post
title: Créer du contenu à partir d'un dossier
date: 2014-07-13
attachments: 
  - name: Exemple de création de contenu à partir d'un dossier.
    path: "processus/Workflow-dossier-vers-contenu.zip"
---

### On va faire quoi?

Vous avez un dossier rempli de fichiers audios, de photos ou de vidéos, et vous voulez mettre le tout dans une page internet?

Comment publier le tout simplement ? La solution peut-être très simple en utilisant  Automator. 
Que ce soit pour construire une page internet ou un rapport en texte ou en PDF.

L'idée est de fournir deux fichiers:

1. un fichier d'en-tête qui contient le début de la page (en-tête, introduction).
2. un fichier de conclusion qui contiendra la fin de la page.

La partie intermédiaire, qui contiendra la liste des fichiers sera construire par un processus Automator en utilisant le contenu du dossier des médias. 
Le processus utilisera aussi les commentaire de chaque fichier pour les insérer dans le contenu généré.

Notre processus va se décomposer en quelques étapes:

1. Dans un premier temps on récupère le contenu du dossier en l'ordonnant par nom.
2. Pour chacun de ses fichiers on va extraire les informations intéressantes et transposer le tout dans un format utilisable dans une page.
3. Pour finir on va ajouter le contenu d'en-tête et enfin celui de conclusion.

Le résultat sera un fichier que l'on pourra publier directement s'il est au format HTML. 
Dans mon cas, pour ne pas compliquer les choses je vais faire abstraction de l'HTML et construire un document dans un format intermédiaire: le [*markdown*][markdown]. 
Mais il sera possible de le convertir par la suite en HTML ou même en PDF. Il suffit simplement d'utiliser un éditeur comme [ByWord][byword] pour faire cette conversion.

### Récupérer la liste des médias

Pour cette première étape il faut commencer par définir le dossier dont on souhaite indexer le contenu. 
Pour un processus nous allons faire cela de façon interactive:

1. Ouvrez Automator et créez un processus simple.
2. Ajouter une action «*demander des éléments du Finder*».
3. Stockez le chemin de ce dossier dans une variable nommée *dossier* en ajoutant une action «*définir la valeur de la variable*».
4. Le contenu du dossier est ensuite récusé avec l'action «*obtenir le contenu de dossiers*».
5. Ajoutons un peu d'ordre en ajoutant une action «*trier des éléments du Finder*» pour ordonner les fichiers par ordre alphabétique croissant.

Le début de votre processus est maintenant achevé et devrait ressembler à ce qui suit.

Wkf-FileIndex-01.png
{% include post_image.html 
    src='/img/screenshots/2014/07-13_Wkf-FileIndex-01.png' 
    alt='Processus complet' %}

Remarquez que votre nouveau processus récupère le contenu complet du dossier. 
Vous pourriez améliorer cela en ajoutant des actions de filtrage pour ne retenir que les types de fichiers que vous souhaitez (images, vidéos, etc.).

### Créer le contenu de fichier

Notre processus a maintenant une liste de fichiers que nous voulons insérer dans un contenu. 
Pour cela nous allons utiliser un second processus.

**Pourquoi sortir cette fonctionnalité du processus principal?**

Nous pourrions très bien insérer cette action directement dans le premier processus et nous en contenter. Mais si nous voulons un système souple, il peut être intéressant de décomposer un peu les étapes pour au moins deux raisons :

1. Il sera plus facile de modifier cette partie du processus sans risquer de  « casser » le processus principal.
2. Il deviens plus facile de se construire plusieurs moulinettes de conversion : spécialisé pour un type particulier de document, ou spécialisé pour une cible particulière (document texte, page web, base de données).

Commencez par créer un nouveau processus. et ajoutez simplement une action «*exécuter un script AppleScript*».
Nous allons utiliser un peu ce langage pour créer un contenu spécifique à chaque fichier.

Ce processus sera appelé pour chaque fichier du dossier. Notre script doit réaliser les étapes suivantes :

1. Il récupère les propriétés du fichier.
2. Il récupère le nom du fichier.
3. Il récupère le commentaire associé au fichier.
4. Il construit le texte du contenu, du markdown dans notre cas, en utilisant ces trois valeurs.

Pour récupérer les propriétés du fichier vous devez ajouter les instructions suivantes :

{% highlight AppleScript %}
on run {input, parameters}
    tell application "Finder"
        set props to properties of file input
        set leNom to name of props
        set leCommentaire to comment of props
    end tell
end run
{% endhighlight %}

Il reste maintenant à ajouter la construction du contenu :

{% highlight AppleScript %}
on run {input, parameters}
	
    tell application "Finder"
        set props to properties of file input
        set leNom to name of props
        set leCommentaire to comment of props
		
        if leCommentaire is not equal to "" then
            set leCommentaire to " : " & leCommentaire
        end if
    end tell
	
    set lienMd to "- <a href="\"" & lenom & "\">" & leNom & "</a>" & leCommentaire & "![" & leNom & "](" & leNom & ")"
	
    return lienMd
end run
{% endhighlight %}

Notez que nous ne créons du contenu associé au commentaire que si un commentaire est effectivement défini pour le fichier. 
Sinon pour le reste c'est un élément de liste où le nom du fichier est un hyperlien vers le fichier. 
Comme pour l'exemple je parcours une liste d'images, le contenu généré insère également ces images en utilisant le code «`![libellé](image)`».

Wkf-FileIndex-02.png
{% include post_image.html 
    src='/img/screenshots/2014/07-13_Wkf-FileIndex-02.png' 
    alt='Script AppleScript' %}

Il ne reste plus qu'à appeler ce module à partir du processus principal. 

Revenez sur ce premier processus et ajoutez maintenant une action «*lancer un processus*». 
Dans les options de l'action il vous faut sélectionner le processus que vous venez de créer et activer le comportement suivant :

L'entrée du processus doit être réalisée par lots de 1 fichier. 
Si vous pensez avoir beaucoup de fichiers à traiter vous pouvez augmenter le nombre de processus exécutés simultanément, mais dans mon cas je reste sur 1 processus à la fois.

Pour la sortie on doit attendre la fin du processus et en renvoyer le résultat.

{% include post_image.html 
    src='/img/screenshots/2014/07-13_Wkf-FileIndex-03.png' 
    alt='Étape pour lancer un processus' %}

La dernière étape consiste maintenant à assembler les contenus construits pour chaque fichier dans un fichier unique.

Ajoutez une action «*créer un fichier texte*» qui sera stocké dans le dossier sélectionné initialement. 
Pour cela utilisez la variable dossier qui a été définie au début.

Stockez le chemin du fichier dans une variable «*fichier-liste*».

{% include post_image.html 
    src='/img/screenshots/2014/07-13_Wkf-FileIndex-04.png' 
    alt='Stocker le résultat dans une variable' %}

La partie la plus complexe du processus est maintenant achevée. 
Vous pouvez tester rapidement l'exécution pour vérifier que le fichier produit correspond à nos attentes.

### Assemblage des fichiers

Pour finir la construction du contenu il faut maintenant réaliser les ultimes actions suivantes :

- On doit sélectionner le fichier d'introduction et le fichier de conclusion.
- Ces deux fichiers doivent être combinés avec le fichier de contenu qui a été construit.

Pour sélectionner les fichiers ajoutez les actions suivantes :

1. «*demander les éléments du Finder*» pour sélectionner un seul fichier en utilisant le dossier initial comme point de départ. Cette action doit ignorer les données de l'action précédente.
2. «*définir une valeur de la variable*» pour se souvenir du chemin.

{% include post_image.html 
    src='/img/screenshots/2014/07-13_Wkf-FileIndex-05.png' 
    alt='Étape 5' %}

Cette paire d'action doit être faite deux fois : une fois pour l'introduction et une variable «*fichier-debut*» et une seconde fois pour la fin et une variable «*fichier-fin*».

Pour enfin assembler les fichiers, il suffit de récupérer les valeurs des variables «*fichier-debut*», «*fichier-liste*» et «*fichier-fin*» et passer le résultat à une action «*combiner les fichiers texte*».

Le résultat est enfin enregistré dans le contenu final avec l'action «*créer un fichier texte*» dans le dossier cible.

{% include post_image.html 
    src='/img/screenshots/2014/07-13_Wkf-FileIndex-06.png' 
    alt='Création du fichier final' %}

Et voilà, le processus est maintenant achevé.

Le fichier produit peut maintenant être converti en HTML ou en PDF en utilisant ByWord ou un script de conversion Markdown.

Vous pouvez télécharger l'ensemble de cet exemple avec des images et le résultat.

### Conclusion

Vous pouvez vous inspirer de ce processus pour l'adapter à vos propres besoins. Que ce soit pour créer automatiquement un album photo sur Internet ou un rapport PDF.

À vous d'adapter la création de contenu à vos besoins. Le processus pourrait aussi être transformé en action de calendrier pour des mises à jour périodiques.

La balle est dans votre camp maintenant !

[markdown]: http://fr.wikipedia.org/wiki/Markdown
[byword]: http://bywordapp.com/