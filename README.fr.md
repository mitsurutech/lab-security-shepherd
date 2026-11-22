# Labo OWASP Security Shepherd avec Docker Compose : s'exercer aux défis de sécurité web, une leçon après l'autre

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml)

Un **labo d'entraînement à la sécurité web** prêt à l'emploi pour la classe, issu de la [plateforme d'apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning), où les écoles et les lycées donnent à chaque élève ses propres bases de données, conteneurs et terminal dans le navigateur. Chaque élève reçoit sa propre copie d'**OWASP Security Shepherd**, le jeu d'entraînement à la sécurité avec ses leçons et ses défis, avec ses **bases MariaDB et MongoDB déjà créées**, pour s'exercer à **l'injection SQL, au cross-site scripting, à l'authentification défaillante, aux références directes non sécurisées à des objets** et plus encore, en marquant une clé de résultat pour chaque défi résolu. L'élève explique la faille et rend des preuves, sans rien installer et sans risque pour la machine de qui que ce soit.

C'est un seul fichier `docker-compose`, `compose.yaml`, et il fonctionne de la même façon sur votre machine que sur la plateforme, où chaque élève reçoit une copie privée sans accès à internet.

## La seule règle

**Attaquez votre propre copie et rien d'autre.** Tout dans ce labo tourne à l'intérieur de votre copie privée, qui n'a aucune route vers internet ni vers un autre élève : la seule chose que vous pouvez atteindre est l'application que le labo a lancée pour vous. Ne pointez jamais un outil vers un site web, un réseau ou une machine qui ne vous appartient pas, dans un labo ou ailleurs : au Royaume-Uni, c'est une infraction au titre du [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), et la plupart des pays ont une loi semblable. Comprendre comment fonctionnent les faiblesses, c'est ainsi qu'on écrit des logiciels qui n'en ont pas, et une bonne première discussion en classe porte sur la raison d'être de cette règle et sur ce qu'est une divulgation responsable.

## Ce qu'il contient

| Service | Image | Mémoire | Ce que c'est |
| --- | --- | --- | --- |
| `web` | [`owasp/security-shepherd`](https://hub.docker.com/r/owasp/security-shepherd) épinglée par son digest | 768 Mo | Tomcat qui fait tourner Security Shepherd, sur le port 8080 |
| `db` | [`mariadb:10.6.22`](https://hub.docker.com/_/mariadb) | 384 Mo | la base où Shepherd garde ses joueurs et leurs résultats, ainsi que ses défis SQL |
| `mongo` | [`mongo:4.4.29`](https://hub.docker.com/_/mongo) | 384 Mo | la base derrière le défi NoSQL |
| `prepare` | encore l'image de Shepherd | 128 Mo | une tâche qui tourne une fois au démarrage puis s'arrête (voir plus bas) |

Cela fait 1 664 Mo pour toute la copie. Tout est épinglé : Shepherd ne publie qu'une étiquette mouvante `dev`, il est donc épinglé par le digest de son image, `sha256:bf264289...c640ef` (la valeur complète est dans `compose.yaml`). Mesuré sur un ordinateur portable avec les images déjà téléchargées, les trois services sont opérationnels en une quinzaine de secondes et utilisent environ 590 Mo pour le serveur web, et 75 Mo et 65 Mo pour les bases, une fois la première page servie.

**Les bases sont créées pour vous, sans rien construire.** Les instructions du projet construisent les deux images de base de données à partir du code source avec Maven. Ce labo ne le fait pas : les schémas se trouvent dans l'archive de l'application elle-même, donc `prepare` l'ouvre une fois, applique les trois petites modifications que fait le script de construction du projet (il rétablit les lignes `DELIMITER` et permet aux comptes des défis de se connecter depuis un autre conteneur), ajoute un joueur appelé `student`, et remet les fichiers à chaque base, qui les charge à son premier démarrage. Les deux fichiers de connexion du serveur web sont livrés vides dans l'image et sont remplis à son démarrage. Il empêche aussi le serveur web de rediriger chaque requête vers un port sécurisé que rien ne publie ici : la plateforme place sa propre adresse devant.

Les images sont des programmes tiers, lancés sans modification depuis les images publiques des projets eux-mêmes et épinglés sur une version ou un digest (jamais `latest`), pour que le labo ne change pas sous les pieds d'une classe entre deux leçons. Rien n'est construit ici et rien de ce dépôt n'est distribué dans ces images.

## Utilisation sur la plateforme

La [plateforme d'apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) donne à chaque élève sa propre copie d'un labo, dans le navigateur, avec un terminal à côté.

**Pour l'essayer :** ouvrez la [page des conteneurs](https://mitsurutech.co.uk/fr/container), trouvez ce labo dans **Sample labs** et appuyez sur Start. Aucun compte n'est nécessaire pour en essayer un.

**Pour le donner en travail à une classe :**

1. Dans votre module, créez une tâche de type **Lab** et choisissez **In a GitHub repository**.
2. Indiquez `https://github.com/mitsurutech/lab-security-shepherd` avec la branche `main`. Le fichier compose est celui par défaut, `compose.yaml`. Faites d'abord un fork du dépôt si vous voulez modifier le fichier.
3. Publiez. La copie de chaque élève part du commit que vous avez publié, donc une modification ultérieure ici ne change pas un labo déjà donné.
4. Précisez dans la tâche ce qu'il faut rendre (voir [Pour les enseignants](#pour-les-enseignants)), et attribuez-la comme n'importe quelle autre tâche.

La [page de ce labo](https://mitsurutech.co.uk/help/lab-security-shepherd) dans le manuel d'aide, son [guide des labos de sécurité](https://mitsurutech.co.uk/fr/help/security-labs) et son [guide des labos en conteneur](https://mitsurutech.co.uk/fr/help/labs) expliquent le reste : ce qu'un fichier compose peut contenir, combien de mémoire reçoit une copie, et comment un enseignant ouvre, suit et note la copie d'un élève.

Pas encore de compte d'établissement ? [La première année est gratuite](https://mitsurutech.co.uk/fr/pricing) jusqu'à 50 élèves, et [l'inscription](https://mitsurutech.co.uk/fr/signup) ne demande qu'une adresse e-mail.

## L'exécuter sur votre propre machine

Il vous faut Docker avec le plugin Compose et environ 2 Go de mémoire libre. Le premier démarrage télécharge les images.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Ouvrez <http://localhost:8080> et connectez-vous en tant que `student` avec le mot de passe `password`. L'administrateur est `admin` avec le même mot de passe, pour voir les joueurs et le Score Board. L'image de Shepherd est construite pour `amd64` ; sur une machine Arm, Docker l'exécute en émulation, ce qui ralentit le démarrage.

`local.yaml` ne publie le port que sur `127.0.0.1` : le labo n'est joignable que depuis votre ordinateur. Arrêtez-le avec `Ctrl-C` et supprimez-le avec `docker compose -f compose.yaml -f local.yaml down -v`. Lancez-le sur une machine depuis laquelle vous acceptez d'attaquer : l'application est volontairement vulnérable.

## Le parcours

1. **Connectez-vous** en tant que `student` avec le mot de passe `password`. Les bases sont déjà créées, il n'y a donc rien à préparer.
2. **Appuyez sur Get Next Challenge.** La première chose proposée est une leçon, *What are Insecure Direct Object References?*, et le jeu enchaîne ensuite sur ses défis.
3. **Trouvez la clé.** Chaque défi cache une clé de résultat. Résolvez le défi, puis tapez la clé dans le champ en haut de la page pour marquer le point.
4. **Suivez le Score Board.** Il compte les clés trouvées. L'administrateur, `admin`, voit aussi chaque joueur et sa progression.
5. **Recommencez quand vous voulez.** Rien n'est conservé : arrêter puis redémarrer le labo donne un Shepherd neuf, sans rien de résolu.

## Pour les enseignants

Nous ne notons rien dans ce labo. Le jeu compte chaque clé qu'un élève soumet et l'administrateur voit le Score Board, mais ce que vous notez, ce sont les preuves que l'élève rend, comme pour n'importe quel autre labo.

**Demandez des preuves en deux parties.** D'abord, la preuve du travail : une capture d'écran de chaque défi résolu, avec l'adresse du labo visible dans le navigateur pour qu'on voie bien que c'est sa copie. Ensuite, la compréhension : pour chacun, un paragraphe écrit avec ses propres mots sur ce que la page croyait alors qu'elle n'aurait pas dû, la saisie exacte utilisée et la raison pour laquelle elle a fonctionné, et le seul changement qui l'aurait empêché. La seconde partie vous dit si c'est compris ou recopié d'un corrigé trouvé en ligne.

**Sa place dans un cursus.** Les défis couvrent l'injection, l'authentification défaillante, la gestion de session, le cross-site scripting, les références directes non sécurisées à des objets, la falsification de requête intersite et la mauvaise configuration de sécurité : le labo convient donc aux modules de sécurité web et de codage sécurisé, et à leur volet juridique et éthique : autorisation et périmètre, le Computer Misuse Act 1990 et la divulgation responsable. Vérifiez la formulation exacte dans le référentiel de votre propre organisme certificateur ; aucun n'est cité ici.

**Qui voit quoi.** Ces labos sont souvent utilisés avec des élèves de 16 et 17 ans. Une copie est privée pour l'élève qui l'a lancée. Un membre du personnel qui enseigne dans le module peut l'ouvrir pour voir ce que l'élève a fait, et l'ouverture du travail d'un élève est inscrite au journal d'accès, que l'élève peut lire.

## Ce qui ne fonctionne pas dans un labo

Le labo n'a aucun accès à internet : tout ce qui, dans un défi, a besoin d'un site extérieur à la copie ne se chargera pas. Les défis mobiles ont besoin d'une application pour téléphone, que le labo n'a pas, ils ne peuvent donc pas être faits ici. Le serveur web reçoit 768 Mo et chaque base 384 Mo. Un mauvais mot de passe saisi trois fois verrouille un compte pendant un moment, c'est la règle du jeu lui-même : mieux vaut alors redémarrer une copie que patienter.

## Dépannage

- **La page de connexion n'apparaît pas juste après Start.** Attendez quelques secondes et appuyez de nouveau sur Open : le labo ne se déclare prêt qu'une fois les deux bases chargées et le serveur web en état de répondre.
- **Le jeu dit que le mot de passe est faux.** Le joueur est `student` et le mot de passe est `password`, en minuscules.
- **Sur votre machine, le port 8080 est déjà utilisé.** Changez le nombre de gauche dans `local.yaml`, par exemple `127.0.0.1:8081:8080`, et ouvrez ce port à la place.

## Vérifier le labo

`test/check.sh` démarre le labo comme le runner de la plateforme démarre chaque service (toutes les capacités retirées, `no-new-privileges`, une limite de processus, des limites de mémoire et aucun accès à internet), puis vérifie depuis son réseau ce que promet cette page : qu'un élève se connecte et se voit proposer le premier défi. Il faut Docker, et il tourne à chaque push : c'est le badge en haut de la page.

```bash
test/check.sh
```

## Versions et licences

[OWASP Security Shepherd](https://github.com/OWASP/SecurityShepherd) est sous licence GPL-3.0, [MariaDB](https://mariadb.org) sous GPL-2.0 et [MongoDB](https://www.mongodb.com/legal/licensing/server-side-public-license) Community Server sous Server Side Public License. Les images sont `owasp/security-shepherd` épinglée par son digest, `mariadb:10.6.22` et `mongo:4.4.29`, lancées telles que publiées et non redistribuées par ce dépôt. Security Shepherd est un projet OWASP ; ce dépôt n'en fait pas partie et n'est pas approuvé par lui.

Le fichier compose, les tests et cette documentation sont sous licence MIT, voir [LICENSE](LICENSE) : copiez-les, modifiez-les, enseignez avec. Les applications qu'il contient relèvent des licences de leurs propres projets, liées ci-dessus.

## À propos

Réalisé par [Mitsuru Technologies](https://mitsurutech.co.uk/fr) pour la [MitsuruTech Learning Platform](https://mitsurutech.co.uk/fr/learning) : Python, Java, Go, Node, SQL et Linux dans le navigateur pour les écoles et les établissements, avec des labos en conteneur, des applications web déployées depuis GitHub et des quiz qui se corrigent tout seuls. Essayez du code sans compte dans le [playground](https://mitsurutech.co.uk/fr/playground). Le labo a sa propre page dans le manuel d'aide, [Security Shepherd lab](https://mitsurutech.co.uk/help/lab-security-shepherd), et les autres sont listés dans [Labos et exemples](https://mitsurutech.co.uk/fr/help/labs).

D'autres labos du même endroit : [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) et [lab-sample](https://github.com/mitsurutech/lab-sample).

## À propos des mots de passe de ce dépôt

Le mot de passe de la base dans `compose.yaml` (`CowSaysMoo`) est la valeur par défaut publiée par OWASP Security Shepherd lui-même. C'est une donnée d'exercice pour un labo qui ne tourne que sur votre ordinateur ou dans la plateforme, jamais un véritable identifiant, et il est écrit ici exprès.
