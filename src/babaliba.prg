// -----------------------------------------------------
// BABALIBA (C) 1984 Dinamic (2004) remake
// Programa: Miguel A. García Prada
// Gráficos: Davit Masiá Coscollar
// Música & FX: Federico J. Álvarez Valero
// Adaptación código BennuGD: Federico J. Álvarez Valero
// -----------------------------------------------------

#define init_bgd1_background_emulation() background.file = 0; background.graph = map_new(640,480)
#define put_screen(f,g) map_clear(0, background.graph ); map_put(0, background.graph, f, g, 320, 240)
#define clear_screen() map_clear(0, background.graph )
#define put( f, g, x, y ) map_put(0, background.graph, f, g, x, y)
#define map_xput(fdst,gdst,gsrc,x,y,angle,size,flags) map_put(fdst, gdst, fdst, gsrc, x, y, angle, size, size, flags, 255, 255, 255, 255)
#define xput(f,g,x,y,angle,size,flags,region) map_put(0, background.graph, f, g, x, y, angle, size, size, flags, 255, 255, 255, 255)

PROGRAM Babaliba;

IMPORT "mod_gfx"
IMPORT "mod_input"
IMPORT "mod_sound"
IMPORT "mod_misc"

#include "src/lib/jkey.lib"

CONST

    pant_inicio = 74;
    h_bloque = 60;
    w_bloque = 60;

GLOBAL

    bool baba1;
    bool baba2;
    bool baba3;
    bool baba4;
    bool baba5;
    bool baba6;
    bool baba7;
    bool baba8;
    bool babal1;
    bool babal2;
    bool babal3;
    bool babal4;
    bool babal5;
    bool babal6;
    bool babal7;
    bool babal8;
    int hechizo;
    int babaliba;
    
    int cont3;
    int x1p;
    int y1p;
    int x2p;
    int y2p;
    bool prisionero;
    bool princesa;
    bool tesoro;
    int pant;
    //temp;
    int file_data; // fichero
    int bicho_data; // fichero
    byte vidas;
    int bombas;
    bool bomba; //si hay bomba activa = true
    int byte pant_bomba = 200; //pantalla en la que se coloca la bomba
    bool explosion; //si explosion true
    int tiempo;
    int graf1; // fichero
    byte lectura[49];
    byte lectura_bichos[5];
    int x_mono;
    int y_mono;
    bool llave_verde;
    bool llave_rosa;

    //identificadores de sonidos
    int s_explosion;
    int s_reloj;
    int s_serpiente;
    int s_chapuzon;
    int s_grito;
    int s_pasos;
    int s_bocado;

    //identificadores de musicas
    int m_menu;
    int m_muerte;
    int m_tesoro;
    int m_fbien;
    int m_fmuerte;
    int m_premio;
    
    //identificadores de sonidos ejecutandose
    int canal_serpiente;
    int reloj;
    int pasos;

    // Ciclo de vida de algunos objetos
    bool is_serpiente = false;
    bool is_bomba_mecha = false;
    int timer_pausa_bomba = 0;
        
// COMIENZO DEL PROGRAMA

BEGIN

    set_mode(640, 480, mode_waitvsync);
    window_set_title("Babaliba Remake 1.1.0");
    init_bgd1_background_emulation();
    set_fps(30, 4);
    jkeys_controller();
    channel_set_volume(-1, 64);
    music_set_volume(64);
    graf1 = fpg_load("gfx/graf01.fpg");
    file_data = fopen("data/datos_mapa.dat", O_READ); //ABRIMOS EL FICHERO QUE CONTIENE EL MAPEADO
    bicho_data = fopen("data/datos_bichos.dat", O_READ); //ABRIMOS EL FICHERO QUE CONTIENE LOS BICHOS

    window_set_icon(graf1, 106);

    //sonidos

    s_explosion = sound_load("sfx/bomba_exp.wav");
    s_reloj = sound_load("sfx/siseo_bomba.wav");
    s_serpiente = sound_load("sfx/serpiente.wav");
    s_chapuzon = sound_load("sfx/chapuzon.wav");
    s_grito = sound_load("sfx/grito.wav");
    s_pasos = sound_load("sfx/pasos.wav");
    s_bocado = sound_load("sfx/bocado.wav");
    
    m_menu = music_load("music/menu.ogg");
    m_muerte = music_load("music/muerte.ogg");
    m_tesoro = music_load("music/tesoro.ogg");
    m_fmuerte = music_load("music/fin_muerte.ogg");
    m_fbien = music_load("music/fin_bien.ogg");
    m_premio = music_load("music/premio.ogg");

    splash();

END

// FINAL DEL PROGRAMA

PROCESS menu()

BEGIN

    x1p = 2;
    y1p = 2;
    cont3 = ((y1p * 10) + x1p);
    x1p++;
    y1p++;
    x2p = ((x1p * 60) - 10);
    y2p = ((y1p * 60) - 10);
    llave_verde = false;
    llave_rosa = false;

    vidas = 5;
    bombas = 20;
    prisionero = false;
    princesa = false;
    tesoro = false;
    bomba = false;
    explosion = false;
    tiempo = 2000;
    pant = 74;
    x_mono = 7;
    y_mono = 2;


    baba1 = false;
    baba2 = false;
    baba3 = false;
    baba4 = false;
    baba5 = false;
    baba6 = false;
    baba7 = false;
    baba8 = false;
    babal1 = false;
    babal2 = false;
    babal3 = false;
    babal4 = false;
    babal5 = false;
    babal6 = false;
    babal7 = false;
    babal8 = false;
    hechizo = 0;
    babaliba = 0;

    let_me_alone();  
    music_play(m_menu, -1);
    put(graf1, 84, 320, 240);
    put(graf1, 2, 50, 230);
    put(graf1, 79, 590, 50);
    banner();
    set_all_sounds_volume(0); //sound_set_volume(-1, 0)
    serpiente(1, 3);
    sound_stop(canal_serpiente);
    arana(10, 2);
    LOOP
        jkeys_controller();
        IF (key(_space) || jkeys_state[_JKEY_SELECT])
            WHILE (key(_space) || jkeys_state[_JKEY_SELECT])
                frame;
            END
            clear_screen(); 
            music_stop(); 
            sound_stop(canal_serpiente); 
            signal(type banner, s_kill); 
            signal(type serpiente, s_kill); 
            signal(type arana, s_kill); 
            WHILE (jkeys_state[_JKEY_SELECT])
                frame;
            END
            break; 
        END
        IF (key(_esc) || jkeys_state[_JKEY_MENU]) 
            escape(1);
        END
        frame;
    END

    //coloca interfaz
    put(graf1, 52, 320, 240);
    put(graf1, 93, 320, 450);
    put(graf1, 155, 530, 370);
    put(graf1, 150, 400, 370);
    put(graf1, 152, 380, 370);
    set_all_sounds_volume(64); // sound_set_volume(-1, 64); 
    mapeado(pant);
    put(graf1, 999, 320, 170); // Este put vuelca el mapa completo en la pantalla
    bichos(pant);
    johnny(x_mono, y_mono);
    p_prisionero();
    p_tiempo();
    p_princesa();
    llaverosa();
    llaveverde();
    
    signal(type menu, s_kill);

