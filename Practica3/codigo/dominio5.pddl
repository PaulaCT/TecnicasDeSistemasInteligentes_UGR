;                              Ejercicio 5 - DOMINIO
;
;                                 P3 TSI grupo 2
;                      Realizado por Paula Cumbreras Torrente
;
; Incluir en el dominio todos los elementos necesarios para usar una nueva acción
; Investigar. Esta acción permitirá realizar nuevas investigaciones para la base. Las investigaciones
; se desbloquean en un nuevo edificio “Bahía de Ingeniería”. Crear una investigación “Impulsor Segador”.
; Modificar la acción Reclutar para que no se puedan crear Segadores hasta que no se haya obtenido
; esta investigación.
;


(define (domain dominio)
  (:requirements :strips :adl :typing :negative-preconditions :universal-preconditions :equality)
  (:types
    unidad edificio recurso investigacion localizacion
  )
  (:constants
    VCE Marine Segador - unidad
    CentroDeMando Barracones Extractor BahiaDeIngenieria - edificio
    Minerales Gas - recurso
    ImpulsorSegador - investigacion
  )
  (:predicates
    ; localizacion
    (unidadEn ?u - unidad ?x - localizacion)
    (edificioEn ?e - edificio ?x - localizacion)
    (existeCamino ?x1 - localizacion ?x2 - localizacion)
    (asignarMaterial ?n - recurso ?x - localizacion)
    (extractorContruido ?x - localizacion)
    (investigacionFinalizada ?i - investigacion)
    ; trabajo
    (extrayendo ?u - unidad ?n - recurso)
    (trabajando ?u - unidad)
    ; generacion
    (necesitaRecurso ?e - edificio ?n - recurso)
    (recursoUnidad ?u - unidad ?n - recurso)
    (recursoInvestigar ?i - investigacion ?n - recurso)
    (generaUnidad ?e - edificio ?u - unidad)
    ; tipos
    (esTipoUnidad ?u ?t - unidad)
    (esTipoEdificio ?e ?t - edificio)
    (esTipoRecurso ?n ?t - recurso)
    (esTipoInvestigacion ?i ?t - investigacion)
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
  (:action Investigar
    :parameters (?i ?tipoI - investigacion ?e - edificio ?x - localizacion)
    :precondition
      (and
        (edificioEn ?e ?x)
        (esTipoEdificio ?e BahiaDeIngenieria)
        (not (investigacionFinalizada ?i))
        (forall (?tipoN - recurso)
          (imply (recursoInvestigar ?tipoI ?tipoN) (>= (cantidadRecurso ?tipoN) 1))
        )
      )
    :effect
      (and
        (investigacionFinalizada ?i)
        (forall (?tipoN - recurso)
          (when (recursoInvestigar ?tipoI ?tipoN) (decrease (cantidadRecurso ?tipoN) 1))
        )
      )
  )
  (:action Reclutar
    :parameters (?u ?tipoU - unidad ?e ?tipoE - edificio ?x - localizacion)
    :precondition
      (and
        (not (exists (?x0 - localizacion) (unidadEn ?u ?x0)))
        (esTipoUnidad ?u ?tipoU)
        (or
          (and
            (= ?tipoU Segador)
            (exists (?i - investigacion)
              (and
                (investigacionFinalizada ?i)
                (esTipoInvestigacion ?i ImpulsorSegador)
              )
            )
          )
          (not (= ?tipoU Segador))
        )
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
