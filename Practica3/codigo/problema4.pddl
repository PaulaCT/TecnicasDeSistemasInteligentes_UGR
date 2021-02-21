;                              Ejercicio 4 - PROBLEMA
;
;                                 P3 TSI grupo 2
;                      Realizado por Paula Cumbreras Torrente
;
; VCE y Marines requieren mineral. Segadores requieren mineral y gas. El CentroDeMando podrá reclutar
; nuevos VCE y los barracones podrán generar Marines y Segadores. Modificar el fichero de problema para que el
; punto de inicio sea tener sobre el mapa solo un trabajador y un CentroDeMando. El objetivo de
; este ejercicio es disponer de un marine en una localización, y tener otro marine y un segador en
; otra.
;

(define (problem problema)
  (:domain dominio)
  (:objects
    l1_1 l1_2 l1_3 l1_4 l1_5 l2_1 l2_2 l2_3 l2_4 l2_5 l3_1 l3_2 l3_3 l3_4 l3_5 l4_1 l4_2 l4_3 l4_4 l4_5 l5_1 l5_2 l5_3 l5_4 l5_5 - localizacion
    centro barracon extractor - edificio
    u1 u2 u3 u4 u5 u6 u7 m1 m2 s1 - unidad
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
    (esTipoUnidad u1 VCE) (esTipoUnidad u2 VCE) (esTipoUnidad u3 VCE) (esTipoUnidad u4 VCE) (esTipoUnidad u5 VCE) (esTipoUnidad u6 VCE) (esTipoUnidad u7 VCE)
    (esTipoUnidad m1 Marine) (esTipoUnidad m2 Marine) (esTipoUnidad s1 Segador) (esTipoEdificio centro CentroDeMando) (esTipoEdificio barracon Barracones)
    (esTipoEdificio extractor Extractor) (esTipoRecurso min1 Minerales) (esTipoRecurso min2 Minerales) (esTipoRecurso min3 Minerales) (esTipoRecurso gas1 Gas)
    (esTipoRecurso gas2 Gas)
    ; distribución objetos
    (edificioEn centro l4_2) (unidadEn u1 l5_3) ; (unidadEn u2 l1_4) (unidadEn u3 l2_2) (unidadEn u4 l2_1)
    (asignarMaterial min1 l3_1) (asignarMaterial min2 l2_5) (asignarMaterial min3 l1_5)
    (asignarMaterial gas1 l4_4) (asignarMaterial gas2 l3_3)
    ; recursos
    (necesitaRecurso Barracones Minerales) (necesitaRecurso CentroDeMando Gas) (necesitaRecurso CentroDeMando Minerales) (necesitaRecurso Extractor Minerales)
    (recursoUnidad VCE Minerales) (recursoUnidad Marine Minerales) (recursoUnidad Segador Minerales) (recursoUnidad Segador Gas)
    (generaUnidad CentroDeMando VCE) (generaUnidad Barracones Marine) (generaUnidad Barracones Segador)
    (= (cantidadRecurso Minerales) 0)
    (= (cantidadRecurso Gas) 0)
  )
  (:goal
    (and
      (unidadEn m1 l1_2)
      (unidadEn s1 l1_2)
      (unidadEn m2 l5_4)
    )
  )
)
