// -----------------------------------------
// BABALIBA (C) 1984 Dinamic (2004) remake
// Programa: Miguel A. García Prada
// Gráficos: Davit Masiá Coscollar
// Música  & FX: Federico J. Álvarez Valero
// -----------------------------------------


Program Babaliba;

Const
    pant_inicio=74;
    h_bloque=60;
    w_bloque=60;

Global

        baba1;
        baba2;
        baba3;
        baba4;
        baba5;
        baba6;
        baba7;
        baba8;
        babal1;
        babal2;
        babal3;
        babal4;
        babal5;
        babal6;
        babal7;
        babal8;
        hechizo;
        babaliba;
        
        cont3;
        x1p;
        y1p;
        x2p;
        y2p;
        prisionero;
        princesa;
        tesoro;
        pant;
    temp;
    file_data;
        bicho_data;
    byte vidas;
    byte bombas;
        bomba; //si hay bomba activa=true
        byte pant_bomba=200; //pantalla en la que se coloca la bomba
        explosion; //si explosionó true
    tiempo;
    graf1;
    Byte lectura[49];
        Byte lectura_bichos[5];
        x_mono;
        y_mono;
        llave_verde;
        llave_rosa;

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
        
// COMIENZO DEL PROGRAMA

Begin

Full_screen=1;
set_title ("Babaliba Remake");
Graph_mode = mode_16bits;
set_mode(m640x480);
set_fps (30, 4);
SET_WAV_VOLUME (-1, 64 );
set_song_volume (64);
graf1=load_fpg ("graf01.fpg") ;
file_data=fopen ("datos_mapa.dat", O_READ); //ABRIMOS EL FICHERO QUE CONTIENE EL MAPEADO
bicho_data=fopen ("datos_bichos.dat", O_READ); //ABRIMOS EL FICHERO QUE CONTIENE LOS BICHOS

//sonidos

         s_explosion=load_wav("sound/bomba_exp.wav");
         s_reloj=load_wav("sound/siseo_bomba.wav");
         s_serpiente=load_wav("sound/serpiente.wav");
         s_chapuzon=load_wav("sound/chapuzon.wav");
         s_grito=load_wav("sound/grito.wav");
         s_pasos=load_wav("sound/pasos.wav");
         s_bocado=load_wav("sound/bocado.wav");
         
         m_menu=load_song("sound/menu.ogg");
         m_muerte=load_song("sound/muerte.ogg");
         m_tesoro=load_song("sound/tesoro.ogg");
         m_fmuerte=load_song("sound/fin_muerte.ogg");
         m_fbien=load_song("sound/fin_bien.ogg");
         m_premio=load_song("sound/premio.ogg");

menu();

end //begin

// FINAL DEL PROGRAMA

process menu()

        begin
        x1p=2;
        y1p=2;
        cont3=((y1p*10)+x1p);
        x1p++;
        y1p++;
        x2p=((x1p*60)-10);
        y2p=((y1p*60)-10);
        llave_verde=false;
        llave_rosa=false;

        vidas=5;
        bombas=20;
        prisionero=false;
        princesa=false;
        tesoro=false;
        bomba=false;
        explosion=false;
        tiempo=2000;
        pant=74;
        x_mono=7;
        y_mono=2;


        baba1=false;
        baba2=false;
        baba3=false;
        baba4=false;
        baba5=false;
        baba6=false;
        baba7=false;
        baba8=false;
        babal1=false;
        babal2=false;
        babal3=false;
        babal4=false;
        babal5=false;
        babal6=false;
        babal7=false;
        babal8=false;
        hechizo=0;
        babaliba=0;

        let_me_alone();
        play_song(m_menu, -1);
    put (graf1, 84, 320,240);
        put (graf1, 2, 50,230);
        put (graf1, 79, 590,50);
        banner();
        SET_WAV_VOLUME (-1, 0 );
        serpiente (1,3);
        stop_wav(canal_serpiente);
        arana(10,2);
    Loop
    If (key(_space)) clear_screen(); stop_song(); stop_wav(canal_serpiente); signal (type banner, s_kill); signal (type serpiente, s_kill); signal (type arana, s_kill); Break; End
        If (key(_esc)) escape(1); end
    Frame;
    End


//coloca interfaz
put (graf1, 52, 320,240);
put (graf1, 93, 320,450);
put (graf1, 155, 530,370);
put (graf1, 150, 400,370);
put (graf1, 152, 380,370);
SET_WAV_VOLUME (-1, 64 );
mapeado (pant);
put (graf1, 999, 320,170);
bichos (pant);
johnny(x_mono,y_mono);
prisionero();
tiempo();
princesa();
llaverosa();
llaveverde();
signal (type menu, s_kill);



end //process menu



// MAPEADOR
// ESTE PROCESO CREA UN MAPA DE PANTALLA EN BLANCO Y COLOCA LOS BLOQUES DE GRAFICOS SEGÚN LEA DEL ARCHIVO DE DATOS DE PANTALLA.
// COMO ENTRADA SOLO NECESITA EL NUMERO DE PANTALLA QUE CORRESPONDA, SIENDO '0' LA PANTALLA SUPERIOR IZQUIERDA Y NUMERANDOSE
// EN EL SENTIDO USUAL DE LECTURA.

Process mapeado(Int pant)

Private

    x1=30;
    y1=30;
    puntero=0;
    bucle;

