% Ejercicio 3
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Encontrar una asignación de horarios que satisfaga las siguientes condiciones:
% a. Existe una única aula, disponible entre las 9:00 y las 15:00.
% b. El aula sólo puede estar ocupada por un único profesor/a al mismo tiempo.
% c. Cada profesor/a debe impartir una clase de 1h de duración.
% d. Cada profesor/a tiene las siguientes restricciones de horarios:
%    Profesor Horario disponible
%    Prof-1 11:00 – 15:00
%    Prof-2 11:00 – 13:00
%    Prof-3 10:00 – 14:00
%    Prof-4 10:00 – 13:00
%    Prof-5 11:00 – 13:00
%    Prof-6 09:00 – 15:00
%

include "all_different.mzn";

% Definición variables

var 11..14: p1;
var 11..12: p2;
var 10..13: p3;
var 10..12: p4;
var 11..12: p5;
var 9..15: p6;
array[1..6] of var int: clases = [p1,p2,p3,p4,p5,p6];

% Restricción 1 hora por profesor

constraint all_different(clases);

solve satisfy;

% Mostrar resultado

output["Profesor 1: ", show (p1),":00\nProfesor 2: ", show (p2),":00\nProfesor 3: ", show (p3),
       ":00\nProfesor 4: ", show (p4),":00\nProfesor 5: ", show (p5),":00\nProfesor 6: ", show (p6),":00"];
