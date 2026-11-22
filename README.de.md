# OWASP-Security-Shepherd-Lab mit Docker Compose: Aufgaben zur Websicherheit üben, eine Lektion nach der anderen

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml)

Ein fertiges **Trainingslab für Websicherheit** für den Unterricht von der [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning), auf der Schulen und Colleges allen Lernenden eigene Datenbanken, Container und ein Terminal im Browser geben. Alle Lernenden bekommen eine eigene Kopie von **OWASP Security Shepherd**, dem Sicherheits-Trainingsspiel mit seinen Lektionen und Aufgaben, mit seinen **bereits angelegten MariaDB- und MongoDB-Datenbanken**, um **SQL-Injection, Cross-Site-Scripting, fehlerhafte Authentifizierung, unsichere direkte Objektreferenzen** und mehr zu üben, wobei jede gelöste Aufgabe einen Ergebnisschlüssel einbringt. Sie erklären die Schwachstelle und geben Belege ab, ohne etwas zu installieren und ohne Risiko für fremde Rechner.

Es ist eine einzige `docker-compose`-Datei, `compose.yaml`, und läuft auf dem eigenen Rechner genauso wie auf der Plattform, wo alle Lernenden eine private Kopie ohne Weg ins Internet bekommen.

## Die eine Regel

**Greifen Sie Ihre eigene Kopie an und sonst nichts.** Alles in diesem Lab läuft in Ihrer eigenen privaten Kopie, die keinen Weg ins Internet und keinen zu anderen Lernenden hat, sodass Sie nur die Anwendung erreichen, die das Lab für Sie gestartet hat. Richten Sie nie ein Werkzeug auf eine Website, ein Netz oder einen Rechner, der Ihnen nicht gehört, weder in einem Lab noch anderswo: Im Vereinigten Königreich ist das eine Straftat nach dem [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), und die meisten Länder haben ein ähnliches Gesetz. Zu lernen, wie Schwachstellen funktionieren, ist der Weg zu Software, die keine hat, und ein gutes erstes Gespräch in einer Klasse ist, warum es diese Regel gibt und wie verantwortungsvolle Offenlegung aussieht.

## Was darin ist