Begin
    map_clear (graf1, 999, 0); //LIMPIAMOS EL GRAFICO EN EL QUE VAMOS A 'TILEAR'
    lee_mapa(pant);
    From bucle=0 To 49 //COMIENZA EL BUCLE PARA VOLCAR LOS BLOQUES GRAFICOS EN LA PANTALLA.
    If (lectura[puntero]>0 and lectura[puntero]!=99) map_put (graf1, 999, lectura[puntero], x1, y1); End //COLOCA EL BLOQUE EN LAS COORDENADAS CORRESPONDIENTES SIEMPRE QUE NO SEA '0'
    x1=x1+w_bloque; //INCREMENTA LA COORDENADA HORIZONTAL PARA DIBUJAR EL PROXIMO BUCLE.
    If (x1>580) //SI LLEGAMOS AL FINAL DE LA PANTALLA PONEMOS BAJAMOS UNA FILA Y RESTAURAMOS 'X' AL COMIENZO.
    x1=30;y1=y1+w_bloque;
    End //if (x1
    puntero++; //INCREMENTAMOS EL PUNTERO QUE NOS DICE QUE BLOQUE HAY QUE IMPRIMIR.
    End //for (bucle

End //MAPEADO


//PROCESO BOMBA
//COLOCA LA BOMBA EN PANTALLA Y LA HACE EXPLOTAR
//ENTRADA X e Y

Process bomba(int x, int y)

Private

       int grafico=24;

Begin
     z=-511;
     if (bombas>9)
     marcador (bombas, 380,370);
     else
     put (graf1, 160, 380,370);
     marcador (bombas, 400,370);
     end //if (bombas>9)

     bomba=true;
     pant_bomba=pant;
     timer[0]=0;
     reloj=play_wav(s_reloj, 0);
     while (timer[0]<500)

     if (pant==pant_bomba)
     graph=grafico;
     else
     graph=99;
     end //if (pant==pant_bomba)
     frame;

     timer[1]=0;
     while ((timer[1]<10) and (pant_bomba==pant))
     frame;
     end //while
     grafico++;
     if (grafico==28)
     grafico=24;
     end //if (grafico==28)

     end //while

     explosion=true;
     stop_wav(reloj);
     play_wav(s_explosion, 0);
     
     graph=0;
     if (pant_bomba==pant)
     timer[4]=0;
     while (timer[4]<20)
     frame;
     end //ehile
     muerte();
     end //if (pant_bomba==pant)
     
     if ((pant_bomba==126) and (prisionero==false))
     let_me_alone();
     play_song(m_fmuerte, 0);
     put (graf1, 53, 320,170);
     put (graf1, 88,320,140);
     put (graf1, 87,320,180);
     timer[4]=0;
     while (timer[4]<800)
     frame;
     end //while
     menu();
     end //if ((pant_bomba==126) and (prisionero==false))
     
     if ((pant_bomba==5) and (princesa==false))
     let_me_alone();
     play_song(m_fmuerte, 0);
     put (graf1, 53, 320,170);
     put (graf1, 95,320,140);
     put (graf1, 87,320,180);
     timer[4]=0;
     while (timer[4]<800)
     frame;
     end //while
     menu();
     end //if ((pant_bomba==5) and (princesa==false))
     
     timer[0]=0;
     
     while (timer[0]<1000)
     frame;
     end //while

     explosion=false;
     bomba=0;

     if (pant_bomba==pant)
     bichos(pant);
     end

     pant_bomba=200;
     bomba=false;
     signal (type bomba, s_kill);
     
     



End //Process bomba(int x, int y)

//PROCESO BICHOS
//SIRVE PARA PONER LOS BICHOS EN CADA PANTALLA
//ENTRADA EL NUMERO DE PANTALLA

Process bichos(int pantalla)

Private

     int bucle;

Begin


     if ((explosion==true) and (pant_bomba==pant))
     signal (type bichos, s_kill);
     end

     fseek(bicho_data, (pantalla*6), 0); //SITUA EL PUNTERO AL COMIENZO DEL BLOQUE DE LA PANTALLA.
     fread(bicho_data, lectura_bichos); //LEE LOS 6 BYTES DE LA PANTALLA Y METE LOS DATOS EN ARRAY 'LECTURA_BICHOS'

     from bucle = 0 to 5

     switch (lectura_bichos[bucle])

     case 201:
                malo_movil(pant, (lectura_bichos[(bucle+1)]));
                bucle=bucle+1;
     end // case 201

     case 202:
                 serpiente((lectura_bichos[(bucle+1)]), (lectura_bichos[(bucle+2)]));
                 bucle=bucle+2;
     end // case 202
     
     case 203:
                 arana((lectura_bichos[(bucle+1)]), (lectura_bichos[(bucle+2)]));
                 bucle=bucle+2;
     end // case 202

     case 204:
                 ciclico((lectura_bichos[(bucle+1)]), (lectura_bichos[(bucle+2)]), (lectura_bichos[(bucle+3)]));
                 bucle=bucle+3;
     end //case 204

     default:
     break;
     end

     end // switch

     end // from bucle= 0 to 5
     
End //Bichos


//RUTINA PARA CAMBIAR DE PANTALLA
//ENTRADA EN PANT NUMERO DE PANTALLA

Process cambio(int pant)

Private
       tipo;
       xl;
       yl;

Begin

     signal(Type johnny, s_kill);
     signal(Type malo_movil, s_kill);
     signal(Type serpiente, s_kill);
     signal(Type ciclico, s_kill);
     signal(Type arana, s_kill);
     signal(type letra, s_kill);
     //signal(type princesa, s_kill);

     if ((princesa==false) and (pant==5))
