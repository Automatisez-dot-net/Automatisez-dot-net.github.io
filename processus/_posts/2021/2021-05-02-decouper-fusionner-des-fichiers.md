---
layout: post
title: Découper et reconstruire de gros fichiers
date: 2021-05-02 14:00:00 +02:00
logo: automator
attachments: 
  - name: "Actions rapides - decouper-fusion.zip (338Ko)"
    path: "processus/actions-rapides_decouper-fusion.zip"
---

Comment transférer plus facilement de très gros fichiers ?
Mais surtout comment les reconstruire plus tard ? 
Cet article vous propose deux actions rapides pour ce genre d’action.

- « _Fichier - découper_ » pour tronçonner vos fichiers ;
- « _Fichiers - fusion_ » pour recoller les morceaux.

Vous êtes pressé et le fonctionnement des deux processus ne vous intéresse pas ?
Téléchargez directement l’archive de ces deux processus et 
installez-les sur votre Mac.

Pour installer les actions :

1. téléchargez [l’archive](/downloads/processus/actions-rapides_decouper-fusion.zip) ;
2. décompressez-la ;
3. ouvrez chaque fichier processus. 
   _Automator_ vous propose de les installer automatiquement.

Regardez comment utiliser [l’action de découpage](#use-split)
et aussi celle de [reconstruction](#use-merge).


## Action rapide ?

Les actions rapides sont des processus qu’il est possible d’utiliser directement
en lui envoyant une donnée.

Elles sont disponibles dans le menu « Services » des applications, mais
le _Finder_ les intègre également dans les menus contextuels ou le menu des
actions associées aux fichiers.

Nous allons donc créer des actions rapides pour pouvoir y accéder directement
à partir du _Finder_.


## Comment ça marche ?

Les deux actions vont utiliser des commandes du _Terminal_.

Rien de compliqué, et surtout un excellent moyen pour profiter de ce que vous
offre déjà votre Mac.
Vous avez déjà, dans son système Unix, beaucoup
d’outils prêts à l’emploi, alors autant vous en servir !

**Le découpage**

Pour découper un fichier, vous pouvez utiliser la commande `split`.

Elle fonctionne aussi bien avec des fichiers au format texte qu’avec des fichiers
dans des formats binaires, comme les images, zip ou documents Office.

**La reconstruction**

Pour reconstruire un fichier, nous allons utiliser la commande `cat`.

Comme `split` cet outil prend en charge les fichiers au format texte ou non.

---

## Découper un fichier

### Créez votre action

Commencez par ouvrir l’application _Automator_.

Quand l’application est active, vous pouvez créer un nouveau document.
Sélectionnez l’option « action rapide ».

{% include post_image.html 
    src='/img/screenshots/apps/automator/automator-new-quick-action.png' 
    alt="Créez une action rapide en sélection l'icône en forme d'engrenage." %}

### Ses paramètres

_Automator_ ouvre une nouvelle fenêtre pour éditer votre processus.

Vous remarquerez que le haut de l’éditeur vous permet de définir les paramètres
de votre action rapide :

- le type de données traité par l’action
- l’application dans laquelle l’action est disponible
- l’image utilisée comme icône de l’action
- la couleur de cette icône

{% include post_image.html 
    src='/img/screenshots/2021/05-02/automator-split-action.png' 
    alt="Le cartouche d'en-tête du processus permet de définir les paramètres" %}

Pour notre action nous allons manipuler des fichiers, et l’action ne devrait être
disponible que dans le _Finder_ :

- sélectionnez « documents » pour le type d’éléments reçus ;
- pour l’application, sélectionnez « Finder » ;
- choisissez une icône ;
- et enfin une couleur.

### Ajout d’une action au processus

Pour utiliser la commande `split` vous allez devoir ajouter une action 
« exécuter un script Shell » à partir de la bibliothèque d’actions située sur 
la gauche de l’éditeur.

_Si la bibliothèque n’est pas affichée vous pouvez utiliser le menu
« présentation/afficher la bibliothèque »._

Dans l’action, indiquez les éléments suivants :

- Shell : « /bin/zsh »
- Données en entrée : « comme arguments »

{% include post_image.html 
    src='/img/screenshots/2021/05-02/automator-action-shell.png' 
    alt="L'action doit utiliser zsh et utiliser les paramètres pour récupérer la liste de fichiers" %}

### Découpage du fichier

Dans le contenu de l’action « exécuter un script Shell » remplacez le
script d’exemple par les lignes suivantes :

```sh
for fichier in "$@"
do
  # Ne découpe que les fichiers, ignore les dossiers
  if [[ -f "$fichier" ]]
  then
    # le début du nom de chaque fragment utilise le nom du fichier
    export part_name="${fichier}.part-"

    # la valeur qui suit le -b indique la taille 
    # de chaque tranche de fichier (5m pour 5Mo)
    # vous pouvez utiliser les unités 'k' (Ko) ou 'm' (Mo)
    split -b 5m "$fichier" "$part_name"
  fi
done
```

Le script est assez simple :

- `for… do… done` va boucler sur chaque fichier passé comme argument à l’action.
  Cette liste est disponible dans la variable `$@`.
- Pour chaque valeur de `fichier` on utiliser `if [[ … ]]; then… fi` pour
  vérifier qu’il s’agit bien d’un fichier et non d’un dossier
- Le modèle de nom des fragments est construit à partir du nom de fichier
  en ajoutant `.part-`. On le stocke dans la variable `part_name`.
- On exécute enfin la commande `split` avec les paramètres suivants :
  - `-b 5m` indique qu’on veut une taille maximum pour chaque fragment de 5Mo.
  - `"$fichier"` le nom du fichier à découper
  - `"$part_name"` pour préciser le début des noms de fragment

Vous pouvez évidemment ajuster la taille de chaque fragment.

Ne changez pas le nom des fragments. 
Nous allons utiliser ce format de nom pour reconstruire le fichier dans
l’action rapide suivante.

<div id="use-split"></div>
### Comment l'utiliser ?

Enregistrez votre processus sous le nom « Fichiers - découper ».

Ouvrez un dossier qui contient au moins un fichier de plus de 5Mo, 
comme une photographie.

Après avoir sélectionné un ou plusieurs documents, faites un clic droit
(ou _Ctrl_+clic) et sélectionnez le menu « actions rapides/Fichiers - découper ».

{% include post_image.html 
    src='/img/screenshots/2021/05-02/automator-split-run.png' 
    alt="Dans le menu contextuel, sélectionnez « actions rapide / Fichiers - découper »" %}

Le processus va s’exécuter et les fragments seront visibles dans le même dossier 
que les fichiers originaux.

Remarquez que le nom de chaque fragment se termine par une série de lettres 
« aa », « ab » et ainsi de suite. 
C’est ce qui permet de trier correctement les fragments pour être capable 
de les assembler dans le bon ordre et reconstituer le fichier d’origine.

{% include post_image.html 
    src='/img/screenshots/2021/05-02/automator-split-result.png' 
    alt="Chaque fichier est découpé en fragment d'au plus 5Mo chaque" %}



---

## Reconstruire un fichier

### Créez votre action

Dans _Automator_, créez maintenant un nouveau processus de 
type « action rapide ».

Pour notre action, nous allons manipuler des fichiers, et l’action ne devrait être
disponible que dans le _Finder_ :

- sélectionnez « fichiers ou dossiers » pour le type d’éléments reçus,
  cela vous permet de choisir les différents fragments ;
- pour l’application, sélectionnez « Finder » ;
- choisissez une icône ;
- et enfin une couleur.

{% include post_image.html 
    src='/img/screenshots/2021/05-02/automator-merge-01.png' 
    alt="Paramètres de l'action rapide de fusion des fragments" %}

Enregistrez l’action sous le nom « Fichiers - fusion ».


### Ajoutez l’action de fusion

Nous allons encore devoir ajouter une action 
« exécuter un script Shell » à partir de la bibliothèque d’actions.

Dans l’action, indiquez les éléments suivants :

- Shell : « /bin/zsh »
- Données en entrée : « comme arguments »

Remplacez maintenant le script exemple par celui ci-dessous :

```sh
# Récupère le nom du premier fichier
export premier_fichier=$1

# Extrait la partie qui précède le .part_XX comme nom du fichier destination
export destination=${premier_fichier%.part-*}

if [[ -e "$destination" ]]
then
  # Le fichier existe, ne fait rien et affiche un message
  osascript -e 'display alert "Le fichier «'$destination'» existe déjà"'
else 
  # Fusionne tous les fichiers dans ce fichier
  cat $(ls $@ | sort) > "${destination}"

  if [[ "0" != "$?" ]]
  then
    osascript -e 'display alert "Erreur à la reconstruction de «'$destination'»"'
  else
    osascript -e 'display alert "Le fichier «'$destination'» reconstruit"'
  fi
fi
```

Le début du script détermine le nom du fichier d’origine en enlevant 
le suffixe que nous avions utilisé dans le processus précédent.

Un premier test `if [[ … ]]` vérifie l’existence du fichier destination.
S’il existe déjà, le script affiche une alerte et le processus ne fera rien.

Au contraire, si aucun fichier n’a été trouvé avec le même nom, l’ensemble des
fichiers transmis en paramètre est fusionné avec la commande `cat`.

Notez que les fichiers sont triés pour s’assurer que les fragments sont assemblés
dans le bon ordre avec la commande `ls $@ | sort`.
Le résultat de cette commande est passé en paramètre à `cat` avec 
l’expression `$(…)`.

On vérifie ensuite le code de retour `$?` de `cat` pour s’assurer qu’aucun problème
n’a été rencontré.

Dans un cas comme dans l’autre on affiche un dialogue pour préciser le
résultat, soit pour avertir d’une erreur, soit pour confirmer le succès.

Libre à vous d’ajuster le script en enlevant les messages que vous estimez 
inutiles.

Le processus achevé devrait ressembler à ce qui suit :

{% include post_image.html 
    src='/img/screenshots/2021/05-02/automator-merge-02.png' 
    alt="Processus complet pour la fusion des fragments" %}


<div id="use-merge"></div>
### Utilisation

Pour utiliser cette action rapide, rouvrez le dossier utilisé pour tester
l’action de découpage.

Sélectionnez tous les fragments d’un des fichiers de test.

**Attention : ** 
Vous ne devez pas sélectionner les fragments de plusieurs fichiers.
Si vous ne respectez pas cette règle, vous risquez d’avoir un fichier qui
ressemblera à [Brundle](https://www.imdb.com/title/tt0091064/?ref_=fn_al_tt_1).

Affichez le menu contextuel du _Finder_ avec un clic secondaire et lancez
l’action rapide « Fichiers - fusion ».

Si vous n’avez pas modifié le nom du fichier d’origine, vous aurez une
alerte indiquant que le fichier existe et n’a pas été écrasé.

Changez son nom, par exemple en ajoutant un « _ » et recommencez.

Au lieu du menu contextuel, vous pouvez aussi utiliser la vue d’aperçu du
_Finder_ et y sélectionner directement l’action.

{% include post_image.html 
    src='/img/screenshots/2021/05-02/automator-merge-03.png' 
    alt="L'action rapide dans l'aperçu du Finder" %}

Cette fois, le processus devrait se terminer avec succès et vous devriez avoir 
un double de votre fichier d’origine.

