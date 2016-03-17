---
layout: post
title: "Verrouillez facilement votre session"
date: 2014-05-04 12:00:00
logo: macOSX
---

Je vous propose d’implémenter un service très simple pour verrouiller votre 
session avec un simple raccourci clavier.

Vous me direz que l’activation de l’économiseur d’écran produira le même effet 
en protégeant l’accès à votre ordinateur avec un mot de passe, à condition 
d’avoir activé cette option dans les préférences de sécurité.

Non, je vous propose de mettre en place un service pour revenir sur l’écran 
d’ouverture de session.

Nous allons procéder en deux temps :

1. Commençons par créer le processus.
2. Il faudra ensuite créer un raccourci clavier pour invoquer facilement 
    ce processus.

Avant tout, il est important de comprendre ce que nous voulons faire. 
Vous devez avoir activé la permutation rapide d’utilisateurs dans les 
préférences Utilisateurs et Groupes.

Nous souhaitons simuler l’activation du menu «*Fenêtre d’ouverture de session*» 
dans le menu des comptes utilisateurs, comme illustré ci-dessous.
￼
{% include post_image.html 
    src='/img/screenshots/2014/05-04_LockSession_menu.png' 
    alt="Le menu des comptes utilisateurs" %}

Commencez par ouvrir Automator et créez un nouveau service. 
Ajoutez maintenant une action «*Exécuter un script Shell*».

Nous allons utiliser une commande de Terminal pour simuler l’activation du menu:

```
"/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession" -suspend
```

La commande *CGSession* est incluse dans l’application qui gère le menu de la 
permutation de compte. 
Elle se trouve dans le bundle de cet élément de la barre de menu, cachée dans 
un dossier Resources.

Si nous l’appelons avec l’option «`-suspend`», cela provoquera le retour vers 
l’écran d’ouverture de session.

Il suffit de répliquer cette commande dans notre action du processus, 
comme ci-dessous:

{% include post_image.html 
    src='/img/screenshots/2014/05-04_LockSession_processus.png' 
    alt="Le processus complet" %}
￼
Et voilà. Le processus est fini. Vous pouvez le tester immédiatement.

Il ne reste plus qu’à ajouter un raccourci clavier. 
Ouvrez l’application *Préférences* et allez dans le panneau «*Clavier*» 
dans l’onglet «*Raccourcis*». 
Sélectionnez la liste des raccourcis pour les services et cherchez votre 
nouveau service.

Il ne vous reste plus qu’à définir une combinaison de touches. 
J’utilise personnellement les touches *Majuscule*, *Contrôle*, *Alt* et 
*Commande* en simultané avec la lettre «`L`».
￼
{% include post_image.html 
    src='/img/screenshots/2014/05-04_LockSession_clavier.png' 
    alt="Création d'un raccourci clavier" %}

Et voilà, vous devriez avoir un service accessible d’une simple combinaison 
de touches.

Plus aucune excuse pour laisser votre session accessible à tous.