x1p=2;
y1p=2;
cont3=((y1p*10)+x1p);
x1p++;
y1p++;
x2p=((x1p*60)-10);
y2p=((y1p*60)-10);
               end //if

     //clear_screen();
     put (graf1, 53, 320,170);
     mapeado(pant);

     if ((pant==34) and (tesoro==false))
     stop_wav(reloj);
     play_song(m_tesoro, -0);
     signal(Type bomba, s_kill);
     signal(Type tiempo, s_sleep);
     tesoro=true;
     put (graf1, 8, 310,370);
     put (graf1, 92,320,170);
        timer[4]=0;
        while (timer[4]<320)
        frame;
        end //while
        rescatado();
        put (graf1, 53, 320,170);
     signal(Type tiempo, s_wakeup);
     end //if ((pant==19) and (tesoro==false))
     //princesa();
     put (graf1, 999, 320,170);
     
     if ((llave_verde==false) and (pant==15))
     put (graf1, 33, 290,110);
     end //if ((llave_verde==true) and (pant==15))
     
     if ((llave_rosa==false) and (pant==51))
     put (graf1, 33, 350,110);
     end //if ((llave_rosa==true) and (pant==15))
     
     
     //pone las letras
     if (hechizo==1)
     switch (pant)
     case 67:
     if (baba6==false)
     letra(3, 170,170);
     end //if (baba...
     end //case67:
     
     case 130:
     if (baba1==false)
     letra(0, 530,110);
     end //if (baba...
     end //case130:
     
     case 26:
     if (baba2==false)
     letra(1, 110,110);
     end //if (baba...
     end //case26:
     
     case 27:
     if (baba5==false)
     letra(2, 470,170);
     end //if (baba...
     end //case27:
     
     case 42:
     if (baba3==false)
     letra(0, 170,170);
     end //if (baba...
     end //case42:
     
     case 87:
     if (baba4==false)
     letra(1, 530,110);
     end //if (baba...
     end //case87:
     
     case 118:
     if (baba7==false)
     letra(0, 170,230);
     end //if (baba...
     end //case118:
     
     case 14:
     if (baba8==false)
     letra(1, 530,110);
     end //if (baba...
     end //case14:

     end //switch (pant)
     end //if (hechizo==1)
     
     
     
     bichos (pant);
     frame;
     johnny(x_mono,y_mono);
     tiempo();


End //CAMBIO


//SERPIENTE
//PROCESO QUE CREA LA SERPIENTE DE LA VASIJA
//ENTRADAS X e Y

Process serpiente(int x, int y)

private

begin

     canal_serpiente=play_wav(s_serpiente, 0);
     graph=110;
     x=((x*60)-10);
     y=((y*60)-10);
     loop
     frame;
     frame;
     frame;
     graph++;
     if (graph==116)
     graph=110;
     end // if (graph==116)
     if (is_playing_wav(canal_serpiente)==0)
     canal_serpiente=play_wav(s_serpiente, 0);
     end
     end // loop

end //begin

Process arana(int x, int y)

private

begin

     graph=122;
     x=((x*60)-10);
     y=((y*60)-10);
     loop
     frame;
     frame;
     frame;
     graph++;
     if (graph==126)
     graph=122;
     end // if (graph==126)
     if (pant==126)
     timer[3]=0;
     while (timer[3]<10)
     frame;
     end //while (timer[3]<100)
     end //if (pant==126)
     end // loop

end //begin


//ENEMIGOS CICLICOS
//PROCESO PARA CREAR LOS ENEMIGOS QUE SE MUEVEN SIGUENDO UN PATRON
//ENTRADA X e Y

Process ciclico(int comx, int finx, int y)

Private

       int desp;

Begin

     desp=20;
     comx=((comx*60)-10);
     finx=((finx*60)-10);
     y=((y*60)-10);
     x=comx;
     graph=108;
     loop
     if (desp>0)
     flags=0;
     else
     flags=1;
     end // if (desp>0)
     frame;
     frame;
     x=x+desp;
     if (x>(finx-30)) desp=-20; end
     if (x<(comx+20)) desp=+20; end
     graph++;
     if (graph==110) graph=108; end
     end //loop

end //Process ciclico(int x, int y)


//ENEMIGOS MOVILES
//PROCESO PARA CREAR LOS ENEMIGOS QUE SE MUEVEN ALEATORIAMENTE POR LA PANTALLA

Process malo_movil(Int pant, Int codigo)

Private

    x1;
    y1;
        xb1;
    cont;
    cont2;
    bucle;
       codigofin;
