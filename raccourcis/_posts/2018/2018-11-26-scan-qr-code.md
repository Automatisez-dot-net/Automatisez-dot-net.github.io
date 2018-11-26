---
layout: post
title: Échanger du texte entre un PC et un iPhone
date: 2018-11-26 06:00:00 +02:00
logo: shortcut-app
youtube_id: knd7BCjXCe8
attachments: 
  - name: Scan Code (raccourcis)
    url: https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/read/Scan%20Code.shortcut
---

L'appareil photo de l'iPhone sait lire des codes QR, mais se limite à ceux 
qui correspondent à des sites internet. 
Je vous propose une solution plus générique pour lire tous les codes 
QR que vous pourriez rencontrer, notamment pour échanger du texte 
entre votre PC et votre iPhone. 

En effet, si entre un Mac et un iPhone il existe le partage de presse-papiers, 
celui n'est pas possible sur un PC fonctionnant avec Windows. 
Pourtant une solution existe et elle est aussi simple qu'utiliser un code QR. 

Le raccourci pour numériser un code est très simple et n'utilise 
que trois actions:

1. La lecture d'un code QR avec « numériser le code-barres ou QR » ;
2. « obtenir le texte de l'entrée » converti le résultat au format texte ;
3. Et « coup d'œil » pour afficher le résultat et éventuellement le partager.

{% include post_image.html 
    src='https://raw.githubusercontent.com/automatisez/iOS-workflow/master/shortcuts-app/read/scan-code.jpeg' 
    alt="Contenu du raccourci « scan code »" %}

En enchaînant ces trois étapes vous avez un raccourci capable de lire
un code-barre ou un code QR, de vous afficher son contenu et vous permet 
ensuite d'en faire ce que vous voulez à l'aide d'une feuille de partage.

Ce raccourci est un bon moyen pour décoder rapidement 
Les différents codes que vous trouverez sur des documents comme 
un avis d'imposition ou des factures.

Mais c'est surtout un bon moyen pour transmettre de courts textes 
entre d'un ordinateur vers un iPhone ou un iPad. 

Pour cela vous devez convertir le texte à envoyer sur l'iPhone à l'aide d'un 
outil capable de créer un code QR à partir de texte. 
Il existe de nombreux sites, comme 
[qr-code-generator.com](https://www.qr-code-generator.com/). 

Il existe aussi des extensions pour votre navigateur internet, 
comme par exemple pour 
[Firefox](https://addons.mozilla.org/fr/firefox/search/?q=Qr%20code)

Affichez le code sur l'ordinateur, numérisez le avec votre raccourci, 
et voilà un petit raccourci très simple qui saura, je l'espère, 
se rendre utile au quotidien.

