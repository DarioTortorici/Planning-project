(define (domain healthcare_scenario_2_numericFluents)
  (:requirements :strips :typing :numeric-fluents)

  (:types
    location - object
    medic - object 
    bot - object 
    box - object 
    carrier - object 
    capacity - object
    content - object 
    aspirine - content 
    scalpel - content
    tongue_depressor - content
    unit - object
    patient - object
  )
  
  (:functions
    (carrier_capacity ?cap - capacity) ;; Capacity of the carrier
    (carrier_load ?cap - capacity) ;; Current load in the carrier
  )

  (:predicates

    ;; medics
    (medic_at ?m - medic ?l - location)
    (medic_has ?m - medic ?c - content)
    (has_aspirine ?m - medic) 
    (has_scalpel ?m - medic) 
    (has_tongue_depressor ?m - medic) 

    ;; bots
    (bot_at ?bot - bot ?l - location) 
    (bot_has_carrier ?bot - bot ?car - carrier) 
    (bot_free ?bot - bot)

    ;; boxes
    (box_at ?b - box ?l - location) 
    (box_empty ?b - box) 
    (box_filled ?b - box) 
    (box_has_content ?c - content ?b - box) 

    ;; carriers
    (carrier_at ?car - carrier ?l - location)
    (carrier_has_box ?car - carrier ?b - box)
    (carrier_has_capacity ?car - carrier ?cap - capacity) ;; Carrier definition of capacity

    ;; contents
    (content_available ?c - content) 
    (content_at ?c - content ?l - location)

    ;; locations
    (connected ?l1 ?l2 - location)

    ;; "maid" units
    (unit_at ?u - unit ?l - location) 
    (unit_free ?u - unit) 
    (unit_busy ?u - unit)
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
      (bot_free ?bot)
    )
    :effect (and
      (bot_at ?bot ?to)
      (not (bot_at ?bot ?from))
    )
  )

  ;; Bot movement with a carrier
  (:action move_bot_with_carrier
    :parameters (?bot - bot ?car - carrier ?from ?to - location)
    :precondition (and
      (connected ?from ?to)
      (bot_at ?bot ?from)
      (bot_has_carrier ?bot ?car)
    )
    :effect (and
      (bot_at ?bot ?to)
      (not (bot_at ?bot ?from))
      (carrier_at ?car ?to)
      (not (carrier_at ?car ?from))
    )
  )

  ;; Attach a carrier onto a bot
  (:action attach_carrier
      :parameters (?bot - bot ?car - carrier ?l - location)
      :precondition (and 
        (bot_at ?bot ?l)
        (carrier_at ?car ?l)
        (bot_free ?bot)
      )
      :effect (and 
        (not (bot_free ?bot))
        (bot_has_carrier ?bot ?car)
      )
  )

  ;; Unattach a carrier from a bot
  (:action unattach_carrier
      :parameters (?bot - bot ?car - carrier ?l - location)
      :precondition (and 
        (bot_at ?bot ?l)
        (carrier_at ?car ?l)
        (bot_has_carrier ?bot ?car)
      )
      :effect (and 
        (not (bot_has_carrier ?bot ?car))
        (bot_free ?bot)
      )
  )

  ;; Loads a box onto a carrier
  (:action load_carrier
    :parameters (?bot - bot ?car - carrier ?cap - capacity ?b - box ?l - location)
    :precondition (and
      (bot_at ?bot ?l)
      (box_at ?b ?l)
      (bot_has_carrier ?bot ?car)
      (carrier_has_capacity ?car ?cap)
      (> (carrier_capacity ?cap) (carrier_load ?cap)) ;; if capacity > load
    )
    :effect (and
      (increase (carrier_load ?cap) 1) ;; load++
      (not (box_at ?b ?l))
      (carrier_has_box ?car ?b)
    )
  )

  ;; Unloads a box from the carrier
  (:action unload_carrier
    :parameters (?bot - bot ?car - carrier ?cap - capacity ?b - box ?l - location)
    :precondition (and
      (bot_at ?bot ?l)
      (bot_has_carrier ?bot ?car)
      (carrier_has_box ?car ?b)
      (carrier_has_capacity ?car ?cap)
    )
    :effect (and
      (decrease (carrier_load ?cap) 1) ;; load--
      (box_at ?b ?l)
      (not (carrier_has_box ?car ?b))
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

  ;; Deliver aspirine
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