END //PROCESS menu


// MAPEADOR
// ESTE PROCESO CREA UN MAPA DE PANTALLA EN BLANCO Y COLOCA LOS BLOQUES DE GRAFICOS SEGÚN LEA DEL ARCHIVO DE DATOS DE PANTALLA.
// COMO ENTRADA SOLO NECESITA EL NÚMERO DE PANTALLA QUE CORRESPONDA, SIENDO '0' LA PANTALLA SUPERIOR IZQUIERDA Y NUMERÁNDOSE
// EN EL SENTIDO USUAL DE LECTURA.

PROCESS mapeado(int pant)

PRIVATE

    int x1 = 30;
    int y1 = 30;
    int puntero = 0;
    int bucle;

BEGIN

    map_clear(graf1, 999, 0); //LIMPIAMOS EL GRAFICO EN EL QUE VAMOS A 'TILEAR'
    lee_mapa(pant);
    FROM bucle = 0 TO 49; //COMIENZA EL BUCLE PARA VOLCAR LOS BLOQUES GRAFICOS EN LA PANTALLA.
        IF ((lectura[puntero] > 0) AND (lectura[puntero] != 99))
            map_put(graf1, 999, graf1, lectura[puntero], x1, y1); // era map_put(graf1, 999, lectura[puntero], x1, y1);
        END //COLOCA EL BLOQUE EN LAS COORDENADAS CORRESPONDIENTES SIEMPRE QUE NO SEA '0'
        x1 = x1 + w_bloque; //INCREMENTA LA COORDENADA HORIZONTAL PARA DIBUJAR EL PROXIMO BUCLE.
        IF (x1 > 580) //SI LLEGAMOS AL FINAL DE LA PANTALLA PONEMOS BAJAMOS UNA FILA Y RESTAURAMOS 'X' AL COMIENZO.
            x1 = 30;
            y1 = y1 + w_bloque;
        END
        puntero++; //INCREMENTAMOS EL PUNTERO QUE NOS DICE QUE BLOQUE HAY QUE IMPRIMIR.
    END

END //MAPEADO


//PROCESO BOMBA
//COLOCA LA BOMBA EN PANTALLA Y LA HACE EXPLOTAR
//ENTRADA X e Y

PROCESS p_bomba(x, y)

PRIVATE

    int grafico = 24;

BEGIN

    is_bomba_mecha = true;
    z = -511;
    IF (bombas > 9)
       marcador(bombas, 380, 370);
    ELSE
       put(graf1, 160, 380, 370);
       marcador(bombas, 400, 370);
    END

    bomba = true;
    pant_bomba = pant;
    timer[0] = 0;
    reloj = sound_play(s_reloj, 0);
    WHILE (timer[0] < 500)

        IF (pant == pant_bomba)
            graph = grafico;
        ELSE
            graph = 99;
        END
        frame;
 
        timer[1] = 0;
        WHILE ((timer[1] < 10) AND (pant_bomba == pant))
            frame;
        END
        grafico++;
        IF (grafico == 28)
            grafico = 24;
        END

    END

    is_bomba_mecha = false;
    explosion = true;
    bomba = false;
    sound_stop(reloj);
    sound_play(s_explosion, 0);
     
    graph = 0;
    IF (pant_bomba == pant)
       timer[4] = 0;
       WHILE (timer[4] < 20)
           frame;
       END
       muerte();
    END
     
    IF ((pant_bomba == 126) AND (prisionero == false))
       let_me_alone();
       music_play(m_fmuerte, 0);
       put(graf1, 53, 320, 170);
       put(graf1, 88, 320, 140);
       put(graf1, 87, 320, 180);
       timer[4] = 0;
       WHILE (timer[4] < 800)
           frame;
       END
       menu();
    END
     
    IF ((pant_bomba == 5) AND (princesa == false))
       let_me_alone();
       music_play(m_fmuerte, 0);
       put(graf1, 53, 320, 170);
       put(graf1, 95, 320, 140);
       put(graf1, 87, 320, 180);
       timer[4] = 0;
       WHILE (timer[4] < 800)
           frame;
       END //WHILE
       menu();
    END
     
    timer[0] = 0;
     
    WHILE (timer[0] < 1000)
       frame;
    END

    explosion = false;
    bomba = false;

    IF (pant_bomba == pant)
       bichos(pant);
    END

    pant_bomba = 200;
    bomba = false;
    signal(type p_bomba, s_kill);

ONEXIT

    is_bomba_mecha = false;

END

//PROCESO BICHOS
//SIRVE PARA PONER LOS BICHOS EN CADA PANTALLA
//ENTRADA EL NUMERO DE PANTALLA

PROCESS bichos(int pantalla)

PRIVATE

    int bucle;

BEGIN

    IF ((explosion == true) AND (pant_bomba == pant))
        signal(type bichos, s_kill);
    END

    fseek(bicho_data, (pantalla * 6), 0); //SITUA EL PUNTERO AL COMIENZO DEL BLOQUE DE LA PANTALLA.
    fread(bicho_data, lectura_bichos); //LEE LOS 6 BYTES DE LA PANTALLA Y METE LOS DATOS EN ARRAY 'LECTURA_BICHOS'

    FROM bucle = 0 TO 5;

        SWITCH (lectura_bichos[bucle])

            CASE 201:
                malo_movil(pant, (lectura_bichos[(bucle + 1)]));
                bucle = bucle + 1;
            END

            CASE 202:
                serpiente((lectura_bichos[(bucle + 1)]), (lectura_bichos[(bucle + 2)]));
                bucle = bucle + 2;
            END
     
            CASE 203:
                arana((lectura_bichos[(bucle + 1)]), (lectura_bichos[(bucle + 2)]));
                bucle = bucle + 2;
            END

            CASE 204:
                ciclico((lectura_bichos[(bucle + 1)]), (lectura_bichos[(bucle + 2)]), (lectura_bichos[(bucle + 3)]));
                bucle = bucle + 3;
            END

            DEFAULT:
                break;
            END

        END

    END
     
