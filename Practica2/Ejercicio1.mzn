% Ejercicio 1
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Puzzle Cripto-aritmético. El siguiente problema plantea un problema criptoaritmético, de forma
% que cada letra codifica un único dígito (es decir, un número entero en [0,9]) y cada dígito está
% asignado a una única letra. Se pide encontrar una asignación de dígitos a letras que satisfaga la
% siguiente suma (una posible traducción del alemán es “Prueba a fondo tus fortalezas”):
%
%   TESTE
% + FESTE
% + DEINE
% =======
%  KRAFTE
%

include "all_different.mzn";

% Definición variables

set of int: VALOR = 0..9;
set of int: VALOR1 = 1..9;
var VALOR1: T;
var VALOR1: F;
var VALOR1: D;
var VALOR: E;
var VALOR: S;
var VALOR: I;
var VALOR: N;
var VALOR1: K;
var VALOR: R;
var VALOR: A;
array[1..10] of var int: letras = [T,F,D,E,S,I,N,K,R,A];

% Restricciones 1 letra por dígito

constraint all_different(letras);

% Restricción suma

constraint   10000*T + 1000*E + 100*S + 10*T + E
           + 10000*F + 1000*E + 100*S + 10*T + E
           + 10000*D + 1000*E + 100*I + 10*N + E 
= 100000*K + 10000*R + 1000*A + 100*F + 10*T + E;

solve satisfy;

% Mostrar resultados

output["T=", show(T), " F=", show(F), " D=", show(D), " E=", show(E), " S=", show(S),
      " I=", show(I), " N=", show(N), " K=", show(K), " R=", show(R), " A=", show(A),
      " \n    \(T)\(E)\(S)\(T)\(E)\n  + \(F)\(E)\(S)\(T)\(E)\n  + \(D)\(E)\(I)\(N)\(E)\n",
      "    ======\n   \(K)\(R)\(A)\(F)\(T)\(E)\n"];