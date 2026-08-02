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
    habitante(Persona, Raza, Nacimiento, _),
    tiempoDeVida(Raza, Esperanza),
    AnioMaximo is Nacimiento + Esperanza,
    between(Nacimiento, AnioMaximo, Anio).
    

estaVivoEn(Persona, Anio):-
    habitante(Persona, elfo, Nacimiento, _),
    Nacimiento =< Anio.

%Punto2A
conoce(wirbel, hazania(rescatarHermanaWirbel, [stark, fern], klares), 1390, presencio).
conoce(frieren, hazania(rescatarHermanaWirbel, [stark, fern], klares), 1390, presencio).
conoce(lawine, hazania(destruirAura, [frieren], weise), 1393, cancion).
conoce(voll, hazania(destruirAura, [denken], auberst), 1400, libro(50)).
conoce(serie, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1335, libro(100)).
conoce(kanne, hazania(recuperarGato, [himmel, frieren], weise), 1375, presencio).

duracionRecuerdo(cancion, 15).
duracionRecuerdo(libro(Paginas), Paginas).

hazaniaRecordada(Persona, NombreHazania, Anio):-
    conoce(Persona, hazania(NombreHazania, _, _), AnioConocimiento, presencio),
    Anio >= AnioConocimiento,
    estaVivoEn(Persona, Anio).

hazaniaRecordada(Persona, NombreHazania, Anio):-
    conoce(Persona, hazania(NombreHazania, _, _), AnioConocimiento, MedioDeConocimiento),
    duracionRecuerdo(MedioDeConocimiento, Duracion),
    Anio >= AnioConocimiento,
    Anio =< AnioConocimiento + Duracion.

%Punto2B
corroborada(Nombre):-
    conoce(_, hazania(Nombre, Personas, Lugar), _, _),
    forall(
        conoce(_, hazania(Nombre, Personas2, Lugar2), _, _),
        (Personas == Personas2, Lugar == Lugar2)
    ).
%Punto2C
pasoAlOlvido(NombreHazania, Anio):-
    not(hazaniaRecordada(_, NombreHazania, Anio)).



%Punto 3A

%festivo(pueblo, hazania, anioDeFestivo)
festivo(weise, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1340).

%estatuas(pueblo, nombreEstaatua, tipoMaterial, hazania, anio)
estatuas(auberst, elEquipoDeHeroes, bronce, hazania(destruirReyDemonio, [frieren, himmel, heiter, eisen], ende), 1370).
estatuas(auberst, elHeroeDelSur, marmol, hazania(destruirSchlatElOmnisciente, [heroeDelSur], ende), 1340).

% mantenimientoEstatua(estatua, anio)
mantenimientoEstatua(elEquipoDeHeroes, 1400).
mantenimientoEstatua(elEquipoDeHeroes, 1450).
mantenimientoEstatua(elHeroeDelSur, 1410).

%Punto 3B
%limiteEstatua(tipoMaterial, limiteEstatua)
limiteEstatua(marmol, 30).
limiteEstatua(bronce, 15).

%estatuaEnBuenEstado(estatua, anio)
%estutua en buen estado sin mantenimiento
estatuaEnBuenEstado(Estatua, Anio):-
    estatuas(_, Estatua, TipoMaterial, _, AnioEstatua),         %estatuas(pueblo, nombreEstaatua, tipoMaterial, hazania, anio)
    limiteEstatua(TipoMaterial, LimiteEstatua),                 %limiteEstatua(tipoMaterial, limiteEstatua)
    Anio >= AnioEstatua,
    Anio - AnioEstatua =< LimiteEstatua.

%estatua en buen estado con mantenimiento
estatuaEnBuenEstado(Estatua, Anio):-
    estatuas(_, Estatua, TipoMaterial, _, AnioEstatua),         %estatuas(pueblo, nombreEstaatua, tipoMaterial, hazania, anio)
    mantenimientoEstatua(Estatua, AnioMantenimiento),           % mantenimientoEstatua(estatua, anio)
    limiteEstatua(TipoMaterial, LimiteEstatua),                 %limiteEstatua(tipoMaterial, limiteEstatua)
    Anio >= AnioMantenimiento,
    Anio - AnioMantenimiento =< LimiteEstatua.

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

test("Voll recuerda destruir al demonio Aura en 1450"):-
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
test("La estatua "elEquipoDeHeroes" esta en buen estado en anio 1380 porque no paso el limite de anios", nondet):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1380).
test("La estatua "elEquipoDeHeroes" esta en buen estado en anio 1410 porque se hizo un mantenimiento en 1400", nondet):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1410).
test("La estatua "elEquipoDeHeroes" esta en buen estado en anio 1460 porque se hizo un mantenimiento en 1450", nondet):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1460).
test("la estatua "elEquipoDeHeroes" no esta en buen estado en anio 1390, porque paso limite de anios", [fail]):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1390).

%mantenimiento en anio 1410
test("La estatua "elHeroeDelSur" esta en buen estado en anio 1360 poruqe no paso el limite de anios", nondet):-
    estatuaEnBuenEstado(elHeroeDelSur, 1360).
test("La estatua "elHeroeDelSur" no esta en buen estado en anio 1380 porque paso el limite de anios", [fail]):-
    estatuaEnBuenEstado(elHeroeDelSur, 1380).
test("La estatua "elHeroeDelSur" esta en buen estado en anio 1420 porque se hizo un mantenimiento en 1410", nondet):-
    estatuaEnBuenEstado(elHeroeDelSur, 1420).
:- end_tests(estatuas).