Begin

        codigo=rand (1,3);
        if (codigo==1)
        codigo=108;
        codigofin=109;
        end
        if (codigo==2)
        codigo=128;
        codigofin=129;
        end
        if (codigo==3)
        codigo=130;
        codigofin=132;
        end
    x1=rand (2,7);
        if (pant==74) x1=2; end
    y1=rand (1,3);
 
         if ((pant==15) || (pant==51))
         y1=rand(2,3);
         end //if ((pant==15) || (pant==51))
         
    cont2=((y1*10)+x1);
    While (lectura[cont2]<>0)
    x1=rand (1,8);
    y1=rand (1,3);

         if ((pant==15) || (pant==51))
         y1=rand(2,3);
         end //if ((pant==15) || (pant==51))
 
    cont2=((y1*10)+x1);
    End
    x1++;y1++;
    x=((x1*60)-10);
    y=((y1*60)-10);
    graph=codigo;

        timer[4]=0;
        while (timer[4]<50)
        frame;
        end //while

    Loop
    cont=rand(1,30);
    
        xb1=50;
        if ((pant==15) || (pant==51))
        xb1=170;
        end //if ((pant==15)
        

    If ((cont==1) AND (lectura[(cont2-1)]==0) AND (x>50))
    cont2--;
         flags=1;
    From bucle=1 To 3
    x=x-20;
    If (graph<codigofin)
    graph++;
    Else
    graph=codigo;
    End
    Frame;
              frame;
    End
    End

    If ((cont==5) AND (lectura[(cont2+1)]==0) AND (x<590))
        cont2++;
        flags=0;
    From bucle=1 To 3
    x=x+20;
    If (graph<codigofin)
    graph++;
    Else
    graph=codigo;
    End
    Frame;
              frame;
    End
        End

    If ((cont==10) AND (lectura[(cont2-10)]==0) AND (y>xb1))
        cont2=cont2-10;
        From bucle=1 To 3
    y=y-20;
    If (graph<codigofin)
    graph++;
    Else
    graph=codigo;
    End
    Frame;
              frame;
    End
    End

    If ((cont==15) AND (lectura[(cont2+10)]==0) AND (y<270))
    cont2=cont2+10;
        From bucle=1 To 3
    y=y+20;
    If (graph<codigofin)
    graph++;
    Else
    graph=codigo;
    End
    Frame;
              frame;
    End
    End
    
    
    Frame;
    End // loop

End //MALO_MOVIL


//LEE MAPA
//PROCESO PARA CARGAR EN EL ARRAY EL MAPEADO DE LA PANTALLA EN CURSO

Process lee_mapa(Int pantalla)

Begin

        fseek(file_data, (pantalla*50), 0); //SITUA EL PUNTERO AL COMIENZO DEL BLOQUE DE LA PANTALLA.
        fread(file_data, lectura); //LEE LOS 50 BYTES DE LA PANTALLA Y METE LOS DATOS EN ARRAY 'LECTURA'

End //LEE_MAPA

//Proceso FOSO
//Genera la caída en el foso de los cocodrilos

Process foso()

private
     int bucle;
begin

     stop_wav(reloj);
     //signal(Type johnny, s_kill);
     //signal(Type malo_movil, s_kill);
     //signal(Type serpiente, s_kill);
     //signal(Type ciclico, s_kill);
     //signal(Type arana, s_kill);
     let_me_alone();
     princesa();
     prisionero();
     llaverosa();
     llaveverde();
     put (graf1, 53, 320,170);
     mapeado(122);
     cocodrilo(116, 230);
     cocodrilo(118, 410);

     //provisional
     //signal(Type malo_movil, s_kill);
     //signal(Type serpiente, s_kill);
     //signal(Type ciclico, s_kill);
     //signal(Type arana, s_kill);
     //fin provisional
     
     put (graf1, 999, 320,170);
     play_wav(s_grito, 0);
     graph=100;
     x=320;
     y=70;
     angle=360000;
     from bucle=1 to 12
     frame;
     frame;
     y=y+15;
     angle=angle-45000;
     if (angle<0)
     angle=360000;
     end
     end //from bucle
     graph=99;
     play_wav(s_chapuzon, 0);
     timer[2]=0;
     while (timer[2]<150)
     frame;
     end //while (timer
     signal(type cocodrilo, s_kill);
     muerte();

end //Process foso()


//MUERTE proceso que mata una vida al chocar contra objetos malignos.

process muerte()

private

begin
        vidas--;
        let_me_alone();
        if (prisionero==true)
        prisionero();
        end//
        princesa();
        bomba=false;
        pant_bomba=200;
        stop_wav(reloj);
        put (graf1, 53, 320,170);
        if (vidas>0)
        put (graf1, 85,320,170);
        switch (vidas)
        case 4:
        put (graf1, 154, 530, 370);
        end //case 4:
        case 3:
        put (graf1, 153, 530, 370);
        end //case 3:
        case 2:
        put (graf1, 152, 530, 370);
        end //case 2:
        case 1:
        put (graf1, 151, 530, 370);
        end //case 1:
        end //while (vidas)

        if ((llave_rosa==true) || (llave_verde==true))
        llaverosa();
        llaveverde();
        end //if



        timer[4]=0;
        play_song(m_muerte, 0);
        while (timer[4]<350)
        frame;
        end //while

        if ((llave_rosa==false) || (llave_verde==false))
        llaverosa();
        llaveverde();
        end //if
                prisionero();
        cambio (pant);

        signal (type muerte ,s_kill);
        else
        play_song(m_fmuerte, 0);
        put (graf1, 150, 530, 370);
        put (graf1, 86,320,140);
        put (graf1, 87,320,180);
        timer[4]=0;
        while (timer[4]<800)
        frame;
        end //while
        menu();
        end

end //process muerte()


//JOHNNNY
//PROCESO QUE CONTROLA A JOHNNY JONES

Process johnny (x1, y1)

Private

    cont2;
    bucle;
        tope_y;
        sonidito;
        
Begin

    cont2=((y1*10)+x1);
    y1++;
    x1++;
    graph=106;
    x=((x1*60)-10);
    y=((y1*60)-10);
        z=-510;
    Frame;
    
    Loop

      If (collision (Type malo_movil)) sonidito=play_wav(s_bocado, 0); muerte(); Break; End
      If (collision (Type serpiente)) sonidito=play_wav(s_bocado, 0); muerte(); Break; End
      If (collision (Type ciclico)) sonidito=play_wav(s_bocado, 0); muerte(); Break; End
      If (collision (Type arana)) sonidito=play_wav(s_bocado, 0); muerte(); Break; End
      
      if (key(_esc)) escape(0); end

