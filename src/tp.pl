%Parte 1.a

%habitante(nombre, raza, nacimiento, pueblo).

habitante(denken, humano, 1290, auberst).
habitante(fern, humano, 1370, weise).
habitante(stark, humano, 1368, riegel).
habitante(lawine, humano, 1372, auberst).
habitante(kanne, humano, 1365, weise).
habitante(wirbel, humano, 1350, klares).
habitante(lernen, humano, 1315, auberst).

habitante(voll, enano, 1200, ende).
habitante(eisen, enano, 1150, riegel).

habitante(serie, elfo, 500, weise).
habitante(frieren, elfo, 100, weise).


%Parte 1.b
tiempoDeVida(humano, 80).
tiempoDeVida(enano, 350).


estaVivoEn(Persona, Anio):-
    habitante(Persona, _, Nacimiento, _),
    Nacimiento =< Anio,
    not(murioEn(Persona, Anio)).

murioEn(Persona, Anio):-
    habitante(Persona, Raza, Nacimiento, _),
    tiempoDeVida(Raza, Esperanza),
    Nacimiento + Esperanza < Anio.
    

% Punto2A
% conoce(Persona, Hazania, AnioConocimiento, MedioDeConocimiento)
conoce(wirbel, hazania(rescatarHermanaWirbel, [stark, fern], klares), 1390, presencio).
conoce(frieren, hazania(rescatarHermanaWirbel, [stark, fern], klares), 1390, presencio).
conoce(lawine, hazania(destruirAura, [frieren], weise), 1393, cancion).
conoce(voll, hazania(destruirAura, [denken], auberst), 1400, libro(50)).
conoce(serie, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1335, libro(100)).
conoce(kanne, hazania(recuperarGato, [himmel, frieren], weise), 1375, presencio).

sigueRecordando(presencio, _, _).

sigueRecordando(cancion, AnioConocio, Anio):-
    Anio =< AnioConocio + 15.

sigueRecordando(libro(Pags), AnioConocio, Anio):-
    Anio =< AnioConocio + Pags.

hazaniaRecordada(Persona, NombreHazania, Anio):-
    conoce(Persona, hazania(NombreHazania, _, _), AnioConocio, Medio),
    estaVivoEn(Persona, Anio),
    sigueRecordando(Medio, AnioConocio, Anio).

%Punto2B
corroborada(Nombre):-
    conoce(_, hazania(Nombre, Personas, Lugar), _, _),
    forall(
        conoce(_, hazania(Nombre, Personas2, Lugar2), _, _),
        (Personas == Personas2, Lugar == Lugar2)
    ).

%Punto2C
pasoAlOlvido(NombreHazania, Anio):-
    conoce(_, hazania(NombreHazania, _, _), _, _),
    not(hazaniaRecordada(_, NombreHazania, Anio)).


%Punto 3A
/*
festivo(pueblo, hazania, anioDeFestivo)
festivo(weise, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1340).

estatuas(pueblo, nombreEstaatua, tipoMaterial, hazania, anio)
estatuas(auberst, elEquipoDeHeroes, bronce, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1370).
estatuas(auberst, elHeroeDelSur, marmol, hazania(destruirSchlatElOmnisciente, [heroeDelSur], ende), 1340).
*/

%correcciones 3A
%conmemora(Pueblo, Hazania, AnioComienzo, TipoFestival)
conmemora(weise, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1340, festival).
conmemora(auberst, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1370, estatua(elEquipoDeHeroes, bronce)).
conmemora(auberst, hazania(destruirSchlatElOmnisciente, [heroeDelSur], ende), 1340, estatua(elHeroeDelSur, marmol)).

% mantenimientoEstatua(estatua, anio)
mantenimientoEstatua(elEquipoDeHeroes, 1400).
mantenimientoEstatua(elEquipoDeHeroes, 1450).
mantenimientoEstatua(elHeroeDelSur, 1410).

