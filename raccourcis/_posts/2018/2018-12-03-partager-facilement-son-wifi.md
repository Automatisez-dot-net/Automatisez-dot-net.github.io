---
layout: post
title: Partager facilement son WiFi avec un raccourci
date: 2018-12-03 06:00:00 +02:00
logo: shortcut-app
youtube_id: 1IYlEuLLlMY
attachments: 
  - name: « encode-wifi-qr-code-part (util) » (raccourci)
    url: https://github.com/automatisez/iOS-workflow/raw/master/shortcuts-app/wifi-share/encode-wifi-qr-code-part%20(util).shortcut
  - name: « encode-wifi-qr-code-part (test) » (raccourci de test, optionnel)
    url: https://github.com/automatisez/iOS-workflow/raw/master/shortcuts-app/wifi-share/encode-wifi-qr-code-part%20(test).shortcut
  - name: « build-wifi-qr-code (util) » (raccourcis)
    url: https://github.com/automatisez/iOS-workflow/raw/master/shortcuts-app/wifi-share/build-wifi-qr-code%20(util).shortcut
  - name: « Wifi partagé » (exemple de raccourci)
    url: https://github.com/automatisez/iOS-workflow/raw/master/shortcuts-app/wifi-share/Wifi%20partage.shortcut
---

Il n’est pas toujours facile de saisir le mot de passe d’un réseau WiFi
sur un téléphone. Certes, Apple vous simplifie la vie en proposant l’échange 
des codes de connexion entre terminaux iOS. 
Mais que faire lorsque vous avez des invités qui utilisent un appareil Android ?
Comment partager un WiFi sécurisé à vos clients ?

C’est exactement ce que nous allons voir.

_Source :_ cet article a été largement inspiré par celui de 
[Pierre Dandumont][jdl_wifi].

### Le principe général

Vous l’aurez probablement deviné, pour proposer une identification facile sur 
un WiFi sécurisé nous allons utiliser une nouvelle fois la technologie des codes QR.

L’objectif est d'écrire un raccourci que vous allez pouvoir activer en 
une tape, soit à partir du widget de _Raccourcis_, soit directement sur votre écran d’accueil.

Et pour cela, nous n’allons pas créer un raccourci, mais trois:

1. le raccourci principal à invoquer d’une tape ;
2. un raccourci générique pour construire le code QR à partir 
   des informations de connexion de notre réseau WiFi ;
3. Un dernier raccourci utilitaire dont le rôle est d'encoder
   le nom du réseau WiFi et son mot de passe.

Le premier raccourci va se contenter de préparer les données de connexion 
avant de les transmettre au second. C’est dans ce raccourci, à ne pas partager, 
que vous devrez indiquer le nom et le mot de passe du réseau.

Pour donner ces informations au raccourci suivant, nous allons utiliser 
la notion de « __dictionnaire__ », une structure de données capable de contenir
à peu près n’importe quel type de valeur, sous la forme d’une liste 
d’associations entre une _clé_ et sa _valeur_.

### Fournir les informations de connexion

#### Le raccourci principal

Le raccourci principal ne va contenir que deux actions :

1. la création du dictionnaire pour les informations de connexion ;
2. l'appel du second raccourci pour créer le code de connexion du WiFi.

{% include post_image.html 
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/wifi-share/Wifi%20partage.png' 
    alt="Contenu d'un raccourci d'exemple « WiFi partagé »" %}

Le dictionnaire créé doit contenir trois clés:

- « name » pour le nom du réseau WiFi ;
- « pwd » indique le mot de passe de connexion à ce réseau WiFi ;
- « sec » donne le type de sécurité utilisé qui peut être « WPA », « WEP » ou être vide.

Il suffit ensuite d’appeler le raccourci que nous allons maintenant créer pour le laisser
finir le travail.

#### Commencez le raccourci de génération de code

Créez un raccourci vide que nous allons appeler « build-wifi-qr-code (util) ».
Oui, j'indique « (util) » à la fin du nom pour plus facilement retrouver 
certains raccourcis.

Dans les options de ce nouveau raccourci vous devez indiquer qu'il n'est 
utilisable que par la fonction de partage et qu'il accepte du texte.

{% include post_image.html 
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/wifi-share/build-wifi-qr-code%20(util)%2000.jpg' 
    alt="Les options du raccourci « build-wifi-qr-code (util) »" %}
    
