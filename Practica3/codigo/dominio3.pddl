;                              Ejercicio 3 - DOMINIO
;
;                                 P3 TSI grupo 2
;                      Realizado por Paula Cumbreras Torrente
;
; Modificar la acción de Construir para que tenga en cuenta que un edificio puede
; requerir más de un tipo de recurso. La acción de construir debe inferir por sí misma si se tiene el
; tipo de recursos necesarios para poder ejecutarse. Para los siguientes ejercicios es muy importante
; definir esta restricción de forma que solo se tenga que instanciar una única vez por tipo de
; edificio. Ejemplo: Para incluir información sobre los recursos necesarios para los Barracones solo
; debe escribirse una única vez (necesita Barracones Minerales) independientemente del número de
; barracones que existan en el problema.
;


(define (domain dominio)
  (:requirements :strips :adl :typing :negative-preconditions :universal-preconditions)
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
    :parameters (?u ?tipoU - unidad ?x0 ?x1 - localizacion)
    :precondition
      (and
	(unidadEn ?u ?x0)
        (existeCamino ?x0 ?x1)
        (esTipoUnidad ?u ?tipoU)
      )
    :effect
      (and
        (unidadEn ?u ?x1)
        (not (unidadEn ?u ?x0))
      )
  )
  (:action Asignar
    :parameters (?u ?tipoU - unidad ?n ?tipo - recurso ?x - localizacion)
    :precondition
      (and
        (esTipoUnidad ?u ?tipoU)
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
    :parameters (?u ?tipoU - unidad ?e ?tipoE - edificio ?x - localizacion)
    :precondition
      (and
        (esTipoUnidad ?u ?tipoU)
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
        (unidadEn ?u ?x)
        (not (trabajando ?u))
        (not (edificioEn ?e ?x))
        (forall (?tipoN - recurso)
          (imply (necesitaRecurso ?tipoE ?tipoN) (>= (cantidadRecurso ?tipoN) 1))
        )
      )
    :effect
      (and
        (edificioEn ?e ?x)
        (forall (?tipoN - recurso)
          (when (necesitaRecurso ?tipoE ?tipoN) (decrease (cantidadRecurso ?tipoN) 1))
        )
        (when (esTipoEdificio ?e Extractor)
          (extractorContruido ?x)
        )
      )
  )
)
