# Babaliba remake para macOS

https://compilersoft.es/remakes-babaliba.html

En 2005, Miguel A. García Prada programó un remake basado en Fenix, una evolución del mítico DIV Games Studio, con gráficos de Davit Masia. Dicho remake funcionaba en Windows, Linux y OSX de la época. En concreto, era OSX para ordenadores Mac con procesador PowerPC. Es un software que ya no funciona en los ordenadores de hoy día. Por ello, hemos decidido actualizarlo.

Podéis leer más sobre este tema en el [diario de desarrollo](DEVLOG.md).

## Estructura del repositorio

### assets

Ficheros necesarios para generar el bundle con la aplicación para macOS (fichero `.app`) y la imagen de disco `.dmg`.

### bennugd

Ejecutables y librerías de [BennuGD2](https://github.com/SplinterGU/BennuGD2). Incluye el compilador (`bgdc`) y el intérprete (`bgdi`).

### bin

Scrips de utilidad para compilar, ejecutar y generar la distribución del software.

### src

Código fuente y assets del juego.

### templates

Plantillas para generar el bundle con la aplicación para macOS.

## Scripts de utilidad

Hasta que aprenda a manejar bien los makefiles, nos apañamos con esto.

`bin/clean.sh`. Limpia todos los ficheros generados.

`bin/compile.sh`. Compila el código fuente. Genera una distribución en el directorio `build/`.

`bin/compile-debug.sh`. Igual que el anterior, pero genera información de depuración.

`bin/make-app.sh`. Genera el fichero `build/Babaliba.app`.

`bin/make-dmg.sh`. Genera el fichero `build/Babaliba.dmg`.

`bin/run.sh`. Ejecuta el juego.

`bin/run-debug.sh`. Igual que el anterior, pero mostrando información de depuración (y pudiendo acceder al depurador interno con `Option + C`).

## Agradecimientos

* A [Miguel A. García Prada](https://twitter.com/MiguelPrada) y [Davit Masia](https://twitter.com/DavidMasia) por hacer originalmente el remake.
* A [Daniel T. Borelli](https://codeberg.org/daltomi), por crear el canal de Telegram de BennuGD y ayudarnos a contactar con Juan Ponteprino.
* A [Juan Ponteprino](https://twitter.com/SplinterGU), por ayudarnos con los ejecutables de BennuGD2 para macOS y resolver todas las dudas que le hemos planteado.
* A [Linus Unnebäck](https://github.com/LinusU/node-appdmg) por la herramienta `appdmg`.
* A todos los amigos a los que les he pasado el juego para que lo probasen y reportasen fallos.
* A ti, por jugar a este juego.

---

2024 - Compiler Software