END


//RUTINA PARA CAMBIAR DE PANTALLA
//ENTRADA EN PANT NUMERO DE PANTALLA

PROCESS cambio(int pant)

PRIVATE

    int tipo;
    int xl;
    int yl;

BEGIN

    signal(Type johnny, s_kill);
    signal(Type malo_movil, s_kill);
    signal(Type serpiente, s_kill);
    signal(Type ciclico, s_kill);
    signal(Type arana, s_kill);
    signal(type letra, s_kill);
    //signal(type p_princesa, s_kill);

    IF ((princesa == false) AND (pant == 5))
        x1p = 2;
        y1p = 2;
        cont3 = ((y1p * 10) + x1p);
        x1p++;
        y1p++;
        x2p = ((x1p*60)-10);
        y2p = ((y1p*60)-10);
    END

    //clear_screen();
    put(graf1, 53, 320, 170);
    mapeado(pant);

    IF ((pant == 34) AND (tesoro == false))
        sound_stop(reloj);
        music_play(m_tesoro, -0);
        signal(type p_bomba, s_kill);
        signal(type p_tiempo, s_sleep);
        tesoro = true;
        put(graf1, 8, 310, 370);
        put(graf1, 92, 320, 170);
        timer[4] = 0;
        WHILE (timer[4] < 320)
            frame;
        END
        rescatado();
        put(graf1, 53, 320, 170);
        signal(type p_tiempo, s_wakeup);
    END
    //p_princesa();
    put(graf1, 999, 320,170);
     
    IF ((llave_verde == false) AND (pant == 15))
        put(graf1, 33, 290, 110);
    END

    IF ((llave_rosa == false) AND (pant == 51))
        put(graf1, 33, 350, 110);
    END

    //pone las letras
    IF (hechizo == 1)
        SWITCH (pant)
            CASE 67:
                IF (baba6 == false)
                    letra(3, 170, 170);
                END
            END

            CASE 130:   
                IF (baba1 == false)
                    letra(0, 530, 110);
                END
            END

            CASE 26:
                IF (baba2 == false)
                    letra(1, 110, 110);
                END
            END

            CASE 27:
                IF (baba5 == false)
                    letra(2, 470, 170);
                END
            END

            CASE 42:
                IF (baba3 == false)
                    letra(0, 170, 170);
                END
            END

            CASE 87:
                IF (baba4 == false)
                    letra(1, 530, 110);
                END
            END

            CASE 118:
                IF (baba7 == false)
                    letra(0, 170, 230);
                END
            END

            CASE 14:
                IF (baba8 == false)
                   letra(1, 530, 110);
                END
            END

        END
    END

    bichos(pant);
    frame;
    johnny(x_mono, y_mono);
    p_tiempo();

END


//SERPIENTE
//PROCESO QUE CREA LA SERPIENTE DE LA VASIJA
//ENTRADAS X e Y

PROCESS serpiente(int xx, int yy)

PRIVATE

BEGIN

    is_serpiente = true;
    canal_serpiente = sound_play(s_serpiente, 0);
    graph = 110;
    x = ((xx * 60) - 10);
    y = ((yy * 60) - 10);
    LOOP
        frame;
        frame;
        frame;
        graph++;
        IF (graph == 116)
           graph = 110;
        END
        IF (sound_is_playing(canal_serpiente) == 0)
            canal_serpiente = sound_play(s_serpiente, 0);
        END
    END

ONEXIT

    is_serpiente = false;

END

PROCESS arana(int xx, int yy)

PRIVATE

BEGIN

    graph = 122;
    x = ((xx * 60) - 10);
    y = ((yy * 60) - 10);
    LOOP
        frame;
        frame;
        frame;
        graph++;
        IF (graph == 126)
            graph = 122;
        END
        IF (pant == 126)
            timer[3] = 0;
            WHILE (timer[3] < 10)
                frame;
            END
        END
    END

END


//ENEMIGOS CICLICOS
//PROCESO PARA CREAR LOS ENEMIGOS QUE SE MUEVEN SIGUENDO UN PATRON
//ENTRADA X e Y

PROCESS ciclico(byte comxx, byte finxx, byte yy)

PRIVATE
    
    int desp;
    int comx;
    int finx;

BEGIN

    desp = 20;
    comx = ((comxx * 60) - 10);
    finx = ((finxx * 60) - 10);
    y = ((yy * 60) - 10);
    x = comx;
    graph = 108;
    LOOP
        IF (desp > 0)
            flags = 0;
        ELSE
            flags = 1;
        END
        frame;
        frame;
        x = x + desp;
        IF (x > (finx - 30))
            desp = -20; 
        END
        IF (x < (comx + 20))
            desp = +20; 
        END
        graph++;
        IF (graph == 110) 
            graph = 108; 
        END
    END

END


//ENEMIGOS MOVILES
//PROCESO PARA CREAR LOS ENEMIGOS QUE SE MUEVEN ALEATORIAMENTE POR LA PANTALLA

PROCESS malo_movil(int pant, byte codigo_b)

PRIVATE

    int x1;
    int y1;
    int xb1;
    int cont;
    int cont2;
    int bucle;
    int codigofin;
    int codigo;

