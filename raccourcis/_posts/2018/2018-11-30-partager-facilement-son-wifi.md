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
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/wifi-share/Wifi partagé.png' 
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

Le résultat sera un dictionnaire identique à celui que nous avons construit
dans le raccourci précédent et transmis sous la forme de texte.

__Note:__ Si vous passez un objet d'un raccourcis vers un autre qui accepte un autre type
de données, l'application _Raccourcis_ se charge de convertir automatiquement le type de données
pour coller à ce qui est demandé.

#### Récupérer les paramètres

Il ne nous reste plus qu'à récupérer les valeurs des différentes clés attendues.
Ajoutez une action « _obtenir la valeur du dictionnaire_ » et sélectionnez l'option 
« _valeur_ ».

Dans le champ « clé » indiqué le nom de la première valeur à obteni, à savoir « sec ».

Le résultat de cette action sera la valeur de la clé « sec » dans le dictionnaire 
que nous venons de construire.

{% include post_image.html 
    src='build-wifi-qr-code (util) 01' 
    alt="" %}

Il nous reste à récupérer les valeurs pour « name » le nom du réseau et 
« pwd » le mot de passe.

##### Passage par une variable magique

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
et aussi de retrouver l'action dont provient la valeur.

##### Nom du réseau et mot de passe

Pour récupérer ces deux dernières informations, nous allons devoir à nouveau
puiser dans le dictionnaire.

Pour obtenir à nouveau son contenu, ajoutez à nouveau l'action 
« _obtenir la valeur du dictionnaire_ » pour obtenir la valeur de la clé « name ».

Le nom du réseau « name », ainsi que le mot de passe « pwd », doivent être encodés pour 
pouvoir être inséré dans le texte du code QR. Cet encodage est assez simple et demande
simplement de précéder certains caratères d'un signe « \ ». 

Mais pour éviter de dupliquer du code, et limiter les risques d'erreur, nous allons nous
appuyer sur un troisième raccourci pour cela. En attendant, ajoutez simplement une action
« _exécuter le raccourci_ » car nous allons avoir besoin de son résultat.

Ajoutez l'action « _exécuter le raccourci_ » pour encoder ce mot de passe.
Inutile de renseigner le nom du raccourci pour l'instant, nous devons d'abord le créer.

{% include post_image.html 
    src='build-wifi-qr-code (util) 02' 
    alt="" %}

Répétez à nouveau ces trois mêmes actions pour la clé de dictionnaire « pwd » pour 
récupérer et encoder le mot de passe.

Nous avons maintenant récupérer les valeurs des trois clés « sec », « name » et « pwd » 
et les deux dernières valeurs sont encodées.

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

{% include post_image.html 
    src='build-wifi-qr-code (util) 03' 
    alt="" %}


#### Générer le code et l'afficher

À partir du texte construit nous pouvons maintenant ajouter
une action « _générer un code QR_ ».

Une correction d'erreur « _moyenne_ » devrait être suffisante dans la plupart des cas.

AJoutez maintenant un action « _coup d'œil_ » qui va afficher ce code QR et 
permettre un partage avec la feuille standard du système.

{% include post_image.html 
    src='build-wifi-qr-code (util) 04' 
    alt="" %}

Vous pourrez ainsi imprimer ce code sur un sticker, l'enregistrer dans une image
ou simplement le présenter à chaque fois qu'un invité le demande.

### Encodage

Il est temps de finaliser notre raccourci. Nous devons encore créer le raccourci qui
va encoder le nom du réseau et le mot de passe.

Créer un nouveau raccourci et nommez le « encode-wifi-qr-code-part (util) ».

Il ne va contenir qu'une seule action « _remplacer le texte_ ». 
assurez vous que l'option « _expression régulière_ » est bien active.

Nous allons rechercher toutes les correspondances à l'expression régulière
suivante :

    ([",;:\\])
    
- Les parenthèses permettent de définir un groupe.
- Les crochet indiquent que nous définissont une liste de caractères
- Dans cette liste le caractère « \ » est lui même précédé d'un « \ »
  pour indiquer qu'il doit être pris pour lui même et ne constitue pas
  le préfixe d'un autre caractères, comme dans « \n »

La valeur de « _remplacer par_ » va aussi suivre la syntaxe d'une expression
régulière :

    \\$1
    
Ceci veut dire que tout ce qui correspond à l'expression régulière
placée entre les parenthèses, sera remplacé par un signe « \ » suivi du résultat
de la correpondance.

Ainsi, si l'entrée de l'action est « bonjour; », la recherche va identifier le signe
point-virgule et le rendre disponbible dans _$1_. 
Le résultat du remplacement sera donc « bonjour\; ».

{% include post_image.html 
    src='encode-wifi-qr-code-part (util)' 
    alt="" %}

Ce dernier raccourci est maintenant terminé. Il ne vous reste plus qu'à indiquer
son nom dans les actions qui l'utilisent dans le raccourci précédent.

### Bilan

Nous avons maintenant un moyen pour créer des codes QR pour se connecter 
en toute sécurité à un réseau WiFi. Ne laisser pas trainer ces codes sur
des papiers si votre réseau n'est pas destiné à être public.

Du coté de _Raccourcis_ nous avons également vu rapidement comment utiliser les
_variables magiques_ et aussi comment enchainer les raccourcis.

J'espère que ces outils vous seront utiles.


[jdl_wifi]: https://www.journaldulapin.com/2018/05/16/qrcode-wifi/