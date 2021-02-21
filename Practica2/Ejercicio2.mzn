% Ejercicio 2
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Encontrar un número X de 10 dígitos que satisfaga que el primer dígito de X representa el
% número de 0s en X, el segundo dígito de X representa el número de 1s en X
% Por ejemplo, el número X=6210001000 satisface dicha condición
%

include "count_fn.mzn";

% Definición variables

set of int: VALOR = 0..9;
var VALOR: d0;
var VALOR: d1;
var VALOR: d2;
var VALOR: d3;
var VALOR: d4;
var VALOR: d5;
var VALOR: d6;
var VALOR: d7;
var VALOR: d8;
var VALOR: d9;
array[1..10] of var int: x = [d0,d1,d2,d3,d4,d5,d6,d7,d8,d9];

% Definición función

predicate f(var int: n, array[int] of var int: x, int: v) =
    n = count(x,v);

% Restricciones

constraint f(d0, x, 0);
constraint f(d1, x, 1);
constraint f(d2, x, 2);
constraint f(d3, x, 3);
constraint f(d4, x, 4);
constraint f(d5, x, 5);
constraint f(d6, x, 6);
constraint f(d7, x, 7);
constraint f(d8, x, 8);
constraint f(d9, x, 9);

solve satisfy;

% Mostrar resultado

output["X= \(d0)\(d1)\(d2)\(d3)\(d4)\(d5)\(d6)\(d7)\(d8)\(d9)\n"]