BEGIN

    codigo = codigo_b;
    codigo = rand(1, 3);
    IF (codigo == 1)
        codigo = 108;
        codigofin = 109;
    END
    IF (codigo == 2)
        codigo = 128;
        codigofin = 129;
    END
    IF (codigo == 3)
        codigo = 130;
        codigofin = 132;
    END
    x1 = rand(2, 7);
    IF (pant == 74) 
        x1 = 2; 
    END
    y1 = rand(1, 3);
    IF ((pant == 15) OR (pant == 51))
        y1 = rand(2, 3);
    END
         
    cont2 = ((y1 * 10) + x1);
    WHILE (lectura[cont2] <> 0)
        x1 = rand(1, 8);
        y1 = rand(1, 3);
        IF ((pant == 15) OR (pant == 51))
            y1 = rand(2, 3);
        END
 
        cont2 = ((y1 * 10) + x1);
    END
    x1++;
    y1++;
    x = ((x1 * 60) - 10);
    y = ((y1 * 60) - 10);
    graph = codigo;

    timer[4] = 0;
    WHILE (timer[4] < 50)
        frame;
    END

    LOOP
        cont = rand(1, 30);
        
        xb1 = 50;
        IF ((pant == 15) OR (pant == 51))
            xb1 = 170;
        END 

        IF ((cont == 1) AND (lectura[(cont2 - 1)] == 0) AND (x > 50))
            cont2--;
            flags = 1;
            FROM bucle = 1 TO 3;
                x = x - 20;
                IF (graph < codigofin)
                    graph++;
                ELSE
                    graph = codigo;
                END
                frame;
                frame;
            END
        END

        IF ((cont == 5) AND (lectura[(cont2 + 1)] == 0) AND (x < 590))
            cont2++;
            flags = 0;
            FROM bucle = 1 TO 3;
                x = x + 20;
                IF (graph < codigofin)
                    graph++;
                ELSE
                    graph = codigo;
                END
                frame;
                frame;
            END
        END

        IF ((cont == 10) AND (lectura[(cont2 - 10)] == 0) AND (y > xb1))
            cont2 = cont2 - 10;
            FROM bucle = 1 TO 3;
                y = y - 20;
                IF (graph < codigofin)
                    graph++;
                ELSE
                    graph = codigo;
                END
                frame;
                frame;
            END
        END

        IF ((cont == 15) AND (lectura[(cont2 + 10)] == 0) AND (y < 270))
            cont2 = cont2 + 10;
            FROM bucle = 1 TO 3;
                y = y + 20;
                IF (graph < codigofin)
                    graph++;
                ELSE
                    graph = codigo;
                END
                frame;
                frame;
            END
        END

        frame;

    END

END


//LEE MAPA
//PROCESO PARA CARGAR EN EL ARRAY EL MAPEADO DE LA PANTALLA EN CURSO

PROCESS lee_mapa(int pantalla)

BEGIN

    fseek(file_data, (pantalla * 50), 0); //SITÚA EL PUNTERO AL COMIENZO DEL BLOQUE DE LA PANTALLA.
    fread(file_data, lectura); //LEE LOS 50 BYTES DE LA PANTALLA Y METE LOS DATOS EN ARRAY 'LECTURA'

END //LEE_MAPA


//Proceso FOSO
//Genera la caída en el foso de los cocodrilos

PROCESS foso()

PRIVATE

    int bucle;

BEGIN

     sound_stop(reloj);
     //signal(Type johnny, s_kill);
     //signal(Type malo_movil, s_kill);
     //signal(Type serpiente, s_kill);
     //signal(Type ciclico, s_kill);
     //signal(Type arana, s_kill);
     let_me_alone();
     p_princesa();
     p_prisionero();
     llaverosa();
     llaveverde();
     put(graf1, 53, 320, 170);
     mapeado(122);
     cocodrilo(116, 230);
     cocodrilo(118, 410);

     //provisional
     //signal(Type malo_movil, s_kill);
     //signal(Type serpiente, s_kill);
     //signal(Type ciclico, s_kill);
     //signal(Type arana, s_kill);
     //fin provisional
     
     put(graf1, 999, 320, 170);
     sound_play(s_grito, 0);
     graph = 100;
     x = 320;
     y = 70;
     angle = 360000;
     FROM bucle = 1 TO 12;
        frame;
        frame;
        y = y + 15;
        angle = angle - 45000;
        IF (angle < 0)
            angle = 360000;
        END
     END
     graph = 99;
     sound_play(s_chapuzon, 0);
     timer[2] = 0;
     WHILE (timer[2] < 150)
        frame;
     END
     signal(type cocodrilo, s_kill);
     muerte();

END


//MUERTE proceso que mata una vida al chocar contra objetos malignos.

PROCESS muerte()

PRIVATE

BEGIN

    vidas--;
    let_me_alone();
    IF (prisionero == true)
        p_prisionero();
    END
    p_princesa();
    bomba = false;
    pant_bomba = 200;
    sound_stop(reloj);
    put(graf1, 53, 320, 170);
    IF (vidas > 0)
        put(graf1, 85, 320, 170);
        SWITCH (vidas)
            CASE 4:
                put(graf1, 154, 530, 370);
            END
            CASE 3:
                put(graf1, 153, 530, 370);
            END
            CASE 2:
                put(graf1, 152, 530, 370);
            END
            CASE 1:
                put(graf1, 151, 530, 370);
            END //CASE 1:
        END 

        IF ((llave_rosa == true) OR (llave_verde == true))
            llaverosa();
            llaveverde();
        END

        timer[4] = 0;
        music_play(m_muerte, 0);
        WHILE (timer[4] < 350)
            frame;
        END

        IF ((llave_rosa == false) OR (llave_verde == false))
            llaverosa();
            llaveverde();
        END
        p_prisionero();
        cambio (pant);

        signal(type muerte ,s_kill);
    ELSE
        music_play(m_fmuerte, 0);
        put(graf1, 150, 530, 370);
        put(graf1, 86,320, 140);
        put(graf1, 87,320, 180);
        timer[4] = 0;
        WHILE (timer[4] < 800)
            frame;
        END
        menu();
    END

END


//JOHNNNY
//PROCESO QUE CONTROLA A JOHNNY JONES

PROCESS johnny(x1, y1)

PRIVATE

    int cont2;
    int bucle;
    int tope_y;
    int sonidito; // @TODO bool?
        
