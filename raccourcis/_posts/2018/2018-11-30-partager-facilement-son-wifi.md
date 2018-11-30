---
layout: post
title: Partager facilement son WiFi avec un raccourci
date: 2018-11-30 06:00:00 +02:00
logo: shortcut-app
youtube_id: 
attachments: 
  - name: Scan Code (raccourcis)
    url: https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/read/Scan%20Code.shortcut
  - name: Scan Code (raccourcis)
    url: https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/read/Scan%20Code.shortcut
---

Il n'est pas toujours facile de saisir le mot de passe d'un réseau WiFi
sur un téléphone. Certes, Apple facilite la vie en proposant l'échange 
des codes de connexion entre appareils iOS. 
Mais que faire lorsque vous avez des invités qui utilisent un téléphone Android?
Comment proposer facilement un WiFi sécurisé à vos clients ?

C'est exactement ce que nous allons voir dans cet article.

_Source_: Cet article a été largement inspiré par cet article 
de [Pierre Dandumont](jdl_wifi).

### Le principe général

Vous l'aurez probablement deviné, pour proposer une identification facile sur 
un WiFi sécurisé nous allons utiliser une nouvelle fois la technologie des codes QR.

L'objectif est de proposer un raccourci que vous allez pouvoir activer en 
une tape, soit à partir du widget de _Raccourcis_, soit directement à partir 
de votre écran d'accueil.

Et pour cela nous n'allons écrire un raccourcis, mais trois:

1. le raccourcis principal à invoquer d'une tape ;
2. un raccourcis générique pour construire le code QR à partir 
   des informations de connexion de notre réseau WiFi ;
3. Un dernier raccourci utilitaire qui sera utilisé pour encoder
   le nom du réseau WiFi et son mot de passe.

Le premier raccourci va se contenter de préparer les informations de connexion 
avant de les transmettre au second. C'est dans ce raccourci, à ne pas partager, 
que vous devrez indiquer le nom et le mot de passe du réseau.

Pour donner ces informations au raccourci suivant, nous allons utiliser 
la notion de « __dictionnaire__ », une structure de données capable de contenir à 
peu près n'importe quel type d'information, sous la forme d'une liste 
d'associations entre une _clé_ et sa _valeur_.

### Fournir les informations de connexion

#### Le raccourci principal

Le raccourci principal ne va contenir que deux actions :

1. la création du dictionnaires pour les informations de connexion ;
2. l'appel du second raccourci pour créer le code de connexion du WiFi.

{% include post_image.html 
    src='' 
    alt="Contenu d'un raccourci d'exemple « WiFi partagé »" %}

Le dictionnaire créé contient doit contenir trois clés:

- « name » donne le nom du réseau WiFi ;
- « pwd » indique le mot de passe de connexion à ce réseau WiFi ;
- « sec » donne le type de sécurité utilisé qui peut être « WPA », « WEP » ou être vide.

Il suffit ensuite d'appeler le raccourci que nous allons maintenant créer pour le laisser
finir le travail.

#### Commencez le raccourci de génération de code

Créez un raccourci vide que nous allons appeler « build-wifi-qr-code (util) ».
Oui, j'indique « (util) » à la fin du nom pour plus facilement retrouver 
certains raccourcis.

Dans les options de ce nouveau raccourci vous devez indiquer qu'il n'est 
utilisable que par la fonction de partage et qu'il accepte du texte.

{% include post_image.html 
    src='' 
    alt="Les options du raccourci « build-wifi-qr-code (util) »" %}
    
Et c'est tout. Nous ajouterons les actions plus tard.

Maintenant que ce raccourci est créé il nous est possible de le sélectionner dans
l'action « _exécuter le raccourci_ ».


### Création du code

Revenez dans l'édition du raccourci « build-wifi-qr-code (util) ».

Le fonctionnement est divisé en trois parties :

1. la récupération des informations de connexion ;
2. la construction du contenu du code QR ;
3. la création du code QR et son affichage.

#### Récupérer les informations de connexion

Notre raccourci accepte du texte en entrée. 
Notre première tâche va donc consister à transformer le texte reçu en entrée
sous la forme d'un dictionnaire.

La première action que vous devez donc ajouter est « _obtenir le dictionnaire de l'entrée_ ».

Le résultat de cette action sera un dictionnaire identique à celui que nous avons construit
dans le raccourci précédent et transmis sous la forme de texte.