Et c'est tout. Nous ajouterons les actions plus tard.

Maintenant que ce raccourci est créé, il nous est possible de le sélectionner dans
l'action « _exécuter le raccourci_ ».


### Création du code

Revenez dans l'édition du raccourci « build-wifi-qr-code (util) ».

Le fonctionnement est divisé en trois parties :

1. la récupération des informations de connexion ;
2. la construction du contenu du code QR ;
3. la création du code QR et son affichage.

#### Récupérer les informations de connexion

Notre raccourci accepte du texte en entrée. 
Notre première tâche va donc consister à transformer le texte reçu en entrée
sous la forme d’un dictionnaire.

La première action que vous devez donc ajouter est « _obtenir le dictionnaire de l’entrée_ ».

Le résultat sera un dictionnaire identique à celui que nous avons construit
dans le raccourci précédent et transmis sous la forme de texte.

__Note:__ si vous passez un objet d’un raccourci vers un autre qui accepte un autre type
de données, l’application _Raccourcis_ se charge de convertir automatiquement le type de données
pour coller à ce qui est demandé.

#### Récupérer les paramètres

Il ne nous reste plus qu’à récupérer les valeurs des différentes clés attendues.
Ajoutez une action « _obtenir la valeur du dictionnaire_ » et sélectionnez l’option 
« _valeur_ ».

Dans le champ « clé » indiqué le nom de la première valeur à obteni, à savoir « sec ».

Le résultat de cette action sera la valeur de la clé « sec » dans le dictionnaire 
que nous venons de construire.

{% include post_image.html 
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/wifi-share/build-wifi-qr-code%20(util)%2001.png' 
    alt="Récupération du dictionnaire et du premier paramètre." %}

Il nous reste à récupérer la valeur de « name », le nom du réseau, et celle de 
« pwd », le mot de passe.

##### Passage par une variable magique

Ajoutez une action « _obtenir la variable_ » pour obtenir à nouveau la valeur du 
dictionnaire.

> _Mais nous n’avons pas défini de variable !_
>
> Oui, nous n’avons pas défini explicitement de variable dans ce raccourci.
> Mais _Raccourcis_ le fait automatiquement et appelle cela des __variables magiques__.

Touchez le bouton « _choisir une variable_ » dans l’action :

1. un menu s’affiche ;
2. sélectionnez l’entrée « _sélectionner la variable magique_ » ;
3. le contenu du raccourci s’affiche avec les variables magiques sous chaque action
   pour laquelle un résultat est obtenu.
4. sélectionnez le résultat de la première action « _obtenir le dictionnaire de l’entrée_ » ;
5. vous allez revenir dans l’éditeur ;

En touchant le nom de cette variable vous aurez la possibilité de modifier son nom, son type
et aussi de retrouver l’action dont provient la valeur.

##### Nom du réseau et mot de passe

Pour récupérer ces deux dernières informations, nous allons devoir à nouveau
puiser dans le dictionnaire.

Pour obtenir à nouveau son contenu, ajoutez à nouveau l’action 
« _obtenir la valeur du dictionnaire_ » pour obtenir la valeur de la clé « name ».

Le nom du réseau « name », ainsi que le mot de passe « pwd », doit être encodé pour  être inséré dans le texte du code QR. Cet encodage est assez simple et demande
simplement de précéder certains caractères d’un signe « \ ». 

Mais pour éviter de dupliquer du code, et limiter les risques d’erreur, nous allons nous
appuyer sur un troisième raccourci pour cela. En attendant, ajoutez simplement une action
« _exécuter le raccourci_ » car nous allons avoir besoin de son résultat.

Ajoutez l’action « _exécuter le raccourci_ » pour encoder ce mot de passe.
Inutile de renseigner le nom du raccourci pour l’instant, nous devons d’abord le créer.

{% include post_image.html 
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/wifi-share/build-wifi-qr-code%20(util)%2002.png' 
    alt="Récupération du nom de réseau." %}

Répétez à nouveau ces trois mêmes actions pour la clé de dictionnaire « pwd » pour 
récupérer et encoder le mot de passe.

Nous avons maintenant récupéré les valeurs des trois clés : « sec », « name » et « pwd » 
et ces deux dernières valeurs sont encodées.

