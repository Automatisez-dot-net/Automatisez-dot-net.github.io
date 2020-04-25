---
layout: post
title: Règles de Mail et scripts de traitement automatique
date: 2020-04-25 00:00:00 +02:00
logo: js-jxa
attachments: 
  - name: "telecharger-les-liens-pdf.applescript (2Ko)"
    path: "scripts/telecharger-les-liens-pdf.applescript"
  - name: "telecharger-les-liens-pdf-avec-curl.applescript (2Ko)"
    path: "scripts/telecharger-les-liens-pdf-avec-curl.applescript"
---

Vous connaissez probablement les règles de traitement automatique des emails
dans _Mail_ sur macOS.<br>
Mais savez-vous que ces règles vous permettent d’appliquer un script pour
traiter ces messages ?<br>
Dans ce tuto, je vais vous montrer comment écrire un tel script et ainsi 
développer vos super-pouvoirs d’automatisation.

Celui que nous allons réaliser ensemble va chercher dans un message
s’il contient une URL pointant vers un document PDF. 

Chaque document identifié sera téléchargé automatiquement en utilisant _Safari_.

Pour ce tutoriel, nous allons procéder par petits pas :

1. Nous allons commencer par créer un squelette pour notre script.
   Il ne fera rien de spécial, mais servira de point de départ pour la suite.
2. À partir de là nous pourrons ajouter une nouvelle règle de filtrage dans _Mail_ 
   pour exécuter ce nouveau script.
3. La mécanique est en place. Il reste à finir le script dont le but
   sera :
   - d’identifier les liens vers des documents PDF dans le corps du courriel ;
   - de télécharger les documents pointés par ces liens.
4. Pour conclure, nous verrons comment ajuster notre règle de tri pour
   archiver le message une fois le traitement effectué.

| **Applications utilisées :** | _Mail_, _Safari_ |
| **Langage :** | JavaScript |
| **Connaissance utile :** | Expressions régulières |
| **Améliorations :** | _Terminal_, curl |


### Créer le script de traitement


Vous devez créer un nouveau script puis l’enregistrer dans le dossier utilisé par 
_Mail_ :

1. ouvrez l’application «_Éditeur de Script_» ;
2. créez un nouveau script avec le menu « fichiers/nouveau » ou
   le raccourci `⌘`+`N` au clavier ;
3. assurez-vous que le script sera en _JavaScript_ et pas en _AppleScript_ :
   dans l’éditeur, sélectionnez le langage _JavaScript_ ;
4. vous devez maintenant enregistrer le script dans le dossier ou _Mail_
   ira le chercher : « _~/Bibliothèque/Application Scripts/com.apple.mail_ ».
   - sélectionnez l’élément de menu « _fichier/enregistrer…_ » (`⌘`+`S`au clavier) ;
   - vérifier que le format de fichier est bien « _script_ » ;
   - donnez un nom significatif comme « _telecharger-les-liens-de-pdf_ »
     (l’extension «_scpt_» sera ajoutée automatiquement).

Créez un nouveau script dans l’_Éditeur de Script_.

{% include post_image.html 
    src='/img/screenshots/2020/04-mail-filter-script/01-nouveau-script.png' 
    alt="Éditeur de Script, menu «fichier / nouveau»." %}

Assurez-vous que le script utilise le langage de programmation _JavaScript_.

{% include post_image.html 
    src='/img/screenshots/2020/04-mail-filter-script/02-language-de-script.png' 
    alt="Éditeur de Script, sous la barre d'outils, sélectionnez JavaScript dans la liste des langues (première option)" %}

> **Astuce** :
> 
> Pour afficher ce dossier dans le dialogue d’enregistrement de fichier, 
> vous pouvez utiliser le raccourci clavier `⇧`+`⌘`+`G`.
> C’est le même que pour l’élément de menu « aller/aller au dossier… » 
> dans le _Finder_.
>
> Entrez le chemin
> « _~/Bibliothèque/Application Scripts/com.apple.mail_ ».

Enregistrez le script dans le [dossier utilisé par _Mail_][aideMailDossierScripts] 
au format « script ».

{% include post_image.html 
    src='/img/screenshots/2020/04-mail-filter-script/03-enregistrer.png' 
    alt="Dialogue d'enregistrement dans l'éditeur de script, le bon dossier est sélectionné en destination et le format est bien «script»." %}

Il ne reste plus qu’à écrire le squelette de notre script :

{% highlight js %}
// Point d'entrée du script appelé par Mail
//
function performMailActionWithMessages(messageList) {
}
{% endhighlight %}

Pour l’instant, ce script ne fait rien.

