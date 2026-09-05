%!Parte 1.a

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


%!Parte 1.b
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
    Anio >= AnioConocio,            % para el punto 3
    sigueRecordando(Medio, AnioConocio, Anio).

%!Punto2B
corroborada(Nombre):-
    conoce(_, hazania(Nombre, Personas, Lugar), _, _),
    forall(
        conoce(_, hazania(Nombre, Personas2, Lugar2), _, _),
        (Personas == Personas2, Lugar == Lugar2)
    ).

%!Punto2C
pasoAlOlvido(NombreHazania, Anio):-
    conoce(_, hazania(NombreHazania, _, _), _, _),
    not(hazaniaRecordada(_, NombreHazania, Anio)).


%!Punto 3A

%conmemora(Pueblo, Hazania, AnioComienzo, TipoFestival)
conmemora(weise, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1340, festival).
conmemora(auberst, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1370, estatua(elEquipoDeHeroes, bronce)).
conmemora(auberst, hazania(destruirSchlatElOmnisciente, [heroeDelSur], ende), 1340, estatua(elHeroeDelSur, marmol)).

% mantenimientoEstatua(estatua, anio)
mantenimientoEstatua(elEquipoDeHeroes, 1400).
mantenimientoEstatua(elEquipoDeHeroes, 1450).
mantenimientoEstatua(elHeroeDelSur, 1410).

%!Punto 3B
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


conoce(Persona, Hazania, AnioComienzo, MedioDeConocimiento):-
    habitante(Persona, _, _, Pueblo),                                   %habitante(nombre, raza, nacimiento, pueblo).
    conmemora(Pueblo, Hazania, AnioComienzo, MedioDeConocimiento).      %conmemora(Pueblo, Hazania, AnioComienzo, TipoFestival)

sigueRecordando(festival, _, _).
sigueRecordando(estatua(NombreEstatua, _), AnioComienzo, Anio):-
    estatuaEnBuenEstado(NombreEstatua, Anio).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parte 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%!Punto 4
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
    paginasLeidasEnPueblo(Pueblo, Anio, PaginasPueblo),
    forall(
        (habitante(_, _, _, OtroPueblo), paginasLeidasEnPueblo(OtroPueblo, Anio, PaginasOtroPueblo)),
        not(PaginasOtroPueblo > PaginasPueblo)).

esMusical(Pueblo, Anio):-
    findall(Hazania,
        puebloRecuerdaHazania(Pueblo, Hazania, Anio),
        Hazanias),
    hazaniasConCancion(Hazanias, HazaniasCancion, Pueblo),
    length(Hazanias, CantidadTotal),
    length(HazaniasCancion, CantidadCancion),
    CantidadCancion >= CantidadTotal / 2.

hazaniasConCancion([], [], _).

hazaniasConCancion([Hazania|Hazanias], [Hazania|HazaniasCancion], Pueblo):-
    conoce(Persona, hazania(Hazania, _, _), _, cancion),
    habitante(Persona, _, _, Pueblo),
    hazaniasConCancion(Hazanias, HazaniasCancion, Pueblo).

hazaniasConCancion([_|Hazanias], HazaniasCancion, Pueblo):-
    hazaniasConCancion(Hazanias, HazaniasCancion, Pueblo).

esChismoso(Pueblo, Anio):-
    puebloRecuerdaHazania(Pueblo, _, Anio),
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
    esImportante(_, Pueblo, Anio),
    forall(
        esImportante(Hazania, Pueblo, Anio),
        (
            conoce(Persona, hazania(Hazania, _, _), _, presencio),
            habitante(Persona, _, _, Pueblo)
        )
    ).

%!Punto 5
%A
esHeroe(Persona):-  %cualquier hazania
    conoce(_, hazania(_, Heroes, _), _, _),      %conoce(Persona,hazania(nombreHazania, [personas], lugar), AnioConocimiento, MedioDeConocimiento)
    member(Persona, Heroes). %persona es algunos que haya participado de la lista de heroe

%B
inspiro(Inspirador, Heroe):-
                            %heroe que acompaniaron
    conoce(Heroe, hazania(_, Heroes, _), _, _),  %conoce(Persona,hazania(nombreHazania, [personas], lugar), AnioConocimiento, MedioDeConocimiento)
    member(Inspirador, Heroes),%son aquellos que participaron en las hazañas que el héroe conoció.
    Inspirador \= Heroe.
%C
cadenaInspiracion(Inicio, Cadena):-
    cadenaInspiracionAux(Inicio, [], Cadena),
    length(Cadena, Largo),
    Largo >= 2,
    forall(member(Persona, Cadena), esHeroe(Persona)).

cadenaInspiracionAux(Heroe, Visitados, [Heroe]):- %la cadena [Heroe] (solo él, sin nadie más) es una cadena válida
    not(member(Heroe, Visitados)).

