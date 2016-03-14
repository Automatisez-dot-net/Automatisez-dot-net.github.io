---
layout: post
title: "Yosemite: un nouveau type de processus, les commandes dictées"
date: 2014-11-18
logo: macOSX
youtube_id: rluMEWK6Bz0
---

Yosemite met un terme aux éléments prononçables, un lointain héritage de Mac OS Classic.

C’est la fonction de dictée vocale qui les remplace et se pose ainsi en la nouvelle interface vocale de votre Mac.

Cet article fait une rapide présentation et vous montre comment utiliser ce nouveau type de processus.

### Présentation

Comme je viens de le dire, les commandes dictées permettent d’appeler un 
processus Automator lorsqu’on utilise la fonctionnalité de dictée vocale. ￼ 
Avec la dictée vocale, il est également nécessaire d’activer les commandes 
dictées dans les réglages de l’accessibilité :

1. Ouvrez l’application **Préférences Système**.
2. Allez dans le panneau «*dictée et parole*».
3. Dans l’onglet «*dictée vocale*», vous devez activer la fonction de dictée. 
   Si vous voulez pouvoir l’utiliser sans connexion internet, cocher aussi 
   l’option «*utiliser la dictée améliorée*».

Cette fonction d’OS X permet de saisir du texte sans utiliser son clavier. 
Mais avec Yosemite elle intègre aussi les commandes d’accessibilité. 
Il est donc possible d’exécuter un script, ou un processus Automator, 
simplement en prononçant une phrase prédéterminée.
￼
{% include post_image.html 
    src='/img/screenshots/2014/11-18_10.10_Type_Processus_Commande_dictee.png' 
    alt='Processus pour une commande dictée.' %}

Dans l’en-tête d’un processus de commande dictée, 
vous avez deux paramètres : 

⁃ la commande dictée est la phrase qu’il faut prononcer pour déclencher le processus. 
⁃ Une case à cocher permet d’activer ou non cette commande.

{% include youtube.html video_id=page.youtube_id %}


### Un exemple simple

Nous allons construire un simple processus pour faire une copie-écran et 
l’envoyer dans un courriel.

Commencez par créer un nouveau processus de type commande dictée. 
Dans la commande, indiquez une phrase code comme «*Mac, envoie l’écran*» 
et cochez l’option pour activer la commande.

Ajoutez l’action «*Effectuer une capture d’écran*» pour réaliser une capture. 
La capture doit être enregistrée dans un nouveau fichier.

Ajoutez maintenant à votre processus une action «*nouveau message Mail*». 
Renseignez l’adresse d’un destinataire ainsi qu’un sujet et un texte 
d’introduction.

Votre processus devrait ressembler à ce qui suit:
￼
{% include post_image.html 
    src='/img/screenshots/2014/11-18_10.10_Processus_Mac_envoie_ecran.png' 
    alt='Exemple de processus pour la commande vocale.' %}

Il ne vous reste plus qu’à tester en activant la dictée vocale 
(touche pression sur la touche « *fn*»). 
Prononcez la phrase magique «*Mac, envoie l’écran*».

Si votre Mac arrive à suivre votre prononciation, le processus devrait se 
lancer et créer un nouveau message avec la copie-écran en pièce jointe.

Voilà comment utiliser simplement les commandes dictées avec Automator et OS X 10.10 Yosemite.

[*M.à.J. le 20/11/2014*]

Pour voir comment utiliser ce processus sur votre Mac, regardez [la vidéo 
de démonstration][video].


[video]: http://youtu.be/rluMEWK6Bz0