__Note:__ Si vous passez un objet d'un raccourcis vers un autre qui accepte un autre type
de données, l'application _Raccourcis_ se charge de convertir automatiquement le type de données
pour coller à ce qui est demandé.

#### Récupérer chaque paramètre

Il ne nous reste plus qu'à récupérer les valeurs des différentes clés attendues.
Ajoutez une action « _obtenir la valeur du dictionnaire_ » et sélectionnez l'option 
« _valeur_ ».

Dans le champ « clé » indiqué le nom de la clé dont nous voulons la valeur, à savoir « name ».

Le résultat de cette action sera la valeur de la clé « name » dans le dictionnaire 
que nous venons de construire.

Le nom du réseau « name » et le mot de passe « pwd » doivent être encodés pour 
pouvoir être inséré dans le texte du code QR. Cet encodage est assez simple et demande
simplement de précéder certains caratères d'un signe « \ ». 

Mais pour éviter de dupliquer du code, et limiter les risques d'erreur, nous allons nous
appuyer sur un troisième raccourci pour cela. En attendant, ajoutez simplement une action
« _exécuter le raccourci_ » car nous allons avoir besoin de son résultat.

Il nous reste à récupérer les valeurs pour le mot de passe et le protocole de sécurité.

Ajoutez une action « _obtenir la variable_ » pour obtenir à nouveau la valeur du 
dictionnaire.

> _Mais nous n'avons pas défini de variable !_
>
> Oui, nous n'avons pas défini explicitement de variable dans ce raccourci.
> Mais _Raccourcis_ le fait automatiquement et appelle cela des __variables magiques__.

Touchez le bouton « _choisir une variable_ » dans l'action :

1. un menu s'affiche ;
2. sélectionnez l'entrée « _sélectionner la variable magique_ » ;
3. le contenu du raccourci s'affiche avec les variables magiques sous chaque action
   pour laquelle un résultat est obtenu.
4. sélectionnez le résulat de la première action « _obtenir le dictionnaire de l'entrée_ » ;
5. vous allez revenir dans l'éditeur ;

En touchant le nom de cette variable vous aurez la possibilité de modifier son nom, son type
et aussi de retrouver l'action qui en fourni la valeur.

Vous avez à nouveau la valeur du dictionnaire, ajoutez à nouveau l'action 
« _obtenir la valeur du dictionnaire_ » pour obtenir la valeur de la clé « pwd ».

Ajoutez encore une fois une action « _exécuter le raccourci_ » pour encoder ce mot de passe.

Ajoutez à nouveau une action « _obtenir la variable_ » pour obtenir le dictionnaire, 
puis « _obtenir la valeur du dictionnaire_ » pour obtenir la valeur de la clé « sec ».

En revanche, inutile d'encoder cette dernière valeur.

Nous avons maintenant récupérer les valeurs des clés « name », « pwd » et « sec » 
et les deux premières valeurs sont encodées.

Nous pouvons maintenant passer à l'étape suivante, la construction du contenu du code QR.

#### Le contenu du code QR

Ajoutez une action « texte » pour construire le contenu du code QR.

Elle doit contenir les éléments suivants :

  WIFI:T:<Security>;S:<WifiNameEnc>;P:<PasswordEnc>;;
  

- Remplacez « __<Security>__ » par la valeur de la variable magique en sortie de 
  l'action qui récupère la valeur de la clé « _sec_ ».
- Remplacez « <__WifiNameEnc__> » par la valeur de la variable magique en sortie
  de l'action qui encode le nom du réseau wifi « _name_ ».
- Remplacez <__PasswordEnc__> par la valeur de la variable magique en sortie
  de l'action qui encode le mot de passe du réseau « _pwd_ ».
  
Attention à bien terminer par deux caractères « ; ».


#### Générer le code et l'afficher

À partir du texte construit nous pouvons maintenant ajouter
une action « _générer un code QR_ ».

Une correction d'erreur « _moyenne_ » devrait être suffisante dans la plupart des cas.

AJoutez maintenant un action « _coup d'œil_ » qui va afficher ce code QR et 
permettre un partage avec la feuille standard du système.

Vous pourrez ainsi imprimer ce code sur un sticker, l'enregistrer dans une image
ou simplement le présenter à chaque fois qu'un invité le demande.

### Encodage



### Un bouton de partage

[jdl_wifi]: https://www.journaldulapin.com/2018/05/16/qrcode-wifi/