//BOMBA

       If (key(_control) and (bomba==false) and (bombas>0))
       bombas--;
       pant_bomba=pant;
       bomba(x,y);
       end //If (key(_control))




              //fin detección objetos malignos

           // Cambio de pantalla a la izquierda.

          if ((key(_left)) and (x<60) and (pant==123))
          escalera(0, 83);
          end // if ((key(_left)) and (x>50) and (pant==123))

          if ((key(_left)) and (x<60)) //if cambio de pantalla
          pant--;
          x_mono=9;
          y_mono=(y/60);
          cambio(pant);
          end //if cambio de pantalla a la izquierda

              //detecta foso
              If ((key(_left)) and (lectura[cont2-1]==50))
              foso();
              end

    If ((key(_left)) AND (lectura[(cont2-1)]==0) AND (x>50))
    graph=100;
    cont2--;
        pasos=play_wav(s_pasos, 0);
    From bucle=1 To 3
    x=x-20;
    If (graph==100)
    graph++;
    Else
    graph--;
    End //if
    Frame;
    End //from bucle
    End //if (key

          // Cambio de pantalla a la derecha.
          if ((key(_right)) and (x>570)) //if cambio de pantalla
          pant++;
          x_mono=0;
          y_mono=(y/60);
          cambio(pant);
          end //if cambio de pantalla a la derecha

              //detetecta foso
              If ((key(_right)) and (lectura[cont2+1]==50))
              foso();
              end


    If ((key(_right)) AND (lectura[(cont2+1)]==0) AND (x<570))
        graph=102;
        cont2++;
        pasos=play_wav(s_pasos, 0);
        From bucle=1 To 3
        x=x+20;
        If (graph==102)
        graph++;
        Else
        graph--;
        End //if
    Frame;
        End //from bucle
        End //if (key


        tope_y=60;
        if ((llave_verde==false) and (pant==15))
        tope_y=170;
        end //if (llave_verde==false)
        if ((llave_rosa==false) and (pant==51))
        tope_y=170;
        end //if (llave_verde==false)


          // Cambio de pantalla arriba.
          if ((key(_up)) and (lectura[(cont2-10)]==29 || (lectura[(cont2-10)]==44)))
          pant=pant-15;
          x_mono=(x/60);
          y_mono=4;
          cambio(pant);
          end //if ((key(_up)) and (lectura[(cont2-10]==29 || 44))

          if ((key(_up)) and (y<60) and (pant==55))
          escalera(0, 32);
          end // if ((key(_up)) and (y<60) and (pant==55))
          
          if ((key(_up)) and (y<60) and (pant==32))
          escalera(1, 55);
          end // if ((key(_up)) and (y<60) and (pant==32))
          
          if ((key(_up)) and (y<60) and (pant==65))
          escalera(1, 105);
          end // if ((key(_up)) and (y<60) and (pant==65))
          

          if ((key(_up)) and (y<60)) //if cambio de pantalla
          pant=pant-15;
          x_mono=(x/60);
          y_mono=4;
          cambio(pant);
          end //if cambio de pantalla a la arriba

              //detecta foso
              If ((key(_up)) and (lectura[cont2-10]==50))
              foso();
              end

    If ((key(_up)) AND (lectura[(cont2-10)]==0) AND (y>tope_y))
        graph=104;
        cont2=cont2-10;
        pasos=play_wav(s_pasos, 0);
        From bucle=1 To 3
        y=y-20;
        If (graph==104)
        graph++;
        Else
        graph--;
        End //if
    Frame;
        End //from bucle
        End //if (key

          // Cambio de pantalla abajo.
          
          if ((key(_down)) and (y>270) and (pant==83))
          escalera(1, 123);
          end // if ((key(_down)) and (y>270) and (pant==93))
          
          if ((key(_down)) and (y>270) and (pant==105))
          escalera(0, 65);
          end // if ((key(_down)) and (y>270) and (pant==105))
          
          if ((key(_down)) and (y>270) and (pant==93))
          escalera(0, 96);
          end // if ((key(_down)) and (y>270) and (pant==93))
          
          if ((key(_down)) and (y>270) and (pant==96))
          escalera(1, 93);
          end // if ((key(_down)) and (y>270) and (pant==96))

          if ((key(_down)) and (y>270)) //if cambio de pantalla
          pant=pant+15;
          x_mono=(x/60);
          y_mono=0;
          if ((pant==15)  || (pant==51)) y_mono=1; end
          //if (pant==51) y_mono=1; end
          cambio(pant);
          end //if cambio de pantalla abajo

              //detecta foso
              If ((key(_down)) and (lectura[cont2+10]==50))
              foso();
              end


    If ((key(_down)) AND (lectura[(cont2+10)]==0) AND (y<270))
        graph=106;
        cont2=cont2+10;
        pasos=play_wav(s_pasos, 0);
        From bucle=1 To 3
        y=y+20;
        If (graph==106)
        graph++;
        Else
        graph--;
        End //if
        Frame;
    End //from bucle
        End //if (key

    Frame;

    End //loop

End //JOHNNY


//PROCESO ESCALERA
//ENTRADA D=DIRECCIÓN: 0 SUBE 1 BAJA
//PANTALLA DESTINO

