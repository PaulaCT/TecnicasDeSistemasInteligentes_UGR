;                              Ejercicio 1 - DOMINIO
;
;                                 P3 TSI grupo 2
;                      Realizado por Paula Cumbreras Torrente
;
; Diseñar y programar una versión inicial del dominio de planificación propuesto.
; Los dominios diseñados deben cumplir con los requisitos propuestos en las siguientes líneas.
;  -Representar en el dominio los tipos: Unidades, Edificios, y Localizaciones. Usar constantes
;   para representar el tipo de unidad VCE, los tipos de edificio CentroDeMando y Barracones,
;   y los tipos de recursos Minerales y Gas.
;  -Definir los predicados necesarios para:
;    *Determinar si un edificio o unidad están en una localización concreta.
;    *Representar que existe un camino entre dos localizaciones.
;    *Asignar un nodo de un recurso concreto a una localización concreta.
;    *Indicar si un VCE están extrayendo un recurso.
;    *Definir qué recurso necesita cada edificio para ser construido.
;  -El dominio debe contener las siguientes 3 acciones definidas:
;    *Navegar: Mueve a una unidad entre dos localizaciones.
;    *Asignar: Asigna un trabajador a un nodo de recurso. Por simplicidad, un trabajador
;     asignado a un nodo de mineral ya no podrá hacer nada más el resto de la ejecución.
;    *Construir: Ordena a un trabajador libre que construya un edificio en una localización.
; En esta implementación, un edificio solo requerirá de un único tipo de recurso para ser
; construido.
;

(define (domain dominio)
  (:requirements :strips :typing :negative-preconditions)
  (:types
    unidad edificio recurso localizacion
  )
  (:constants
    VCE - unidad
    CentroDeMando Barracones - edificio
    Minerales Gas - recurso
  )
  (:predicates
    (unidadEn ?u - unidad ?x - localizacion)
    (edificioEn ?e - edificio ?x - localizacion)
    (existeCamino ?x1 - localizacion ?x2 - localizacion)
    (asignarMaterial ?n - recurso ?x - localizacion)
    (extrayendo ?u - unidad ?n - recurso)
    (trabajando ?u - unidad)
    (necesitaRecurso ?e - edificio ?n - recurso)
    (esTipoUnidad ?u ?t - unidad)
    (esTipoEdificio ?e ?t - edificio)
    (esTipoRecurso ?n ?t - recurso)
  )
  (:functions
    (cantidadRecurso ?n - recurso)
  )
  (:action Navegar
    :parameters (?u - unidad ?x0 ?x1 - localizacion)
    :precondition
      (and
        (esTipoUnidad ?u VCE)
        (unidadEn ?u ?x0)
        (existeCamino ?x0 ?x1)
      )
    :effect
      (and
        (unidadEn ?u ?x1)
        (not (unidadEn ?u ?x0))
      )
  )
  (:action Asignar
    :parameters (?u - unidad ?n ?tipo - recurso ?x -localizacion)
    :precondition
      (and
        (esTipoUnidad ?u VCE)
        (not (trabajando ?u))
        (asignarMaterial ?n ?x)
        (unidadEn ?u ?x)
      )
    :effect
      (and
        (extrayendo ?u ?n)
        (trabajando ?u)
        (increase (cantidadRecurso ?tipo) 1)
      )
  )
  (:action Construir
    :parameters (?u - unidad ?e ?tipoE - edificio ?x - localizacion ?tipoN - recurso)
    :precondition
      (and
        (esTipoUnidad ?u VCE)
        (esTipoEdificio ?e ?tipoE)
        (necesitaRecurso ?tipoE ?tipoN)
        (unidadEn ?u ?x)
        (not (trabajando ?u))
        (not (edificioEn ?e ?x))
        (>= (cantidadRecurso ?tipoN) 1)
      )
    :effect
      (and
        (edificioEn ?e ?x)
        (decrease (cantidadRecurso ?tipoN) 1)
      )
  )
)
