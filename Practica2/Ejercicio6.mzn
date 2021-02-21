% Ejercicio 6
% P2 TSI grupo 2- Realizado por Paula Cumbreras Torrente
%
% Cinco personas de cinco regiones diferentes viven en las primeras cinco casas contiguas de una
% calle. Practican cinco profesiones distintas, y cada uno tiene un animal y una bebida favoritos,
% todos ello diferentes. Las casas están pintadas con diferentes colores. Ademas sabemos lo
% siguiente:
% a. El vasco vive en la casa roja.
% b. El catalán tiene un perro.
% c. El gallego es un pintor.
% d. El navarro bebe te.
% e. El andaluz vive en la primera casa de la izquierda.
% f. El de la casa verde bebe café.
% g. La casa verde está al lado de la blanca y a su derecha.
% h. El escultor cría caracoles.
% i. El diplomático vive en la casa amarilla.
% j. En la casa central se bebe leche.
% k. La casa del andaluz está al lado de la azul.
% l. El violinista bebe zumo.
% m. El zorro está en una casa al lado de la del médico.
% n. El caballo está en una casa al lado de la del diplomático.
% Resolver el problema de forma que podamos responder: ¿dónde está la cebra y quién bebe agua?
%

include "all_different.mzn";

% Definición variable

set of int: OPCIONES = 1..5;

% Casas 1..5 (izq..der)

array[1..5, 1..5] of var OPCIONES: matriz;

var OPCIONES: region = 1;
var OPCIONES: color = 2;
var OPCIONES: profesion = 3;
var OPCIONES: animal = 4;
var OPCIONES: bebida = 5;

% Región 1..5 (vasco, catalán, gallego, navarro, andaluz)
% Color_casa 1..5 (rojo, verde, blanco, amarillo, azul)
% Profesiones 1..5 (pintor, escultor, diplomático, violinista, médico)
% Animal (perro, caracoles, zorro, caballo, cebra)
% Bebida (te, cafe, leche, zumo, agua)

var OPCIONES: cebra;
var OPCIONES: agua;

% Definición funciones

predicate asignar_casa(array[int,int] of var OPCIONES: m, var OPCIONES: casa, var OPCIONES: caract, var OPCIONES: q) =
   m[casa,caract]=q;

predicate asignar_si(array[int,int] of var OPCIONES: m, var OPCIONES: q1, var OPCIONES: caract1, var OPCIONES: q2, var OPCIONES: caract2)=
   forall (i in 1..5) (
      if m[i,caract1]=q1 then m[i,caract2]=q2 endif
   ); 
   
predicate al_lado(array[int,int] of var OPCIONES: m, var OPCIONES: q1, var OPCIONES: caract1, var OPCIONES: q2, var OPCIONES: caract2)=
   forall (i in 1..5) (
      if m[i,caract1]=q1 then ( if i<=4 then m[i+1,caract2]=q2 endif ) \/ ( if i>=2 then m[i-1,caract2]=q2 endif ) endif 
   );
   
predicate al_la_derecha(array[int,int] of var OPCIONES: m, var OPCIONES: q1, var OPCIONES: caract1, var OPCIONES: q2, var OPCIONES: caract2)=
   forall (i in 1..5) (
      if m[i,caract1]=q1 then ( if i<=4 then m[i+1,caract2]=q2 endif ) endif 
   );
   
predicate no_repetir(array[int,int] of var OPCIONES: m)=
   forall (i in 1..5) (
      all_different(matriz[1..5,i])
   );
   
predicate buscar(array[int,int] of var OPCIONES: m, var OPCIONES: q, var OPCIONES: caract, var OPCIONES: sol)=
   forall (i in 1..5) (
      if m[i,caract]=q then sol=i endif 
   );
   
% Restricciones - conociendo la casa

constraint asignar_casa(matriz,1,region,5); % El andaluz vive en la primera casa de la izquierda.
constraint asignar_casa(matriz,3,bebida,3); % En la casa central se bebe leche.

% Restricciones - sin conocer la casa

constraint asignar_si(matriz,1,region,1,color); % El vasco vive en la casa roja.
constraint asignar_si(matriz,2,region,1,animal); % El catalán tiene un perro.
constraint asignar_si(matriz,3,region,1,profesion); % El gallego es un pintor.
constraint asignar_si(matriz,4,region,1,bebida); % El navarro bebe te.
constraint asignar_si(matriz,2,color,2,bebida); % El de la casa verde bebe café.
constraint asignar_si(matriz,2,profesion,2,animal); % El escultor cría caracoles.
constraint asignar_si(matriz,3,profesion,4,color); % El diplomático vive en la casa amarilla.
constraint asignar_si(matriz,4,profesion,4,bebida); % El violinista bebe zumo.

% Restricciones - posición de las casas

constraint al_la_derecha(matriz,2,color,3,color); % La casa verde está al lado de la blanca y a su derecha.
constraint al_lado(matriz,4,profesion,5,color); % La casa del andaluz está al lado de la azul.
constraint al_lado(matriz,3,animal,5,profesion); % El zorro está en una casa al lado de la del médico.
constraint al_lado(matriz,4,animal,3,profesion); % El caballo está en una casa al lado de la del diplomático.

constraint no_repetir(matriz);

% Encontrar solución

constraint buscar(matriz,5,animal,cebra);
constraint buscar(matriz,5,bebida,agua);

solve satisfy;

% Mostrar resultado

output ["casa       1    2    3    4    5\nregion     \(matriz[1,1])    \(matriz[2,1])    \(matriz[3,1])    \(matriz[4,1])    \(matriz[5,1])",
       "\ncolor      \(matriz[1,2])    \(matriz[2,2])    \(matriz[3,2])    \(matriz[4,2])    \(matriz[5,2])",
       "\nprofesion  \(matriz[1,3])    \(matriz[2,3])    \(matriz[3,3])    \(matriz[4,3])    \(matriz[5,3])",
       "\nanimal     \(matriz[1,4])    \(matriz[2,4])    \(matriz[3,4])    \(matriz[4,4])    \(matriz[5,4])",
       "\nbebida     \(matriz[1,5])    \(matriz[2,5])    \(matriz[3,5])    \(matriz[4,5])    \(matriz[5,5])",
       "\n\nLa cebra la tiene el \(matriz[cebra,region]) en la casa \(cebra)\nBebe agua el \(matriz[agua,region]) en la casa \(agua)",
       "\n\n[Region: 1-vasco, 2-catalan, 3-gallego, 4-navarro,5-andaluz]\n[Casas numeradas de izquierda a derecha]"];