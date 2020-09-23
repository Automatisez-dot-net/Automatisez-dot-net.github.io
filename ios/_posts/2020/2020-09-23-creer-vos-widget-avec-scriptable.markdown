---
layout: post
title: Créer vos widgets avec Scriptable
date: 2020-09-23 23:00:00 +02:00
logo: scriptable-app
---

Nous allons voir ensemble comment utiliser _Scriptable_ pour construire
votre propre widget pour iOS 14. 
Il n'est pas question de vous transformer en développeur, mais plutôt de
découvrir les fonctionnalités offertes par _Scriptable_.
Un widget peut être pour vous un bon outil pour construire un mini tableau de
bord personnalisé.

_Scriptable_ s'intègre parfaitement avec iOS 14 et permet d'ajouter des widgets
à votre écran d'accueil. Mais, comme c'est surtout un outil de développement, 
ses widgets seront des pages blanches.
Vous avez la responsabilité de remplir ces pages en lui fournissant du contenu
à l'aide d'un script;

-----

### Comment ajouter un widget _Scriptable_ ?

#### Ajoutez un widget

Ajoutez un widget _Scriptable_ en suivant la même procédure que pour
[n'importe quel autre widget][help_widget]. 
Une fois le widget ajouté sur votre écran d'accueil il apparait comme
un bloc vide.

{% include post_image.html 
    src='/img/screenshots/2020/09-scriptable-widget/scriptable-widget-vide.jpg' 
    alt="Un widget Scriptable vide" %}

Votre widget restera vide tant qu'un de vos script ne lui donnera pas de 
contenu.
Pour cela vous devez configurer le widget en lui associant votre script.

#### Associez votre script à votre widget

Ouvrez _Scriptable_ et créez un nouveau script "widget simple".
Vous pouvez maintenant configurer le widget pour utiliser ce script.

Appuyez longuement sur le widget jusqu'à ce que le menu suivant s'affiche :

{% include post_image.html 
    src='/img/screenshots/2020/09-scriptable-widget/scriptable-widget-menu.jpg' 
    alt="Un widget Scriptable vide" %}

Choisissez l'option « modifier le widget » pour basculer dans la configuration.

{% include post_image.html 
    src='/img/screenshots/2020/09-scriptable-widget/scriptable-widget-conf.jpg'
    alt="Un widget Scriptable vide" %}

Touchez l'option « script » pour choisir celui qui va fournir le contenu de ce
widget. 
Pour l'instant il est vide et le widget va gentiment vous le rappeler par un
message d'erreur.

{% include post_image.html 
    src='/img/screenshots/2020/09-scriptable-widget/scriptable-widget-noscript.jpg' 
    alt="Un widget Scriptable vide" %}

C'est tout à fait normal puisque votre script est pour l'instant totalement vide.
Nous allons maintenant préparer un contenu minimum pour ce widget.


#### Écrire un premier script

##### Un widget minimal

Comme le message d'erreur vous l'indique, votre script doit appeler la méthode
[`Script.setWidget()`][ref_set_widget]. 
Cette fonction attend un paramètre et celui-ci doit être un widget.

La class [`ListWidget`][ref_list_widget] est disponible pour créer cet objet.
Vous pouvez en construire une instance de la façon suivante :

```javascript
let widget = new ListWidget();
```

Un script très minimal pour un widget serait comme celui ci :

1. créer le widget ;
2. utiliser ce widget pour le script ;
3. indiquer que le script est fini.

```javascript
let widget = new ListWidget();
Script.setWidget(widget);
Script.complete();
```

##### Ajoutez du texte

L'objet widget vous permet d'ajouter une ligne de texte avec `addText()`.
La valeur renvoyée par cette méthode est un objet [WidgetText][ref_widget_text].

Vous pouvez modifier quelques propriétés pour cet objet comme la couleur, 
la transparence, la longeur maximale des lignes, l'alignement.

Dans le script ci-dessous nous allons modifier deux caractéristiques:

1. la police de caractères
2. l'alignement pour centrer le texte horizontalement

```javascript
let text = widget.addText("Hello !");
let font = Font.blackRoundedSystemFont(24);
text.centerAlignText();
text.font = font;
```
Votre widget devrait présenter maintenant votre message :

{% include post_image.html 
    src='/img/screenshots/2020/09-scriptable-widget/widget-text-only.jpg' 
    alt="Un widget avec uniquement du texte et un fond uni" %}


##### Décorez avec un dégradé de couleurs

Si nous laissons notre widget dans cet état il aura un fond uni blanc, 
ou noir si vous utiliser le thème sombre.

Ajoutons donc un dégradé de couleurs.

Le dégradé est un objet [`LinearGradient`][ref_linear_gradient] :

1. créez une instance de la classe `LinearGradient` ;
2. définissez les couleurs du dégradé ;
3. définisser les positions de chaque couleur dans le dégradé:
   une valeur comprise entre 0 pour le début et 1 pour la fin ;
4. et la dernière étape consiste à utiliser ce dégradé comme fond pour le widget
   avec la propriété `backgroundGradient`.

```javascript
let bg = new LinearGradient();

bg.colors = [
  new Color("#0000aa", 1.0),
  new Color("#6666ff", 1.0)
];
bg.locations = [0, 1];

widget.backgroundGradient = bg;
```
L'aspect du widget s'affine un peu :

{% include post_image.html 
    src='/img/screenshots/2020/09-scriptable-widget/widget-gradient.jpg' 
    alt="Un widget avec uniquement du texte et un fond dégradé" %}

##### Changer la couleur du texte

En noir sur fond sombre le texte n'est pas très lisible.
Vous pouvez changer la couleur du texte avec la propriété `textColor`:

```javascript
text.textColor = Color.white();
```

Le message devient plus lisible en blanc sur le fond dégradé :

{% include post_image.html 
    src='/img/screenshots/2020/09-scriptable-widget/widget-white-text.jpg' 
    alt="Un widget avec uniquement du texte et un fond dégradé" %}

-----
### Testez plus simplement votre widget

Pour l'instant lorsque vous voulez vérifier le rendu de votre widget, 
il est nécessaire de quitter _Scriptable_ pour revenir sur l'écran d'accueil.

Vous avez une solution plus rapide.

- L'object `config` permet de connaitre votre environnement d'exécution: 
  application, widget, notification, Siri, etc.
- Le widget vous permet d'afficher un rendu lorsqu'il est exécuté dans
  le contexte de l'application. Vous avez une méthode pour chaque taille
  possible.

```javascript
if ( config.runsInWidget ) {
  // Vous êtes dans un widget, 
  // associez votre widget au script pour l'afficher
  Script.setWidget(widget);
} 
else {
  // À priori dans l'application, 
  // afficher le widget en petite taille.
  widget.presentSmall();
}

Script.complete();
``` 

Ce premier widget au complet est donc le suivant:

```javascript
// Variables used by Scriptable.
// These must be at the very top of the file. Do not edit.
// icon-color: deep-purple; icon-glyph: magic;
let widget = new ListWidget();

widget.spacing = 0;
widget.setPadding(0, 0, 0, 0);

let bg = new LinearGradient();
bg.colors = [
  new Color("#0000aa", 1.0),
  new Color("#6666ff", 1.0)
];
bg.locations = [0, 1];
widget.backgroundGradient = bg;

let text = widget.addText("Hello !");
let font = Font.blackRoundedSystemFont(24);
text.centerAlignText();
text.font = font;
text.textColor = Color.white();

// check environment to just display widget content
// when running from Scriptable app
if ( config.runsInWidget ) {
  // create and show widget
  Script.setWidget(widget);
} 
else {
  widget.presentSmall();
}

Script.complete();
```

-----
### Conclusion

Vous avez vu dans cet article les bases pour écrire un widget avec l'application
_Scriptable_.

Pour l'instant rien de bien utile, à part une fonction décorative.

Nous verrons dans un prochain article comment utiliser un service web
pour afficher une image dynamique dans un widget.



[ref_list_widget]: https://docs.scriptable.app/listwidget/
[ref_set_widget]: https://docs.scriptable.app/script/#setwidget
[ref_widget_text]: https://docs.scriptable.app/widgettext/
[ref_linear_gradient]: https://docs.scriptable.app/lineargradient/

[help_widget]: https://support.apple.com/fr-fr/HT207122