Il définit une fonction nommée `performMailActionWithMessages()` 
qui sera appelée par _Mail_ pendant l’exécution de la règle de tri.

Nous avons maintenant un début de programme minimaliste, ce qui va nous permettre de 
configurer l’application _Mail_ pour qu’elle l’exécute avec une règle
de tri des messages.


### Configurer une règle pour exécuter ce script


Ouvrez les préférences de l’application _Mail_, puis l’onglet « règles ».

{% include post_image.html 
    src='/img/screenshots/2020/04-mail-filter-script/04-regles-de-mail.png' 
    alt="Dans Mail, l'onglet «règles» dans la fenêtre des préférences." %}

Pour ajouter une règle, vous devez cliquer sur le bouton « ajouter une règle » :

1. Donnez une description explicite comme 
   « _Archiver les PDF liés automatiquement_ ».
2. Renseignez les critères utilisés pour identifier les messages.
   Pour l’exemple, je vais vérifier l’expéditeur et le sujet du message.
   Seuls ceux ayant la mention « _exemple lien pdf_ » dans leur sujet
   seront retenus.
3. Pour les messages qui correspondent, vous devez définir au moins
   une action « _exécuter AppleScript_ » et sélectionnez le script que vous
   venez juste de créer dans la liste.

{% include post_image.html 
    src='/img/screenshots/2020/04-mail-filter-script/05-nouvelle-regle.png' 
    alt="Dans les préférences de Mail, la feuille d'édition d'une règle." %}

Pour vous assurer que la règle est bien exécutée, j’ajoute une opération 
« marquer d’un drapeau ».

> **Important**
>
> Les règles sont utilisées dans l’ordre. Pensez-y si votre règle ne 
> semble pas être exécutée correctement.
> Vous trouverez plus d’informations sur [le site d’Apple][aideMailRegles].


### Finaliser le script


Les pièces du puzzle sont alignées sur la ligne de départ, 
mais notre script ne fait rien. Le feignant.

Nous devons donc remplir les trous et lui donner un peu de travail.

Nous allons définir trois fonctions :

- `performMailActionWithMessages()` est la fonction principale 
  du script. C’est elle que _Mail_ s’attend à trouver.
  Elle est bien définie, mais il est temps de lui ajouter un peu de code
  entre ses accolades.
- `computeAllMatches()` permet d’utiliser une expression régulière pour
  identifier les URL des fichiers à télécharger. 
  Je n’en dis pas plus, un peu de patience.
- `downloadFileAt()` réalise le téléchargement du contenu d’une URL.
  Vous verrez que ce n’est pas grand-chose, mais regrouper cette partie dans
  un emplacement spécifique va nous faciliter la vie quand il faudra nous adapter
  à d’autres scénarios (spoil ! on va finir par écrire deux versions
  de ce petit script).


#### `performMailActionWithMessages()`


{% highlight js %}
// Point d'entrée: la fonction appelée par la règle au lancement du script
//
function performMailActionWithMessages(messageList) {
  // Garde une référence sur l'application courante (Mail)
  let app = Application.currentApplication();
  app.includeStandardAdditions = true;
  
  // Expression régulière pour les documents PDF
  let urlRE = /https?:\/\/[^\s]+\.pdf/g;

  // Liste des URLs identifiés dans la liste de messages
  let foundURL = [];

  // Cherche une URL désignant un PDF dans le texte du message
  messageList.forEach((message) => {
    // Récupère le contenu sous forme de text enrichi
    // et cherche toutes les correspondance avec l'expression régulière
    let matches = computeAllMatches(message.content(), urlRE);
    
    matches.forEach((result) => {
      let url = result[0];
      foundURL.push(url);
      
      downloadFileAt(url);
    });
  });
  
  // Les téléchargements sont lancés, affiche un message avec la liste des message
  if ( foundURL.length > 0 ) {
    app.displayDialog(`PDF identifiés:\n— ` + foundURL.join(' ;\n— '), { 
      buttons: [ "OK" ],
      defaultButton: 1,
      withIcon: "note",
      givingUpAfter: 15
    });
  }
  else {
    // Si aucun lien vers un PDF n'a été trouvé, affiche un message
    app.displayDialog(`Aucun PDF identifié.`, { 
      buttons: [ "OK" ],
      defaultButton: 1,
      withIcon: "note",
      givingUpAfter: 15
    });
  }
}
{% endhighlight %}


Cette fonction commence par définir quelques 
variables qui seront utiles plus loin :

- `app` référence l’application courante, c’est-à-dire _Mail_.
- `urlRE` est une [expression régulière][regex] pour retrouver les URL
  qui désignent un fichier PDF.