Process escalera(int d, int pant_dest)

private
     int bucle;
     inc_x;
     inc_y;
     temporal;
begin

     pant=200;
     signal(Type johnny, s_kill);
     signal(Type malo_movil, s_kill);
     signal(Type serpiente, s_kill);
     signal(Type ciclico, s_kill);
     signal(Type arana, s_kill);
     put (graf1, 53, 320,170);
     mapeado(120);

     //provisional
     signal(Type malo_movil, s_kill);
     signal(Type serpiente, s_kill);
     signal(Type ciclico, s_kill);
     signal(Type arana, s_kill);
     //fin provisional

     put (graf1, 999, 320,170);

     switch (d)
     case 0:
     graph=100;
     x=410;
     y=230;
     inc_x=-60;
     inc_Y=-60;
     end //case[0]
     case 1:
     graph=102;
     x=230;
     y=50;
     inc_x=60;
     inc_Y=60;
     end //case[1]
     end //switch
     
     from bucle=1 to 4;
     timer[2]=0;
     while (timer[2]<30)
     temporal=play_wav(s_pasos, 0);
     frame;
     end // while
     x=x+inc_x;
     y=y+inc_y;
     stop_wav(temporal);
     end// from bucle=1 to 4;
     
     switch (pant_dest)
     case 32:
     x_mono=6;
     y_mono=0;
     end //case 32
     case 55:
     x_mono=5;
     y_mono=0;
     end //case 55
     case 65:
     x_mono=7;
     y_mono=0;
     end //case 65
     case 83:
     x_mono=5;
     y_mono=4;
     end //case 83:
     case 93:
     x_mono=6;
     y_mono=4;
     end //case 93
     case 96:
     x_mono=5;
     y_mono=4;
     end //case 96
     case 105:
     x_mono=5;
     y_mono=4;
     end //case 105
     case 123:
     x_mono=0;
     y_mono=3;
     end //case 123
     end //switch

     pant=pant_dest;
     cambio (pant_dest);

end //Process escalera()


//PROCESO PRISIONERO

process prisionero()

private
       tempo;
begin

loop

If (collision (Type johnny))

prisionero=true;
let_me_alone();
graph=0;
x=1000;
y=1000;
frame;
put (graf1, 53, 320,170);
put (graf1, 89,320,170);
            play_song(m_tesoro,0);
        timer[4]=0;
        while (timer[4]<320)
        frame;
        end //while
        rescatado();
        cambio (pant);
end //If (collision (Type johnny))

if (prisionero==true)
   x=250;
   y=370;
   graph=126;
   tempo=rand (1,100);
   if (tempo<10)
   graph=126;
   else
   graph=127;
   end
   frame;
end //if (prisionero==true)

if (prisionero==false)

if (pant!=126) graph=0; x=1000; frame; end

if (pant==126)
x=470;
y=230;
graph=127;
tempo=rand (1,100);
if (tempo<10)
graph=126;
else
graph=127;
end
frame;

end //if (pant==126)


end //if ((prisionero==false)

end //loop

end //process prisionero()



//PROCESO CREA BANNER DE CREDITOS
process banner()

        private
        
        begin
        
        graph=83;
        x=1500;
        y=445;
        
        loop
        x=x-3;
        if (x<-1050)
        x=1500;
        end //if (x==-850)
        frame;

        end //loop

end  //process banner();

//MARCADORES

process marcador(int valor, xn, yn)

        private
               bucle;
               string cadena;
               string v1;
               a;
        begin;
        cadena=itoa (valor);
        a=len(cadena);
        from bucle=0 to len(cadena)-1
        v1=substr (cadena, bucle,bucle);
        put (graf1, (asc (v1)+102), xn,yn);
        xn=xn+20;
        a--;
        frame;

        
        end //from bucle= 1 to string cadena


end //process marcador(int valor);

//proceso tiempo

process tiempo();

        private

        begin
        marcador (tiempo, 50,380);
        loop

        timer[7]=0;
        while (timer[7]<60)
        frame;
        end

        tiempo--;

        if (tiempo>999)
        marcador (tiempo, 50,380);
        end

        if ((tiempo<1000) and (tiempo>99))
        put (graf1,150,50,380);
        marcador (tiempo, 70,380);
        end

        if (tiempo<100)
        put (graf1,150,70,380);
        marcador (tiempo, 90,380);
        end

        if (tiempo==0)
        let_me_alone();
        stop_wav(reloj);
        play_song(m_fmuerte, 0);
        put (graf1, 53, 320,170);
        put (graf1, 91,320,140);
        put (graf1, 87,320,180);
        timer[4]=0;
        while (timer[4]<800)
        frame;
        end //while
        menu();
        end //

        end //loop

        
end //process tiempo();

//proceso cocodrilo

process cocodrilo(int sprite, int x1)

        private
        aleatorio;
        begin
        graph=sprite;
        x=x1;
        y=230;
        loop
        aleatorio=rand(1,100);
        if (aleatorio<10)
        graph=sprite;
        else
        graph=sprite+1;
        end //if aleatorio
        frame;
        end //loop

        
end //process cocodrilo(int sprite, int x1)


process princesa()

private
       tempo;
    cont;
    bucle;
 
begin
//x1p=2;
//y1p=2;
//cont3=((y1p*10)+x1p);
//x1p++;
//y1p++;
//x2p=((x1p*60)-10);
//y2p=((y1p*60)-10);
loop

If (collision (Type johnny))