cadenaInspiracionAux(Heroe, Visitados, [Heroe|Resto]):-
    not(member(Heroe, Visitados)),%si heroe principal ya esta en la cadena(si esta, corta la recursion)
    inspiro(Heroe, Siguiente),%siguiente quienes inspiraron
    cadenaInspiracionAux(Siguiente, [Heroe|Visitados], Resto).

%!Punto 6
antecesor(Antecesor, Heroe):-
    cadenaInspiracion(Antecesor, Cadena),
    append(Antecesores, [Heroe | _], Cadena),
    member(Antecesor, Antecesores).

antecesoresDe(Heroe, Antecesores):-
    findall(Antecesor, antecesor(Antecesor, Heroe), Antecesores).

subconjunto([], []).

% subconjunto(ListaAntecesores, AntecesoresElegidos)
subconjunto([Personaje | PersonajesRestantes], [Personaje | SubconjuntoRestante]):-
    subconjunto(PersonajesRestantes, SubconjuntoRestante).

subconjunto([_ | PersonajesRestantes], Subconjunto):-
    subconjunto(PersonajesRestantes, Subconjunto).

equipoDeLosSuenios(Heroe, Equipo):-
    esHeroe(Heroe),
    antecesoresDe(Heroe, ListaAntecesores),
    subconjunto(ListaAntecesores, AntecesoresElegidos),
    AntecesoresElegidos \= [],
    append(AntecesoresElegidos, [Heroe], Integrantes),
    permutation(Integrantes, Equipo).

%!Tests
:- begin_tests(habitantes).

test("humanos y enanos no viven mas alla de su esperanza de vida", nondet):-
    assertion(estaVivoEn(kanne, 1370)),
    assertion(estaVivoEn(voll, 1550)),
    assertion(not(estaVivoEn(voll, 1551))),
    assertion(not(estaVivoEn(kanne, 2000))).

test("nadie puede vivir antes de haber nacido, sin importar su raza"):-
    assertion(not(estaVivoEn(denken, 1289))),
    assertion(not(estaVivoEn(voll, 1199))),
    assertion(not(estaVivoEn(serie, 499))).

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

test("Destruir al demonio Aura pasó al olvido en 1460", nondet):-
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

test("Un pueblo recuerda una hazania si un habitante que vive en ese pueblo la recuerda.", nondet):-
    assertion(puebloRecuerdaHazania(weise, destruirReyDemonio, 1400)),
    assertion(puebloRecuerdaHazania(klares, rescatarHermanaWirbel, 1395)),
    assertion(not(puebloRecuerdaHazania(klares, destruirReyDemonio, 1395))).

test("El total de paginas leidas en un pueblo en un anio es la sumatoria de todas las paginas leidas por cada habitante que vive en ese pueblo."):-
    assertion(paginasLeidasEnPueblo(weise, 1335, 100)),
    assertion(paginasLeidasEnPueblo(weise, 1336, 0)).

test("Un pueblo es el mas lector en un año determinado si ningun otro pueblo leyó mas paginas que él.", nondet):-
    puebloMasLector(1400, ende).

test("Un pueblo es musical si la mayoria de las hazanias recordadas en el pueblo son mediante canciones."):-
    assertion(esMusical(aubert, 1395)),
    assertion(not(esMusical(weise, 1400))).

test("Un pueblo es chismoso si ninguna de las hazanias recordadas por el pueblo esta corroborada.", nondet):-
    assertion(esChismoso(ende, 1420)),
    assertion(not(esChismoso(weise, 1400))).

test("Una Hazania es importante para un pueblo en un año determinado si todos los habitantes vivos del pueblo recuerdan esa hazania.", nondet):-
    assertion(esImportante(destruirReyDemonio, weise, 1400)),
    assertion(not(esImportante(recuperarGato, weise, 1400))).

test("Un pueblo vive tiempos sin precedentes en un año determinado si todas las hazanias importantes del pueblo fueron presenciadas por alguien del pueblo.", nondet):-
    assertion(sinPrecedentes(klares, 1395)),
    assertion(not(sinPrecedentes(weise, 1400))).

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

:- begin_tests(dreamteam).
 test("Fern + Himmel es un dream team válido para Fern", nondet):-
    equipoDeLosSuenios(fern, [fern, himmel]).

 test("Himmel + Fern es un dream team válido para Fern", nondet):-
    equipoDeLosSuenios(fern, [himmel, fern]).

 test("Fern sola no es un dream team válido para Fern", [fail]):-
    equipoDeLosSuenios(fern, [fern]).

 test("Frieren sola no es un dream team válido para Fern", [fail]):-
    equipoDeLosSuenios(fern, [frieren]).
:- end_tests(dreamteam).