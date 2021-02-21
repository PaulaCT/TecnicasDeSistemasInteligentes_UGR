% Ejercicio 4
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Encontrar una asignación de horarios que satisfaga las siguientes condiciones:
% a. Existen cuatro aulas, disponibles entre las 9:00 y las 13:00.
% b. Cada aula sólo puede estar ocupada por un único profesor/a al mismo tiempo.
% c. Existen 3 asignaturas (IA, TSI y FBD), que se imparten en periodos de 1h semanal.
% d. Los estudiantes se dividen en 4 grupos (G1, G2, G3 y G4).
% e. Cada grupo recibe docencia de una única asignatura en cada momento.
% f. Cada profesor da docencia a los grupos definidos en la siguiente tabla.
% g. Cada profesor imparte docencia de un único grupo/asignatura en cada momento.
% h. Cada profesor tiene las restricciones de horarios definidas en la siguiente tabla.
%    Profesor Asignaturas Horas no disponibles para el profesor/a
%    Prof1 IA-G1, IA-G2, TSI-G1, TSI-G2 Ninguno
%    Prof2 FBD-G1, FBD-G2 10:00-11:00
%    Prof3 TSI-G3, TSI-G4, FBD-G3, FBD-G4 Ninguno
%    Prof4 IA-G3, IA-G4 09:00-10:00
%

include "all_different.mzn";

% Definición variables

set of int: VALORES = 1..4;
set of int: HORA = 9..13;

array[1..4] of var HORA: p1;
array[1..2] of var HORA: p2; 
array[1..4] of var HORA: p3;
array[1..2] of var HORA: p4;

array[1..3] of var HORA: g1_prof = [p1[1],p1[3],p2[1]]; %horario
array[1..3] of var HORA: g2_prof = [p1[2],p1[4],p2[2]]; %horario
array[1..3] of var HORA: g3_prof = [p4[1],p3[1],p3[3]]; %horario
array[1..3] of var HORA: g4_prof = [p4[2],p3[2],p3[4]]; %horario

array[1..3] of var VALORES: g1; %aulas
array[1..3] of var VALORES: g2; %aulas
array[1..3] of var VALORES: g3; %aulas
array[1..3] of var VALORES: g4; %aulas

% Definición función
    
predicate aulas(array[int] of var VALORES: a, array[int] of var VALORES: b,
                array[int] of var HORA: a_prof, array[int] of var HORA: b_prof) =
   forall (i in 1..3) ( forall (j in 1..3) (
      if a_prof[i] = b_prof[j] then b[j] != a[i] endif ));


% Restricción - un profesor no puede dar dos clases a la vez

constraint all_different(p1);
constraint all_different(p2);
constraint all_different(p3);
constraint all_different(p4);

% Restricciones - horario profesores

constraint p2[1] != 10;
constraint p2[2] != 10;
constraint p4[1] > 9;
constraint p4[2] > 9;

% Restricción - incompatibilidad horaria por grupos

constraint all_different(g1_prof);
constraint all_different(g2_prof);
constraint all_different(g3_prof);
constraint all_different(g4_prof);

% Restricción - 1 clase por hora y aula

constraint aulas(g1,g2,g1_prof,g2_prof);
constraint aulas(g1,g3,g1_prof,g3_prof);
constraint aulas(g1,g4,g1_prof,g4_prof);
constraint aulas(g2,g3,g2_prof,g3_prof);
constraint aulas(g2,g4,g2_prof,g4_prof);
constraint aulas(g3,g4,g3_prof,g4_prof);

solve satisfy;

% Mostrar resultado

output["Grupo 1:\n IA- aula \(g1[1]) horario \(p1[1]):00\n TSI- aula \(g1[2]) horario \(p1[3]):00\n",
       " FBD- aula \(g1[3]) horario \(p2[1]):00\n",
       "Grupo 2:\n IA- aula \(g2[1]) horario \(p1[2]):00\n TSI- aula \(g2[2]) horario \(p1[4]):00\n",
       " FBD- aula \(g2[3]) horario \(p2[2]):00\n",
       "Grupo 3:\n IA- aula \(g3[1]) horario \(p4[1]):00\n TSI- aula \(g3[2]) horario \(p3[1]):00\n",
       " FBD- aula \(g3[3]) horario \(p3[3]):00\n",
       "Grupo 4:\n IA- aula \(g4[1]) horario \(p4[2]):00\n TSI- aula \(g4[2]) horario \(p3[2]):00\n",
       " FBD- aula \(g4[3]) horario \(p3[4]):00\n"];