BEGIN

    cont2 = ((y1 * 10) + x1);
    y1++;
    x1++;
    graph = 106;
    x = ((x1 * 60) - 10);
    y = ((y1 * 60) - 10);
    z = -510;
    frame;
    
    LOOP

        jkeys_controller();

        IF (collision(Type malo_movil)) 
            sonidito = sound_play(s_bocado, 0); 
            muerte(); 
            break; 
        END
        IF (collision(Type serpiente)) 
            sonidito = sound_play(s_bocado, 0); 
            muerte(); 
            break; 
        END
        IF (collision(Type ciclico)) 
            sonidito = sound_play(s_bocado, 0); 
            muerte(); 
            break; 
        END
        IF (collision(Type arana)) 
            sonidito = sound_play(s_bocado, 0); 
            muerte(); 
            break; 
        END

        IF (key(_esc) || jkeys_state[_JKEY_SELECT])
            escape(0);
        END

        //BOMBA

        IF (key(_control) || key(_space) | jkeys_state[_JKEY_A])
            IF ((bomba == false) AND (bombas > 0))
                bombas--;
                pant_bomba = pant;
                p_bomba(x, y);
            END
        END 

        //fin detección objetos malignos

        // Cambio de pantalla a la izquierda.

        IF ((key(_left) || key(_o) || jkeys_state[_JKEY_LEFT]) AND (x < 60) AND (pant == 123))
            escalera(0, 83);
        END

        IF ((key(_left) || key(_o) || jkeys_state[_JKEY_LEFT]) AND (x < 60)) //IF cambio de pantalla
            pant--;
            x_mono = 9;
            y_mono = (y / 60);
            cambio(pant);
        END

        //detecta foso
        IF ((key(_left) || key(_o) || jkeys_state[_JKEY_LEFT]) AND (lectura[cont2 - 1] == 50))
            foso();
        END

        IF ((key(_left) || key(_o) || jkeys_state[_JKEY_LEFT]) AND (lectura[(cont2 - 1)] == 0) AND (x > 50))
            graph = 100;
            cont2--;
            pasos = sound_play(s_pasos, 0);
            FROM bucle = 1 TO 3;
                x = x - 20;
                IF (graph == 100)
                    graph++;
                ELSE
                    graph--;
                END
                frame;
            END
        END

        // Cambio de pantalla a la derecha.
        IF ((key(_right) || key(_p) || jkeys_state[_JKEY_RIGHT]) AND (x > 570)) //IF cambio de pantalla
            pant++;
            x_mono = 0;
            y_mono = (y / 60);
            cambio(pant);
        END

        //detecta foso
        IF ((key(_right) || key(_p) || jkeys_state[_JKEY_RIGHT]) AND (lectura[cont2 + 1] == 50))
            foso();
        END


        IF ((key(_right) || key(_p) || jkeys_state[_JKEY_RIGHT]) AND (lectura[(cont2 + 1)] == 0) AND (x < 570))
            graph = 102;
            cont2++;
            pasos = sound_play(s_pasos, 0);
            FROM bucle =1 TO 3;
                x = x + 20;
                IF (graph == 102)
                    graph++;
                ELSE
                    graph--;
                END
                frame;
            END
        END


        tope_y = 60;
        IF ((llave_verde == false) AND (pant == 15))
            tope_y = 170;
        END
        IF ((llave_rosa == false) AND (pant == 51))
            tope_y = 170;
        END


        // Cambio de pantalla arriba.
        IF ((key(_up) || key(_q) || jkeys_state[_JKEY_UP]) AND (lectura[(cont2 - 10)] == 29 OR (lectura[(cont2 - 10)] == 44)))
            pant = pant - 15;
            x_mono=(x / 60);
            y_mono = 4;
            cambio(pant);
        END

        IF ((key(_up) || key(_q) || jkeys_state[_JKEY_UP]) AND (y < 60) AND (pant == 55))
            escalera(0, 32);
        END

        IF ((key(_up) || key(_q) || jkeys_state[_JKEY_UP]) AND (y < 60) AND (pant == 32))
            escalera(1, 55);
        END

        IF ((key(_up || key(_q) || jkeys_state[_JKEY_UP])) AND (y < 60) AND (pant == 65))
            escalera(1, 105);
        END

        IF ((key(_up) || key(_q) || jkeys_state[_JKEY_UP]) AND (y < 60)) //IF cambio de pantalla
            pant = pant - 15;
            x_mono = (x / 60);
            y_mono = 4;
            cambio(pant);
        END

        //detecta foso
        IF ((key(_up) || key(_q) || jkeys_state[_JKEY_UP]) AND (lectura[cont2 - 10] == 50))
            foso();
        END

        IF ((key(_up) || key(_q) || jkeys_state[_JKEY_UP]) AND (lectura[(cont2 - 10)] == 0) AND (y > tope_y))
            graph = 104;
            cont2 = cont2 - 10;
            pasos = sound_play(s_pasos, 0);
            FROM bucle = 1 TO 3;
                y=y-20;
                IF (graph==104)
                    graph++;
                ELSE
                    graph--;
                END
                frame;
            END
        END

        // Cambio de pantalla abajo.

        IF ((key(_down) || key(_a) || jkeys_state[_JKEY_DOWN]) AND (y > 270) AND (pant == 83))
            escalera(1, 123);
        END

        IF ((key(_down) || key(_a) || jkeys_state[_JKEY_DOWN]) AND (y > 270) AND (pant == 105))
            escalera(0, 65);
        END

        IF ((key(_down) || key(_a) || jkeys_state[_JKEY_DOWN]) AND (y > 270) AND (pant == 93))
            escalera(0, 96);
        END

        IF ((key(_down) || key(_a) || jkeys_state[_JKEY_DOWN]) AND (y > 270) AND (pant == 96))
            escalera(1, 93);
        END

        IF ((key(_down) || key(_a) || jkeys_state[_JKEY_DOWN]) AND (y > 270)) //IF cambio de pantalla
            pant = pant + 15;
            x_mono = (x / 60);
            y_mono = 0;
            IF ((pant == 15) OR (pant == 51))
                y_mono=1; 
            END
            cambio(pant);
        END

        //detecta foso
        IF ((key(_down) || key(_a) || jkeys_state[_JKEY_DOWN]) AND (lectura[cont2 + 10] == 50))
            foso();
        END


        IF ((key(_down) || key(_a) || jkeys_state[_JKEY_DOWN]) AND (lectura[(cont2 + 10)] == 0) AND (y < 270))
            graph = 106;
            cont2 = cont2 + 10;
            pasos = sound_play(s_pasos, 0);
            FROM bucle = 1 TO 3;
                y=y+20;
                IF (graph==106)
                    graph++;
                ELSE
                    graph--;
                END
                frame;
            END
        END

        frame;

    END

END


//PROCESO ESCALERA
//ENTRADA D=DIRECCIÓN: 0 SUBE 1 BAJA
//PANTALLA DESTINO

PROCESS escalera(int d, int pant_dest)

PRIVATE

    int bucle;
    int inc_x;
    int inc_y;
    int temporal;

