(define (domain healthcare_scenario_1_rigorous)
  (:requirements :strips :typing)

  (:types
    location - object
    medic - object 
    bot - object 
    box - object 
    content - object 

    ;; added types to model better
    aspirine - content 
    scalpel - content
    tongue_depressor - content

    unit - object
    patient - object
  )

  (:predicates

    ;; medics
    (medic_at ?m - medic ?l - location)
    (medic_has ?m - medic ?c - content)

    (has_aspirine ?m - medic) ;; added predicates for each content
    (has_scalpel ?m - medic) 
    (has_tongue_depressor ?m - medic) 

    ;; bots
    (bot_at ?bot - bot ?l - location) 
    (bot_unloaded ?bot - bot) ;; modified the bot_(un)/loaded predicate with the new logic
    (bot_loaded ?bot - bot) 

    ;; boxes
    (box_at ?b - box ?l - location) 
    (bot_has_box ?b - box ?bot - bot) ;; added predicate to check if a bot has a box 
    (box_empty ?b - box) 
    (box_filled ?b - box) ;; removed the content predicate from the box_filled predicate
    (box_has_content ?c - content ?b - box) ;; added predicate to check if a box has a content 

    ;; contents
    (content_at ?c - content ?l - location)
    (content_available ?c - content) ;; added predicate to check if a content is available

    ;; locations
    (connected ?l1 ?l2 - location)

    ;; "maid" units
    (unit_at ?u - unit ?l - location) 
    (unit_free ?u - unit) 
    (unit_busy ?u - unit);; added predicate to check if a unit is busy to model one unit per patient
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
      (bot_unloaded ?bot)
    )
    :effect (and
      (bot_at ?bot ?to)
      (not (bot_at ?bot ?from))
    )
  )

  ;; Bot movement with a box
  (:action move_bot_with_box ;; added action to model the movement of a bot with a box
    :parameters (?bot - bot ?b - box ?from ?to - location)
    :precondition (and
      (connected ?from ?to)
      (bot_at ?bot ?from)
      (bot_has_box ?b ?bot)
    )
    :effect (and
      (bot_at ?bot ?to)
      (not (bot_at ?bot ?from))
      (not (box_at ?b ?from))
      (box_at ?b ?to)
    )
  )

  ;; Loads a box onto a bot
  (:action load_box
    :parameters (?bot - bot ?b - box ?l - location)
    :precondition (and
      (bot_at ?bot ?l)
      (bot_unloaded ?bot)
      (box_at ?b ?l)
    )
    :effect (and
      (not (bot_unloaded ?bot))
      (bot_loaded ?bot)
      (bot_has_box ?b ?bot)
      (not (box_at ?b ?l))
    )
  )

  ;; Unloads a box from a bot and places it at a location
  (:action unload_box ;; modified the unload_box action without the medic delivery
    :parameters (?bot - bot ?b - box ?l - location)
    :precondition (and
      (bot_loaded ?bot)
      (bot_has_box ?b ?bot)
    )
    :effect (and
      (not (bot_loaded ?bot))
      (bot_unloaded ?bot)
      (not (bot_has_box ?b ?bot))
      (box_at ?b ?l)
    )
  )

  ;; Fills a box with content
  (:action fill_box
    :parameters (?bot - bot ?l - location ?b - box ?c - content)
    :precondition (and
      (bot_at ?bot ?l)
      (box_at ?b ?l)
      (content_at ?c ?l)
      (box_empty ?b)
      (content_available ?c)
    )
    :effect (and
      (box_has_content ?c ?b)
      (not (box_empty ?b))
      (box_filled ?b)
      (not (content_at ?c ?l))
    )
  )

  ;; Deliver aspirine to medic
  (:action deliver_aspirine
    :parameters (?bot - bot ?b - box ?aspirine - aspirine ?l - location ?m - medic)
    :precondition (and
      (bot_at ?bot ?l)
      (box_has_content ?aspirine ?b)
      (box_at ?b ?l)
      (medic_at ?m ?l)
      (box_filled ?b)
    )
    :effect (and
      (box_empty ?b)
      (not (box_filled ?b))
      (content_at ?aspirine ?l)
      (medic_has ?m ?aspirine)
      (not (box_has_content ?aspirine ?b))
      (not (content_available ?aspirine))
      (has_aspirine ?m)
    )
  )

  ;; Deliver scalpel to medic
  (:action deliver_scalpel
    :parameters (?bot - bot ?b - box ?scalpel - scalpel ?l - location ?m - medic)
    :precondition (and
      (bot_at ?bot ?l)
      (box_has_content ?scalpel ?b)
      (box_at ?b ?l)
      (medic_at ?m ?l)
      (box_filled ?b)
    )
    :effect (and
      (box_empty ?b)
      (not (box_filled ?b))
      (content_at ?scalpel ?l)
      (medic_has ?m ?scalpel)
      (not (box_has_content ?scalpel ?b))
      (not (content_available ?scalpel))
      (has_scalpel ?m)
    )
  )

  ;; Deliver tongue depressor to medic
  (:action deliver_tongue_depressor
    :parameters (?bot - bot ?b - box ?tongue_depressor - tongue_depressor ?l - location ?m - medic)
    :precondition (and
      (bot_at ?bot ?l)
      (box_has_content ?tongue_depressor ?b)
      (box_at ?b ?l)
      (medic_at ?m ?l)
      (box_filled ?b)
    )
    :effect (and
      (box_empty ?b)
      (not (box_filled ?b))
      (content_at ?tongue_depressor ?l)
      (medic_has ?m ?tongue_depressor)
      (not (box_has_content ?tongue_depressor ?b))
      (not (content_available ?tongue_depressor))
      (has_tongue_depressor ?m)
    )
  )

  ;; Unit movement
  (:action move_unit
    :parameters (?u - unit ?from ?to - location)
    :precondition (and
      (connected ?from ?to)
      (unit_at ?u ?from)
      (unit_free ?u)
    )
    :effect (and
      (unit_at ?u ?to)
      (not (unit_at ?u ?from))
    )
  )

  ;; Unit movement with a patient
  (:action move_patient_with_unit
    :parameters (?u - unit ?p - patient ?from ?to - location)
    :precondition (and
      (connected ?from ?to)
      (unit_at ?u ?from)
      (unit_busy ?u)
      (unit_escorting ?u ?p)
      (patient_at ?p ?from)
    )
    :effect (and
      (unit_at ?u ?to)
      (not (unit_at ?u ?from))
      (not (patient_at ?p ?from))
      (patient_at ?p ?to)
    )
  )

  ;; Unit equivalent lo load a box with a patient
  (:action accompanies_patient
    :parameters (?u - unit ?p - patient ?l - location)
    :precondition (and
      (unit_at ?u ?l)
      (unit_free ?u)
      (patient_at ?p ?l)
    )
    :effect (and
      (not (unit_free ?u))
      (unit_busy ?u)
      (unit_escorting ?u ?p)
    )
  )

  ;; Unit releases a patient at a location (equivalent to unattach a carrier from a bot)
  (:action leave_patient
  :parameters (?u - unit ?p - patient ?l - location)
  :precondition (and
    (unit_busy ?u)
    (unit_escorting ?u ?p)
    (unit_at ?u ?l)
  )
  :effect (and
    (not (unit_busy ?u))
    (unit_free ?u)
    (not (unit_escorting ?u ?p))
    (patient_at ?p ?l)
  )
)

)