> Si vous ne connaissez pas les expressions régulières, sachez que c’est une des pierres d’infinité de l’automatisation. 
> Je vous renvoie à ma [courte présentation][articleREgExp] de cet outil incontournable.

Votre œil averti aura certainement remarqué que j’assigne la valeur `true` à 
la propriété `includeStandardAdditions`.
C’est le moyen qui nous ouvre les portes aux extensions standard _AppleScript_,
à travers l’objet qui représente cette application.

L’expression régulière est assez simple, même si elle semble plutôt revêche. 
Comme le montre le diagramme ci-dessous, elle identifie ce qui commence par
« http:// » ou « https:// », suivi de tout ce qui n’est pas un espace, jusqu’à 
trouver l’extension de fichier « .pdf ». 


Ce n’est pas la plus rigoureuse, pour une URL, mais elle devrait faire le boulot.
Si vous êtes curieux, la question a déjà été posée sur 
[StackOverflow](https://stackoverflow.com/questions/161738/what-is-the-best-regular-expression-to-check-if-a-string-is-a-valid-url),
mais vous trouverez beaucoup de réponses à cette question, y compris 
[un site entier](https://urlregex.com) dédié à la cause.

Fin de digression.

`/https?:\/\/[^\s]+\.pdf/`

{% include img_svg.html 
    svgSrc="/img/screenshots/2020/04-mail-filter-script/regexp-url.svg" 
    imgSrc="/img/screenshots/2020/04-mail-filter-script/regexp-url.png" 
    alt="visualisation graphique de l'expression régulière" %}


Après ces préliminaires il est temps de détailler plus avant
les rouages internes de notre fonction :

1. Elle reçoit un paramètre `messageList` qui est le tableau des messages 
   identifiés par la règle.
2. Pour chacun des messages de cette liste, on en récupère le contenu avec
   `message.content()`.
3. C’est le moment de faire entrer en scène notre expression régulière 
   `urlRE` pour retrouver tous les liens vers des PDF dans le corps du texte.
   Le résultat sera un tableau de tableaux.
4. Il ne reste plus qu’à parcourir la liste des correspondances trouvées
   pour appeler la fonction de téléchargement `downloadFileAt()`.
5. À la toute fin on affichera un dialogue temporaire pour rendre compte à
   l’utilisateur.

Pour appliquer l’expression régulière sur le contenu du message je vais
utiliser une fonction `computeAllMatches()`, et il est grand temps d’en parler plus en détail.


#### `computeAllMatches()`


Pourquoi introduire cette fonction ?

Après tout, on devrait pouvoir simplement utiliser [`matchAll()`][matchAll] sur le contenu.

Eh bien oui… et non. Parce que `matchAll()` n’existe pas avant
macOS 10.15 Catalina. 

Pour faire court, cette fonction va appeler `matchAll()`, lorsqu’elle est disponible.
Dans le cas contraire, elle fera une pirouette pour proposer
une solution alternative, légèrement moins performante.

{% highlight js %}
// Construit un tableau avec toutes les correspondances
// et les groupes
//
function computeAllMatches(text, regex) {
  let allMatches = [];
  
  if ( !!text.matchAll ) {
    // Catalina et plus
    allMatches = [... text.matchAll(regex)];
  }
  else {
    // Avant macOS 10.15 Catalina
    while ( null !== (matches = regex.exec(text)) ) {
      allMatches.push(matches);
    }
  }
  
  return allMatches;
}
{% endhighlight %}


> Étant donné que mon Mac est sous Catalina, je n’avais pas du tout
> anticipé ce petit souci. Mais Arnaud F., qui m’a plus qu’inspiré le sujet 
> de cet article, m’a aidé à comprendre pourquoi rien ne marchait chez lui.
> Une bonne séance de debug à distance (merci _Messages_ !) m’aura
> aidé à pointer le problème du doigt.


#### `downloadFileAt()`


Dernier, mais indispensable, volet de cette trilogie de fonctions, 
celle-ci est responsable de déclencher le téléchargement du fichier.

{% highlight js %}
// Utilise Safari pour télécharger le fichier à l'URL indiquée
//
function downloadFileAt(url) {
  let safariApp = Application("Safari");
  safariApp.includeStandardAdditions = true;

  safariApp.activate();
  safariApp.openLocation(url);
}
{% endhighlight %}

Le fonctionnement est assez simple :

1. Elle récupère une référence sur l’application _Safari_.
2. Cette dernière est activée.
3. On lui demande d’ouvrir l’URL passée en paramètre.


### L’épreuve du feu


Vous devez avoir un message dans votre boite de réception qui correspond
aux critères de votre filtre. Envoyez-vous un courriel, avec un lien vers un
PDF, comme celui-ci :

```
Un exemple de mail avec un lien vers un PDF.

http://www.automatisez.net/downloads/livre/Automatisez-sous-Mac-extrait.pdf
```

Pensez bien à ajouter « _exemple lien pdf_ » dans le sujet pour que le message
soit identifié par la règle.

Vous allez recevoir votre email et la règle devrait se déclencher.
Le drapeau va apparaitre sur le message puis _Safari_ ouvrira le PDF.
Enfin, un dialogue vous indiquera qu’un lien a été trouvé dans le message.

Inutile de vous renvoyer un nouvel email à chaque fois.

Vous pouvez rejouer l’évaluation des règles sur le message sélectionné
en cliquant sur l’élément de menu « messages/appliquer les règles »
(`⌥` + `⌘` + `L` avec le raccourci clavier).


### Un cran plus loin


Ce script n’est pas parfait et il ne correspond certainement pas à tous 
les cas de figure.

Le téléchargement des fichiers PDF utilise _Safari_, qui peut ne pas télécharger 
le fichier, mais se contenter de l’ouvrir.
Vous pourriez donc améliorer le script en utilisant un logiciel dédié au 
téléchargement.

Nous allons modifier le script en remplaçant _Safari_ par
l’outil [_curl_][curl]. Et le fichier sera téléchargé dans votre dossier 
de téléchargement standard.

#### `performMailActionWithMessages()`

##### Modification de l’expression régulière

Il faut ajuster notre expression régulière pour extraire aussi le nom 
du fichier. Changez la déclaration comme suit :

{% highlight js %}
let urlRE = /https?:\/\/[^\s]+\/([^\/\s]+\.pdf)/g;
{% endhighlight %}

Inutile de vous obliger à jouer aux 7 différences. 
Le petit ajout se trouve dans la définition d’un groupe encadré par `(` et `)`. 
La correspondance pour le contenu de ce groupe sera disponible dans
les résultats renvoyés par `computeAllMatches()`.

{% include img_svg.html 
    svgSrc="/img/screenshots/2020/04-mail-filter-script/regexp-url-group-name.svg" 
    imgSrc="/img/screenshots/2020/04-mail-filter-script/regexp-url-group-name.png" 
    alt="visualisation graphique de l'expression régulière avec un groupe." %}

Si l’on reprend l’exemple de message que je vous ai donné comme test, le résultat
devrait être le suivant :

{% highlight js %}
[
  [ 
    "http://www.automatisez.net/downloads/livre/Automatisez-sous-Mac-extrait.pdf",
    "Automatisez-sous-Mac-extrait.pdf" 
  ]
]
{% endhighlight %}

- l’objet de plus haut niveau est un tableau de résultat.
- Chaque résultat est lui même un autre tableau dont les valeurs sont :
  - à la position 0 : la totalité du texte en correspondance avec l’expression
    régulière.
  - à partir de la position 1 : le texte en correspondance pour chaque groupe
    défini dans l’expression régulière. Ici, c’est le nom du fichier.


##### Savoir où télécharger


On doit déclarer une variable pour y stocker le 
chemin du dossier de téléchargement de l’utilisateur.

Ajoutez cette ligne juste après la déclaration de l'expression régulière.

{% highlight js %}
var downloadsFolder = app.pathTo("downloads folder", {as: "alias"}).toString();
{% endhighlight %}

La fonction `pathTo()` va retourner un _alias_ et on en récupère le chemin
de fichier complet pour Unix (le chemin POSIX) avec la fonction `toString()`.


##### On récupère le nom du fichier pour le téléchargement

Il faut ensuite modifier la partie relative au traitement des résultats 
pour obtenir le nom du fichier.

{% highlight js %}
// Pour chaque correspondance d'URL…
matches.forEach((result) => {
  // Le premier élément contient la totalité du texte
  // qui correspond à l'expression régulière, c'est à dire l'URL.
  let url  = result[0];
  // Les éléments suivant correspondent aux correspondances de groupes
  // Ici c'est donc le nom du fichier.
  let name = result[1]; 
  foundURL.push(url);

  downloadFileAt(url, downloadsFolder, name);
});
{% endhighlight %}

Notre fonction de téléchargement ne prend plus un, mais trois paramètres :

- l’_`url`_ du fichier à télécharger ;
- _`downloadsFolder`_ pour le chemin du dossier de téléchargements ;
- _`name`_ pour le nom du fichier.

Nous pouvons maintenant modifier cette fonction de téléchargement pour 
utiliser l’outil _[curl][curl]_ avec _Terminal_.


#### `downloadFileAt()` avec _curl_


_curl_ est une commande Unix. On doit généralement ouvrir une session _Terminal_ 
pour les exécuter, mais Apple fait bien les choses et permet de lancer une
commande Unix directement en AppleScript (et JavaScript dans notre cas) :

{% highlight js %}
app.doShellScript( command );
{% endhighlight %}

Sauf que cette option ne semble pas vraiment fonctionner avec _Mail_ dans Catalina. 
Un coup d’œil rapide avec le debugger permet de constater que l'appel se heurte
à une erreur de privilèges insuffisants.

L’extension de la lutte des classes même dans nos Mac !

Pourtant, il est difficile de croire qu’Apple ait pu casser macOS.

Ce n’est en effet pas le cas. la commande `doShellScript()` ne fonctionne que
si votre application n’est pas confinée (tiens, tiens…) dans un bac à sable. 
_Éditeur de Script_ n’est pas dans un environnement protégé, alors que _Mail_
l’est, ce qui nous interdit d’utiliser cette commande pour appeler _curl_.

Nous devons donc prendre un chemin détourné et passer par _Terminal_ pour exécuter
la commande. Et cela aura un petit avantage puisqu’ainsi nous aurons un
meilleur retour visuel du déroulement des opérations.

Plus de blabla, passons au concret :

{% highlight js %}
function downloadFileAt(url, destination, filename) {
  let terminalApp = Application("Terminal");
  terminalApp.includeStandardAdditions = true;

  let commands = [
    `cd`,
    `curl "${ url }\" -o "${ destination }/${ filename }"`,
    `exit`
  ];
	
  terminalApp.activate();
  terminalApp.doScript(commands.join(" ; "));
}
{% endhighlight %}

Vous ne devriez pas avoir trop de mal à décoder cette fonction :

- on récupère une référence vers _Terminal_ et on
  lui ouvre l’accès aux extensions standard d’AppleScript ;
- on construit un tableau avec les différentes commandes à exécuter ;
- et enfin, on réveille l’application juste avant de lui demander d’exécuter
  la série de commandes.

Petite revue des détails des instructions utilisées :

{% highlight sh %}
cd
{% endhighlight %}

Change le dossier courant de la session _shell_ pour revenir dans le dossier 
personnel de l’utilisateur. 
C’est une simple précaution de paranoïaque puisque le terminal devrait 
déjà s’ouvrir avec ce dossier de travail. 

{% highlight sh %}
curl "${ url }\" -o "${ destination }/${ filename }"
{% endhighlight %}

C’est ici que tout est fait. On demande à _curl_ de récupérer le contenu 
indiqué dans la variable `url`.
L’option `-o` est suivi du chemin complet qui désigne le fichier enregistré. 
Il est composé en mettant bout à bout le chemin `destination` avec le nom `filename`.

{% highlight sh %}
exit
{% endhighlight %}

La commande `exit` porte bien son nom puisque son seul rôle est de montrer la
sortie en mettant un terme à la session de terminal.

Elle est bien close, mais la fenêtre de _Terminal_ reste ouverte. 
Vous devrez fermer celle-ci à la main, ce qui vous laisse voir si le téléchargement
s’est bien passé.


### Un dernier mot


Les deux variantes du script sont téléchargeables, sous forme de fichier texte,
avec cet article.

Vous pourrez les ouvrir avec _Éditeur de Script_ et les enregistrer au format 
script dans le dossier de _Mail_. Pensez bien à changer le langage sur 
_JavaScript_ dans l’éditeur.

J’espère, pour ma part, que cet article vous donnera envie de plus souvent 
déléguer le traitement de vos emails à votre Mac. 

Il existe beaucoup d’autres possibilités, comme enregistrer les pièces jointes
d’un message. À vous de jouer avec le vocabulaire de l’application _Mail_.


Bonne automatisation à tous.



[aideMailDossierScripts]: https://support.apple.com/fr-fr/guide/mail/mlhlp1171/13.0/mac/10.15
[aideMailRegles]: https://support.apple.com/fr-fr/guide/mail/mlhlp1017/mac
[regex]: /raccourcis/2020/04/05/introduction-aux-expressions-regulieres.html
[curl]: https://github.com/tldr-pages/tldr/blob/master/pages/common/curl.md
[matchAll]: https://developer.mozilla.org/fr/docs/Web/JavaScript/Reference/Objets_globaux/String/matchAll

[articleREgExp]: /raccourcis/2020/04/05/introduction-aux-expressions-regulieres.html