BEGIN

    pant = 200;
    signal(Type johnny, s_kill);
    signal(Type malo_movil, s_kill);
    signal(Type serpiente, s_kill);
    signal(Type ciclico, s_kill);
    signal(Type arana, s_kill);
    put(graf1, 53, 320, 170);
    mapeado(120);
    //provisional
    signal(Type malo_movil, s_kill);
    signal(Type serpiente, s_kill);
    signal(Type ciclico, s_kill);
    signal(Type arana, s_kill);
    //fin provisional
    put(graf1, 999, 320, 170);
    SWITCH (d)
        CASE 0:
            graph = 100;
            x = 410;
            y = 230;
            inc_x = -60;
            inc_Y = -60;
       END
       CASE 1:
            graph = 102;
            x = 230;
            y = 50;
            inc_x = 60;
            inc_Y = 60;
       END
    END
        
    FROM bucle = 1 TO 4;
        timer[2] = 0;
        WHILE (timer[2] < 30)
            temporal = sound_play(s_pasos, 0);
            frame;
        END
        x = x + inc_x;
        y = y + inc_y;
        sound_stop(temporal);
    END
     
    SWITCH (pant_dest)
        CASE 32:
            x_mono = 6;
            y_mono = 0;
        END
        CASE 55:
            x_mono = 5;
            y_mono = 0;
        END
        CASE 65:
            x_mono = 7;
            y_mono = 0;
        END
        CASE 83:
            x_mono = 5;
            y_mono = 4;
        END
        CASE 93:
            x_mono = 6;
            y_mono = 4;
        END
        CASE 96:
            x_mono = 5;
            y_mono = 4;
        END
        CASE 105:
            x_mono = 5;
            y_mono = 4;
        END
        CASE 123:
            x_mono = 0;
            y_mono = 3;
        END 
    END

    pant = pant_dest;
    cambio(pant_dest);

END


//PROCESO PRISIONERO

PROCESS p_prisionero()

PRIVATE

    int tempo;

BEGIN

    LOOP

        IF (collision(Type johnny))
            prisionero = true;
            let_me_alone();
            graph = 0;
            x = 1000;
            y = 1000;
            frame;
            put(graf1, 53, 320, 170);
            put(graf1, 89,320, 170);
            music_play(m_tesoro, 0);
            timer[4] = 0;
            WHILE (timer[4] < 320)
                frame;
            END //WHILE
            rescatado();
            cambio(pant);
        END

        IF (prisionero == true)
            x = 250;
            y = 370;
            graph = 126;
            tempo = rand(1, 100);
            IF (tempo < 10)
                graph = 126;
            ELSE
                graph = 127;
            END
            frame;
        END

        IF (prisionero == false)

            IF (pant != 126)
                graph = 0; 
                x = 1000; 
                frame; 
            END

            IF (pant == 126)
                x = 470;
                y = 230;
                graph = 127;
                tempo = rand(1, 100);
                IF (tempo < 10)
                    graph = 126;
                ELSE
                    graph = 127;
                END
                frame;
            END

        END

    END

END



//PROCESO CREA BANNER DE CREDITOS
PROCESS banner()

PRIVATE

BEGIN
        
    graph = 83;
    x = 1500;
    y = 445;

    LOOP
        x = x - 3;
        IF (x < -1050)
            x = 1500;
        END
        frame;

    END

END


//MARCADORES

PROCESS marcador(int valor, xn, yn)

PRIVATE

    int bucle;
    string cadena;
    string v1;
    int a;

BEGIN

    cadena = itoa(valor);
    a = len(cadena);
    FROM bucle = 0 TO (len(cadena) - 1);
        v1 = substr(cadena, bucle, 1);
        put(graf1, (asc (v1) + 102), xn, yn);
        xn = xn + 20;
        a--;
        frame;
    END

END //PROCESS marcador(int valor);

//proceso tiempo

PROCESS p_tiempo()

PRIVATE

BEGIN

    //marcador(tiempo, 50, 380);
    LOOP

        timer[7] = 0;
        WHILE (timer[7] < 60)
            frame;
        END

        tiempo--;

        IF (tiempo > 999)
            marcador(tiempo, 50, 380);
        END

        IF ((tiempo < 1000) AND (tiempo > 99))
            put(graf1, 150, 50, 380);
            marcador(tiempo, 70, 380);
        END

        IF ((tiempo < 100) AND (tiempo > 9))
            put(graf1, 150, 50, 380);
            put(graf1, 150, 70, 380);
            marcador(tiempo, 90, 380);
        END

        IF (tiempo < 10)
            put(graf1, 150, 50, 380);
            put(graf1, 150, 70, 380);
            put(graf1, 150, 90, 380);
            marcador(tiempo, 110, 380);
        END

        IF (tiempo <= 0)
            let_me_alone();
            sound_stop(reloj);
            music_play(m_fmuerte, 0);
            put(graf1, 53, 320, 170);
            put(graf1, 91,320, 140);
            put(graf1, 87,320, 180);
            timer[4] = 0;
            WHILE (timer[4] < 800)
                frame;
            END
            menu();
        END

    END
        
END

//proceso cocodrilo

PROCESS cocodrilo(int sprite, int x1)

PRIVATE

    int aleatorio;

BEGIN

    graph = sprite;
    x = x1;
    y = 230;
    LOOP
        aleatorio = rand(1, 100);
        IF (aleatorio < 10)
            graph = sprite;
        ELSE
            graph = sprite + 1;
        END
        frame;
    END
     
END


PROCESS p_princesa()

PRIVATE

    int tempo;
    int cont;
    int bucle;
 
