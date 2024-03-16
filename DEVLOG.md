# Diario de desarrollo

## ¿Por qué esta actualización del remake de Babaliba? ¿Y por qué ahora?

Ya hace años que me escocía el tema de que el remake de Babaliba para macOS sólo funcionase en ordenadores PowerPC. Periódicamente me daba por mirar cómo estaba actualmente el soporte para [DIV Games Studio y sus sucesores](https://es.wikipedia.org/wiki/DIV_Games_Studio#Sucesores). Sin profundizar demasiado, me dolía encontrarme con demasiados enlaces rotos a páginas web que ya no están disponibles, ni buceando en [archive.org](https://web.archive.org). Y lo dejaba estar.

Hace un par de semanas me encontré con un vídeo de Rafa Laguna en el que hablaba de [ports de Godot para Nintendo Switch con Pablo Antonio Navarro Reyes (panreyes)](https://www.youtube.com/watch?v=j9vfOKthCRs). Y da la casualidad de que este hombre es el creador/mantenedor de Pixtudio, que es una de esas evoluciones de DIV. [Pregunté](https://www.youtube.com/watch?v=j9vfOKthCRs&lc=UgyghXerZTYTlYwI3Fd4AaABAg) si sabían de algún sucesor de DIV que funcionase en macOS, pero no tuve suerte, así que lo dejé estar.

La semana pasada tuvo lugar la sexta edición de [Retro Parla](https://www.retroparla.com/), lo cual siempre supone un chute de nostalgia y un empujón para retomar cosas relacionadas con el retro. Retomé la búsqueda y, esta vez, desde la [página de descargas de BennuGD](https://www.bennugd.org/downloadss/) llegué a una versión de los binarios (de 2011) que funcionaba en macOS. Me puse a adaptar el [código fuente del remake de Babaliba](https://github.com/compilersoftware/babaliba) hasta que conseguí que compilase. Pero me di cuenta de que el binario del intérprete (`bgdi`) estaba enlazando librerías a una ruta del disco duro del usuario que lo compiló (joseba). Así que por ese camino no íbamos a llegar a ninguna parte, aunque consiguiese adaptar el código para hacerlo funcionar.

Estuve intentando compilar por mi cuenta los binarios de BennuGD2 a partir de su [código fuente](https://github.com/SplinterGU/BennuGD2), pero no es algo que domine y, al primer error, ya estoy bastante perdido. Así que tocaba buscar ayuda.

Estamos en 2024. Por desgracia los foros están bastante muertos. Ahora se llevan otros canales de comunicación. Hice una búsqueda en Telegram y, por suerte, encontré un [canal dedicado a BennuGD](https://t.me/Bennu_Game_Development). Lancé allí la pregunta y Daniel, el creador del canal, me ayudó lo mejor que buenamente pudo. Luego me di cuenta de que en el canal sólo estábamos él, yo y el bot que gestiona las altas (luego se uniría el propio panreyes). 

Daniel no me pudo ayudar a compilar los binarios, pero sí que me dio pistas para contactar con Juan Ponteprino (SplinterGU) que, a la postre, es el creador/mantenedor de BennuGD2. Al habla con él en el [servidor de Discord de DivHub](https://discord.gg/CAKr9QR), nos facilitó los ejecutables ya compilados para macOS y, de esa forma, hemos podido terminar de adaptar el código y generar una aplicación distribuible como es debido. Eso sí, sin firmar, que tampoco vamos a pagar los 100 euros/año de la licencia de desarrolladores para esto.

## Estrategia para adaptar el código

No tengo ni idea de DIV Games Studio, Fenix, BennuGD ni nada por el estilo. Y el código original del remake tampoco era de lo más amigable. Tampoco es que haya documentación de BennuGD 2. 

Lo primero que he hecho ha sido ir comentando las líneas de código que me daban problemas, o adaptando los errores del compilador que eran más o menos evidentes, hasta que he conseguido que compilase por primera vez.

Luego, ha sido cuestión de ir adaptando el código sin modificar su estructura salvo en lo imprescindible, fijándome en los ejemplos que hay en el propio repositorio de BennuGD2.

Por último, me he permitido el lujo de meter algunas mejoras, como una *splash screen*, soporte para joystick o poder alternar entre ventana y pantalla completa.

No me siento para nada orgulloso de cómo ha quedado el código fuente. Pero, como digo, la estrategia ha sido tocar lo mínimo del original para que funcionase. Repito, no es que no sea experto en el lenguaje usado, es que hasta que he empezado con este tema, no tenía la más mínima idea ni de la sintaxis, no hablemos ya de su arquitectura. Al final, no ha sido otra cosa que un ejercicio de pelear con *legacy code*, como si fuera resolver un puzle.

Para generar el bundle de la aplicación y la imagen de disco para distribuirla, he recuperado un trabajo que ya hice hace 8 años para el [port de UWOL para macOS](https://github.com/AugustoRuiz/UWOL/pull/1) de Augusto Ruiz. Recordaba haberlo hecho, pero no cómo se hacía. Afortunadamente, para eso están los repositorios de software y toda la documentación generada alrededor.

## La importancia de la comunidad

Nada de esto hubiera sido posible sin ayuda de la comunidad. Gracias a la ayuda ágil y desinteresada de algunas personas (ver sección **Agradecimientos** en el fichero [README.md](./README.md)), hemos podido conseguir tener esta versión recompilada para sistemas operativos modernos. Y es por eso que, desde Compiler Software, siempre abogamos por hacer público el código fuente, por mucha vergüenza que nos dé, y también publicar y compartir las investigaciones que hacemos y los procesos de desarrollo que seguimos.

---

Fede J. Álvarez, marzo de 2024.