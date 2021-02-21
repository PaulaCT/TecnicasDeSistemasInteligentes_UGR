% Ejercicio 5
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Encontrar una asignación de horarios que satisfaga las siguientes condiciones:
% a. Existen un aula, disponible en seis franjas consecutivas de 1h (por ejemplo, de 8:00
%    a 14:00) de lunes a viernes.
% b. Existen nueve asignaturas (A1..A9). El número de horas semanales de cada
%    asignatura se detalla en la siguiente tabla:
%    A1    A2    A3   A4   A5   A6   A7   A8   A9
%    4 hrs 2 hrs 4hrs 4hrs 4hrs 2hrs 2hrs 2hrs 1hr
% c. Las asignaturas {A1,A3,A4,A5,A8} deben impartirse en bloques de 2h
%    consecutivas, mientras que el resto, es decir {A2,A6,A7,A9}, se imparten en
%    bloques de 1h.
% d. En cada día de la semana sólo se puede impartir, como máximo, UN bloque de cada
%    asignatura.
% e. El profesor/a de cada asignatura es el siguiente: Prof1={A1,A3}; Prof2={A4,A5};
%    Prof3={A6,A9}; Prof4={A2,A7,A8}.
% f. Cada profesor sólo puede impartir un bloque de alguna de sus asignaturas cada día,
%    excepto Prof4 (quien puede impartir más de una).
% g. La cuarta franja horaria debe reservarse para el recreo; es decir, no asignar ninguna
%    asignatura.
%

include "count_fn.mzn";

% Definición variables

set of int: ASIGNATURA = 0..9;
array[1..5,1..6] of var ASIGNATURA: horario;

% Definición funciones

predicate establecer_recreo (array[int,int] of var ASIGNATURA: h) =
   forall (i in 1..5) (h[i,4]=0);

predicate bloque_dos_horas (array[int,int] of var ASIGNATURA: h, var ASIGNATURA: a) =
   forall (i in 1..5) (if count(h[i,1..6],a) != 0 then ( count(h[i,1..6],a) = 2 /\
      if h[i,1] = a then h[i,2] = a 
      elseif h[i,2] = a then h[i,3] = a 
      elseif h[i,5] = a then h[i,6] = a 
      else h[i,5] = a endif)
      endif );
      
predicate bloque_una_hora(array[int,int] of var ASIGNATURA: h, var ASIGNATURA: a) =
   forall (i in 1..5) (if count(h[i,1..6],a) != 0 then count(h[i,1..6],a) = 1 endif );

predicate bloque_profesor (array[int,int] of var ASIGNATURA: h, var ASIGNATURA: a1, var ASIGNATURA: a2) =
   forall (i in 1..5) (if count(h[i,1..6],a1) != 0 then count(h[i,1..6],a2) = 0 endif ); 
   
predicate horas_semanales (array[int,int] of var ASIGNATURA: h, var ASIGNATURA: a, var int:t) =
   t = count(h[1,1..6],a) + count(h[2,1..6],a) + count(h[3,1..6],a) + count(h[4,1..6],a) + count(h[5,1..6],a);
   
% Restricción - recreo

constraint establecer_recreo(horario);

% Restricción - 1 bloque de asignaturas (2h) por día

constraint bloque_dos_horas(horario,1);
constraint bloque_dos_horas(horario,3);
constraint bloque_dos_horas(horario,4);
constraint bloque_dos_horas(horario,5);
constraint bloque_dos_horas(horario,8);

% Restricción - 1 bloque de asignaturas (1h) por día

constraint bloque_una_hora(horario,2);
constraint bloque_una_hora(horario,6);
constraint bloque_una_hora(horario,7);
constraint bloque_una_hora(horario,9);

% Restricciones - profesor 1 bloque por día 

constraint bloque_profesor(horario,1,3);
constraint bloque_profesor(horario,4,5);
constraint bloque_profesor(horario,6,9);

% Restricciones - número de horas semanales

constraint horas_semanales(horario,0,5);
constraint horas_semanales(horario,1,4);
constraint horas_semanales(horario,2,2);
constraint horas_semanales(horario,3,4);
constraint horas_semanales(horario,4,4);
constraint horas_semanales(horario,5,4);
constraint horas_semanales(horario,6,2);
constraint horas_semanales(horario,7,2);
constraint horas_semanales(horario,8,2);
constraint horas_semanales(horario,9,1);

solve satisfy;

% Mostrar resultado

output["        L    M    X    J    V\n  8:00  \(horario[1,1])    \(horario[2,1])    \(horario[3,1])    \(horario[4,1])    \(horario[5,1])",
       "\n  9:00  \(horario[1,2])    \(horario[2,2])    \(horario[3,2])    \(horario[4,2])    \(horario[5,2])",
       "\n 10:00  \(horario[1,3])    \(horario[2,3])    \(horario[3,3])    \(horario[4,3])    \(horario[5,3])",
       "\n 11:00  \(horario[1,4])    \(horario[2,4])    \(horario[3,4])    \(horario[4,4])    \(horario[5,4])",
       "\n 12:00  \(horario[1,5])    \(horario[2,5])    \(horario[3,5])    \(horario[4,5])    \(horario[5,5])",
       "\n 13:00  \(horario[1,6])    \(horario[2,6])    \(horario[3,6])    \(horario[4,6])    \(horario[5,6])"]