BEGIN

    //x1p=2;
    //y1p=2;
    //cont3=((y1p*10)+x1p);
    //x1p++;
    //y1p++;
    //x2p=((x1p*60)-10);
    //y2p=((y1p*60)-10);

    LOOP

        IF (collision(Type johnny))

            princesa = true;
            graph = 99;
            let_me_alone();
            put(graf1, 53, 320, 170);
            put(graf1, 94,320, 170);
            music_play(m_tesoro, 0);
            timer[4] = 0;
            WHILE (timer[4] < 320)
                frame;
            END
            p_prisionero();
            rescatado();
            cambio(pant);
        END

        IF (princesa == true)
            x = 190;
            y = 370;
            graph = 120;
            tempo = rand(1, 100);
            IF (tempo < 10)
                graph = 120;
            ELSE
                graph = 121;
            END
            frame;
        END

        IF (princesa == false)

            IF (pant != 5)
                graph = 0;
                x = 1000;
                frame;
            END

            IF (pant == 5)
                graph = 121;
                cont = rand(1, 30);
                x = x2p;
                y = y2p;

                IF ((cont == 1) AND (lectura[(cont3 - 1)] == 0) AND (x > 50))
                    cont3--;
                    FROM bucle = 1 TO 3;
                        x = x - 20;
                        x2p = x2p - 20;
                        IF (graph == 120)
                            graph = 121;
                        ELSE
                            graph = 120;
                        END
                        frame;
                        frame;
                    END
                END

                IF ((cont == 5) AND (lectura[(cont3 + 1)] == 0) AND (x < 590))
                    cont3++;
                    FROM bucle = 1 TO 3;
                        x = x + 20;
                        x2p = x2p + 20;
                        IF (graph == 120)
                            graph = 121;
                        ELSE
                            graph = 120;
                        END
                        frame;
                        frame;
                    END
                END

                IF ((cont == 10) AND (lectura[(cont3 - 10)] == 0) AND (y > 50))
                    cont3 = cont3 - 10;
                    FROM bucle = 1 TO 3;
                        y = y - 20;
                        y2p = y2p - 20;
                        IF (graph == 120)
                            graph = 121;
                        ELSE
                            graph = 120;
                        END
                        frame;
                        frame;
                    END
                END

                IF ((cont == 15) AND (lectura[(cont3 + 10)] == 0) AND (y < 270))
                    cont3 = cont3 + 10;
                    FROM bucle = 1 TO 3;
                        y = y + 20;
                        y2p = y2p + 20;
                        IF (graph == 120)
                            graph = 121;
                        ELSE
                            graph = 120;
                        END
                        frame;
                        frame;
                    END
                END

                frame;

            END

        END

    END

END

//PROCESO LLAVE_ROSA

PROCESS llaverosa()

PRIVATE

    int tempo;
    int sonido;

BEGIN

    LOOP

        IF (collision(Type johnny))
            llave_rosa = true;
            sonido = music_play(m_premio, 0);
            graph = 99;
        END

        IF (llave_rosa == true)
            IF (princesa == false)
                x = 190;
                y = 370;
            ELSE 
                x = 1000;
                y = 1000;
            END
            graph = 97;
            frame;
        END


        IF (llave_rosa == false)

            IF (pant != 132)
                graph = 0;
                x = 1000;
                frame;
            END

            IF (pant == 132)
                x = 410;
                y = 230;
                graph = 97;
                frame;

            END

        END

    END

END


//PROCESO LLAVE_VERDE

PROCESS llaveverde()

PRIVATE

    int tempo;
    int sonido;

BEGIN

    LOOP

        IF (collision(Type johnny))
            llave_verde = true;
            sonido = music_play(m_premio, 0);
            graph = 99;
        END

        IF (llave_verde == true)
            IF (tesoro == false)
                x = 310;
                y = 370;
            ELSE
                x = 1000;
                y = 1000;
            END
            z = -512;
            graph = 96;
            frame;
        END

        IF (llave_verde == false)

            IF (pant != 13)
                graph = 0;
                x = 1000;
                frame; 
            END

            IF (pant == 13)
                x = 230;
                y = 170;
                graph = 96;
                frame;
            END

        END

    END

END


//PROCESO ESCAPE

PROCESS escape(int tipo)

PRIVATE

    int opcion = 0;

BEGIN
        
    timer_pausa_bomba = timer[0];

    signal(type johnny, s_freeze);
    signal(type p_bomba, s_freeze);
    signal(type malo_movil, s_freeze);
    signal(type ciclico, s_freeze);
    signal(type serpiente, s_freeze);
    signal(type arana, s_freeze);
    signal(type p_prisionero, s_freeze);
    signal(type p_princesa, s_freeze);
    signal(type p_tiempo, s_freeze);
    signal(type llaveverde, s_freeze);
    signal(type llaverosa, s_freeze);
    signal(type banner, s_freeze);
    sound_stop(canal_serpiente);
    sound_stop(reloj);
        
        
    LOOP
        z = -512;
        SWITCH (tipo)
        
            CASE 0:
                x = 320;
                y = 220;
                IF (opcion == 0)
                    graph = 162;
                ELSE
                    graph = 161;
                END
                IF ((key(_left) || key(_o) || jkeys_state[_JKEY_LEFT]) AND (opcion == 0))
                    opcion = 1;
                END
                IF ((key(_right) || key(_p) || jkeys_state[_JKEY_RIGHT]) AND (opcion == 1))
                    opcion = 0;
                END
                IF ((key(_control) || key(_space) || jkeys_state[_JKEY_A]) AND (opcion == 0))
                    WHILE (key(_control) || key(_space) || jkeys_state[_JKEY_A])
                        frame;
                    END
                    signal(type johnny, s_wakeup);
                    signal(type p_bomba, s_wakeup);
                    signal(type malo_movil, s_wakeup);
                    signal(type ciclico, s_wakeup);
                    signal(type serpiente, s_wakeup);
                    signal(type arana, s_wakeup);
                    signal(type p_prisionero, s_wakeup);
                    signal(type p_princesa, s_wakeup);
                    signal(type p_tiempo, s_wakeup);
                    signal(type llaveverde, s_wakeup);
                    signal(type llaverosa, s_wakeup);
                    IF (is_bomba_mecha == true)
                        timer[0] = timer_pausa_bomba;
                        sound_play(s_reloj);
                    END
                    IF (is_serpiente)
                        sound_play(s_serpiente);
                    END
                    signal(type escape, s_kill);
                END
                IF ((key(_control) || key(_space) || jkeys_state[_JKEY_A]) AND (opcion == 1))
                    WHILE (key(_control) || key(_space) || jkeys_state[_JKEY_A])
                        frame;
                    END
                    menu();
                END
            
            END //CASE 0:

            CASE 1:
                music_pause();
                signal(type menu, s_freeze);
                x = 320;
                y = 220;
                IF (opcion == 0)
                    graph = 164;
                ELSE
                    graph = 163;
                END
                IF ((key(_left) || key(_o) || jkeys_state[_JKEY_LEFT]) AND (opcion == 0))
                    opcion = 1;
                END
                IF ((key(_right) || key(_p) || jkeys_state[_JKEY_RIGHT]) AND (opcion == 1))
                    opcion = 0;
                END
                IF ((key(_control) || key(_space) || jkeys_state[_JKEY_A]) AND (opcion == 0))
                    WHILE (key(_control) || key(_space) || jkeys_state[_JKEY_A])
                        frame;
                    END
                    signal(type serpiente, s_wakeup);
                    signal(type arana, s_wakeup);
                    signal(type banner, s_wakeup);
                    signal(type menu, s_wakeup);
                    music_resume();
                    signal(type escape, s_kill);
                END
                IF ((key(_control) || key(_space) || jkeys_state[_JKEY_A]) AND (opcion == 1))
                    fclose(file_data);
                    exit("", 0);
                END

            END

        END

        frame;
        
    END
        
