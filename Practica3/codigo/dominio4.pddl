;                              Ejercicio 4 - DOMINIO
;
;                                 P3 TSI grupo 2
;                      Realizado por Paula Cumbreras Torrente
;
; Crear una acción Reclutar para crear nuevas unidades. Incluir dos nuevos tipos de
; unidades, el Marine y el Segador. Al igual que los edificios, la creación de cada unidad requiere
; distintos recursos. VCE y Marines requieren mineral. Segadores requieren mineral y gas. Cada
; edificio podrá generar unas unidades u otras.
;


(define (domain dominio)
  (:requirements :strips :adl :typing :negative-preconditions :universal-preconditions)
  (:types
    unidad edificio recurso localizacion
  )
  (:constants
    VCE Marine Segador - unidad
    CentroDeMando Barracones Extractor - edificio
    Minerales Gas - recurso
  )
  (:predicates
    ; localizacion
    (unidadEn ?u - unidad ?x - localizacion)
    (edificioEn ?e - edificio ?x - localizacion)
    (existeCamino ?x1 - localizacion ?x2 - localizacion)
    (asignarMaterial ?n - recurso ?x - localizacion)
    (extractorContruido ?x - localizacion)
    ; trabajo
    (extrayendo ?u - unidad ?n - recurso)
    (trabajando ?u - unidad)
    ; generacion
    (necesitaRecurso ?e - edificio ?n - recurso)
    (recursoUnidad ?u - unidad ?n - recurso)
    (generaUnidad ?e - edificio ?u - unidad)
    ; tipos
    (esTipoUnidad ?u ?t - unidad)
    (esTipoEdificio ?e ?t - edificio)
    (esTipoRecurso ?n ?t - recurso)
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
        (increase (cantidadRecurso ?tipo) 5)
      )
  )
  (:action Reclutar
    :parameters (?u ?tipoU - unidad ?e ?tipoE - edificio ?x - localizacion)
    :precondition
      (and
        (not (exists (?x0 - localizacion) (unidadEn ?u ?x0)))
        (esTipoUnidad ?u ?tipoU)
        (esTipoEdificio ?e ?tipoE)
        (edificioEn ?e ?x)
        (generaUnidad ?tipoE ?tipoU)
        (forall (?tipoN - recurso)
          (imply (recursoUnidad ?tipoU ?tipoN) (>= (cantidadRecurso ?tipoN) 1))
        )
      )
    :effect
      (and
        (unidadEn ?u ?x)
        (forall (?tipoN - recurso)
          (when (recursoUnidad ?tipoU ?tipoN) (decrease (cantidadRecurso ?tipoN) 1))
        )
      )
  )
  (:action Construir
    :parameters (?u - unidad ?e ?tipoE - edificio ?x - localizacion)
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
