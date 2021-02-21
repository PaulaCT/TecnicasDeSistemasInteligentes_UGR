% Ejercicio 9
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Un turista desea llenar su mochila con varios objetos para hacer un viaje. El peso máximo que
% aguanta la mochila son 275kg, y cada objeto tiene distinto grado de preferencia para el turista
% (la preferencia se mide en una escala de 0 a 200, donde los números más altos representan los
% objetos más deseados por el turista). En la tabla siguiente se muestran los objetos, su peso y su
% preferencia. Encontrar el conjunto de objetos cuya suma de preferencias sea máxima sin
% exceder el peso máximo que aguanta la mochila.
%   Objeto            Peso (Kg)   Preferencia
%   Mapa              9           150
%   Compás            13          35
%   Agua              153         200
%   Sandwich          50          160
%   Azúcar            15          60
%   Lata              68          45
%   Plátano           27          60
%   Manzana           39          40
%   Queso             23          30
%   Cerveza           52          10
%   Protector Solar   11          70
%   Cámara            32          30
%

% Definición variables

set of int: OBJETOS = 1..12;
set of int: DENTRO = 0..1;
var 1..890: pref_total;
var 1..493: peso_total;
var int: peso_max = 275; 
array[OBJETOS] of var int: pesos = [9,13,153,50,15,68,27,39,23,52,11,32];
array[OBJETOS] of var int: pref = [150,35,200,160,60,45,60,40,30,10,70,30];
array[OBJETOS] of var DENTRO: mochila;

% Definición funciones

function var int: aniadir(array[OBJETOS] of var int: v, array[OBJETOS] of var DENTRO: m) =
   v[1]*m[1]+v[2]*m[2]+v[3]*m[3]+v[4]*m[4]+v[5]*m[5]+v[6]*m[6]+v[7]*m[7]+v[8]*m[8]+v[9]*m[9]+v[10]*m[10]+v[11]*m[11]+v[12]*m[12];
   
predicate llenar_mochila(var int: pt, var int: prt, array[OBJETOS] of var int: p, array[OBJETOS] of var int: pr, array[OBJETOS] of var DENTRO: m) =
   pt = aniadir(p,m) /\ prt = aniadir(pr,m);
   
predicate pesar(var int: pt, var int: pm) =
   pt <= pm;

constraint llenar_mochila(peso_total,pref_total,pesos,pref, mochila);

% Restricción - peso

constraint pesar(peso_total,peso_max);

solve maximize pref_total;

% Mostrar resultados

output["Objeto  |Mapa Compás Agua Sandwich Azúcar Lata Plátano Manzana Queso Cerveza P.Solar Cámara\n",
       "S-1/N-0 |\(mochila[1])    \(mochila[2])      \(mochila[3])    \(mochila[4])        \(mochila[5])      \(mochila[6])",
       "    \(mochila[7])       \(mochila[8])       \(mochila[9])      \(mochila[10])      \(mochila[11])       \(mochila[12])\n",
       "Peso total = \(peso_total)\nSuma preferencias = \(pref_total)\n"]