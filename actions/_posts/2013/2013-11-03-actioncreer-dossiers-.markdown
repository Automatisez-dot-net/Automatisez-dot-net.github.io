---
layout: post
title: "Yosemite : une nouvelle action pour créer des dossiers"
date: 2013-11-03
logo: macOSX
ibooks_intro: > # Message shown next to link to iBooks Store
    Si vous voulez en découvrir un peu plus sur Automator, je vous conseille 
    la lecture de mon livre dédié au sujet.
---

Cet article va inaugurer une petite série sur les nouveautés d'Automator 
introduites dans OS X Yosemite.

Parfois Apple a des idées et décide d'ajouter de nouvelles actions à Automator. 
Voici une des nouveautés d'Automator pour OS X 10.10. 
Vous verrez que finalement cette nouveauté n'était peut être pas indispensable 
ni même une réussite.

### Une nouvelle action

Cette nouvelle action permet de créer un nouveau dossier en y intégrant la 
date du jour. Vous la trouverez avec les actions du Finder.

L’action «*Nouveau dossier daté*» se présente sous la forme d’un ensemble 
d’options plutôt nombreuses.

{% include post_image.html 
    src='/img/screenshots/2013/11-03_action-Finder-nouveau_dossier-date.png' 
    alt='Le processus au complet.' %}

Les options de l’action se divisent en cinq groupes :

1. Le **dossier de destination**. 
    C’est l’emplacement dans lequel votre dossier sera créé. 
    Notez qu’il est possible d’utiliser une variable comme valeur pour 
    cette option.
2. Le **format** à utiliser pour la date. 
    Il est réparti en quatre valeurs avec des séparateurs. 
    Chaque valeur est sélectionnée dans une liste. 
    Notez qu’il n’est pas possible d’utiliser une variable, 
    pas même pour les séparateurs. 
    Il faudra se contenter des valeurs proposées par Apple.
3. Les **options** de présentation permettent d’indiquer comment les valeurs des 
    dates doivent être présentées.
4. Le **nom du dossier** : 
    trois options pour définir le nom du dossier, 
    sa position par rapport à la date ainsi que le séparateur éventuel. 
    Remarquez qu’il n’est pas possible de laisser la valeur du nom vide. 
    L’action échouera avec une erreur. 
5. L’**action réalisée** : 
    si l’action reçoit des éléments en entrée il est possible de les copier 
    dans le nouveau dossier, de les déplacer dans ce nouveau dossier, ou plus 
    simplement ne rien faire de spécial.

Tout en bas, sous ces cinq boites d’options, l’action présente un exemple de 
résultat avec vos options.

### Pas vraiment une réussite

Visuellement, l’action n’est pas vraiment simple et ne donne pas une idée
de simplicité. Cette multitude d’options tranche avec les interfaces habituelles 
proposées par Apple. 
Les options du format ne permettent pas de voir quels séparateurs ont été 
sélectionnés. 
Si vous voulez savoir, il faut regarder l’aperçu en bas du cadre. 
Un aperçu qui prend tout son sens.

{% include post_image.html 
    src='/img/screenshots/2013/11-03_action-Finder-nouveau_dossier-select.png' 
    alt='Créer un dossier nommé à partir d\'une date' %}

Pire, si vous voulez agrandir votre éditeur de processus, 
le cadre de l’action ne laissera pas son contenu occuper l’espace libre. 
Les options restent désespérément figées à leur largeur d’origine. 
Aucune flexibilité.

{% include post_image.html 
    src='/img/screenshots/2013/11-03_action-Finder-nouveau_dossier-adapt.png' 
    alt='Le processus au complet.' %}

### On faisait comment avant ?

On peut saluer l’initiative d’Apple pour proposer une nouvelle action. 
Mais si vous trouvez celle-ci trop complexe à utiliser, je vous conseille une 
solution alternative en combinant les variables et l’action «*nouveau dossier*».

Car oui, il existait déjà une action pour créer un dossier. 
Et en plus, elle a moins de limitations puisque le nom peut ne contenir que la 
date. La nouvelle action peut donc être facilement remplacée par celle-ci :

{% include post_image.html 
    src='/img/screenshots/2013/11-03_action-Finder-nouveau_dossier.png' 
    alt='L\'action pour créer un dossier' %}


Et pour spécifier le format à utiliser pour la date, c’est aussi simple que 
le définir comme ceci :

{% include post_image.html 
    src='/img/screenshots/2013/11-03_action-Finder-nouveau_dossier-format.png' 
    alt='Définir le format de la date' %}

Notez que pour cette action aussi il est possible d’utiliser une variable 
pour définir le dossier de destination. 

Pour conclure, Yosemite apporte une nouvelle action certainement utile, 
mais qui aurait gagné à être un plus simple. 
On peut regretter que cette nouvelle action n’apporte pas une réelle nouveauté.


