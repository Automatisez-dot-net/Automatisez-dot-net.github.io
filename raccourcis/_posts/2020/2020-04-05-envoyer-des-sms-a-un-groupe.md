---
layout: post
title: Envoyer des SMS à un groupe de contacts
date: 2020-04-05 17:00:00 +02:00
logo: shortcut-app
attachments: 
  - name: SMS à un groupe (raccourcis)
    url: https://www.icloud.com/shortcuts/3ee01c9e43804cb1aafea4539e2a226d
---

_Comment envoyer des messages, ou des SMS, aux membres d’un groupe ?_
<br>
Si _Mail_ vous laisse sélectionner un groupe comme destinataire d’un email, 
vous ne trouverez rien de tel dans _Messages_.
<br>
Voilà pourquoi je me suis lancé dans l’écriture de ce tuto.
Voyons ensemble comment _Raccourcis_ peut, assez facilement, 
combler cette lacune.

### Levé de rideau

Pour créer un raccourci qui réalise l’envoi d’un message à
un groupe de contacts, nous avons besoin d’une application capable
de sélectionner un groupe et transmettre les contacts à _Raccourcis_.

Si votre iPhone sait parfaitement voir les groupes que vous définissez dans
vos différents comptes de carnet d’adresses, il ne propose rien dans _Contacts_
pour en ajouter ou les modifier.

Je vais donc devoir utiliser une application tierce pour cette tâche.
Et il se trouve que j’en ai justement écrit une pour combler ces
lacunes. C’est sans scrupules que mon raccourci s’appuie sur mon app, 
parce que souvent on n’est jamais mieux servi que par soi même.