Nous pouvons maintenant passer à l’étape suivante, la construction du contenu du code QR.

#### Le contenu du code QR

Ajoutez une action « texte » pour construire le contenu du code QR.

Elle doit contenir les éléments suivants :

  WIFI:T:<Security>;S:<WifiNameEnc>;P:<PasswordEnc> ; ;
  

- Remplacez « __<Security>__ » par la valeur de la variable magique en sortie de 
  l’action qui récupère la valeur de la clé « _sec_ ».
- Remplacez « <__WifiNameEnc__> » par la valeur de la variable magique en sortie
  de l’action qui encode le nom du réseau wifi « _name_ ».
- Remplacez <__PasswordEnc__> par la valeur de la variable magique en sortie
  de l’action qui encode le mot de passe du réseau « _pwd_ ».
  
Attention à bien terminer par deux caractères « ; ».

{% include post_image.html 
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/wifi-share/build-wifi-qr-code%20(util)%2003.png' 
    alt="Récupération du mot de passe et construction du contenu du code QR." %}


#### Générer le code et l’afficher

À partir du texte que nous venons de construire, nous pouvons maintenant ajouter
une action « _générer un code QR_ ».

Une correction d’erreur « _moyenne_ » devrait être suffisante dans la plupart des cas.

Ajoutez maintenant un action « _coup d'œil_ » qui va afficher ce code QR et 
permettre un partage avec la feuille standard du système.

{% include post_image.html 
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/wifi-share/build-wifi-qr-code%20(util)%2004.png' 
    alt="Finalisation du raccourci avec la création et l’affichage du code QR" %}

Vous pourrez ainsi imprimer ce code sur un sticker, l’enregistrer dans une image
ou simplement le présenter à chaque fois qu’un invité le demande.

### Encodage

Il est temps de finaliser notre raccourci. Nous devons encore créer le raccourci qui
va encoder le nom du réseau et le mot de passe.

Créez un nouveau raccourci et nommez-le « encode-wifi-qr-code-part (util) ».

Il ne va contenir qu’une seule action « _remplacer le texte_ ». 
Assurez-vous que l’option « _expression régulière_ » est bien active.

Nous allons rechercher toutes les correspondances à l’expression régulière
suivante :

    ([",;:\\])
    
- Les parenthèses permettent de définir un groupe.
- Les crochets indiquent que nous définissons une liste de caractères
- Dans cette liste le caractère « \ » est lui-même précédé d’un « \ »
  pour indiquer qu’il doit être pris pour lui même et ne constitue pas
  le préfixe d’un autre caractère, comme dans « \n »

La valeur de « _remplacer par_ » va aussi suivre la syntaxe d’une expression
régulière :

    \\$1
    
Ceci veut dire que tout ce qui correspond à l’expression régulière
placée entre les parenthèses sera remplacé par un signe « \ » suivi du résultat
de la correspondance.

Ainsi, si l’entrée de l’action est « bonjour ; », la recherche va identifier le signe
point-virgule et le rendre disponible dans _$1_. 
Le résultat du remplacement sera donc « bonjour\ ; ».

{% include post_image.html 
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/wifi-share/encode-wifi-qr-code-part%20(util).png' 
    alt="Encodage des noms et mot de passe du réseau, le raccourci réutilisable." %}

Ce dernier raccourci est maintenant terminé. Il ne vous reste plus qu’à indiquer
son nom dans les actions qui l’utilisent dans le raccourci précédent.

### Bilan

Nous avons maintenant un moyen pour créer des codes QR pour nous connecter 
en toute sécurité à un réseau WiFi. Ne laissez pas trainer ces codes sur
des papiers si votre réseau n’est pas destiné à être public.

Du côté de _Raccourcis_ nous avons également vu rapidement comment utiliser les
_variables magiques_ et aussi comment enchainer les raccourcis.

Vous pouvez télécharger directement les raccourcis à partir de cette page.
Respectez bien l’ordre indiqué de façon à ce que chaque référence à un 
raccourci soit bien reconnue.

J’espère que ces outils vous seront utiles et que vous aurez un
peu plus envie d’apprendre à utiliser _Raccourcis_.


[jdl_wifi]: https://www.journaldulapin.com/2018/05/16/qrcode-wifi/ "Journal du Lapin"