princesa=true;
graph=99;
let_me_alone();
put (graf1, 53, 320,170);
put (graf1, 94,320,170);
            play_song(m_tesoro,0);
        timer[4]=0;
        while (timer[4]<320)
        frame;
        end //while
        prisionero();
        rescatado();
        cambio (pant);
end //If (collision (Type johnny))

if (princesa==true)
   x=190;
   y=370;
   graph=120;
   tempo=rand (1,100);
   if (tempo<10)
   graph=120;
   else
   graph=121;
   end
   frame;
end //if (princesa==true)

if (princesa==false)

if (pant!=5) graph=0; x=1000; frame; end

if (pant==5)
graph=121;
cont=rand(1,30);
        x=x2p;
        y=y2p;

    If ((cont==1) AND (lectura[(cont3-1)]==0) AND (x>50))
    cont3--;
    From bucle=1 To 3
    x=x-20;
        x2p=x2p-20;
    If (graph==120)
    graph=121;
    Else
    graph=120;
    End
    Frame;
        frame;
    End
    End

    If ((cont==5) AND (lectura[(cont3+1)]==0) AND (x<590))
        cont3++;
    From bucle=1 To 3
    x=x+20;
        x2p=x2p+20;
    If (graph==120)
    graph=121;
    Else
    graph=120;
    End
    Frame;
        frame;
    End
        End

    If ((cont==10) AND (lectura[(cont3-10)]==0) AND (y>50))
        cont3=cont3-10;
        From bucle=1 To 3
    y=y-20;
        y2p=y2p-20;
    If (graph==120)
    graph=121;
    Else
    graph=120;
    End
    Frame;
        frame;
    End
    End

    If ((cont==15) AND (lectura[(cont3+10)]==0) AND (y<270))
    cont3=cont3+10;
        From bucle=1 To 3
    y=y+20;
        y2p=y2p+20;
    If (graph==120)
    graph=121;
    Else
    graph=120;
    End
    Frame;
        frame;
    End
    End

frame;

end //if (pant==5)


end //if ((princesa==false)

end //loop

end //process princesa()

//PROCESO LLAVE_ROSA

process llaverosa()

private
       tempo;
       sonido;
begin

loop

If (collision (Type johnny))

llave_rosa=true;
sonido=play_song(m_premio, 0);
graph=99;
end //If (collision (Type johnny))


if (llave_rosa==true)
   if (princesa==false)
   x=190;
   y=370;
   else
   x=1000;
   y=1000;
   end //if (princesa==false)
   graph=97;
   frame;
end //if (llave_rosa==true)


if (llave_rosa==false)

if (pant!=132) graph=0; x=1000; frame; end

if (pant==132)
x=410;
y=230;
graph=97;
frame;

end //if (pant==132)


end //if ((llave_rosa==false)

end //loop

end //process llave_rosa()


//PROCESO LLAVE_VERDE

process llaveverde()

private
       tempo;
       sonido;
begin

loop

If (collision (Type johnny))

llave_verde=true;
sonido=play_song(m_premio, 0);
graph=99;
end //If (collision (Type johnny))

if (llave_verde==true)
   if (tesoro==false)
   x=310;
   y=370;
   else
   x=1000;
   y=1000;
   end //if tesoro==false)
   z=-512;
   graph=96;
   frame;
end //if (llave_verde==true)

if (llave_verde==false)

if (pant!=13) graph=0; x=1000; frame; end

if (pant==13)
x=230;
y=170;
graph=96;
frame;

end //if (pant==13)


end //if ((llave_verde==false)

end //loop

end //process llave_verde()


//PROCESO ESCAPE

process escape(int tipo)

        private
        
               opcion=0;
        
        begin
        
        signal(type johnny, s_freeze);
        signal(type bomba, s_freeze);
        signal(type malo_movil, s_freeze);
        signal(type ciclico, s_freeze);
        signal(type serpiente, s_freeze);
        signal(type arana, s_freeze);
        signal(type prisionero, s_freeze);
        signal(type princesa, s_freeze);
        signal(type tiempo, s_freeze);
        signal(type llaveverde, s_freeze);
        signal(type llaverosa, s_freeze);
        signal(type banner, s_freeze);
        pause_wav(canal_serpiente);
        pause_wav(reloj);
        
        
        loop
        z=-512;
        switch (tipo)
        
        case 0:
        x=320;
        y=220;
        if (opcion==0)
        graph=162;
        else
        graph=161;
        end //if (opcion==0)
        if ((key(_left)) and (opcion==0))
        opcion=1;
        end //if
        if ((key(_right)) and (opcion==1))
        opcion=0;
        end //if
        if ((key(_control)) and (opcion==0))
        while (key(_control))
        frame;
        end
        signal(type johnny, s_wakeup);
        signal(type bomba, s_wakeup);
        signal(type malo_movil, s_wakeup);
        signal(type ciclico, s_wakeup);
        signal(type serpiente, s_wakeup);
        signal(type arana, s_wakeup);
        signal(type prisionero, s_wakeup);
        signal(type princesa, s_wakeup);
        signal(type tiempo, s_wakeup);
        signal(type llaveverde, s_wakeup);
        signal(type llaverosa, s_wakeup);
        resume_wav(reloj);
        resume_wav(canal_serpiente);
        signal(type escape, s_kill);
        end //if
        if ((key(_control)) and (opcion==1))
        menu();
        end //if
        
        end //case 0:

        case 1:
        pause_song();
        x=320;
        y=220;
        if (opcion==0)
        graph=164;
        else
        graph=163;
        end //if (opcion==0)
        if ((key(_left)) and (opcion==0))
        opcion=1;
        end //if
        if ((key(_right)) and (opcion==1))
        opcion=0;
        end //if
        if ((key(_control)) and (opcion==0))
        while (key(_control))
        frame;
        end
        signal(type serpiente, s_wakeup);
        signal(type arana, s_wakeup);
        signal(type banner, s_wakeup);
        resume_song();
        signal(type escape, s_kill);
        end //if
        if ((key(_control)) and (opcion==1))
        fclose (file_data);
        exit("",0);
        end //if

        end //case 1:


        end //switch(tipo)

        frame;
        
        end //loop
        
