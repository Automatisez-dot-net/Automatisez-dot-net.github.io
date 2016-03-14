---
layout: post
title: Un processus pour ajouter des fichiers dans Evernote
date: 2016-02-09 12:00:00 +01:00
logo: evernote
attachments: 
  - name: Evernote, archiver les fichiers.app
    path: processus/Evernote_archiver_les_fichiers.app.zip
---

Si vous utilisez Evernote, vous avez peut-être remarqué que cette application 
ne propose pas de solution pour créer une note à partir d'un fichier.

Pourtant, Evernote dispose d'une bonne intégration avec AppleScript. 
Je vous propose donc d'utiliser cela pour construire un petit service. 
Celui ci nous permettra de créer une nouvelle note à partir d'un fichier, 
comme celui créé après une numérisation, puis placer ce fichier dans la corbeille.

### Objectif de l'application

Vous me direz probablement qu'il est très facile de créer une nouvelle note à 
partir d'un document. Il vous suffit de faire glisser son icône sur celui 
d'Evernote.

Mais cette utilisation, si elle est simple, n'est pas très facilement 
automatiquement *automatisable*.

Mon objectif est donc de créer une action qui puisse être *intégrée à un mode 
de traitement automatique*: comme un flux de numérisation de documents ou des 
scripts de règles dans Mail.

Une option consisterai à ouvrir le document avec l'application Evernote. 
Une opération simple a réaliser avec l'action Automator 
«*Ouvrir les éléments du Finder*» en forçant l'utilisation d'Evernote. 
Cela fonctionne parfaitement, mais Evernote conserve alors la fenêtre de 
création d'une note ouverte. 
L'utilisateur doit alors manuellement valider la création de la note.

Utilisons donc AppleScript...

### Mise en œuvre

Le processus va être divisé en quatre actions:

1. se souvenir des documents spécifiés en entrée du processus ;
2. créer la nouvelle note dans Evernote en ajoutant le fichier en pièce jointe ;
3. demander à l'utilisation s'il souhaite supprimer le fichier d'origine ;
4. placer le document d'origine dans la corbeille.

Commencez par créer une application ou un service.

La première action à ajouter est donc «*définir la valeur de la variable*». 
Créez une variable «*documents*» qui se souviendra des documents.

L'action suivante va consister à créer la note dans Evernote en s'appuyant 
sur l'intégration avec AppleScript. 
Ajoutez donc l'action «*exécuter un script AppleScript*». 
Nous verrons plus loins comment écrire ce bout de script.

Ajoutez maintenant l'action «*demander une confirmation*». 
Elle va permettre de demander à l'utilisateur si le fichier doit être placé à 
la corbeille après la création de la note.

Enfin, la dernière action du processus sera justement «*placer les éléments du 
Finder dans la corbeille*». 
Elle ne sera exécutée que si l'utilisateur répond par l'affirmative à l'action 
précédente.

La structure générale du processus est maintenant complète. 
Il vous reste à implémenter le plus important: la création de la note.

### Créer une note en AppleScript

Le script AppleScript comprend une procédure «*run*»:

```AppleScript
on run {input, parameters}
    ...	
return input
end run
```

Cette procedure accepte la liste de documents en paramètres (*input*) 
ainsi que des paramètres (*parameters*) que nous ignorerons. 
La liste de documents est aussi la valeur renvoyée par cette procédure.

Ce script doit fonctionner de la façon suivante :

1. Pour chaque document:
    1.	récupère le nom du fichier, sans l'extension;
    2.	récupère le chemin du fichier;
    3.	on demande ensuite à Evernote de créer une nouvelle note en y ajoutant le fichier.

La boucle est réalisée en utilisant une structure «*repeat*» pour parcourir la 
liste «*input*».

```AppleScript
repeat with currentFile in input
    ...
end repeat
```

Pour obtenir les information du fichier il faut utiliser le Finder:

```AppleScript
tell application "Finder"
    set theFilePath to (POSIX path of currentFile)
    set theName to (name of currentFile)
end tell
```

En utilisant les informations sur ce fichier, vous pouvez maintenant demander 
à Evernote de créer une nouvelle note.

```AppleScript
tell application "Evernote"
    activate
    create note title theName from file currentFile attachments theFilePath
end tell
```

Mais il est possible qu'Evernote génère des erreurs. 
Pour éviter que cela ne bloque notre petit script, il est donc conseillé 
d'intercepter toute interruption en encadrant l'utilisation avec Evernote dans 
un gestionnaire d'exceptions:

```AppleScript
try -- Masquer les erreurs d'Evernote
    ...
on error errStr number errorNumber
    set messageErreur to "Erreur: " & errStr & "(" & (errorNumber as string) & ")."
    log messageErreur
end try
```

Le script achevé devrait donc ressembler à ce qui suit:

```AppleScript
on run {input, parameters}
  repeat with currentFile in input
    tell application "Finder"
      set theFilePath to (POSIX path of currentFile)
      set theName to (name of currentFile)
    end tell
    try -- Masquer les erreurs Evernote
      tell application "Evernote"
        activate
        create note title theName from file currentFile attachments theFilePath
      end tell
    on error errStr number errorNumber
      set messageErreur to "Erreur: " & errStr & "(" & (errorNumber as string) & ")."
      log messageErreur
    end try
  end repeat
	
  return input
end run
```

Vous pouvez consulter le vocabulaire d'Evernote en consultant la page de 
référence sur le site des développeurs.

### La confirmation de suppression

Il vous faut faire confirmer la suppression du fichier d'origine à l'utilisateur. 
Pour cela vous devez personnaliser l'action de confirmation:

- Changez le titre en y plaçant la variables «*documents*».
- Dans le message, saisissez un texte qui indique à quelle étape du processus 
    l'utilisateur se trouve «*archivé dans Evernote*» par exemple.
- Modifiez le label du bouton d'annulation en indiquant quelle action sera 
    réalisée : «*conserver*».
- Modifiez le label du bouton de confirmation de la même façon : «*supprimer*».

### Conclusion

Le processus final devrait ressembler à l'application ci-dessous:
￼
{% include post_image.html 
    src='/img/screenshots/2016/02-09_Evernote_archiver_les_fichiers.png' 
    alt='Processus complet pour archiver un fichier dans Evernote.' %}


Ce processus vous permet d'automatiser l'acquisition de notes dans Evernote. 
C'est une première étape. 
Mais l'intégration de l'application avec AppleScript vous permet, entre autre, 
de traiter automatiquement vos courriels avec des règles. 
Un moyen automatique pour les archiver ou en archiver les pièces jointes.

Le processus est disponible sous la forme d'une application avec cet article. 
Téléchargez-le !

