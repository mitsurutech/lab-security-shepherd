# OWASP Security Shepherd lab with Docker Compose: practise web security challenges, one lesson at a time

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml)

A ready-made **web security training lab** for classrooms, from the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning), where schools and colleges give every student their own databases, containers and terminal in the browser. Each student gets their own copy of **OWASP Security Shepherd**, the security training game with its lessons and challenges, with its **MariaDB and MongoDB databases already made**, to practise **SQL injection, cross-site scripting, broken authentication, insecure direct object references** and more, scoring a result key for each challenge solved. They explain the flaw, and hand in evidence, with nothing installed and no risk to anybody else's machine.

It is one `docker-compose` file, `compose.yaml`, and it runs the same on your own machine as it does on the platform, where every student gets a private copy with no way out to the internet.

## The one rule

**Attack your own copy and nothing else.** Everything in this lab runs inside your own private copy, which has no route to the internet and none to any other student, so the only thing you can reach is the application the lab started for you. Never point a tool at a website, a network or a machine you do not own, in a lab or anywhere else: in the UK that is an offence under the [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), and most countries have a law like it. Learning how weaknesses work is how you build software that does not have them, and a good first conversation in a class is why this rule exists and what responsible disclosure looks like.

## What is in it

| Service | Image | Memory | What it is |
| --- | --- | --- | --- |
| `web` | [`owasp/security-shepherd`](https://hub.docker.com/r/owasp/security-shepherd) pinned by digest | 768 MB | Tomcat running Security Shepherd, on port 8080 |
| `db` | [`mariadb:10.6.22`](https://hub.docker.com/_/mariadb) | 384 MB | the database Shepherd keeps its players and results in, and its SQL challenges |
| `mongo` | [`mongo:4.4.29`](https://hub.docker.com/_/mongo) | 384 MB | the database behind the NoSQL challenge |
| `prepare` | the Shepherd image again | 128 MB | a job that runs once at start and exits (see below) |

That is 1,664 MB for the whole copy. Everything is pinned: Shepherd publishes only a moving `dev` tag, so it is pinned by its image digest, `sha256:bf264289...c640ef` (the full value is in `compose.yaml`). Measured on a laptop with the images already pulled, all three services are healthy in about fifteen seconds and use roughly 590 MB for the web server and 75 MB and 65 MB for the databases once the first page has been served.

**The databases are made for you, without anything built.** The project's own instructions build the two database images from the source code with Maven. This lab does not: the schemas are inside the application's own archive, so `prepare` opens it once, makes the three small changes the project's build script makes (it restores the `DELIMITER` lines, and lets the challenge accounts connect from another container), adds a player called `student`, and hands the files to each database, which loads them on its first start. The web server's two connection files ship empty in the image, and are filled in when it starts. It also stops the web server redirecting every request to a secure port nothing here publishes: the platform puts its own address in front.

The images are third-party programs, run unmodified from the projects' own public images and pinned to a version or digest (never `latest`), so the lab does not change under a class between one lesson and the next. Nothing is built here and nothing from this repository is distributed in them.

## Using it on the platform

The [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) gives every student their own copy of a lab, in the browser, with a terminal beside it.

**To try it:** open the [container page](https://mitsurutech.co.uk/container), find this lab in **Sample labs** and press Start. No account is needed to try one.

**To set it as work for a class:**

1. In your module, make a task of type **Lab** and choose **In a GitHub repository**.
2. Give `https://github.com/mitsurutech/lab-security-shepherd` with the branch `main`. The compose file is the default, `compose.yaml`. Fork the repository first if you want to change the file.
3. Publish. Every student's copy starts from the commit you published, so a later change here does not alter a lab already set.
4. Say in the task what to hand in (see [For teachers](#for-teachers)), and assign it like any other task.

The help manual's [page for this lab](https://mitsurutech.co.uk/help/lab-security-shepherd), its [guide to the security labs](https://mitsurutech.co.uk/help/security-labs) and its [guide to container labs](https://mitsurutech.co.uk/help/labs) cover the rest: what a compose file may say, how much memory a copy gets, and how a teacher opens, watches and marks a student's copy.

No college account yet? [Your first year is free](https://mitsurutech.co.uk/pricing) for up to 50 students, and [signing up](https://mitsurutech.co.uk/signup) takes an email address.

## Running it on your own machine

You need Docker with the Compose plugin and about 2 GB of free memory. The first start downloads the images.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Open <http://localhost:8080> and sign in as `student` with the password `password`. The administrator is `admin` with the same password, for seeing the players and the Score Board. The Shepherd image is built for `amd64`; on an Arm machine Docker runs it under emulation, which is slower to start.

`local.yaml` publishes the port on `127.0.0.1` only, so the lab is reachable from your own computer and from nowhere else. Stop it with `Ctrl-C`, and remove it with `docker compose -f compose.yaml -f local.yaml down -v`. Run it on a machine you are happy to attack from: the application is insecure on purpose.

## Working through it

1. **Sign in** as `student` with the password `password`. The databases are already made, so there is nothing to set up.
2. **Press Get Next Challenge.** The first thing offered is a lesson, *What are Insecure Direct Object References?*, and the game goes on from there to its challenges.
3. **Find the key.** Each challenge hides a result key. Solve the challenge, then type the key into the box at the top of the page to score it.
4. **Watch the Score Board.** It counts the keys found. The administrator, `admin`, can also see every player and their progress.
5. **Start again when you want to.** Nothing is saved: stopping the lab and starting it again is a fresh Shepherd with nothing solved.

## For teachers

Nothing in this lab is marked by us. The game scores each key a student submits and the administrator can see the Score Board, but what you mark is the evidence the student hands in, the way you mark any other lab.

**Ask for evidence in two halves.** First, proof of the work: a screenshot of each challenge solved, with the lab's own address visible in the browser so it is clearly their copy. Second, the understanding: for each one, a written paragraph in their own words on what the page trusted that it should not have, the exact input they used and why it worked, and the one change that would have stopped it. The second half tells you whether it was understood or copied from a walkthrough.

**Where it sits in a course.** The challenges cover injection, broken authentication, session management, cross-site scripting, insecure direct object references, cross-site request forgery and security misconfiguration, so the lab suits web security and secure coding units, and the legal and ethical side of one: authorisation and scope, the Computer Misuse Act 1990 and responsible disclosure. Check your own awarding body's unit for the exact wording; none is quoted here.

**Who sees what.** These labs are often used with students aged 16 and 17. A copy is private to the student who started it. A member of staff who teaches the module can open it to see what the student has done, and opening a student's work is written to the access log, which the student can read.

## What does not work in a lab

The lab has no way out to the internet at all, so anything in a challenge that needs a website outside the copy will not load. The mobile challenges need a phone app, which the lab does not have, so they cannot be completed here. The web server is given 768 MB and each database 384 MB. A wrong password typed three times locks an account for a while, which is the game's own rule, so a copy is best restarted rather than waited on.

## Troubleshooting

- **The sign-in page does not appear straight after Start.** Wait a few seconds and press Open again: the lab reports itself ready only once both databases have loaded and the web server answers.
- **The game says the password is wrong.** The player is `student` and the password is `password`, in lower case.
- **On your own machine, port 8080 is already in use.** Change the left-hand number in `local.yaml`, for example `127.0.0.1:8081:8080`, and open that port instead.

## Checking the lab

`test/check.sh` starts the lab the way the platform's runner starts every service (all capabilities dropped, `no-new-privileges`, a process limit, memory limits, and no way out to the internet) and then checks from inside its network what this page promises: that a student signs in and is offered the first challenge. It needs Docker and runs on every push, which is the badge at the top.

```bash
test/check.sh
```

## Versions and licences

[OWASP Security Shepherd](https://github.com/OWASP/SecurityShepherd) is GPL-3.0 licensed, [MariaDB](https://mariadb.org) is GPL-2.0 and [MongoDB](https://www.mongodb.com/legal/licensing/server-side-public-license) Community Server is under the Server Side Public License. The images are `owasp/security-shepherd` pinned by digest, `mariadb:10.6.22` and `mongo:4.4.29`, run as published and not redistributed by this repository. Security Shepherd is an OWASP project and this repository is not part of it, nor endorsed by it.

The compose file, the tests and this documentation are MIT licensed, see [LICENSE](LICENSE): copy it, change it, teach with it. The applications inside are the licences of their own projects, linked above.

## About

Made by [Mitsuru Technologies](https://mitsurutech.co.uk) for the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning): Python, Java, Go, Node, SQL and Linux in the browser for schools and colleges, with container labs, web apps deployed from GitHub, and quizzes that mark themselves. Try code with no account in the [playground](https://mitsurutech.co.uk/playground). The lab has its own page in the help manual, [Security Shepherd lab](https://mitsurutech.co.uk/help/lab-security-shepherd), and the others are listed in [Labs and samples](https://mitsurutech.co.uk/help/labs).

More labs from the same place: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) and [lab-sample](https://github.com/mitsurutech/lab-sample).

## About the passwords in this repository

The database password in `compose.yaml` (`CowSaysMoo`) is OWASP Security Shepherd's own published default. It is a fixture for a lab that runs only on your own computer or inside the platform, never a real credential, and it is written here on purpose.
