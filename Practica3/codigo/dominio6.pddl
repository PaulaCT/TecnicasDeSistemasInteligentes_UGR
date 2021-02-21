;                              Ejercicio 6 - DOMINIO
;
;                                 P3 TSI grupo 2
;                      Realizado por Paula Cumbreras Torrente
;
; Modificar todos los elementos necesarios del dominio para que este sea capaz de
; usar información numérica.
;   -Incluir una nueva acción para recolectar recursos de un nodo y almacenarlos. Cada vez
;    que se llame a esta acción se actualizará el número de minerales o gas guardado. Por
;    cada trabajador asignado a un nodo se incrementará en 10 el recurso3. Incluir una nueva
;    acción para desasignar VCE de un nodo.
;   -Modificar las acciones de Construir, Reclutar e Investigar para para consumir un cierto
;    número de recursos. Estos recursos deben estar almacenados y ser suficientes para
;    poder ejecutar la acción.
;   -Poner un límite a la cantidad de recursos de un tipo que se puede almacenar. Incluir un
;    nuevo edificio “Depósito”. Cada depósito incrementará el límite de almacenamiento en
;    cierta magnitud. Empezando por un límite de 100 unidades de cada recurso, cada
;    depósito incrementará el límite en otras 100 unidades.
;


(define (domain dominio)
  (:requirements :strips :adl :typing :negative-preconditions :universal-preconditions :equality)
  (:types
    unidad edificio recurso investigacion localizacion
  )
  (:constants
    VCE Marine Segador - unidad
    CentroDeMando Barracones Extractor BahiaDeIngenieria Deposito - edificio
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
    (almacenLleno ?n - recurso)
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
    (maximoAlmacen)
    (capacidadRecoleccion)
    (costeConstruccion ?e - edificio ?n - recurso)
    (costeReclutamiento ?u - unidad ?n - recurso)
    (costeInvestigacion ?i - investigacion ?n - recurso)
    (numTrabajadores ?n - recurso)
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
    :parameters (?u - unidad ?n ?tipo - recurso ?x ?xu - localizacion)
    :precondition
      (and
        (esTipoUnidad ?u VCE)
        (not (trabajando ?u))
        (asignarMaterial ?n ?x)
        (unidadEn ?u ?xu)
        (existeCamino ?x ?xu)
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
        (increase (numTrabajadores ?tipo) 1)
      )
  )
  (:action Desasignar
    :parameters (?u - unidad ?n ?tipo - recurso)
    :precondition
      (and
        (esTipoUnidad ?u VCE)
        (trabajando ?u)
        (extrayendo ?u ?n)
        (esTipoRecurso ?n ?tipo)
      )
    :effect
      (and
        (not (extrayendo ?u ?n))
        (not (trabajando ?u))
        (decrease (numTrabajadores ?tipo) 1)
      )
  )
  (:action Recolectar
    :parameters (?n ?tipo - recurso)
    :precondition
      (and
        (not (almacenLleno ?tipo))
        (esTipoRecurso ?n ?tipo)
        (<= (cantidadRecurso ?tipo) (- (maximoAlmacen) (* (numTrabajadores ?tipo) (capacidadRecoleccion))))
      )
    :effect
      (and
        (increase (cantidadRecurso ?tipo)(* (numTrabajadores ?tipo) (capacidadRecoleccion)))
        (when (> (cantidadRecurso ?tipo) (- (maximoAlmacen) (* (numTrabajadores ?tipo) (capacidadRecoleccion))))
          (almacenLleno ?tipo)
        )
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
          (imply (recursoInvestigar ?tipoI ?tipoN) (>= (cantidadRecurso ?tipoN) (costeInvestigacion ?tipoI ?tipoN)))
        )
      )
    :effect
      (and
        (investigacionFinalizada ?i)
        (forall (?tipoN - recurso)
          (when (recursoInvestigar ?tipoI ?tipoN) (decrease (cantidadRecurso ?tipoN) (costeInvestigacion ?tipoI ?tipoN)))
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
          (imply (recursoUnidad ?tipoU ?tipoN) (>= (cantidadRecurso ?tipoN) (costeReclutamiento ?tipoU ?tipoN)))
        )
      )
    :effect
      (and
        (unidadEn ?u ?x)
        (forall (?tipoN - recurso)
          (when (recursoUnidad ?tipoU ?tipoN) (decrease (cantidadRecurso ?tipoN) (costeReclutamiento ?tipoU ?tipoN)))
        )
      )
  )
  (:action Construir
    :parameters (?u - unidad ?e ?tipoE - edificio ?x - localizacion)
    :precondition
      (and
        (not (exists (?x0 - localizacion) (edificioEn ?e ?x0)))
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
          (imply (necesitaRecurso ?tipoE ?tipoN) (>= (cantidadRecurso ?tipoN) (costeConstruccion ?tipoE ?tipoN)))
        )
      )
    :effect
      (and
        (when (esTipoEdificio ?e Deposito)
          (and
            (increase (maximoAlmacen) 100)
            (not (almacenLleno Gas))
            (not (almacenLleno Minerales))
          )
        )
        (edificioEn ?e ?x)
        (forall (?tipoN - recurso)
          (when (necesitaRecurso ?tipoE ?tipoN) (decrease (cantidadRecurso ?tipoN) (costeConstruccion ?tipoE ?tipoN)))
        )
        (when (esTipoEdificio ?e Extractor)
          (extractorContruido ?x)
        )
      )
  )
)
