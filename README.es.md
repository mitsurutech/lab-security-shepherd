# Laboratorio OWASP Security Shepherd con Docker Compose: practica retos de seguridad web, lección a lección

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-security-shepherd/actions/workflows/check.yml)

Un **laboratorio de entrenamiento en seguridad web** listo para clase, de la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning), donde colegios e institutos dan a cada estudiante sus propias bases de datos, contenedores y terminal en el navegador. Cada estudiante recibe su propia copia de **OWASP Security Shepherd**, el juego de entrenamiento en seguridad con sus lecciones y retos, con sus **bases de datos MariaDB y MongoDB ya creadas**, para practicar **inyección SQL, cross-site scripting, autenticación rota, referencias directas inseguras a objetos** y más, sumando una clave de resultado por cada reto resuelto. El estudiante explica el fallo y entrega pruebas, sin instalar nada y sin riesgo para la máquina de nadie más.

Es un solo archivo `docker-compose`, `compose.yaml`, y funciona igual en tu ordenador que en la plataforma, donde cada estudiante recibe una copia privada sin salida a internet.

## La única regla

**Ataca tu propia copia y nada más.** Todo en este laboratorio se ejecuta dentro de tu copia privada, que no tiene ruta a internet ni a ningún otro estudiante, así que lo único a lo que puedes llegar es la aplicación que el laboratorio arrancó para ti. Nunca apuntes una herramienta a una web, una red o una máquina que no sea tuya, ni en un laboratorio ni en ningún otro sitio: en el Reino Unido es un delito según la [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), y la mayoría de los países tienen una ley parecida. Aprender cómo funcionan las debilidades es la forma de crear software que no las tenga, y una buena primera conversación en clase es por qué existe esta regla y qué es la divulgación responsable.

## Qué contiene

