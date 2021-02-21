;                              Ejercicio 1 - PROBLEMA
;
;                                 P3 TSI grupo 2
;                      Realizado por Paula Cumbreras Torrente
;
; Definir un fichero de problema con un mapa de, al menos, 5x5 localizaciones de tamaño. En
; una de las localizaciones deben encontrarse un CentroDeMando y al menos tres VCE. En el mapa
; debe haber al menos tres nodos de mineral y dos de gas. Para poder construir los barracones hace
; falta tener minerales, mientras que para poder construir nuevos Centros de Mando hace falta gas.
; El objetivo (:goal) de este ejercicio es la construcción de un edificio de Barracones en una
; localización.
;

(define (problem problema)
  (:domain dominio)
  (:objects
    l1_1 l1_2 l1_3 l1_4 l1_5 l2_1 l2_2 l2_3 l2_4 l2_5 l3_1 l3_2 l3_3 l3_4 l3_5 l4_1 l4_2 l4_3 l4_4 l4_5 l5_1 l5_2 l5_3 l5_4 l5_5 - localizacion
    centro barracon - edificio
    u1 u2 u3 - unidad
    min1 min2 min3 gas1 gas2 - recurso
  )
  (:init
    ; creación grid
    (existeCamino l1_1 l2_1) (existeCamino l2_1 l1_1) (existeCamino l1_1 l1_2) (existeCamino l1_2 l1_1) (existeCamino l1_2 l2_2) (existeCamino l2_2 l1_2) (existeCamino l1_2 l1_3)
    (existeCamino l1_3 l1_2) (existeCamino l1_2 l1_1) (existeCamino l1_1 l1_2) (existeCamino l1_3 l2_3) (existeCamino l2_3 l1_3) (existeCamino l1_3 l1_4) (existeCamino l1_4 l1_3)
    (existeCamino l1_3 l1_2) (existeCamino l1_2 l1_3) (existeCamino l1_4 l2_4) (existeCamino l2_4 l1_4) (existeCamino l1_4 l1_5) (existeCamino l1_5 l1_4) (existeCamino l1_4 l1_3)
    (existeCamino l1_3 l1_4) (existeCamino l1_5 l2_5) (existeCamino l2_5 l1_5) (existeCamino l1_5 l1_4) (existeCamino l1_4 l1_5) (existeCamino l2_1 l1_1) (existeCamino l1_1 l2_1)
    (existeCamino l2_1 l3_1) (existeCamino l3_1 l2_1) (existeCamino l2_1 l2_2) (existeCamino l2_2 l2_1) (existeCamino l2_2 l1_2) (existeCamino l1_2 l2_2) (existeCamino l2_2 l3_2)
    (existeCamino l3_2 l2_2) (existeCamino l2_2 l2_3) (existeCamino l2_3 l2_2) (existeCamino l2_2 l2_1) (existeCamino l2_1 l2_2) (existeCamino l2_3 l1_3) (existeCamino l1_3 l2_3)
    (existeCamino l2_3 l3_3) (existeCamino l3_3 l2_3) (existeCamino l2_3 l2_4) (existeCamino l2_4 l2_3) (existeCamino l2_3 l2_2) (existeCamino l2_2 l2_3) (existeCamino l2_4 l1_4)
    (existeCamino l1_4 l2_4) (existeCamino l2_4 l3_4) (existeCamino l3_4 l2_4) (existeCamino l2_4 l2_5) (existeCamino l2_5 l2_4) (existeCamino l2_4 l2_3) (existeCamino l2_3 l2_4)
    (existeCamino l2_5 l1_5) (existeCamino l1_5 l2_5) (existeCamino l2_5 l3_5) (existeCamino l3_5 l2_5) (existeCamino l2_5 l2_4) (existeCamino l2_4 l2_5) (existeCamino l3_1 l2_1)
    (existeCamino l2_1 l3_1) (existeCamino l3_1 l4_1) (existeCamino l4_1 l3_1) (existeCamino l3_1 l3_2) (existeCamino l3_2 l3_1) (existeCamino l3_2 l2_2) (existeCamino l2_2 l3_2)
    (existeCamino l3_2 l4_2) (existeCamino l4_2 l3_2) (existeCamino l3_2 l3_3) (existeCamino l3_3 l3_2) (existeCamino l3_2 l3_1) (existeCamino l3_1 l3_2) (existeCamino l3_3 l2_3)
    (existeCamino l2_3 l3_3) (existeCamino l3_3 l4_3) (existeCamino l4_3 l3_3) (existeCamino l3_3 l3_4) (existeCamino l3_4 l3_3) (existeCamino l3_3 l3_2) (existeCamino l3_2 l3_3)
    (existeCamino l3_4 l2_4) (existeCamino l2_4 l3_4) (existeCamino l3_4 l4_4) (existeCamino l4_4 l3_4) (existeCamino l3_4 l3_5) (existeCamino l3_5 l3_4) (existeCamino l3_4 l3_3)
    (existeCamino l3_3 l3_4) (existeCamino l3_5 l2_5) (existeCamino l2_5 l3_5) (existeCamino l3_5 l4_5) (existeCamino l4_5 l3_5) (existeCamino l3_5 l3_4) (existeCamino l3_4 l3_5)
    (existeCamino l4_1 l3_1) (existeCamino l3_1 l4_1) (existeCamino l4_1 l5_1) (existeCamino l5_1 l4_1) (existeCamino l4_1 l4_2) (existeCamino l4_2 l4_1) (existeCamino l4_2 l3_2)
    (existeCamino l3_2 l4_2) (existeCamino l4_2 l5_2) (existeCamino l5_2 l4_2) (existeCamino l4_2 l4_3) (existeCamino l4_3 l4_2) (existeCamino l4_2 l4_1) (existeCamino l4_1 l4_2)
    (existeCamino l4_3 l3_3) (existeCamino l3_3 l4_3) (existeCamino l4_3 l5_3) (existeCamino l5_3 l4_3) (existeCamino l4_3 l4_4) (existeCamino l4_4 l4_3) (existeCamino l4_3 l4_2)
    (existeCamino l4_2 l4_3) (existeCamino l4_4 l3_4) (existeCamino l3_4 l4_4) (existeCamino l4_4 l5_4) (existeCamino l5_4 l4_4) (existeCamino l4_4 l4_5) (existeCamino l4_5 l4_4)
    (existeCamino l4_4 l4_3) (existeCamino l4_3 l4_4) (existeCamino l4_5 l3_5) (existeCamino l3_5 l4_5) (existeCamino l4_5 l5_5) (existeCamino l5_5 l4_5) (existeCamino l4_5 l4_4)
    (existeCamino l4_4 l4_5) (existeCamino l5_1 l4_1) (existeCamino l4_1 l5_1) (existeCamino l5_1 l5_2) (existeCamino l5_2 l5_1) (existeCamino l5_2 l4_2) (existeCamino l4_2 l5_2)
    (existeCamino l5_2 l5_3) (existeCamino l5_3 l5_2) (existeCamino l5_2 l5_1) (existeCamino l5_1 l5_2) (existeCamino l5_3 l4_3) (existeCamino l4_3 l5_3) (existeCamino l5_3 l5_4)
    (existeCamino l5_4 l5_3) (existeCamino l5_3 l5_2) (existeCamino l5_2 l5_3) (existeCamino l5_4 l4_4) (existeCamino l4_4 l5_4) (existeCamino l5_4 l5_5) (existeCamino l5_5 l5_4)
    (existeCamino l5_4 l5_3) (existeCamino l5_3 l5_4) (existeCamino l5_5 l4_5) (existeCamino l4_5 l5_5) (existeCamino l5_5 l5_4) (existeCamino l5_4 l5_5)
    ; asignación tipos
    (esTipoUnidad u1 VCE) (esTipoUnidad u2 VCE) (esTipoUnidad u3 VCE) (esTipoEdificio centro CentroDeMando) (esTipoEdificio barracon Barracones)
    (esTipoRecurso min1 Minerales) (esTipoRecurso min2 Minerales) (esTipoRecurso min3 Minerales) (esTipoRecurso gas1 Gas) (esTipoRecurso gas2 Gas)
    ; distribución objetos
    (edificioEn centro l4_2) (unidadEn u1 l5_3) (unidadEn u2 l1_4) (unidadEn u3 l2_2)
    (asignarMaterial min1 l3_1) (asignarMaterial min2 l2_5) (asignarMaterial min3 l1_5)
    (asignarMaterial gas1 l4_4) (asignarMaterial gas2 l3_3)
    ; recursos
    (necesitaRecurso Barracones Minerales) (necesitaRecurso CentroDeMando Gas)
    (= (cantidadRecurso Minerales) 0)
    (= (cantidadRecurso Gas) 0)
  )
  (:goal
    (edificioEn barracon l5_1)
  )
)
