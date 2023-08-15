%Base de conocimiento:
atleta(dante, 22, argentina).
atleta(fede, 22, argentina).
atleta(usainBolt, 33, jamaica).

compiteEn(basket, dante).
compiteEn(cienMetrosLLanosMasculinos, fede).
compiteEn(futbol, dante).

pais(Pais):-
    atleta(_,_,Pais).

entrega(basket, oro, argentina).
entrega(cienMetrosLLanosMasculinos, plata, fede).
entrega(cienMetrosLLanosMasculinos, oro, usainBolt).

evento(basket, faseDeGrupos, argentina).
evento(basket, final, argentina).
evento(futbol, faseDeGrupos, argentina).
%Punto 2:
vinoAPasear(Atleta):-
    nombreAtleta(Atleta),
    not(compiteEn(_,Atleta)).

%Punto 3:
medallasDelPais(Pais, Disciplina, Medalla):-
    entrega(Disciplina, Medalla, CompetidorOPais),
    esPaisOCompetidorDelPais(CompetidorOPais, Pais).

esPaisOCompetidorDelPais(Pais, Pais):-
    pais(Pais).
esPaisOCompetidorDelPais(Competidor, Pais):-
    atletaDePais(Competidor, Pais).

atletaDePais(Atleta, Pais):-
    atleta(Atleta,_,Pais).

%Punto 4:
participoEn(Ronda, Disciplina, Atleta):- %Sólo disciplinas Individuales.
    evento(Disciplina, Ronda, Participante),
    participanteIndividual(Participante, Atleta),
    compiteEn(Disciplina, Atleta).

participanteIndividual(Atleta, Atleta):-
    nombreAtleta(Atleta).
participanteIndividual(Pais, Atleta):-
    atletaDePais(Atleta, Pais).

nombreAtleta(Atleta):-
    atleta(Atleta,_,_).

%Punto 5:
dominio(Pais,Disciplina):-
    disciplina(Disciplina),
    pais(Pais),
    forall(entrega(Disciplina,_,MiembroDePodio), atletaDePais(MiembroDePodio,Pais)).

%Punto 6:
medallaRapida(Disciplina):-
    entrega(Disciplina,oro,Ganador),
    not(participoEnMasDeUnaRonda(Ganador, Disciplina)).

participoEnMasDeUnaRonda(Ganador, Disciplina):-
    evento(Disciplina, Ronda1, Ganador),
    evento(Disciplina, Ronda2, Ganador),
    Ronda1 \= Ronda2.

%Punto 7:
noEsElFuerte(Pais,Disciplina):-
    pais(Pais),
    disciplina(Disciplina),
    forall(evento(Disciplina,Ronda, Participante), noParticipoOSoloInicial(Pais, Ronda, Participante)).

disciplina(Disciplina):-
    entrega(Disciplina,_,_).

noParticipoOSoloInicial(Pais, RondaInicial, Participante):-
    esRondaInicialYParticipanteDePais(Pais, RondaInicial, Participante).
noParticipoOSoloInicial(Pais, Ronda, Participante):-
    not(esRondaInicial(Ronda)),
    not(esPaisOCompetidorDelPais(Participante,Pais)).

esRondaInicial(faseDeGrupos).
esRondaInicial(ronda1).

esRondaInicialYParticipanteDePais(Pais, Ronda, Participante):-
    esRondaInicial(Ronda),
    esPaisOCompetidorDelPais(Participante, Pais).

%Punto 8:
medallasEfectivas(Pais,CuentaFinalDeMedallas):-
    pais(Pais),
    findall(Puntos,puntosPorMedallaDePais(Pais,Puntos), TodosLosPuntos),
    sum_list(TodosLosPuntos, CuentaFinalDeMedallas).

puntosPorMedallaDePais(Pais,Puntos):-
    medallasDelPais(Pais,_,Medalla),
    puntosPorMedalla(Medalla,Puntos).

puntosPorMedalla(oro, 3).
puntosPorMedalla(plata,2).
puntosPorMedalla(bronce,1).

%Punto 9:
laEspecialidad(Atleta):-
    participoEn(_,_,Atleta),
    forall(participoEn(_,Disciplina,Atleta), ganoMedallaDeOroOPlata(Atleta,Disciplina)).

ganoMedallaDeOroOPlata(Atleta,Disciplina):-
    ganadorDeMedallaDe(Ganador, Disciplina, Medalla),
    oroOPlata(Medalla),
    participanteIndividual(Ganador, Atleta).


ganadorDeMedallaDe(Atleta, Disciplina, Medalla):-
    entrega(Disciplina, Medalla, Atleta).

oroOPlata(oro).
oroOPlata(plata).