| Servicio | Imagen | Memoria | Qué es |
| --- | --- | --- | --- |
| `web` | [`owasp/security-shepherd`](https://hub.docker.com/r/owasp/security-shepherd) fijada por su digest | 768 MB | Tomcat con Security Shepherd, en el puerto 8080 |
| `db` | [`mariadb:10.6.22`](https://hub.docker.com/_/mariadb) | 384 MB | la base de datos donde Shepherd guarda sus jugadores y resultados, y sus retos de SQL |
| `mongo` | [`mongo:4.4.29`](https://hub.docker.com/_/mongo) | 384 MB | la base de datos del reto NoSQL |
| `prepare` | otra vez la imagen de Shepherd | 128 MB | un trabajo que se ejecuta una vez al arrancar y termina (ver abajo) |

Eso suma 1.664 MB para toda la copia. Todo está fijado: Shepherd solo publica una etiqueta móvil `dev`, así que se fija por el digest de su imagen, `sha256:bf264289...c640ef` (el valor completo está en `compose.yaml`). Medido en un portátil con las imágenes ya descargadas, los tres servicios están listos en unos quince segundos y usan unos 590 MB para el servidor web, y 75 MB y 65 MB para las bases de datos, una vez servida la primera página.

**Las bases de datos se crean por ti, sin construir nada.** Las instrucciones del propio proyecto construyen las dos imágenes de base de datos a partir del código fuente con Maven. Este laboratorio no: los esquemas están dentro del propio archivo de la aplicación, así que `prepare` lo abre una vez, hace los tres pequeños cambios que hace el script de construcción del proyecto (restaura las líneas `DELIMITER` y deja que las cuentas de los retos se conecten desde otro contenedor), añade un jugador llamado `student` y entrega los archivos a cada base de datos, que los carga en su primer arranque. Los dos archivos de conexión del servidor web vienen vacíos en la imagen y se rellenan cuando arranca. También evita que el servidor web redirija cada petición a un puerto seguro que aquí nada publica: la plataforma pone su propia dirección delante.

Las imágenes son programas de terceros, ejecutados sin cambios desde las imágenes públicas de los propios proyectos y fijados a una versión o un digest (nunca `latest`), para que el laboratorio no cambie bajo los pies de una clase de una lección a la siguiente. Aquí no se construye nada y nada de este repositorio se distribuye en ellas.

## Uso en la plataforma

La [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning) da a cada estudiante su propia copia de un laboratorio, en el navegador, con una terminal al lado.

**Para probarlo:** abre la [página de contenedores](https://mitsurutech.co.uk/es/container), busca este laboratorio en **Sample labs** y pulsa Start. No hace falta cuenta para probar uno.

**Para ponerlo como tarea a una clase:**

1. En tu módulo, crea una tarea de tipo **Lab** y elige **In a GitHub repository**.
2. Indica `https://github.com/mitsurutech/lab-security-shepherd` con la rama `main`. El archivo compose es el predeterminado, `compose.yaml`. Haz antes un fork del repositorio si quieres cambiar el archivo.
3. Publica. La copia de cada estudiante parte del commit que publicaste, así que un cambio posterior aquí no altera un laboratorio ya asignado.
4. Indica en la tarea qué hay que entregar (consulta [Para docentes](#para-docentes)) y asígnala como cualquier otra tarea.

La [página de este laboratorio](https://mitsurutech.co.uk/help/lab-security-shepherd) en el manual de ayuda, su [guía de laboratorios de seguridad](https://mitsurutech.co.uk/es/help/security-labs) y su [guía de laboratorios de contenedores](https://mitsurutech.co.uk/es/help/labs) explican el resto: qué puede decir un archivo compose, cuánta memoria recibe una copia y cómo un docente abre, sigue y corrige la copia de un estudiante.

¿Aún no tienes cuenta de centro? [El primer año es gratis](https://mitsurutech.co.uk/es/pricing) para hasta 50 estudiantes, y para [registrarte](https://mitsurutech.co.uk/es/signup) basta un correo electrónico.

## Ejecutarlo en tu propio ordenador

Necesitas Docker con el plugin Compose y unos 2 GB de memoria libre. El primer arranque descarga las imágenes.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Abre <http://localhost:8080> e inicia sesión como `student` con la contraseña `password`. El administrador es `admin` con la misma contraseña, para ver los jugadores y el Score Board. La imagen de Shepherd está construida para `amd64`; en una máquina Arm, Docker la ejecuta con emulación, que tarda más en arrancar.

`local.yaml` solo publica el puerto en `127.0.0.1`, así que el laboratorio solo es accesible desde tu ordenador. Detenlo con `Ctrl-C` y elimínalo con `docker compose -f compose.yaml -f local.yaml down -v`. Ejecútalo en una máquina desde la que no te importe atacar: la aplicación es insegura a propósito.

## Cómo recorrerlo

1. **Inicia sesión** como `student` con la contraseña `password`. Las bases de datos ya están creadas, así que no hay nada que preparar.
2. **Pulsa Get Next Challenge.** Lo primero que se ofrece es una lección, *What are Insecure Direct Object References?*, y a partir de ahí el juego pasa a sus retos.
3. **Encuentra la clave.** Cada reto esconde una clave de resultado. Resuelve el reto y escribe la clave en el cuadro de la parte superior de la página para sumarla.
4. **Mira el Score Board.** Cuenta las claves encontradas. El administrador, `admin`, también puede ver a cada jugador y su progreso.
5. **Empieza de nuevo cuando quieras.** No se guarda nada: parar el laboratorio y arrancarlo otra vez da un Shepherd nuevo sin nada resuelto.

## Para docentes

Nosotros no corregimos nada en este laboratorio. El juego puntúa cada clave que envía un estudiante y el administrador puede ver el Score Board, pero lo que corriges son las pruebas que entrega el estudiante, como cualquier otro laboratorio.

**Pide las pruebas en dos partes.** Primero, la prueba del trabajo: una captura de pantalla de cada reto resuelto, con la dirección del propio laboratorio visible en el navegador para que se vea claramente que es su copia. Segundo, la comprensión: para cada uno, un párrafo escrito con sus propias palabras sobre en qué confiaba la página que no debía, la entrada exacta que usó y por qué funcionó, y el único cambio que lo habría impedido. La segunda parte te dice si lo ha entendido o lo ha copiado de una guía resuelta.

**Dónde encaja en un curso.** Los retos cubren inyección, autenticación rota, gestión de sesiones, cross-site scripting, referencias directas inseguras a objetos, falsificación de petición en sitios cruzados y configuración de seguridad incorrecta, así que el laboratorio encaja en unidades de seguridad web y programación segura, y en su parte legal y ética: autorización y alcance, la Computer Misuse Act 1990 y la divulgación responsable. Consulta la redacción exacta en la unidad de tu propio organismo certificador; aquí no se cita ninguna.

**Quién ve qué.** Estos laboratorios se usan a menudo con estudiantes de 16 y 17 años. Una copia es privada para el estudiante que la arrancó. Un miembro del personal que imparte el módulo puede abrirla para ver lo que ha hecho el estudiante, y abrir el trabajo de un estudiante queda escrito en el registro de accesos, que el estudiante puede leer.

## Qué no funciona en un laboratorio

El laboratorio no tiene ninguna salida a internet, así que lo que en un reto necesite una web fuera de la copia no cargará. Los retos móviles necesitan una aplicación de teléfono, que el laboratorio no tiene, así que no se pueden completar aquí. El servidor web recibe 768 MB y cada base de datos 384 MB. Una contraseña errónea escrita tres veces bloquea una cuenta durante un rato, que es la propia regla del juego, así que conviene reiniciar la copia antes que esperar.

## Solución de problemas

- **La página de inicio de sesión no aparece justo después de Start.** Espera unos segundos y vuelve a pulsar Open: el laboratorio solo se declara listo cuando las dos bases de datos se han cargado y el servidor web responde.
- **El juego dice que la contraseña es incorrecta.** El jugador es `student` y la contraseña es `password`, en minúsculas.
- **En tu ordenador, el puerto 8080 ya está en uso.** Cambia el número de la izquierda en `local.yaml`, por ejemplo `127.0.0.1:8081:8080`, y abre ese puerto en su lugar.

## Comprobar el laboratorio

`test/check.sh` arranca el laboratorio como el runner de la plataforma arranca cada servicio (todas las capacidades eliminadas, `no-new-privileges`, un límite de procesos, límites de memoria y sin salida a internet) y luego comprueba desde dentro de su red lo que promete esta página: que un estudiante inicia sesión y se le ofrece el primer reto. Necesita Docker y se ejecuta en cada push: es la insignia de arriba.

```bash
test/check.sh
```

## Versiones y licencias

[OWASP Security Shepherd](https://github.com/OWASP/SecurityShepherd) tiene licencia GPL-3.0, [MariaDB](https://mariadb.org) GPL-2.0 y [MongoDB](https://www.mongodb.com/legal/licensing/server-side-public-license) Community Server la Server Side Public License. Las imágenes son `owasp/security-shepherd` fijada por su digest, `mariadb:10.6.22` y `mongo:4.4.29`, ejecutadas tal como se publican y sin que este repositorio las redistribuya. Security Shepherd es un proyecto de OWASP y este repositorio no forma parte de él ni cuenta con su respaldo.

El archivo compose, las pruebas y esta documentación tienen licencia MIT, consulta [LICENSE](LICENSE): cópialo, cámbialo, enseña con él. Las aplicaciones de dentro tienen las licencias de sus propios proyectos, enlazadas arriba.

## Acerca de

Creado por [Mitsuru Technologies](https://mitsurutech.co.uk/es) para la [MitsuruTech Learning Platform](https://mitsurutech.co.uk/es/learning): Python, Java, Go, Node, SQL y Linux en el navegador para colegios, institutos y centros de formación, con laboratorios de contenedores, aplicaciones web desplegadas desde GitHub y cuestionarios que se corrigen solos. Prueba código sin cuenta en el [playground](https://mitsurutech.co.uk/es/playground). El laboratorio tiene su propia página en el manual de ayuda, [Security Shepherd lab](https://mitsurutech.co.uk/help/lab-security-shepherd), y los demás aparecen en [Laboratorios y ejemplos](https://mitsurutech.co.uk/es/help/labs).

Más laboratorios del mismo sitio: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) y [lab-sample](https://github.com/mitsurutech/lab-sample).

## Sobre las contraseñas de este repositorio

La contraseña de la base de datos en `compose.yaml` (`CowSaysMoo`) es el valor predeterminado que publica el propio OWASP Security Shepherd. Es un dato de ejercicio para un laboratorio que solo se ejecuta en tu ordenador o dentro de la plataforma, nunca una credencial real, y está escrita aquí a propósito.
