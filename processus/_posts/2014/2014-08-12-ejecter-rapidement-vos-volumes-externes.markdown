---
layout: post
title: Ejecter rapidement vos volumes externes
date: 2014-08-12 12:00:00
logo: folder
attachments:
    - name: "Service éjecter volume externe (Automator et AppleScript)"
      path: processus/service-ejecter-volumes-externes.zip
---

Comment utiliser AppleScript pour éjecter en un clic l’ensemble de vos disques 
externes et clefs USB?

C’est le problème que cet article a la prétention de vouloir résoudre de façon 
simple et minimaliste.

<div class="alert alert-info">
Merci à Guillaume Gete pour avoir largement corrigé le script extrêmement 
lourd que j'avais publié dans une première version. 
Les scripts joints à l'article ont été mis à jour.
</div>

Si vous avez un ordinateur portable et que vous utilisez Time Machine, 
vous avez peut-être pris l’habitude de le brancher sur un disque externe 
tous les soirs en revenant chez vous?

Plus généralement, si vous branchez souvent clés USB, cartes mémoire et disques 
externes, vous avez surement envie d'éjecter tout ce petit monde facilement. 
Si possible en un seul clic.

### Une solution. Vite !

La paresse étant souvent la meilleure motivation pour automatiser les petites 
tâches quotidiennes, j’ai donc pris les choses en main et je me suis fendu de 
quelques lignes d’AppleScript pour faire à ma place l’éjection des volumes 
externes.

Les premières question à se poser sont simples:

- A quelle application faire appel?
- Comment obtenir la liste des disques?
- Comment identifier les disques externes?
- Quelle action pour éjecter un volume?

Les réponses à ces questions sont relativement simple:

- Le Finder semble être l’application candidate idéale. 
    Une visite dans son dictionnaire AppleScript s’impose.
- Le Finder possède un propriété ’*disks*’ qui semble être exactement ce que 
    je cherche : la liste des différents disques connectés au système.
- Chaque élément de cette liste est un objet de la classe ’*Disk*’ dont les 
    objets possèdent deux attributs intéressants : ’*ejectable*’ et ’*local volume*’.
- Le Finder accepte la commande ’*eject*’ qui devrait faire exactement ce que son nom semble suggérer.

Commençont notre script:

``` AppleScript
tell application "Finder"
    set disques to disks
    set disques_ejectables to {}
end tell
```

La liste ’*disques*’ contiendra la liste des disques du système. 
On pourrait très bien se passer de cette variable, mais j'ai tendance à être 
un peu verbeux.

La seconde variable ’*disques_ejectables*’ sera le sous-ensemble, à construire, 
des seuls volumes externes.

Il faut maintenant remplir cette liste en parcourant la liste des disques et en 
ne retenant que les disques éjectables et qui sont locaux. On utilise une boucle
`repeat with … end repeat`.

``` AppleScript
repeat with i from 1 to the count of disques
    set le_disque to (item i of disques)
    if (le_disque is ejectable and le_disque is local volume) then
        set disques_ejectables to disques_ejectables & {le_disque}
    end if
end repeat
```

Il suffit ensuite de parcourir une seconde fois cette liste pour éjecter les 
volumes les uns après les autres. Le script final est donc le suivant:

``` AppleScript
tell application "Finder"
 set disques to disks
 set disques_ejectables to {}
        
 repeat with i from 1 to the count of disques
   set le_disque to (item i of disques)
   if (le_disque is ejectable and le_disque is local volume) then
     set disques_ejectables to disques_ejectables & {le_disque}
   end if
 end repeat
        
 if ((count of disques_ejectables) is greater than 0) then
   try
     repeat with i from 1 to the count of disques_ejectables
       eject (item i of disques_ejectables)
     end repeat
   end try
 end if
end tell
```

Mais il est possible de faire encore beaucoup plus court en utilisant la 
capacité de construire des requêtes en AppleScript.

``` AppleScript
tell application "Finder" to eject (every disk whose ejectable is true and local volume is true)
```

Merci [Guillaume](http://www.gete.net/) pour cette dramatique optimisation de 
la taille du script.

### Construisons un service

Et voilà un script simple et rapide à utiliser. 
Vous pouvez l'enregistrer comme simple application avec l'éditeur AppleScript 
et le lancer à partir du Dock ou de votre bureau.

Je vous propose d'intégrer ce script à un service d'OS X pour qu'il soit 
utilisable de partout.

Lancez maintenant Automator et créez un nouveau service. 
Celui ci ne reçoit aucune entrée et peut être disponible à partir de n'importe 
quelle application.

Ajoutez une action «*exécuter un script AppleScript*» dans votre processus et 
coller le code du script entre `on run` et `return input`.

Votre processus devrait ressembler à ceci :
￼
{% include post_image.html 
    src='/img/screenshots/2014/08-14_service-eject-xtern-vol.png' 
    alt="Processus complet" %}

Et voilà, vous avez maintenant un service utilisable simplement pour éjecter 
tous vos volumes externes.

Le script est simpliste et on peut l’améliorer facilement : 
en réduisant le nombre de lignes ou même éviter de parcourir deux fois la liste des disques.

Libre à vous d’améliorer ce script comme bon vous semble. 
Télécharger le fichier script ainsi que le service qui sont joints à cet article.