{% capture mesGroupesDescr %}
L’application _[Mes Groupes](https://www.sylvaingamel.fr/fr/applications/mygroups/)_
vous permet de créer et d’organiser vos contacts sur votre iPhone
ou votre iPad. 

Elle propose quelques fonctions plus avancées.
L’exportation du contenu d’un groupe en fait partie. 
Ce rend possible de les utiliser dans une autre application, comme _Raccourcis_.
{% endcapture %}

{% include card-with-img.html
    url="https://www.sylvaingamel.fr/fr/applications/mygroups/"
    urlTitle="Vers le site de l'application Mes Groupes"
    imgSrc="/img/logos/mygroups-icon.png"
    img="Bannière d'application"
    content=mesGroupesDescr
     %}

<html>
    <div class="alert alert-info">
L’application <em>Mes Groupes</em> peut être téléchargée librement, 
mais le partage de groupes est une fonction payante, débloquée par 
un achat intégré.
<br>
<strong>Un <em>essai gratuit</em> est disponible.</strong>
    </div>
</html>

Je part du principe que vous avez déjà un groupe de contacts et
qu'ils ont des numéros de téléphone portable.

Le raccourci peut être installé directement à partir du lien iCloud 
donnée dans la [section téléchargement](#downloadSection) de cet article.

### Créer l'extension

Commencez par ouvrir _Raccourcis_ et ajoutez un nouvel élément en tapant 
le bouton « **+** » placé en haut en droite.

{% include post_image.html
    src="/img/2020/04/00-creation.jpg" 
    alt="Contenu du raccourci après création" %}

Étant donné que nous voulons une extension pour la feuille de partage, 
nous devons préciser le comportement de notre raccourci :

- touchez le cercle bleu avec trois points « **…** » pour afficher 
  les caractéristiques ;
- donnez-lui un nom : « SMS à un groupe » ;
- décochez l’option « **afficher dans le widget** » ;
- cochez l’option « **dans la feuille de partage** » ;
- sélectionnez de type de données « types de feuilles de partage » :
    - décochez tous les éléments ;
    - sélectionnez uniquement la ligne « **contacts** » ;

Vous pouvez également personnaliser la couleur et l’icône de votre raccourci.

{% include post_image.html 
    src="/img/2020/04/01-config.png" 
    alt="Personnalisation du raccourci comme extension acceptant des contacts." %}

{% capture setupDescr %}
Cette vidéo illustre comment créer et configurer le raccourci pour
qu’il fonctionne comme une extension dans la feuille de partage.
{% endcapture %}
{% include video.html
    src="/img/2020/04/01-config.mp4" 
    description=setupDescr %}


### Construire la liste de destinataires

Pour avoir la liste des numéros auxquels envoyer un SMS, nous allons suivre
trois étapes :

1. on récupère la liste des téléphones ;
2. on filtre les numéros mobiles ;
3. ces numéros sont stockés dans une variable dédiée.

#### Récupérer tous les numéros de téléphone

La première étape de votre raccourci doit construire la liste
des téléphones.

En effet, pour l’instant, votre raccourci accepte en entrée une liste de contacts.

Pour envoyer des messages, il faut commencer par extraire les numéros de téléphone
de cette liste :

- ajoutez l’action « **obtenir les numéros de téléphone de l’entrée** » ;
- ajoutez une action « **coup d'œil** » à la liste.

{% include post_image.html 
    src="/img/2020/04/02-liste-tel.jpg" 
    alt="L'action qui extrait les numéros de téléphone, suivie d'une action coup d'œil." %}

{% capture extractDescr %}
Cette vidéo montre comment après avoir récupéré la liste
des numéros de téléphone vous pouvez rapidement tester votre
extension avec l’application _Mes Groupes_.
{% endcapture %}
{% include video.html
    src="/img/2020/04/02-get-phones.mp4" 
    description=extractDescr %}


#### Filtrer les mobiles

Nous avons, pour l’instant, récupéré tous les numéros, sans distinction
entre les portables et les lignes fixes.

Il est nécessaire d’ajouter une série d’actions pour éliminer ceux 
qui correspondent à des fixes.
Un traitement décrit par trois étapes :

1. Pour chaque numéro des contacts :
    1. Vérifiez si le numéro correspond à un numéro mobile ;
    2. Si c’est le cas, ajoutez le à la liste 
       de destinataires.

##### Parcours de la liste initiale

Ajoutez une action « **répéter** » à votre raccourci.

Cette action permet d’appliquer une série d’actions individuellement à chacun 
des éléments d’une liste. 
Toutes les actions entre ce bloc et le bloc « **fin de la récurrence** » 
seront appliquées pour chaque élément.

Une boite d’action « **répéter avec chaque élément dans…** » sera ajoutée.
Le texte « numéros de téléphone », affiché sur fond bleu, correspond au
résultat de l’étape précédente « **obtenir les numéros de téléphone** ».

Vous pouvez vérifier que ces numéros seront traités comme des numéros de 
téléphone en touchant le nom de la variable « numéros de téléphone »

{% include post_image.html 
    src="/img/2020/04/03-boucle-tel.png" 
    alt="L’action après l’ajout une boucle sur les téléphones." %}



Nous pouvons maintenant construire notre filtre, appliqué à chaque numéro 
de téléphone, pour ne conserver que les numéros mobiles.


##### Filtrage

Le filtrage est probablement la partie la plus technique de ce raccourci.

Il se limite à une seule action, mais celle-ci utilise un outil particulièrement
utile et relativement simple à comprendre avec un minimum d'effort.

Je parle des _[expressions régulières][regexp]_. 
Une technique capable d'identifier des motifs spécifiques dans une suite 
de caractères.


Avant d’en arriver à ce stade, nous allons devoir ajouter une action
dans la boucle « **répéter avec chaque élément dans…** » :

1. cherchez l’action « **correspondre au texte** » ;
2. une fois dans la liste, l’intitulé de l’action sera
   « **faire correspondre… dans _élément de répétition_** » ;
3. il ne vous reste plus qu’à saisir l’expression régulière dans
   après « ****faire correspondre…** ».


Voici l’expression régulière à saisir pour identifier un
numéro mobile français :

  ```^(\+33\s)?0?[67][0-9.\s]+```

> Je vous ai écrit un [petit article bonus][articleBonus]
> pour vous expliquer comment comprendre cette expression et
> l’adapter à vos besoins.


{% include post_image.html 
    src="/img/2020/04/04-regex.png" 
    alt="L'action pour comparer un texte à une expression régulière." %}


Comme cet article ne porte pas sur les expressions régulières, je ne vais pas 
détailler ici comment comprendre ou modifier celle-ci. Je vous renvoie à
[l'article][articleBonus] qui lui est consacré.



##### Le résultat

À ce stade, notre raccourci effectue les étapes suivantes :

1. Il récupère une liste de fiches contact en entrée et en extrait la liste
   des numéros téléphoniques.
2. Pour chaque numéro de cette liste, il vérifie s’il correspond à un numéro
   de portable.

Il nous faut maintenant ajouter les numéros mobiles à la liste des résultats.

Cela se fait facilement en ajoutant une action « **ajouter à une variable** ».

Mais avant cela, vérifiez que l’expression régulière a identifié une
correspondance avec le numéro de téléphone.

Ajoutez donc une action « **si** ». Trois nouveaux blocs sont alors ajoutés 
à votre raccourci :

- Un bloc « **si** » pour définir la condition. Les actions entre ce bloc et le
  bloc « **sinon** » qui suit seront exécutées si la condition est vraie.
- Un bloc « **sinon** » : les actions entre ce bloc et le bloc 
  « **terminer si** » seront exécutées si la condition est fausse.

{% include post_image.html 
    src="/img/2020/04/05-bloc-si-sinon.png" 
    alt="L'ajout d'un bloc si, alors, sinon, fin-si au raccourci." %}


Il faut maintenant définir la condition qui permet d’identifier un numéro
mobile :

- par défaut, la condition va s’appliquer sur le résultat de l’évaluation de
  l’expression régulière : « _correspondance_ ».
- vérifiez que les correspondances ne sont pas vides :
  

{% capture checkMatchDescr %}
Cette courte vidéo montre comment définir la condition
qui vérifie si l’expression régulière a identifié une correspondance.
{% endcapture %}
{% include video.html
    src="/img/2020/04/03-check-match.mp4" 
    description=checkMatchDescr %}


Il ne reste plus qu’à ajouter le numéro de téléphone qui correspond à
l’expression régulière dans notre liste de destinataires :

- ajouter l’action « **ajouter à une variable** » dans le bloc « **si** » ;
- donner le nom « _mobiles_ » à la variable.

{% capture buildListDescr %}
La vidéo ci-contre montre l’ajout de l’action qui construit la liste des
numéros mobiles identifiés par le test de correspondance.
{% endcapture %}
{% include video.html
    src="/img/2020/04/04-build-list.mp4" 
    description=buildListDescr %}

Et voilà, nous en avons fini pour l’essentiel. 

Ajoutez une action « **coup d’œil** » à la fin du raccourci pour tester 
le résultat. La valeur à afficher doit être la variable « _mobiles_ ».

**Pour tester :**

- Ouvrez l’application _Mes Groupes_. Dans la liste de vos groupes, faites glisser
le doigt de la gauche vers la droite pour afficher les actions disponibles.
- Sélectionnez l’élément « **partager** » pour afficher la feuille de partage.
- Vous devrez probablement faire défiler la liste des raccourcis pour trouver 
  votre nouveau « _SMS à un groupe_ ».
- Tapez sur ce raccourci pour le lancer. Après de courtes secondes, la liste des
  téléphones devrait s’afficher dans une vue _coup d’œil_.


### Envoyez les messages

Et voilà, nous sommes dans la dernière ligne droite pour finaliser notre 
nouveau raccourci.

Il ne reste plus qu'à envoyer un message à notre liste de téléphones mobiles, 
ce qui devrait se concrétiser en deux étapes :

1. saisir le message ;
2. réaliser l’envoi.

#### Saisir le message à envoyer

Ajoutez maintenant une action « **demander une entrée** » au raccourci.

Le bloc qui s’insère à la fin de votre raccourci vous permet de définir 
une question et le type d’entrée que l’utilisateur doit saisir :

- le titre : « _Quel message envoyer ?_ » ;
- touchez « _en afficher plus_ » pour avoir les options supplémentaires ;
- le type d’entrée : « _texte_ » ;
- vous pouvez éventuellement indiquer une réponse par défaut, mais dans le cas
  d’un message ça n’a pas beaucoup d’intérêt.

Voilà, l’utilisateur du raccourci peut rentrer le message à envoyer.

{% include post_image.html 
    src="/img/2020/04/06-enter-msg.png" 
    alt="La configuration de l'action pour entrer un message." %}


#### Expédition du message

L’envoi va se faire pour chaque numéro de téléphone, un par un.

Nous avons donc à nouveau besoin d’une action 
« **répéter pour chaque élément** ».

Il est nécessaire d’indiquer que la répétition s’applique sur les éléments
de notre liste « _Mobiles_ » des destinataires :

- toucher le paramètre de l’action ;
- effacer son contenu ;
- sélectionnez la bonne variable.

Et voilà, nous avons une boucle qui va nous permettre de réaliser l’envoi 
d’un message à chaque numéro présent dans notre liste.

Il ne reste plus qu’à ajouter l’action « **envoyer un message** », en prenant
bien soin de placer cette action dans le bloc de répétition.

- indiquez que le destinataire doit être l’élément de la répétition
  (il faut laisser le doigt sur la variable pour pouvoir modifier la valeur)
- dans les options, pensez à décocher « **afficher lors de l’exécution** » 
  pour gagner du temps pendant que le scénario de votre raccourci se déroule.


{% capture sendLoopDescr %}
Cette vidéo montre comment construire la boucle, la _répétition_,
qui va réaliser l'envoi du message à chaque destinataire.

Vous verrez surement que _Raccourcis_ affiche deux fois l’action
« **fin de la récurrence** ». C’est un bug de l’application.
{% endcapture %}
{% include video.html
    src="/img/2020/04/05-send-loop.mp4" 
    description=sendLoopDescr %}


Le raccourci est maintenant achevé. Il ne vous reste plus qu’à le tester avec une
petite liste de destinataires.


### Bilan


Dans ce tutoriel, nous avons vu :

- comment extraire une information spécifique d’une liste de contacts ;
- comment filtrer des éléments textuels en s’appuyant sur l’utilisation
  d’un [_expression régulière_][regexp] ;
- comment construire une liste avec un bloc de _répétition_ ;
- comment envoyer un SMS, ou un message, avec _Raccourcis_.

Je n’ai pas détaillé comment fonctionne l’[_expression régulière_][regexp].
Si vous voulez plus de détails je vous renvoie à 
l’[article complémentaire][articleBonus] qui lui est dédié.

Vous voilà maintenant capable d’envoyer un SMS à un de vos groupes de contacts.
Dans cet exemple, j’ai utilisé _Messages_, mais il est d’adapter ce raccourci
pour utiliser une autre application de messagerie.
La seule condition est qu’elle propose un action _paramétrable_ qui
d’intègre à _Raccourcis_.

-----

**Mises à jour**

- clarification de la partie concernant le filtrage.

[regexp]: https://fr.wikipedia.org/w/index.php?title=Expression_régulière
[regExper]: https://regexper.com/
[visualRegEx]: https://regexper.com/#%5E%28%5C%2B33%5Cs%29%3F0%3F%5B67%5D%5B0-9.%5Cs%5D%2B
[suissePrefixesMobiles]: https://en.wikipedia.org/wiki/Telephone_numbers_in_Switzerland
[reMobilesSuisse1]: https://regexper.com/#%5E%28%5C%2B41%5Cs%29%3F%2874%7C75%7C76%7C77%7C78%7C79%29%5B0-9.%5Cs%5D%2B
[reMobilesSuisse2]: https://regexper.com/#%5E%28%5C%2B41%5Cs%29%3F7%5B4-9%5D%5B0-9.%5Cs%5D%2B

[articleBonus]: /raccourcis/2020/04/05/introduction-aux-expressions-regulieres.html