END


//proceso conseguido ahora a buscar el hechizo

PROCESS rescatado()

PRIVATE
        
BEGIN

    IF ((prisionero == true) AND (princesa == true) AND (tesoro == true) AND (hechizo == 0))
        hechizo=1;
        signal(Type cambio, s_kill);
        signal(type johnny, s_kill);
        signal(type arana, s_kill);
        signal(type serpiente, s_kill);
        signal(type p_bomba, s_sleep);
        signal(type p_prisionero, s_freeze);
        sound_stop(reloj);
        signal(type p_tiempo, s_freeze);
        signal(type malo_movil, s_kill);
        signal(type ciclico, s_kill);
        put(graf1, 53, 320, 170);
        put(graf1, 169, 320, 140);
        put(graf1, 170, 320, 180);
        music_play(m_tesoro, 0);
        timer[4] = 0;
        WHILE (timer[4] < 320)
            frame;
        END
        signal(type p_bomba, s_wakeup);
        sound_play(s_reloj);
        signal(type p_tiempo, s_wakeup);
        signal(type p_prisionero, s_wakeup);
        p_princesa();
        pant_bomba = 200;
        cambio(pant);
    END
     
END


//proceso letra

PROCESS letra(int tipo, int x1, int y1)

PRIVATE

    int sonido;

BEGIN

    LOOP
        x = x1;
        y = y1;
        z = -510;
        graph = (tipo + 165);
        frame;

        IF (collision(type johnny))

            SWITCH (tipo)
                //letra B
                CASE 0:
                    IF ((babal1 == false) AND (babaliba == 0))
                        babaliba++;
                        babal1 = true;
                        IF (pant == 130) 
                            baba1 = true; 
                        END
                        IF (pant == 42) 
                            baba3 = true; 
                        END
                        IF (pant == 118) 
                            baba7 = true; 
                        END
                        put(graf1,165, 110, 450);
                        sonido = music_play(m_premio, 0);
                        signal(type letra, s_kill);
                    END

                    IF ((babal3 == false) AND (babaliba == 2))
                        babaliba++;
                        babal3 = true;
                        IF (pant == 130)  
                            baba1 = true; 
                        END
                        IF (pant == 42)   
                            baba3 = true; 
                        END
                        IF (pant == 118)  
                            baba7 = true; 
                        END
                        put(graf1, 165, 230, 450);
                        sonido = music_play(m_premio, 0);
                        signal(type letra, s_kill);
                    END

                    IF ((babal7 == false) AND (babaliba == 6))
                        babaliba++;
                        babal7 = true;
                        IF (pant == 130) 
                            baba1 = true; 
                        END
                        IF (pant == 42) 
                            baba3 = true; 
                        END
                        IF (pant == 118) 
                            baba7 = true; 
                        END
                        put(graf1, 165, 470, 450);
                        sonido = music_play(m_premio, 0);
                        signal(type letra, s_kill);
                    END

                END

                //letra A
                CASE 1:
                    IF ((babal2 == false) AND (babaliba == 1))
                        babaliba++;
                        babal2 = true;
                        IF (pant == 26) 
                            baba2 = true; 
                        END
                        IF (pant == 87) 
                            baba4 = true; 
                        END
                        IF (pant == 14) 
                            baba8 = true; 
                        END
                        put(graf1, 166, 170, 450);
                        sonido = music_play(m_premio, 0);
                        signal(type letra, s_kill);
                    END

                    IF ((babal4 == false) AND (babaliba == 3))
                        babaliba++;
                        babal4 = true;
                        IF (pant == 26) 
                            baba2 = true; 
                        END
                        IF (pant == 87) 
                            baba4 = true; 
                        END
                        IF (pant == 14) 
                            baba8 = true; 
                        END
                        put(graf1, 166, 290, 450);
                        sonido = music_play(m_premio, 0);
                        signal(type letra, s_kill);
                    END //IF (babal4 == false)

                    IF ((babal8 == false) AND (babaliba == 7))
                        babaliba++;
                        babal8 = true;
                        put(graf1, 166, 530, 450);
                        sonido = music_play(m_premio, 0);
                        let_me_alone();
                        sound_stop(reloj);
                        graph = 99;
                        x = 1000;
                        y = 1000;
                        put(graf1, 53, 320, 170);
                        put(graf1, 173, 320, 100);
                        put(graf1, 171, 320, 140);
                        marcador((2000 - tiempo), 280, 180);
                        put(graf1, 172, 320, 220);
                        p_princesa();
                        p_prisionero();
                        music_play(m_fbien, 0);
                        timer[4] = 0;
                        WHILE (timer[4] < 1200)
                            frame;
                        END
                        menu();
                    END
                END

                //letra L
                CASE 2:
                    IF ((babal5 == false) AND (babaliba == 4))
                        babaliba++;
                        babal5 = true;
                        baba5 = true;
                        put(graf1, 167, 350, 450);
                        sonido = music_play(m_premio, 0);
                        signal(type letra, s_kill);
                    END
                END

                //letra I
                CASE 3:
                    IF ((babal6 == false) AND (babaliba == 5))
                        babaliba++;
                        babal6 = true;
                        baba6 = true;
                        put(graf1, 168, 410, 450);
                        sonido = music_play(m_premio, 0);
                        signal(type letra, s_kill);
                    END
                END

            END

        END

    END
        
END

PROCESS set_all_sounds_volume(int volume)

BEGIN

    sound_set_volume(s_explosion, volume);
    sound_set_volume(s_reloj, volume);
    sound_set_volume(s_serpiente, volume);
    sound_set_volume(s_chapuzon, volume);
    sound_set_volume(s_grito, volume);
    sound_set_volume(s_pasos, volume);
    sound_set_volume(s_bocado, volume);

END

PROCESS splash()

PRIVATE

    int splashScreen;

BEGIN

    region_define(1, 0, 0, 640, 480);
    splashScreen = map_load("gfx/splash.png");
    xput(file, splashScreen, 320, 240, 0, 100, 0, region);
    frame(5000);
    fade_off(1000);
    WHILE (fade_info.fading)
        frame; 
    END
    clear_screen();
    fade_on(0);
    menu();

END