| Dienst | Image | Speicher | Was es ist |
| --- | --- | --- | --- |
| `web` | [`owasp/security-shepherd`](https://hub.docker.com/r/owasp/security-shepherd), per Digest festgelegt | 768 MB | Tomcat mit Security Shepherd, auf Port 8080 |
| `db` | [`mariadb:10.6.22`](https://hub.docker.com/_/mariadb) | 384 MB | die Datenbank, in der Shepherd seine Spieler und Ergebnisse sowie seine SQL-Aufgaben hält |
| `mongo` | [`mongo:4.4.29`](https://hub.docker.com/_/mongo) | 384 MB | die Datenbank hinter der NoSQL-Aufgabe |
| `prepare` | noch einmal das Shepherd-Image | 128 MB | ein Job, der beim Start einmal läuft und sich dann beendet (siehe unten) |

Das sind 1.664 MB für die ganze Kopie. Alles ist festgelegt: Shepherd veröffentlicht nur ein wanderndes Tag `dev`, deshalb ist es per Image-Digest festgelegt, `sha256:bf264289...c640ef` (der vollständige Wert steht in `compose.yaml`). Gemessen auf einem Laptop mit bereits geladenen Images sind alle drei Dienste nach etwa fünfzehn Sekunden betriebsbereit und brauchen, sobald die erste Seite ausgeliefert ist, rund 590 MB für den Webserver und 75 MB und 65 MB für die Datenbanken.

**Die Datenbanken werden für Sie angelegt, ohne dass etwas gebaut wird.** Die Anleitung des Projekts baut die beiden Datenbank-Images mit Maven aus dem Quellcode. Dieses Lab nicht: Die Schemata liegen im Archiv der Anwendung selbst, also öffnet `prepare` es einmal, nimmt die drei kleinen Änderungen vor, die das Build-Skript des Projekts macht (es stellt die `DELIMITER`-Zeilen wieder her und erlaubt den Konten der Aufgaben, sich aus einem anderen Container zu verbinden), fügt einen Spieler namens `student` hinzu und übergibt die Dateien an jede Datenbank, die sie bei ihrem ersten Start lädt. Die beiden Verbindungsdateien des Webservers sind im Image leer und werden bei seinem Start befüllt. Außerdem verhindert es, dass der Webserver jede Anfrage auf einen sicheren Port umleitet, den hier nichts veröffentlicht: Die Plattform setzt ihre eigene Adresse davor.

Die Images sind Programme Dritter, unverändert aus den eigenen öffentlichen Images der Projekte gestartet und auf eine Version oder einen Digest festgelegt (nie `latest`), damit sich das Lab zwischen zwei Lektionen nicht unter einer Klasse verändert. Hier wird nichts gebaut, und nichts aus diesem Repository wird in ihnen verteilt.

## Verwendung auf der Plattform

Die [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning) gibt allen Lernenden eine eigene Kopie eines Labs im Browser, mit einem Terminal daneben.

**Zum Ausprobieren:** Öffnen Sie die [Container-Seite](https://mitsurutech.co.uk/de/container), suchen Sie dieses Lab unter **Sample labs** und drücken Sie Start. Zum Ausprobieren ist kein Konto nötig.

**Als Aufgabe für eine Klasse:**

1. Legen Sie in Ihrem Modul eine Aufgabe vom Typ **Lab** an und wählen Sie **In a GitHub repository**.
2. Geben Sie `https://github.com/mitsurutech/lab-security-shepherd` mit dem Branch `main` an. Die Compose-Datei ist die Vorgabe, `compose.yaml`. Forken Sie das Repository zuerst, wenn Sie die Datei ändern möchten.
3. Veröffentlichen Sie. Jede Kopie startet von dem Commit, den Sie veröffentlicht haben, sodass eine spätere Änderung hier ein bereits gestelltes Lab nicht verändert.
4. Schreiben Sie in die Aufgabe, was abzugeben ist (siehe [Für Lehrkräfte](#für-lehrkräfte)), und weisen Sie sie wie jede andere Aufgabe zu.

Die [Seite zu diesem Lab](https://mitsurutech.co.uk/help/lab-security-shepherd) im Hilfehandbuch, sein [Leitfaden zu den Sicherheits-Labs](https://mitsurutech.co.uk/de/help/security-labs) und sein [Leitfaden zu Container-Labs](https://mitsurutech.co.uk/de/help/labs) erklären den Rest: was eine Compose-Datei enthalten darf, wie viel Speicher eine Kopie bekommt und wie eine Lehrkraft die Kopie von Lernenden öffnet, beobachtet und bewertet.

Noch kein College-Konto? [Das erste Jahr ist kostenlos](https://mitsurutech.co.uk/de/pricing) für bis zu 50 Lernende, und für die [Anmeldung](https://mitsurutech.co.uk/de/signup) genügt eine E-Mail-Adresse.

## Auf dem eigenen Rechner ausführen

Sie brauchen Docker mit dem Compose-Plugin und etwa 2 GB freien Speicher. Beim ersten Start werden die Images heruntergeladen.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Öffnen Sie <http://localhost:8080> und melden Sie sich als `student` mit dem Passwort `password` an. Der Administrator ist `admin` mit demselben Passwort, um die Spieler und das Score Board zu sehen. Das Shepherd-Image ist für `amd64` gebaut; auf einem Arm-Rechner führt Docker es per Emulation aus, was den Start verlangsamt.

`local.yaml` veröffentlicht den Port nur auf `127.0.0.1`, sodass das Lab nur von Ihrem eigenen Rechner aus erreichbar ist. Stoppen Sie es mit `Ctrl-C` und entfernen Sie es mit `docker compose -f compose.yaml -f local.yaml down -v`. Führen Sie es auf einem Rechner aus, von dem aus Sie bedenkenlos angreifen können: Die Anwendung ist absichtlich unsicher.

## Durcharbeiten

1. **Melden Sie sich** als `student` mit dem Passwort `password` an. Die Datenbanken sind schon angelegt, es gibt also nichts einzurichten.
2. **Drücken Sie Get Next Challenge.** Als Erstes wird eine Lektion angeboten, *What are Insecure Direct Object References?*, und von dort geht das Spiel zu seinen Aufgaben weiter.
3. **Finden Sie den Schlüssel.** Jede Aufgabe versteckt einen Ergebnisschlüssel. Lösen Sie die Aufgabe und tippen Sie den Schlüssel oben auf der Seite in das Feld, um ihn zu werten.
4. **Behalten Sie das Score Board im Blick.** Es zählt die gefundenen Schlüssel. Der Administrator, `admin`, sieht außerdem jeden Spieler und seinen Fortschritt.
5. **Fangen Sie neu an, wann Sie wollen.** Nichts wird gespeichert: Stoppen und erneutes Starten des Labs ergibt ein frisches Shepherd, in dem nichts gelöst ist.

## Für Lehrkräfte

Wir bewerten in diesem Lab nichts. Das Spiel wertet jeden Schlüssel, den Lernende einreichen, und der Administrator sieht das Score Board, aber was Sie bewerten, sind die Belege, die die Lernenden abgeben, wie bei jedem anderen Lab.

**Verlangen Sie Belege in zwei Teilen.** Erstens den Nachweis der Arbeit: einen Screenshot jeder gelösten Aufgabe, auf dem die Adresse des Labs im Browser zu sehen ist, damit klar ist, dass es die eigene Kopie ist. Zweitens das Verständnis: für jede Aufgabe einen Absatz in eigenen Worten darüber, worauf die Seite vertraut hat, obwohl sie es nicht hätte tun sollen, welche Eingabe genau verwendet wurde und warum sie funktioniert hat, und welche einzelne Änderung es verhindert hätte. Der zweite Teil zeigt Ihnen, ob etwas verstanden oder aus einer Musterlösung abgeschrieben wurde.

**Wo es in einen Kurs passt.** Die Aufgaben behandeln Injection, fehlerhafte Authentifizierung, Sitzungsverwaltung, Cross-Site-Scripting, unsichere direkte Objektreferenzen, Cross-Site Request Forgery und Sicherheitsfehlkonfiguration, deshalb eignet sich das Lab für Einheiten zu Websicherheit und sicherer Programmierung und für deren rechtliche und ethische Seite: Autorisierung und Umfang, den Computer Misuse Act 1990 und verantwortungsvolle Offenlegung. Prüfen Sie den genauen Wortlaut in der Einheit Ihrer eigenen Prüfungsstelle; hier wird keine zitiert.

**Wer was sieht.** Diese Labs werden oft mit Lernenden im Alter von 16 und 17 Jahren genutzt. Eine Kopie ist privat für die Person, die sie gestartet hat. Ein Mitglied des Personals, das das Modul unterrichtet, kann sie öffnen, um zu sehen, was die Person getan hat, und das Öffnen der Arbeit von Lernenden wird ins Zugriffsprotokoll geschrieben, das die Lernenden lesen können.

## Was in einem Lab nicht geht

Das Lab hat überhaupt keinen Weg ins Internet, deshalb lädt nichts, was in einer Aufgabe eine Website außerhalb der Kopie braucht. Die mobilen Aufgaben brauchen eine Handy-App, die das Lab nicht hat, deshalb lassen sie sich hier nicht abschließen. Der Webserver bekommt 768 MB und jede Datenbank 384 MB. Ein dreimal falsch eingegebenes Passwort sperrt ein Konto für eine Weile, das ist die eigene Regel des Spiels, deshalb startet man eine Kopie besser neu, statt zu warten.

## Fehlerbehebung

- **Die Anmeldeseite erscheint nicht direkt nach Start.** Warten Sie einige Sekunden und drücken Sie erneut Open: Das Lab meldet sich erst als bereit, wenn beide Datenbanken geladen sind und der Webserver antwortet.
- **Das Spiel meldet ein falsches Passwort.** Der Spieler ist `student` und das Passwort ist `password`, in Kleinbuchstaben.
- **Auf dem eigenen Rechner ist Port 8080 schon belegt.** Ändern Sie die linke Zahl in `local.yaml`, zum Beispiel auf `127.0.0.1:8081:8080`, und öffnen Sie stattdessen diesen Port.

## Das Lab prüfen

`test/check.sh` startet das Lab so, wie der Runner der Plattform jeden Dienst startet (alle Capabilities entzogen, `no-new-privileges`, ein Prozesslimit, Speicherlimits und kein Weg ins Internet), und prüft dann aus seinem Netz heraus, was diese Seite verspricht: dass sich Lernende anmelden und die erste Aufgabe angeboten bekommen. Es braucht Docker und läuft bei jedem Push, das ist das Abzeichen oben.

```bash
test/check.sh
```

## Versionen und Lizenzen

[OWASP Security Shepherd](https://github.com/OWASP/SecurityShepherd) steht unter der GPL-3.0, [MariaDB](https://mariadb.org) unter der GPL-2.0 und [MongoDB](https://www.mongodb.com/legal/licensing/server-side-public-license) Community Server unter der Server Side Public License. Die Images sind `owasp/security-shepherd`, per Digest festgelegt, `mariadb:10.6.22` und `mongo:4.4.29`, so gestartet, wie sie veröffentlicht sind, und von diesem Repository nicht weiterverteilt. Security Shepherd ist ein OWASP-Projekt, und dieses Repository gehört weder dazu noch wird es davon unterstützt.

Die Compose-Datei, die Tests und diese Dokumentation stehen unter der MIT-Lizenz, siehe [LICENSE](LICENSE): kopieren, ändern, damit unterrichten. Für die Anwendungen darin gelten die Lizenzen ihrer eigenen Projekte, oben verlinkt.

## Über uns

Erstellt von [Mitsuru Technologies](https://mitsurutech.co.uk/de) für die [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning): Python, Java, Go, Node, SQL und Linux im Browser für Schulen und Colleges, mit Container-Labs, aus GitHub bereitgestellten Web-Apps und Quizzen, die sich selbst bewerten. Probieren Sie Code ohne Konto im [Playground](https://mitsurutech.co.uk/de/playground) aus. Das Lab hat eine eigene Seite im Hilfehandbuch, [Security Shepherd lab](https://mitsurutech.co.uk/help/lab-security-shepherd), und die anderen stehen unter [Labs und Beispiele](https://mitsurutech.co.uk/de/help/labs).

Weitere Labs aus demselben Haus: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) und [lab-sample](https://github.com/mitsurutech/lab-sample).

## Zu den Passwörtern in diesem Repository

Das Datenbankpasswort in `compose.yaml` (`CowSaysMoo`) ist der von OWASP Security Shepherd selbst veröffentlichte Standardwert. Es ist eine Übungsvorgabe für ein Lab, das nur auf Ihrem eigenen Rechner oder in der Plattform läuft, niemals eine echte Zugangsangabe, und es steht hier absichtlich.