end //process escape(int tipo)


//proceso conseguido ahora a buscar el hehizo

process rescatado()

        private
        
        begin

        if ((prisionero==true) and (princesa==true) and (tesoro==true) and (hechizo==0))
        hechizo=1;
        signal(Type cambio, s_kill);
        signal (type johnny, s_kill);
        signal (type arana, s_kill);
        signal (type serpiente, s_kill);
        signal (type bomba, s_sleep);
        signal (type prisionero, s_freeze);
        pause_wav(reloj);
        signal (type tiempo, s_freeze);
        signal (type malo_movil, s_kill);
        signal (type ciclico, s_kill);
          put (graf1, 53, 320,170);
        put (graf1, 169, 320, 140);
        put (graf1, 170, 320, 180);
        play_song(m_tesoro, 0);
        timer[4]=0;
        while (timer[4]<320)
        frame;
        end //while
        signal (type bomba, s_wakeup);
        resume_wav(reloj);
        signal (type tiempo, s_wakeup);
        signal (type prisionero, s_wakeup);
        princesa();
        pant_bomba=200;
        cambio(pant);
        end //if ((prisonero==true) and (princesa==true) and (tesoro==true))

        
end //process rescatado()


//proceso letra

process letra(int tipo, int x1, int y1)

        private
        sonido;

        begin


        loop
        x=x1;
        y=y1;
        z=-510;
        graph=(tipo+165);
        frame;
        
        if (collision (type johnny))

        switch (tipo)
        //letra B
        case 0:
        if ((babal1==false) and (babaliba==0))
        babaliba++;
        babal1=true;
        if (pant==130) baba1=true; end
        if (pant==42) baba3=true; end
        if (pant==118) baba7=true; end
        put (graf1,165, 110,450);
        sonido=play_song(m_premio, 0);
        signal (type letra, s_kill);
        end //if (babal1==false)
        
        if ((babal3==false) and (babaliba==2))
        babaliba++;
        babal3=true;
        if (pant==130) baba1=true; end
        if (pant==42) baba3=true; end
        if (pant==118) baba7=true; end
        put (graf1,165, 230,450);
        sonido=play_song(m_premio, 0);
        signal (type letra, s_kill);
        end //if (babal3==false)
        
        if ((babal7==false) and (babaliba==6))
        babaliba++;
        babal7=true;
        if (pant==130) baba1=true; end
        if (pant==42) baba3=true; end
        if (pant==118) baba7=true; end
        put (graf1,165, 470,450);
        sonido=play_song(m_premio, 0);
        signal (type letra, s_kill);
        end //if (babal7==false)
        end //case 0:
        
        //letra A
        case 1:
        if ((babal2==false) and (babaliba==1))
        babaliba++;
        babal2=true;
        if (pant==26) baba2=true; end
        if (pant==87) baba4=true; end
        if (pant==14) baba8=true; end
        put (graf1,166, 170,450);
        sonido=play_song(m_premio, 0);
        signal (type letra, s_kill);
        end //if (babal2==false)

        if ((babal4==false) and (babaliba==3))
        babaliba++;
        babal4=true;
        if (pant==26) baba2=true; end
        if (pant==87) baba4=true; end
        if (pant==14) baba8=true; end
        put (graf1,166, 290,450);
        sonido=play_song(m_premio, 0);
        signal (type letra, s_kill);
        end //if (babal4==false)

        if ((babal8==false) and (babaliba==7))
        babaliba++;
        babal8=true;
        put (graf1,166, 530,450);
        sonido=play_song(m_premio, 0);
        let_me_alone();
        stop_wav(reloj);
        graph=99;
        x=1000;
        y=1000;
        put (graf1, 53, 320,170);
        put (graf1, 173, 320, 100);
        put (graf1, 171, 320, 140);
        marcador ((2000-tiempo), 280, 180);
        put (graf1, 172, 320, 220);
        princesa();
        prisionero();
        play_song(m_fbien, 0);
        timer[4]=0;
        while (timer[4]<1200)
        frame;
        end
        menu();
        end //if (babal7==false)
        end //case 1:
        
        //letra L
        case 2:
        if ((babal5==false) and (babaliba==4))
        babaliba++;
        babal5=true;
        baba5=true;
        put (graf1,167, 350,450);
        sonido=play_song(m_premio, 0);
        signal (type letra, s_kill);
        end //if (babal2==false)
        end //case 2
        
        //letra I
        case 3:
        if ((babal6==false) and (babaliba==5))
        babaliba++;
        babal6=true;
        baba6=true;
        put (graf1,168, 410,450);
        sonido=play_song(m_premio, 0);
        signal (type letra, s_kill);
        end //if (babal2==false)
        end //case 2

        end //switch (tipo)
        
        
        end //if (collision


        end //loop
        
        
end //process letra(int tipo, int x1, int y1)
