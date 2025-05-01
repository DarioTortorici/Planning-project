(define (domain healthcare_scenario_1)
  (:requirements :strips :typing)

  (:types
    location - object
    medic - object 
    bot - object 
    box - object 
    content - object 
    unit - object
    patient - object
  )

  (:predicates

    ;; medics
    (medic_at ?m - medic ?l - location)
    (medic_has ?m - medic ?c - content)

    ;; bots
    (bot_at ?bot - bot ?l - location) 
    (bot_unloaded ?bot - bot ?b - box) 
    (bot_loaded ?bot - bot ?b - box) 

    ;; boxes
    (box_at ?b - box ?l - location)
    (box_empty ?b - box)
    (box_filled ?b - box ?c - content)

    ;; contents
    (content_at ?c - content ?l - location)

    ;; locations
    (connected ?l1 ?l2 - location)

    ;; units
    (unit_at ?u - unit ?l - location) 
    (unit_free ?u - unit) 
    (unit_escorting ?u - unit ?p - patient) 

    ;; patients
    (patient_at ?p - patient ?l - location)

  ) 

  ;; Bot movement
  (:action move_bot
    :parameters (?bot - bot ?from ?to - location)
    :precondition (and
      (connected ?from ?to)
      (bot_at ?bot ?from)
    )
    :effect (and
      (bot_at ?bot ?to)
      (not (bot_at ?bot ?from))
    )
  )

  ;; loads a box onto a bot
  (:action load_box
    :parameters (?bot - bot ?b - box)
    :precondition (and
      (bot_unloaded ?bot ?b)
    )
    :effect (and
      (not (bot_unloaded ?bot ?b))
      (bot_loaded ?bot ?b)
    )
  )

  ;; unloads a box from a bot
  (:action unload_box
    :parameters (?bot - bot ?b - box ?c - content ?m - medic ?l - location)
    :precondition (and
      (bot_loaded ?bot ?b)
      (box_filled ?b ?c)
      (bot_at ?bot ?l)
      (medic_at ?m ?l)
    )
    :effect (and
      (bot_unloaded ?bot ?b)
      (not (bot_loaded ?bot ?b))
      (box_empty ?b)
      (medic_has ?m ?c)
    )
  )

  ;; fills a box with content
  (:action fill_box
    :parameters (?b - box ?c - content ?l - location)
    :precondition (and
      (box_empty ?b)
      (content_at ?c ?l)
      (box_at ?b ?l)
    )
    :effect (and
      (not (box_empty ?b))
      (box_filled ?b ?c)
      (not (content_at ?c ?l))
    )
  )

  ;; unit movement
  (:action move_unit
    :parameters (?u - unit ?from ?to - location)
    :precondition (and
      (connected ?from ?to)
      (unit_at ?u ?from)
      
    )
    :effect (and
      (unit_at ?u ?to)
      (not (unit_at ?u ?from))
    )
  )

  ;; unit accompanies a patient
  (:action accompanies_patient
    :parameters (?u - unit ?p - patient ?l - location)
    :precondition (and
      (unit_free ?u)  
      (unit_at ?u ?l)
      (patient_at ?p ?l)
    )
    :effect (and
      (not (unit_free ?u))
      (unit_escorting ?u ?p)
      (not (patient_at ?p ?l))
    )
  )

  ;; unit releases a patient at a location
  (:action release_patient
    :parameters (?u - unit ?p - patient ?l - location)
    :precondition (and
      (unit_escorting ?u ?p)
      (unit_at ?u ?l)
    )
    :effect (and
      (unit_free ?u)
      (not (unit_escorting ?u ?p))
      (patient_at ?p ?l)
    )
  )
)