%Punto 3B
%limiteEstatua(tipoMaterial, limiteEstatua)
limiteEstatua(marmol, 30).
limiteEstatua(bronce, 15).

%eventoCuidado(NombreEstatua, Anio)
eventoCuidado(NombreEstatua, Anio):-
    conmemora(_, _, Anio, estatua(NombreEstatua, _)).           %conmemora(Pueblo, Hazania, AnioComienzo, TipoFestival)
eventoCuidado(NombreEstatua, Anio):-                            % mantenimientoEstatua(estatua, anio)
    mantenimientoEstatua(NombreEstatua, Anio).

%estatuaEnBuenEstado(estatua, anio)
estatuaEnBuenEstado(NombreEstatua, Anio):-
    conmemora(_, _, _, estatua(NombreEstatua, Material)),       %conmemora(Pueblo, Hazania, AnioComienzo, TipoFestival)
    limiteEstatua(Material, LimiteEstatua),                %limiteEstatua(tipoMaterial, limiteEstatua)
    eventoCuidado(NombreEstatua, AnioEvento),                   %eventoCuidado(NombreEstatua, Anio)
    AnioEvento =< Anio,
    Anio - AnioEvento =< LimiteEstatua.


/*
hazaniaRecordada(Persona, NombreHazania, Anio):-
    habitante(Persona, _, Nacimiento, Pueblo),                          %habitante(nombre, raza, nacimiento, pueblo).
    festivo(Pueblo, hazania(NombreHazania, _, _), AnioDeFestivo),       %hazania(nombreHazania, [personas], lugar)
    Anio >= AnioDeFestivo,
    Anio >= Nacimiento,
    estaVivoEn(Persona, Anio).

hazaniaRecordada(Persona, NombreHazania, Anio):-
    habitante(Persona, _, Nacimiento, Pueblo),                                      %habitante(nombre, raza, nacimiento, pueblo).
    estatuas(Pueblo, Estatua, _, hazania(NombreHazania,_, _), AnioEstatua),         %hazania(nombreHazania, [personas], lugar)
    estatuaEnBuenEstado(Estatua, Anio),                                             %estatuaEnBuenEstado(estatua, anio)    
    Anio >= Nacimiento,
    estaVivoEn(Persona, Anio).
*/

conoce(Persona, Hazania, AnioComienzo, MedioDeConocimiento):-
    habitante(Persona, _, _, Pueblo),                                   %habitante(nombre, raza, nacimiento, pueblo).
    conmemora(Pueblo, Hazania, AnioComienzo, MedioDeConocimiento).      %conmemora(Pueblo, Hazania, AnioComienzo, TipoFestival)

sigueRecordando(presencio, _, _).
sigueRecordando(festival, _, _).
sigueRecordando(estatua(NombreEstatua, _), AnioComienzo, Anio):-
    estatuaEnBuenEstado(NombreEstatua, Anio).
sigueRecordando(MedioDeConocimiento, AnioComienzo, Anio):-
    duracionRecuerdo(MedioDeConocimiento, Duracion),                    %duracionRecuerdo(MedioDeConocimiento, Duracion)
    Anio =< AnioComienzo + Duracion.

hazaniaRecordada(Persona, NombreHazania, Anio):-
    conoce(Persona, hazania(NombreHazania, _, _), AnioComienzo, MedioDeConocimiento),               %conoce(Persona, Hazania, AnioComienzo, TipoConmemoracion)
    Anio >= AnioComienzo,
    sigueRecordando(MedioDeConocimiento, AnioComienzo, Anio),
    estaVivoEn(Persona, Anio).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parte 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Punto 4
puebloRecuerdaHazania(Pueblo, NombreHazania, Anio):-
    hazaniaRecordada(Persona, NombreHazania, Anio),
    habitante(Persona, _, _, Pueblo).

