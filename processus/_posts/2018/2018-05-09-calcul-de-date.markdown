---
layout: post
title: Comment faire des calcul avec des dates ?
date: 2018-05-09 19:00:00 +02:00
logo: automator
attachments: 
  - name: date-calculs-python..workflow
    path: processus/date-calculs-python.workflow.zip
---

Il peut arriver que l'on ait besoin de faire des calculs de dates, par exemple
pour avoir la date dans une semaine, ou la date de la veille. 
Cependant s'il existe bien des variables pour obtenir la date du jour, 
aucune action ne propose de faire des calculs de date.
Nous allons donc voir comment faire avec l'aide de quelques lignes de 
[Python](https://www.python.org).

Mais tout d'abord je remercie [Matthieu](https://twitter.com/mattnsr) 
qui m'a donné l'idée de cet article.


### Mise en place du processus

Lancez Automator et créez un processus simple.

Nous allons ajouter deux actions :

1. « Exécuter un script Shell »
2. « Afficher les résultats »

La première action contiendra notre calcul de date.

La seconde et dernière action n'est là que pour afficher le résultat.
Vous pourriez aussi bien stocker celui ci dans une variable.

### Le calcul de date

Il existe de nombreux langages de script utilisables dans macOS.
Python est l'un d'entre eux et il a l'avantage de permettre l'affichage 
en français.

Commencez par configurer le script de la façon suivante :

- « Shell » doit être défini sur « /usr/bin/python »
- « Données en entrée » doit être « stdin »

ce dernier paramètre indique qu'il suffit d'afficher du texte pour que cela 
soit ajouté au résultat de l'action.

Passons maintenant à l'écriture du script Python qui va donner la date.
Pour cela nous allons utiliser deux objets différents :

1. `date` permet d'obtenir la date du jour.
2. `timedelta` défini un intervalle de temps que nous allons pouvoir ajouter 
   ou retirer de la date du jour.

Pour pouvoir utiliser ces objets il faut commencer par indiquer à Python
que nous en avons besoin. Cela passe par leur importation dans le script, 
autrement dit, nous indiquons à l'interprète de Python que nous utilisons des
objets extérieur à notre script :

```python
from datetime import date, timedelta
import locale
```

Pour obtenir la date du jour, rien de plus simple :

```python
today = date.today()
```

Maintenant nous devons définir un intervalle de temps. Disons que nous voulons 
la date dans 7 jours :

```python
delta = timedelta(days = 7)
```

Il ne reste plus qu'à réaliser le calcul :

```python
nextWeek = today + delta
```

Votre script est presque terminé.

Si vous exécutez maintenant le processus vous n'aurez aucun résultat.
Il faut afficher la date.

Pour cela nous allons utiliser la fonction [`strftime()`][1] sur la date
en lui passant un [motif de format][2].

Si nous voulons afficher quelque chose comme « Mercredi 16 Mai 2018 » le format
sera « `%A %d %B %Y` » :

```python
print(nextWeek.strftime("%A %d %B %Y"))
```

### Obtenir un affichage en français

Pour utiliser une version traduite du format de date, nous avons besoin d'un
troisième composant : `locale`.

Ajoutez donc à votre script la ligne suivante :

```python
import locale
```

_Note :_ Pour la lisibilité il est conseillé de regrouper les importations 
         ensemble, en haut du script.

Et avant de réaliser l'affichage de la date, nous allons indiquer que nous
voulons utiliser les formats et traductions françaises :

```python
locale.setlocale(locale.LC_ALL, locale = "FR_fr")
```

Le premier paramètre inque sur quelle information la localisation va s'appliquer.
Le second indique la langue, ici le Français de France. Vous pourriez aussi
utiliser une variante francophone suisse ou Québécoise.

### Le processus final


Le résultat final de votre script ressemble à ce qui suit :

```Python
from datetime import date, timedelta
import locale

today = date.today()
delta = timedelta(days = 7)
nextWeek = today + delta

locale.setlocale(locale.LC_ALL, locale = "FR_fr")

print(nextWeek.strftime("%A %d %B %Y"))
```

Ce qui donne le processus suivant :

{% include post_image.html 
    src='/img/screenshots/2018/05-09_date-calculs-python.png' 
    alt="Un processus incluant un calcul de date en Python." %}


### Conclusion

Et voilà, vous savez maintenant utiliser un peu de Python pour
enrichir vos processus et effectuer des calculs simples de date.

J’espère que vous avez trouvé cet article utile et intéressant.


[1]: https://docs.python.org/3.5/library/datetime.html?highlight=strftime#datetime.date.strftime
[2]: https://docs.python.org/3.5/library/datetime.html?highlight=strftime#strftime-strptime-behavior