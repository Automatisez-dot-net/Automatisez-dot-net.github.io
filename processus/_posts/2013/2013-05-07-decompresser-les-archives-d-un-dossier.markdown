---
layout: post
title: "Décompresser les archives d'un dossier"
date: 2013-05-07 12:00:00
logo: folder
attachments:
    - name: "Service pour décompression les zip d'un dossier"
      path: processus/unzip-contenu-du-dossier.zip
---


Vous avez téléchargé une série de fichiers zip et vous devez maintenant tous 
les décompresser ?

Vous pouvez bien sûr tous les ouvrir avec le Finder les uns après les autres. 
Mais il serait plus simple de faire ça d'un clic en utilisant un service.

<div class="alert alert-warning">
<strong>Remarque:</strong>
La création de services avec Automator requiert au minimum Mac 
OS X.6 Snow Leopard.
</div>

Voici un petit service qui récupère les fichiers Zip d'un dossier puis les 
décompresse les uns après les autres.

Pour faire cela j'utilise un script Shell qui appelle la commande open qui 
ouvre le fichier en utilisant l'application par défaut.

L'option `-W` permet de bloquer le processus tant que l'action n'est pas finie. 
Cela évite de décompresser tous les zip en même temps. 
On attend ainsi qu'un fichier soit décompressé avant de passer au suivant.
￼
{% include post_image.html 
    src='/img/screenshots/2013/05-07_serv-unzip-folder-content.png' 
    alt="Service pour décompresser les zip d'un dossier" %}

**Téléchargement**

Le processus final sera installé par OS X dans votre dossier «*Services*» 
dans votre dossier «*Bibliothèque*» personnel ou celui du système.