paginasLeidasEnPueblo(Pueblo, Anio, PaginasLeidas):-
    findall(PaginasLibro,
        (
            conoce(Persona, _, Anio, libro(PaginasLibro)),
            habitante(Persona, _, _, Pueblo)
        ),
        ListaPaginas
        ),
    sum_list(ListaPaginas, PaginasLeidas).

puebloMasLector(Anio, Pueblo):-
    findall(UnPueblo,
        habitante(_, _, _, UnPueblo),
        Pueblos),
    buscarPuebloMasLector(Pueblos, Anio, _, 0, Pueblo).

buscarPuebloMasLector([], _, PuebloActual, _, PuebloActual).
buscarPuebloMasLector([UnPueblo|OtrosPueblos], Anio, PuebloActual, PaginasActuales, PuebloMasLector):-
    paginasLeidasEnPueblo(UnPueblo, Anio, Paginas),
    Paginas > PaginasActuales,
    buscarPuebloMasLector(OtrosPueblos, Anio, UnPueblo, Paginas, PuebloMasLector).
buscarPuebloMasLector([_|OtrosPueblos], Anio, PuebloActual, PaginasActuales, PuebloMasLector):-
    buscarPuebloMasLector(OtrosPueblos, Anio, PuebloActual, PaginasActuales, PuebloMasLector).


esMusical(Pueblo, Anio):-
    findall(Hazania,
        puebloRecuerdaHazania(Pueblo, Hazania, Anio),
        Hazanias),
    hazaniasConCancion(Hazanias, HazaniasCancion),
    length(Hazanias, CantidadTotal),
    length(HazaniasCancion, CantidadCancion),
    CantidadCancion >= CantidadTotal / 2.

hazaniasConCancion([], []).

hazaniasConCancion([Hazania|Hazanias], [Hazania|HazaniasCancion]):-
    conoce(_, hazania(Hazania, _, _), _, cancion),
    hazaniasConCancion(Hazanias, HazaniasCancion).

hazaniasConCancion([Hazania|Hazanias], HazaniasCancion):-
    not(conoce(_, hazania(Hazania, _, _), _, cancion)),
    hazaniasConCancion(Hazanias, HazaniasCancion).

esChismoso(Pueblo, Anio):-
    forall(puebloRecuerdaHazania(Pueblo, Hazania, Anio),
        not(corroborada(Hazania))
    ).

esImportante(Hazania, Pueblo, Anio):-
    puebloRecuerdaHazania(Pueblo, Hazania, Anio),
    forall(
        (
            habitante(Persona, _, _, Pueblo),
            estaVivoEn(Persona, Anio)
        ),
        hazaniaRecordada(Persona, Hazania, Anio)
    ).

sinPrecedentes(Pueblo, Anio):-
    forall(
        esImportante(Hazania, Pueblo, Anio),
        (
            conoce(Persona, hazania(Hazania, _, _), _, presencio),
            habitante(Persona, _, _, Pueblo)
        )
    ).

%Punto 5
%A
esHeroe(Persona):-
    conoce(_, hazania(_, Heroes, _), _, _),      %conoce(Persona,hazania(nombreHazania, [personas], lugar), AnioConocimiento, MedioDeConocimiento)
    member(Persona, Heroes). 
%B
inspiro(Inspirador, Heroe):-
    conoce(Heroe, hazania(_, Heroes, _), _, _),  %conoce(Persona,hazania(nombreHazania, [personas], lugar), AnioConocimiento, MedioDeConocimiento)
    member(Inspirador, Heroes),
    Inspirador \= Heroe.
%C
cadenaInspiracion(Inicio, [Inicio]).
cadenaInspiracion(Inicio, [Inicio | Resto]):-
    inspiro(Inicio, Siguiente),
    cadenaInspiracion(Siguiente, Resto),        
    not(member(Inicio, Resto)).



%Tests
:- begin_tests(habitantes).

