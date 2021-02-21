% Ejercicio 9
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Resolver el ejercicio 8 suponiendo ahora que cada tarea la realiza un único trabajador y
% que los tres son capaces de realizar cualquier tarea, pero el tiempo que cada trabajador requiere
% para finalizarla es distinto. La duración de cada tarea dependiendo del trabajador que la realiza
% se muestra en la siguiente tabla.
%       A B C D E F G H I
%   Tr1 4 3 3 2 4 3 1 1 2
%   Tr2 7 5 1 5 2 2 2 3 3
%   Tr3 10 7 4 8 6 1 3 5 4
%

include "all_different.mzn";
include "cumulative.mzn";

% Definición variables

set of int: TAREA = 1..9;
var TAREA: A=1;
var TAREA: B=2;
var TAREA: C=3;
var TAREA: D=4;
var TAREA: E=5;
var TAREA: F=6;
var TAREA: G=7;
var TAREA: H=8;
var TAREA: I=9;
array[1..3,TAREA] of var int: coste;
var int: max_trabajadores = 3;
set of int: TIME = 1..29;
var TIME: coste_total;
array[TAREA] of var TIME: empieza;
array[TAREA] of var TIME: finaliza;
array[TAREA] of var int: trabaja;
                                                                
% Definición funciones

predicate inicializar_coste(array[int,TAREA] of var int: c) =
  c[1,1]= 4 /\ c[1,2]= 3 /\ c[1,3]= 3 /\ c[1,4]= 3 /\ c[1,5]= 4 /\ c[1,6]= 3 /\ c[1,7]= 1 /\ c[1,8]= 1 /\ c[1,9]= 2 /\
  c[2,1]= 7 /\ c[2,2]= 5 /\ c[2,3]= 1 /\ c[2,4]= 5 /\ c[2,5]= 2 /\ c[2,6]= 2 /\ c[2,7]= 2 /\ c[2,8]= 3 /\ c[2,9]= 3 /\
  c[3,1]= 10 /\ c[3,2]= 7 /\ c[3,3]= 4 /\ c[3,4]= 8 /\ c[3,5]= 6 /\ c[3,6]= 1 /\ c[3,7]= 3 /\ c[3,8]= 5 /\ c[3,9]= 4 ;

predicate cumulative_multi(array[TAREA] of var TIME: e, array[int,TAREA] of var int: c, array[TAREA] of var int: w, var int: mr) =
   let { set of int: times = lb_array(e)..max([ ub(e[i]) + ub(c[w[i],i]) | i in TAREA ]) } 
   in forall( t in times ) (
      mr >= sum( i in TAREA ) 
      ( e[i] <= t /\ t < e[i] + c[w[i],i] )
   );

predicate realizado_antes(array[int] of var TIME: e, array[int,TAREA] of var int: c, var int:a, var int:b, array[TAREA] of var int: t) =
   e[b] + c[t[b],b] <= e[a];

predicate un_trabajador(array[TAREA] of var int: t, array[TAREA] of var TIME: e) =
   forall (i in 1..9) (
     forall (j in 1..9) (
       if i != j /\ e[i] = e[j] then t[i] != t[j] endif
     )
   );
   
predicate varios_trabajos(array[TAREA] of var int: t, array[TAREA] of var TIME: e, array[TAREA] of var TIME: f, var int: tr) =
   forall (i in 1..9) (
     forall (j in 1..9) (
       if i != j /\ t[i] = tr then
          if e[j] >= e[i] /\ e[j] < f[i] then t[j] != tr
          elseif f[j] > e[i] /\ f[j] <= f[i] then t[j] != tr
          else e[j] = e[j] endif
       endif
     )
   );

predicate terminar(array[int,TAREA] of var int: c, array[TAREA] of var int: t, array[TAREA] of var TIME:e, array[TAREA] of var TIME:f) =
  forall(i in 1..9) (f[i] = e[i] + c[t[i],i]);

predicate calcular_coste(array[int] of var int:f, var int: ct) =
   ct = max(f);
   
function var int: mini(var int: a, var int: b, var int: c) =
  min(min(a,b),min(b,c));

constraint inicializar_coste(coste);

% Restricciones - orden

constraint realizado_antes(empieza,coste,B,A,trabaja);
constraint realizado_antes(empieza,coste,C,B,trabaja);
constraint realizado_antes(empieza,coste,D,A,trabaja);
constraint realizado_antes(empieza,coste,E,C,trabaja);
constraint realizado_antes(empieza,coste,E,D,trabaja);
constraint realizado_antes(empieza,coste,F,C,trabaja);
constraint realizado_antes(empieza,coste,F,D,trabaja);
constraint realizado_antes(empieza,coste,G,C,trabaja);
constraint realizado_antes(empieza,coste,G,D,trabaja);
constraint realizado_antes(empieza,coste,H,A,trabaja);
constraint realizado_antes(empieza,coste,I,G,trabaja);
constraint realizado_antes(empieza,coste,I,H,trabaja); 
constraint cumulative_multi(empieza,coste,trabaja,max_trabajadores);

% Restricciones - varios trabajos a la vez

constraint varios_trabajos(trabaja,empieza,finaliza,1);
constraint varios_trabajos(trabaja,empieza,finaliza,2);
constraint varios_trabajos(trabaja,empieza,finaliza,3);

% Cálculo de coste

constraint terminar(coste, trabaja, empieza, finaliza);
constraint calcular_coste(finaliza, coste_total);

%solve satisfy;
solve minimize coste_total;

% Mostrar resultado

output["Tarea    Empieza  Termina   Trabajador\n",
       "A        \(empieza[1])        \(finaliza[1])         \(trabaja[1])\n",
       "B        \(empieza[2])        \(finaliza[2])         \(trabaja[2])\n",
       "C        \(empieza[3])        \(finaliza[3])         \(trabaja[3])\n",
       "D        \(empieza[4])        \(finaliza[4])        \(trabaja[4])\n",
       "E        \(empieza[5])       \(finaliza[5])        \(trabaja[5])\n",
       "F        \(empieza[6])       \(finaliza[6])        \(trabaja[6])\n",
       "G        \(empieza[7])       \(finaliza[7])        \(trabaja[7])\n",
       "H        \(empieza[8])        \(finaliza[8])         \(trabaja[8])\n",
       "I        \(empieza[9])       \(finaliza[9])        \(trabaja[9])\n",
       "Coste = \(coste_total)"]