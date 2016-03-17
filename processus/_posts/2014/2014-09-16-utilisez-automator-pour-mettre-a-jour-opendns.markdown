---
layout: post
title: "Utilisez Automator pour mettre à jour OpenDNS"
date: 2014-09-16 12:00:00
logo: openDNS
attachments:
    - name: "Processus - Notifier OpenDNS (ZIP)"
      path: processus/process-notif-_OpenDNS.zip
---

Vous utilisez peut-être OpenDNS pour contrôler votre accès internet et 
limiter les débordements de vos trop curieux enfants?

Si vous êtes chez un fournisseur d'accès qui vous propose une adresse IP fixe, 
vous n'avez pas vraiment de problème. 
En revanche, si vous avez une adresse IP dynamique, vous devez régulièrement 
notifier votre adresse à OpenDNS pour que le service puisse continuer à vous 
identifier.

Voici comment utiliser Automator pour ne pas installer l'application d'OpenDNS.

### Comment fonctionne OpenDNS ?

Ce service vous propose d'installer une petite application qui va se charger 
de mettre à jour automatiquement le service avec votre adresse IP fournie par 
votre fournisseur d'accès.

Si, comme moi, vous n'aimez pas avoir une application qui tourne en permanence 
sur votre Mac juste pour cette fonction, sachez qu'il est possible de faire 
cette mise à jour simplement en ouvrant une adresse internet spéciale. 
Cette manipulation est décrite dans 
[l'espace des développeurs](https://support.opendns.com/entries/23891440).

Pour faire court, il vous suffit d'accéder à l'URL suivante pour notifier 
OpenDNS de votre adresse IP:

```
https://updates.opendns.com/nic/update?hostname=NOM_DU_RESEAU_DYNAMIQUE
```

Safari va alors vous demander nom d'utilisateur et mot de passe pour 
s'assurer que vous êtes bien le propriétaire du réseau.

Entrez vos identifiants. Safari devrait renvoyer une page qui comprend une 
réponse: 'good' suivi de l'adresse IP publique si tout c'est bien passé.

### Comment faire cela avec Automator ?

Automator est tout à fait capable de faire cette manipulation.

Commencez par créer un processus simple.

1. Vous devez ajouter une première action «*obtenir le texte indiqué*» et 
    y renseigner l'adresse à partir du modèle indiqué ci-dessus.
2. Ajoutez maintenant une action «*afficher une page web*» pour que cette 
    URL soit ouverte avec votre navigateur. 

La première étape du processus est achevée. Vous pouvez maintenant exécuter

Votre navigateur va alors vous demander identifiant et mot de passe pour 
votre compte OpenDNS. C'est tout à fait normal.

Si vous utilisez Safari, enregistrez ces identifiants dans votre trousseau 
d'accès. Cela évitera de saisir ces identifiants à chaque exécution du processus.

Il ne reste plus qu'une étape pour finaliser notre processus:

1. Récupérez la réponse d'OpenDNS au format texte en ajoutant une action 
    «*obtenir le texte d'une page web*». 
    Précisez bien que vous voulez ce résultat au format texte.
2. Ajoutez maintenant une action «*définir la valeur de la variable*» 
    pour stocker cette réponse. 
    Nommez cette variable «*résultat*». 
    Elle va nous servir dans la dernière action.
3. Le processus va maintenant se conclure avec un affichage de notification. 
    Ajoutez l'action «*afficher la notification*» et indiquez le titre 
    de votre choix. 
    Dans le message de la notification, faites simplement glisser la 
    variable «*résultat*».

Et voilà le processus achevé.

### Pour finir

Le processus final devrait ressembler à ce qui suit:￼

{% include post_image.html 
    src='/img/screenshots/2014/09-16_process-notifier-OpenDNS.png' 
    alt="Le processus complet" %}

Comment rendre cette mise à jour automatique? 
Il existe plusieurs solutions. 
La plus simple serait de créer une alarme de calendrier avec Automator. 
Cette solution est simple et garantie que le processus sera exécuté 
régulièrement, tous les matins par exemple. 
Cela fonctionne bien avec un ordinateur fixe, mais peut être plus délicat 
avec un Mac portable.

Une solution alternative serait d'utiliser une application comme 
[Control Plane](http://www.controlplaneapp.com/about/) 
pour déclencher le processus à chaque fois que vous vous 
connectez au réseau Wifi de votre domicile.

À vous de choisir la solution qui vous correspond le mieux.

En attendant, téléchargez le processus attaché à cet article. 
Pensez à bien indiquer le nom de votre réseau dynamique dans
