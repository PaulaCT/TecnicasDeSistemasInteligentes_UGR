% Ejercicio 7
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% En la tabla adjunta aparece la información necesaria para llevar a cabo la construcción de una
% casa. En la primera columna aparecen los indentificadores de las tareas necesarias para
% construirla. En la segunda columna aparece la descripción de cada una de estas. En la tercera
% columna se muestra la duración (en días) de cada una de las tareas. Y la cuarta columna
% muestra la relación de precedencia entre tareas. Se pide encontrar una asignación de tiempos de
% inicio a estas tareas de forma que se pueda construir la casa en el menor tiempo posible,
% asumiendo que cada tarea la realiza un único trabajador y que se disponen de tantos
% trabajadores como se necesiten.
% Tarea Descripción             Duración   Predecesoras
% A     Levantar muros          7          Ninguna
% B     Carpintería de tejado   3          A
% C     Poner tejado            1          B
% D     Instalación eléctrica   8          A
% E     Pintado fachada         2          C,D
% F     Ventanas                1          C,D
% G     Jardín                  1          C,D
% H     Techado                 3          A
% I     Pintado interior        2          F,H
%

include "all_different.mzn";

% Definición variables

set of int: TAREA = 1..9;
array[1..9] of var int: costes = [7,3,1,8,2,1,1,3,2];
var int: coste_total;
array[1..9] of var TAREA: orden; 
array[1..9] of var int: empieza;
array[1..9] of var int: finaliza;

% Definición funciones

predicate realizado_antes(array[int] of var TAREA: x, var int:a, var int:b) =
   x[a] > x[b];

predicate empezar(array[int] of var TAREA: o, array[int] of var int: c, array[int] of var int:e, array[int] of var int:f) =
   forall (i in 1..9) (
      forall (j in 1..9) (
         if o[j] = i then e[i] = empezar_anteriores(o,f,j) /\ f[i] = e[i]+c[j] endif
      )
   );
   
function var int: empezar_anteriores(array[int] of var TAREA: o, array[int] of var int: f, var int: p) =
   if p = 1 then 1 elseif p = 2 \/ p = 4 \/ p = 8 then  f[o[1]] elseif p = 3 then f[o[2]] 
   elseif p = 5 \/ p = 6 \/ p = 7  then max(f[o[3]], f[o[4]]) elseif p = 9 then max(f[o[6]], f[o[8]]) else 0 endif;

predicate calcular_coste(array[int] of var int:f, var int: ct) =
   ct = max(f);
   
% Restricción - cada acción se realiza una vez 

constraint all_different(orden);

% Restricciones - orden

constraint realizado_antes(orden,2,1);
constraint realizado_antes(orden,3,2);
constraint realizado_antes(orden,4,1);
constraint realizado_antes(orden,5,3);
constraint realizado_antes(orden,5,4);
constraint realizado_antes(orden,6,3);
constraint realizado_antes(orden,6,4);
constraint realizado_antes(orden,7,3);
constraint realizado_antes(orden,7,4);
constraint realizado_antes(orden,8,1);
constraint realizado_antes(orden,9,6);
constraint realizado_antes(orden,9,8); 

% Cálculo de coste

constraint empezar(orden, costes, empieza, finaliza);
constraint calcular_coste(finaliza, coste_total);

%solve satisfy;
solve minimize coste_total;

% Mostrar resultado

output["Tarea    Empieza  Termina\n",
       "A        \(empieza[orden[1]])        \(finaliza[orden[1]])\n",
       "B        \(empieza[orden[2]])        \(finaliza[orden[2]])\n",
       "C        \(empieza[orden[3]])       \(finaliza[orden[3]])\n",
       "D        \(empieza[orden[4]])        \(finaliza[orden[4]])\n",
       "E        \(empieza[orden[5]])       \(finaliza[orden[5]])\n",
       "F        \(empieza[orden[6]])       \(finaliza[orden[6]])\n",
       "G        \(empieza[orden[7]])       \(finaliza[orden[7]])\n",
       "H        \(empieza[orden[8]])        \(finaliza[orden[8]])\n",
       "I        \(empieza[orden[9]])       \(finaliza[orden[9]])\n",
       "Coste = \(coste_total)"]
