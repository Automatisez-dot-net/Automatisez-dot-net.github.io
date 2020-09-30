---
layout: post
title: L'image astronomique du jour avec un widget Scriptable
date: 2020-09-25 00:00:00 +02:00
logo: scriptable-app
attachments:
    - name: "APOD widget sur Github"
      url: https://gist.github.com/automatisez/c6f6e6725b57c410aa0633dd35b0c3ce
      description: Téléchargez la dernière mise à jour de ce script.
---

Dans le dernier billet, nous avons découvert les bases de la création 
d’un widget iOS 14 avec _Scriptable_.
Il est temps de passer sur un cas concret : afficher 
[l’image astronomique du jour][apod] sur le site de la NASA 
(_Astronomy Picture of the Day_, soit _APOD_ pour les intimes).

{% include post_image.html 
    src='/img/screenshots/2020/09-apod-widget/apod-widget-preview.jpg' 
    alt="Un widget pour afficher l'image astronomique du jour" %}

Nous allons utiliser les mêmes fonctions que dans notre exemple précédent.
Mais, cette fois-ci, nous allons devoir aller chercher une image sur internet
avant de pouvoir l’afficher dans notre widget.

En route ! Partons à l’aventure pour décrocher les étoiles.


-----


### Sommaire

- [Récupérer l’image astro du jour](#section_apod)
- [Commencez le code du widget](#section_widget)
- [Parlons un peu avec la NASA](#section_call)
- [Derniers mots](#section_end)




<div id="section_apod"></div>
### Comment télécharger l’image du jour ?




La NASA propose chaque jour une image liée au thème de l’astronomie sur une
[page dédiée][apod].

Mais les informations contenues dans cette page sont également disponibles par
une interface de programmation ([API][def_api]). 
C’est le chemin que nous allons emprunter pour alimenter notre widget.

Pour faire simple, une _interface de programmation_ web fonctionne sur le modèle
d’un dialogue entre un client et un serveur :

- le client, _c’est-à-dire notre widget_, pose une question ;
- le serveur, un ordinateur de la NASA, vous envoie une réponse.

Nous ne ferons pas plus compliqué que cela dans notre scénario.


#### Demandez (_gentiment_) l'image du jour


> Bon, j’avoue que cette première partie attaque peut-être un peu fort si vous
> n’êtes pas très technique. 
> Pas de panique, vous pourrez vous contenter d’utiliser le script fini. 
> Mais faites un petit effort, ça en vaut la peine. ;-)

L’interface est décrite parmi de nombreuses autres sur une 
[page de la NASA][api_nasa].

Dans le contexte d’une interface de programmation, la question se pose sous la
forme d’une adresse web[^1] en utilisant une [URI][def_uri] :

```
https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY
```

Notre question se décompose en 2 parties :

- le sujet de notre question : `https://api.nasa.gov/planetary/apod`
  - `https` désigne le langage que nous allons utiliser. 
    Ici nous parlons, comme un navigateur internet, le langage _HTTP_ dans
    sa version sécurisée.
  - `api.nasa.gov` nomme la machine à laquelle on s’adresse.
  - `/planetary/apod` est la question pour obtenir l’image du jour.
- après le point d’interrogation, on ajoute des informations complémentaires 
  (_paramètres_) à notre question `api_key=DEMO_KEY` :
  - `api_key` nous identifie. C’est un peu notre numéro de carte de membre.

Il est possible d’utiliser d’autres paramètres pour compléter notre question.
Pour cela je vous renvoie à [la documentation en ligne][api_nasa].


#### La réponse en JSON


Vous rencontrerez beaucoup d’interfaces de programmation qui utilisent le
[format JSON][def_json] pour rédiger questions et réponses. 
Pour cette interface, c’est la réponse qui utilise ce format.

Pour faire court, c’est un format en texte ou on représente des objets sous la
forme d’une série de paires de noms (_clés_) et de leur _valeur_.

Voici un exemple de réponse pour APOD :

```json
{
  "copyright": "Adam Block",
  "date": "2020-09-25",
  "explanation": "The Great Spiral Galaxy in Andromeda (also known as M31)…",
  "hdurl": "https://apod.nasa.gov/apod/image/2009/m31abtpmoon.jpg",
  "media_type": "image",
  "service_version": "v1",
  "title": "Moon over Andromeda",
  "url": "https://apod.nasa.gov/apod/image/2009/m31abtpmoon1024.jpg"
}
```

Dans notre cas, nous n’allons avoir besoin que de l’URL de l’image à afficher, 
c’est-à-dire la clé `url`.


#### Obtenir une clé


Dans l’exemple ci-dessus, j’utilise la clé publique _DEMO_KEY_ pour obtenir
ma réponse.

Cette clé est publique et fortement limitée en nombre d’utilisations.
Pour avoir un widget fonctionnel, il vous faudra votre propre clé.

Il vous suffit de donner votre nom et votre email sur la [page des APIs][api_nasa]
pour obtenir une clé personnelle.
C’est totalement gratuit et vous n’aurez même pas besoin de créer un compte.

{% include post_image.html 
    src='/img/screenshots/2020/09-apod-widget/apod-widget-get-api-key_small.jpg' 
    alt="Obtenir facilement un jeton d'accès pour discuter avec la NASA ? Ca n'a pas de prix et c'est gratuit." %}




<div id="section_widget"></div>
### Commencez le code du widget



Créez un nouveau script dans _Scriptable_. 

Vous pouvez commencer par lui donner un nom « APOD widget », choisissez une 
icône, une couleur. Bref, donnez-lui un look.

Mais passons aux choses sérieuses et commençons notre script :

1. il faut créer le widget ;
2. on peut ensuite télécharger l’image du jour ;
3. on construit un affichage en fonction du contexte d’exécution ;
4. le script doit indiquer qu’il a fini son travail.

```js
// on crée le widget, puis on chargera la photo
let widget = createWidget();
await loadPhoto(widget);

if (config.runsInWidget) {
  // quand on est un widget, on associe le widget
  // au script
  Script.setWidget(widget);
} else {
  // sinon on se contente d'afficher le résultat
  // dans Scriptable
  widget.presentSmall();
}

Script.complete();
```

La fonction `createWidget()` ne fait pas grand-chose de plus que créer une
instance d’un `ListWidget`.
Elle définit les espacements appliqués dans ce widget.

```js
function createWidget() {
  let w = new ListWidget();

  w.spacing = 0;
  w.setPadding(0, 0, 0, 0);

  return w;
}
```

Il ne reste plus qu’à écrire la fonction `loadPhoto()` :


```js
async function loadPhoto(widget) { 
  // à suivre...
}
```

Il semblerait donc que ce soit le moment de se lancer et d’ouvrir un canal de
communication avec la NASA pour récupérer notre photo.




<div id="section_call"></div>
### Parlons un peu avec la NASA



#### Préparez-vous à prendre la parole ?

Le serveur est à l’écoute de ses (très) nombreux clients.
Avant de lui parler directement, il est indispensable de préparer le terrain. 
Dans notre cas, cela se traduit par la préparation de notre requête.

Cette requête est créée à partir de l’URI de la question : 
celle que nous avons décortiquée dans la
première section de cet article.

```js
async function loadPhoto(widget) {
    let requestURI = `${apiURL}?api_key=${apiKey}`;
  
    let request = new Request(requestURI);
}
```

Vous aurez peut-être remarqué que nous utilisons deux variables :

- `apiURI` doit contenir l’adresse de base pour notre question ;
- `apiKey` contient votre clé personnelle pour l’accès à l’API de la NASA.

Une bonne pratique est de définir ces valeurs au début de votre script.
Elles seront plus faciles à trouver et à modifier en cas de besoin.

```js
let apiURL = "https://api.nasa.gov/planetary/apod";
let apiKey = "DEMO_KEY";
```


#### Posez votre question !


Pour obtenir l’image du jour, nous devons procéder en deux étapes :

1. Demander les informations sur l’image du jour : 
   c’est la réponse en JSON à la question définie par l’API.
   L’image n’est pas directement dans cette réponse, mais vous y trouverez 
   son adresse, indiquée dans la propriété _url_.
3. Avec l’adresse de l’image en main vous pouvez poser votre seconde question
   pour obtenir l’image à partir de son adresse.

Vous attendez une réponse au format JSON, donc demandez ce JSON à travers
votre requête :

```js
let json = await request.loadJSON();
```

> Les opérations réseau pouvant être longues, la fonction `loadJSON()` ne retourne pas directement la réponse.
> C’est une _promesse_ de réponse qui est renvoyée.
> Pour simplifier le script, j’utilise ici le mot clé `await` qui va attendre que cette promesse soit tenue et que le JSON soit disponible.

L’adresse de l’image est dans la propriété _url_ du JSON. 
Il faut utiliser cette valeur pour charger l’image, là encore en passant par
une requête et la fonction `loadImage()` :

```js
let imgRequest = new Request(json.url);
let img = await imgRequest.loadImage();
```

Oui, `loadImage()` renvoie aussi la promesse d’une image et j’utilise à nouveau 
`await` pour attendre que la promesse soit tenue.

Une fois l’image obtenue on peut l’insérer dans le widget.

Attention, il existe bien une fonction `addImage()` sur le widget, mais dans ce 
cas l’image n’occupera pas tout l’espace et sera entourée d’une marge.

Comme nous voulons une image qui remplisse entièrement l’espace du widget, la
solution est de l’utiliser comme image de fond.
Nous allons également associer l’adresse du site [APOD][apod],
une adresse définie comme une variable.

Avoir une URL associée au widget permettra de l’ouvrir lorsqu’on touche 
le widget.


```js
widget.backgroundImage = img;
widget.url = apodNavURL;
```

Il ne reste plus qu’à gérer au minimum les cas où nous n’avons pas une bonne 
réponse pour compléter la fonction :

```js
async function loadPhoto(widget) {
  let requestURI = `${apiURL}?api_key=${apiKey}`;
  
  let request = new Request(requestURI);
  let json = await request.loadJSON();
  
  if ( json && json.url ) {
    let imgRequest = new Request(json.url);
    let img = await imgRequest.loadImage();
  
    widget.backgroundImage = img;
    widget.url = apodNavURL;
  } else if ( json && json.error && json.error.message ) {
    widget.addText(json.error.message);
  } else {
    widget.addText("Erreur. Pas de réponse.")
  }
}
```


#### Mise en place


Votre script est prêt et il est temps d’ajouter le widget sur votre écran.

Au moment de la configuration, vous devez :

1. choisir votre script ;
2. indiquer qu’une interaction avec le widget ouvrira l’URL associée.

{% include post_image.html 
    src='/img/screenshots/2020/09-apod-widget/apod-widget-config.jpg' 
    alt="Configurer votre widget en donnant son nom et l'action à effectuer." %}

Revenez sur l’écran d’accueil et après quelques secondes votre widget devrait
être mis à jour avec la photo du jour comme papier peint.


#### Une dernière précaution


Ce n’est pas une idée brillante de coller votre jeton d’accès à une API 
directement dans un script que vous allez peut-être partager avec 
d’autres personnes.

Il existe une solution simple : le trousseau géré par l’iPhone. 

À l’aide d’un script vide, ajoutez votre clé comme ceci :

```js
Keychain.set("nasa-api-key", "VOTRE_CLE_D'ACCES");
```

Le script peut alors récupérer cette clé de façon sécurisée avec les trois lignes
suivantes :

```js
let apiKey = "DEMO_KEY";
if ( Keychain.contains('nasa-api-key') ) {
  apiKey = Keychain.get('nasa-api-key');
}
```

La clé de test est utilisée par défaut, mais si vous avez correctement
enregistré votre clé personnelle, c’est elle qui sera utilisée pour
les requêtes.




<div id="section_end"></div>
### Derniers mots




Ce script est volontairement simple et pourrait bénéficier de plusieurs
améliorations.

- Je ne vérifie pas le type de média et si l’image du jour n’est pas une image
  le script ne fonctionnera pas.
- Le chargement de l’image peut être long et donner l'impression que le widget 
  ne fonctionner pas correctement.
  Il est possible d’ajouter un petit message de chargement dans l’intervalle.
- Idéalement il faudrait utiliser les promesses et le caractère asynchrone
  de la communication pour éviter de bloquer le widget.


Le script complet, que vous pouvez aussi télécharger :

```js
// Variables used by Scriptable.
// These must be at the very top of the file. Do not edit.
// icon-color: cyan; icon-glyph: image;

// ## Configuration 
// 
// API og APOD
//
let apiURL = "https://api.nasa.gov/planetary/apod";
let apiKey = "DEMO_KEY";
if ( Keychain.contains('nasa-api-key') ) {
  apiKey = Keychain.get('nasa-api-key');
}

// Public URL
let apodNavURL = "https://apod.nasa.gov";


// ## Functions

// Basic widget creation
//
function createWidget() {
  let widget = new ListWidget();

  widget.spacing = 0;
  widget.setPadding(0, 0, 0, 0);

  return widget;
}


// Access APOD API to get image
// then update widget
//
async function loadPhoto(widget) {
  let requestURI = `${apiURL}?api_key=${apiKey}`;
  
  let request = new Request(requestURI);
  console.log(`Request: ${requestURI}`);
  let json = await request.loadJSON();
  console.log(`Response: ${JSON.stringify(json)}`);
  
  if ( json && json.url ) {
    let imgRequest = new Request(json.url);
    let img = await imgRequest.loadImage();
  
    widget.backgroundImage = img;
    widget.url = apodNavURL;
  } else if ( json && json.error && json.error.message ) {
    widget.addText(json.error.message);
  } else {
    widget.addText("Erreur. Pas de réponse.")
  }
}


// -----
 

// create widget, load image and push widget
let widget = createWidget();
await loadPhoto(widget);

// check environment to just display widget content
// when running from Scriptable app
if (config.runsInWidget) {
  Script.setWidget(widget);
} else {
  widget.presentSmall();
}

// We must notify caller that script ended
Script.complete();
```


[^1]: Il existe de nombreuses autres façons de poser une question.  Par chance, cette API utilise une des plus simples pour débuter.



[apod]: https://apod.nasa.gov/
[api_nasa]: https://api.nasa.gov

[def_api]: https://fr.wikipedia.org/wiki/Interface_de_programmation
[def_json]: https://fr.wikipedia.org/wiki/JavaScript_Object_Notation
[def_uri]: https://fr.wikipedia.org/wiki/Uniform_Resource_Identifier
