;                              Ejercicio 2 - DOMINIO
;
;                                 P3 TSI grupo 2
;                      Realizado por Paula Cumbreras Torrente
;
; Incluir una restricción nueva a la extracción de recursos, de forma que, para
; poder obtener Gas, primero deberá construirse un extractor sobre el nodo. Añadir el edificio
; Extractor. Modificar la acción Asignar para que solo pueda asignarse un VCE a un
; nodo de gas si tiene construido un extractor.
;


(define (domain dominio)
  (:requirements :strips :typing :negative-preconditions)
  (:types
    unidad edificio recurso localizacion
  )
  (:constants
    VCE - unidad
    CentroDeMando Barracones Extractor - edificio
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
    (extractorContruido ?x - localizacion)
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
    :parameters (?u - unidad ?n ?tipo - recurso ?x - localizacion)
    :precondition
      (and
        (esTipoUnidad ?u VCE)
        (not (trabajando ?u))
        (asignarMaterial ?n ?x)
        (unidadEn ?u ?x)
        (esTipoRecurso ?n ?tipo)
        (or
          (and
            (esTipoRecurso ?n Gas)
            (extractorContruido ?x)
          )
          (esTipoRecurso ?n Minerales)
        )
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
        (or
          (and
            (esTipoEdificio ?e Extractor)
            (exists (?gas - recurso)
              (and
                (asignarMaterial ?gas ?x)
                (esTipoRecurso ?gas Gas)
              )
            )
          )
          (not (esTipoEdificio ?e Extractor))
        )
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
        (when (esTipoEdificio ?e Extractor)
          (extractorContruido ?x)
        )
      )
  )
)
