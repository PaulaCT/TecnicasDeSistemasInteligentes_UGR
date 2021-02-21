% Ejercicio 8
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Resolver el ejercicio 7 suponiendo que disponemos de tres trabajadores (que en cada momento sólo 
% puede estar dedicados a una única tarea) y que las tareas requieren los siguientes trabajadores:
%   A B C D E F G H I
%   2 3 2 2 1 2 1 1 2
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
array[TAREA] of var int: costes = [7,3,1,8,2,1,1,3,2];
array[TAREA] of var int: trabajadores = [2,3,2,2,1,2,1,1,2];
var int: max_trabajadores = 3;
set of int: TIME = 1..29;
var TIME: coste_total;
array[TAREA] of var TIME: empieza;
array[TAREA] of var TIME: finaliza;
                                                                
% Definición funciones

predicate realizado_antes(array[int] of var TIME: e, array[int] of var int: c, var int:a, var int:b) =
   e[b] + c[b] <= e[a];

predicate terminar(array[int] of var int: c, array[int] of var int:e, array[int] of var int:f) =
  forall(i in 1..9) (finaliza[i] = empieza[i] + costes[i]);

predicate calcular_coste(array[int] of var int:f, var int: ct) =
   ct = max(f);

% Restricciones - orden

constraint realizado_antes(empieza,costes,B,A);
constraint realizado_antes(empieza,costes,C,B);
constraint realizado_antes(empieza,costes,D,A);
constraint realizado_antes(empieza,costes,E,C);
constraint realizado_antes(empieza,costes,E,D);
constraint realizado_antes(empieza,costes,F,C);
constraint realizado_antes(empieza,costes,F,D);
constraint realizado_antes(empieza,costes,G,C);
constraint realizado_antes(empieza,costes,G,D);
constraint realizado_antes(empieza,costes,H,A);
constraint realizado_antes(empieza,costes,I,G);
constraint realizado_antes(empieza,costes,I,H); 
constraint cumulative(empieza,costes,trabajadores,max_trabajadores);

% Cálculo de coste

constraint terminar(costes, empieza, finaliza);
constraint calcular_coste(finaliza, coste_total);

%solve satisfy;
solve minimize coste_total;

% Mostrar resultado

output["Tarea    Empieza  Termina\n",
       "A        \(empieza[1])        \(finaliza[1])\n",
       "B        \(empieza[2])       \(finaliza[2])\n",
       "C        \(empieza[3])       \(finaliza[3])\n",
       "D        \(empieza[4])        \(finaliza[4])\n",
       "E        \(empieza[5])       \(finaliza[5])\n",
       "F        \(empieza[6])       \(finaliza[6])\n",
       "G        \(empieza[7])       \(finaliza[7])\n",
       "H        \(empieza[8])        \(finaliza[8])\n",
       "I        \(empieza[9])       \(finaliza[9])\n",
       "Coste = \(coste_total)"]