test("humanos y enanos no viven mas alla de su esperanza de vida", nondet):-
    estaVivoEn(kanne, 1370),
    estaVivoEn(voll, 1550),
    not(estaVivoEn(kanne, 2000)).

test("nadie puede vivir antes de haber nacido, sin importar su raza"):-
    not(estaVivoEn(denken, 1289)),
    not(estaVivoEn(voll, 1999)),
    not(estaVivoEn(serie, 499)).

test("los elfos no mueren de viejos"):-
    estaVivoEn(serie, 5000).

:- end_tests(habitantes).

:- begin_tests(recuerdos).

test("Lawine no recuerda destruir al demonio Aura en 1380 porque aún no escuchó una canción sobre esa hazaña", [fail]):-
    hazaniaRecordada(lawine, destruirAura, 1380).

test("Lawine recuerda destruir al demonio Aura en 1400", nondet):-
    hazaniaRecordada(lawine, destruirAura, 1400).

test("Lawine ya no recuerda destruir al demonio Aura en 1410 porque pasaron más de 15 años de que escuchó la canción", [fail]):-
    hazaniaRecordada(lawine, destruirAura, 1410).

test("Voll recuerda destruir al demonio Aura en 1450", nondet):-
    hazaniaRecordada(voll, destruirAura, 1450).

test("Voll no recuerda destruir al demonio Aura en 1460", [fail]):-
    hazaniaRecordada(voll, destruirAura, 1460).

test("Wirbel recuerda rescatar a la hermana de Wirbel en 1430", nondet):-
    hazaniaRecordada(wirbel, rescatarHermanaWirbel, 1430).

test("Wirbel ya no recuerda rescatar a la hermana de Wirbel en 1440 porque no está vivo en ese año", [fail]):-
    hazaniaRecordada(wirbel, rescatarHermanaWirbel, 1440).

test("Rescatar a la hermana de Wirbel es una hazaña corroborada", nondet):-
    corroborada(rescatarHermanaWirbel).

test("Destruir al demonio Aura no es una hazaña corroborada", [fail]):-
    corroborada(destruirAura).

test("Destruir al demonio Aura pasó al olvido en 1460"):-
    pasoAlOlvido(destruirAura, 1460).

test("Destruir al demonio Aura no pasó al olvido en 1440", [fail]):-
    pasoAlOlvido(destruirAura, 1440).

:- end_tests(recuerdos).


:- begin_tests(conmemoraciones).
test("Lawine recuerda destruir al rey demonio en 1400, poruqe en Auberst hay una estatua de buen estado", nondet):-
    hazaniaRecordada(lawine, destruirReyDemonio, 1400).
test("Lawine no recuerda destuir al rey demonio en 1390 porque la estatua no esta en buen estado", [fail]):-
    hazaniaRecordada(lawine, destruirReyDemonio, 1390).
test("Fern recierda destuir al rey demonio en 1400, porque se conmemora con un dia de destivo", nondet):-
    hazaniaRecordada(fern, destruirReyDemonio, 1400).
:- end_tests(conmemoraciones).

:- begin_tests(estatuas).
%mantenimiento en anio 1400 y 1450
test("La estatua elEquipoDeHeroes esta en buen estado en anio 1380 porque no paso el limite de anios", nondet):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1380).
test("La estatua elEquipoDeHeroes esta en buen estado en anio 1410 porque se hizo un mantenimiento en 1400", nondet):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1410).
test("La estatua elEquipoDeHeroes esta en buen estado en anio 1460 porque se hizo un mantenimiento en 1450", nondet):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1460).
test("la estatua elEquipoDeHeroes no esta en buen estado en anio 1390, porque paso limite de anios", [fail]):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1390).

%mantenimiento en anio 1410
test("La estatua elHeroeDelSur esta en buen estado en anio 1360 poruqe no paso el limite de anios", nondet):-
    estatuaEnBuenEstado(elHeroeDelSur, 1360).
