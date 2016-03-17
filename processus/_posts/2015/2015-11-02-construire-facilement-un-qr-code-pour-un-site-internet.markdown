---
layout: post
title: "Construire facilement un QR Code pour un site internet"
date: 2015-11-02 12:00:00
logo: safari
attachments:
    - name: "Service, créer un code QR pour une URL"
      path: processus/Serv-URL-Creer-QRCode.zip
---

Vous connaissez peut-être les Codes QR ? 
Ce sont ces grilles de points, le plus souvent en noir et blanc, 
que l’on peut prendre en photo sur son mobile pour éviter d’entrer une 
longue adresse internet.

Je ne les utilise pas énormément, mais il est parfois utile de pouvoir en 
insérer un dans un document papier. 
Et là, on passe 2 minutes à retrouver une application ou un site capable 
de construire un tel code.

Je vous propose un processus capable de faire l’opération en un clic, 
directement à partir de Safari.

### Comment ça marche ?

Il existe différents sites internet capables de vous construire gratuitement 
un code QR. Dans cet exemple je vais utiliser [q-r-code.fr](http://q-r-code.fr/).

Le site en question permet de construire des codes QR pour différents types de 
données, mais dans note cas nous n’allons utiliser que celui pour les adresses 
internet (URL).

Le fonctionnement est simple :

1. vous entrez une adresse internet
2. après validation l’image du code QR est remplacée par le bon code

Sans entrer dans les détails, il est relativement simple de découvrir comment est obtenue cette image. Il suffit d’une visite dans les outils de développement de Safari découvrir que les images de codes sont récupérées à une adresse de la forme :

```
http://q-r-code.fr/image.php?lien=${LIEN}&err=M&couleur=0,0,0
```

Où il suffit de remplacer `${LIEN}` par l’URL du site, mais encodée pour 
pouvoir être mise dans une autre URL.

### Le processus

Il suffit de créer un nouveau service dans Automator qui accepte du texte à
partir de n’importe quelle application.
L’idée générale sera :

1. d’encoder l’URL du site dont on veut le code QR ;
2. construire l’URL de l’image du code QR ;
3. télécharger l’image ;
4. donner un nom significatif à cette image ;
5. ajouter l’URL de destination comme commentaire au fichier (afin de retrouver 
    plus facilement l’image).

Pour l’encodage il n’est pas utile de se casser la tête. 
JavaScript sait très bien le faire et il vous suffit donc d’utiliser un bout de 
JavaScript pour faire l’opération.

Même chose pour la construction de l’adresse. 
J’utilise encore un peu de JavaScript.

Le plus important est de transformer le texte de l’adresse de l’image en 
URL avec l’action «*get URLs from text*». 
L’image est directement récupérable en la téléchargeant dans le dossier de 
votre choix. Ici j’ai utilisé le dossier de téléchargement, mais vous pourriez 
vouloir un dossier spécial pour les codes QR.

La fin du processus est classique avec le changement du nom et l’ajout du 
commentaire pour les informations de fichier.

Le processus complet ressemble à ce qui suit :
￼
{% include post_image.html 
    src='/img/screenshots/2015/11-02_Serv-URL-QRCode.png' 
    alt="Service de création de QR code pour une URL" %}


### Utilisation

Dans Safari il vous faut un clic secondaire sur l’adresse pour afficher
le menu des services et aller sélectionner votre créateur de code QR.
￼
{% include post_image.html 
    src='/img/screenshots/2015/11-02_Serv-URL-QRCode-trigger.png' 
    alt="Déclencher le service à partir de Safari" %}

Une fois le processus terminé, une notification vous avertit.
L’image est disponible dans le dossier des téléchargements. 
Vous pouvez vérifier que l’affichage des informations vous montre bien 
l’adresse du site dans le champ des commentaires.
￼
{% include post_image.html 
    src='/img/screenshots/2015/11-02_Serv-URL-QRCode-output.png' 
    alt="Image code QR et URL dans les commentaires" %}
