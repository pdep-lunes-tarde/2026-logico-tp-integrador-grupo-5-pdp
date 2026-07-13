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



:- begin_tests(tpIntegrador, []).

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

:- end_tests(tpIntegrador).