test("La estatua elHeroeDelSur no esta en buen estado en anio 1380 porque paso el limite de anios", [fail]):-
    estatuaEnBuenEstado(elHeroeDelSur, 1380).
test("La estatua elHeroeDelSur esta en buen estado en anio 1420 porque se hizo un mantenimiento en 1410", nondet):-
    estatuaEnBuenEstado(elHeroeDelSur, 1420).
:- end_tests(estatuas).

:- begin_tests(pueblos).
test("En Weise se recuerda destruir al rey demonio en 1400", nondet):-
    puebloRecuerdaHazania(weise, destruirReyDemonio, 1400).
test("En Klares se recuerda rescatar a la hermana de Wirbel en 1395", nondet):-
    puebloRecuerdaHazania(klares, rescatarHermanaWirbel, 1395).
test("En Klares no se recuerda destruir al rey demonio en 1395"):-
    not(puebloRecuerdaHazania(klares, destruirReyDemonio, 1395)).

test("En Weise se leyeron 100 páginas en 1335"):-
    paginasLeidasEnPueblo(weise, 1335, 100).
test("En Weise se leyeron 0 páginas en 1336"):-
    paginasLeidasEnPueblo(weise, 1336, 0).

test("Ende es el pueblo mas lector en 1400", nondet):-
    puebloMasLector(1400, ende).

test("Aubert es musical en 1395"):-
    esMusical(aubert, 1395).
test("Weise no es musical en 1400"):-
    not(esMusical(weise, 1400)).

test("Ende es chismoso en 1420 ya que solo se recuerda destruir al demonio Aura que no está corroborada"):-
    esChismoso(ende, 1420).
test("Weise no es chismoso en 1400"):-
    not(esChismoso(weise, 1400)).

test("destruir al rey demonio es importante para Weise en 1400", nondet):-
    esImportante(destruirReyDemonio, weise, 1400).
test("recuperar al gato perdido no es importante para Weise en 1400 (solo Kanne la recuerda)"):-
    not(esImportante(recuperarGato, weise, 1400)).

test("Klares vive tiempos sin precedentes en 1395"):-
    sinPrecedentes(klares, 1395).
test("Weise no vive tiempos sin precedentes en 1400, destruir al rey demonio es importante para Weise pero nadie de allí presenció esa hazaña."):-
    not(sinPrecedentes(weise, 1400)).
:- end_tests(pueblos).

%tests Punto 5
:- begin_tests(esHeroe).
test("Frieren es un Heroe, ya que participo en hazania destruirAlReyDemonio", nondet):-
    esHeroe(frieren).
test("Wirbel no es un Heroe porque no participo en ninguna Hazania",[fail]):-
    esHeroe(wirbel).
:- end_tests(esHeroe).

:- begin_tests(inspirador).
test("Frieren inspiro a Fern, Fern conoce destruirAlReyDemonio donde Frieren participo", nondet):-
    inspiro(frieren, fern).
test("stark inspiro a Frieren, Frieren conoce rescatarALaHermanaDeWirbel donde Stark participo", nondet):-
    inspiro(stark, frieren).
test("nadie inspiro a Eisen a ser un Heroe, ya que no sabemos de ninguna Hazania que el conozca",[fail]):-
    inspiro(_, eisen).
:- end_tests(inspirador).

:- begin_tests(cadenas).
test("Himmel → Fern → Frieren → Denken es una cadena de inspiración válida", nondet):-
    cadenaInspiracion(himmel, [himmel,fern,frieren,denken]).
test("Denken → Frieren no es una cadena de inspiración válida porque Denken no inspiró a Frieren",[fail]):-
    cadenaInspiracion(denken, [denken,frieren]).
test("Frieren → Fern → Frieren no es una cadena de inspiración válida ya que se repite 2 veces Frieren", [fail]):-
    cadenaInspiracion(frieren, [frieren, fern, frieren]).
:- end_tests(cadenas).


