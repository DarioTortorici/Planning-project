(define (domain healthcare_scenario_5)
  (:requirements :strips :typing :durative-actions)

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
    (bot_idle ?bot - bot) ;; Added to avoid overlaps of actions

    ;; boxes
    (box_at ?b - box ?l - location) 
    (box_empty ?b - box) 
    (box_filled ?b - box) 
    (box_has_content ?c - content ?b - box) 

    ;; carriers
    (carrier_at ?car - carrier ?l - location)
    (carrier_has_box ?car - carrier ?b - box)
    (is_empty ?car - carrier ?cap - capacity) 
    (is_full ?car - carrier ?cap - capacity) 

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
    (unit_idle ?u - unit) ;; Added to avoid overlaps of actions

    ;; patients
    (patient_at ?p - patient ?l - location)

  )

;; Bot movement
(:durative-action move_bot
    :parameters (?bot - bot ?from ?to - location)
    :duration (= ?duration 2)
    :condition (and
        (at start (connected ?from ?to))
        (at start (bot_at ?bot ?from))
        (at start (bot_free ?bot))
        (at start (bot_idle ?bot))
    )
    :effect (and
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (bot_at ?bot ?to))
        (at end (not (bot_at ?bot ?from)))
    )
)

;; Bot movement with a carrier
(:durative-action move_bot_with_carrier
    :parameters (?bot - bot ?car - carrier ?from ?to - location)
    :duration (= ?duration 3)
    :condition (and
        (at start (connected ?from ?to))
        (at start (bot_at ?bot ?from))
        (at start (bot_has_carrier ?bot ?car))
        (at start (bot_idle ?bot))
        )
    :effect (and
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (bot_at ?bot ?to))
        (at end (not (bot_at ?bot ?from)))
        (at end (carrier_at ?car ?to))
        (at end (not (carrier_at ?car ?from)))
    )
)

;; Attach a carrier onto a bot
(:durative-action attach_carrier
    :parameters (?bot - bot ?car - carrier ?l - location)
    :duration (= ?duration 1)
    :condition (and 
        (at start (bot_at ?bot ?l))
        (at start (carrier_at ?car ?l))
        (at start (bot_free ?bot))
        (at start (bot_idle ?bot))
    )
    :effect (and 
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (not (bot_free ?bot)))
        (at end (bot_has_carrier ?bot ?car))
    )
)

;; Unattach a carrier from a bot
(:durative-action unattach_carrier
    :parameters (?bot - bot ?car - carrier ?l - location)
    :duration (= ?duration 1)
    :condition (and 
        (at start (bot_at ?bot ?l))
        (at start (carrier_at ?car ?l))
        (at start (bot_has_carrier ?bot ?car))
        (at start (bot_idle ?bot))
    )
    :effect (and 
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (not (bot_has_carrier ?bot ?car)))
        (at end (bot_free ?bot))
    )
)

;; Loads a box onto a carrier
(:durative-action load_carrier
    :parameters (?bot - bot ?car - carrier ?cap - capacity ?b - box ?l - location)
    :duration (= ?duration 3)
    :condition (and
        (at start (bot_at ?bot ?l))
        (at start (box_at ?b ?l))
        (at start (bot_has_carrier ?bot ?car))
        (at start (is_empty ?car ?cap))
        (at start (bot_idle ?bot))
    )
    :effect (and
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (not (is_empty ?car ?cap)))
        (at end (is_full ?car ?cap))
        (at end (not (box_at ?b ?l)))
        (at end (carrier_has_box ?car ?b))
    )
)

;; Unloads a box from the carrier
(:durative-action unload_carrier
    :parameters (?bot - bot ?car - carrier ?cap - capacity ?b - box ?l - location)
    :duration (= ?duration 3)
    :condition (and
        (at start (bot_at ?bot ?l))
        (at start (bot_has_carrier ?bot ?car))
        (at start (is_full ?car ?cap))
        (at start (carrier_has_box ?car ?b))
        (at start (bot_idle ?bot))
    )
    :effect (and
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (box_at ?b ?l))
        (at end (not (is_full ?car ?cap)))
        (at end (is_empty ?car ?cap))
        (at end (not (carrier_has_box ?car ?b)))
    )
)

;; Fills a box with content
(:durative-action fill_box
    :parameters (?bot - bot ?l - location ?b - box ?c - content)
    :duration (= ?duration 3)
    :condition (and
        (at start (bot_at ?bot ?l))
        (at start (box_at ?b ?l))
        (at start (content_at ?c ?l))
        (at start (box_empty ?b))
        (at start (content_available ?c))
        (at start (bot_idle ?bot))
    )
    :effect (and
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (box_has_content ?c ?b))
        (at end (not (box_empty ?b)))
        (at end (box_filled ?b))
        (at end (not (content_at ?c ?l)))
    )
)

;; Deliver aspirine to medic
(:durative-action deliver_aspirine
    :parameters (?bot - bot ?b - box ?aspirine - aspirine ?l - location ?m - medic)
    :duration (= ?duration 2)
    :condition (and
        (at start (bot_at ?bot ?l))
        (at start (box_has_content ?aspirine ?b))
        (at start (box_at ?b ?l))
        (at start (medic_at ?m ?l))
        (at start (box_filled ?b))
        (at start (bot_idle ?bot))
    )
    :effect (and
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (box_empty ?b))
        (at end (not (box_filled ?b)))
        (at end (content_at ?aspirine ?l))
        (at end (medic_has ?m ?aspirine))
        (at end (not (box_has_content ?aspirine ?b)))
        (at end (not (content_available ?aspirine)))
        (at end (has_aspirine ?m))
    )
)

;; Deliver scalpel to medic
(:durative-action deliver_scalpel
    :parameters (?bot - bot ?b - box ?scalpel - scalpel ?l - location ?m - medic)
    :duration (= ?duration 2)
    :condition (and
        (at start (bot_at ?bot ?l))
        (at start (box_has_content ?scalpel ?b))
        (at start (box_at ?b ?l))
        (at start (medic_at ?m ?l))
        (at start (box_filled ?b))
        (at start (bot_idle ?bot))
    )
    :effect (and
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (box_empty ?b))
        (at end (not (box_filled ?b)))
        (at end (content_at ?scalpel ?l))
        (at end (medic_has ?m ?scalpel))
        (at end (not (box_has_content ?scalpel ?b)))
        (at end (not (content_available ?scalpel)))
        (at end (has_scalpel ?m))
    )
)

;; Deliver tongue depressor to medic
(:durative-action deliver_tongue_depressor
    :parameters (?bot - bot ?b - box ?tongue_depressor - tongue_depressor ?l - location ?m - medic)
    :duration (= ?duration 2)
    :condition (and
        (at start (bot_at ?bot ?l))
        (at start (box_has_content ?tongue_depressor ?b))
        (at start (box_at ?b ?l))
        (at start (medic_at ?m ?l))
        (at start (box_filled ?b))
        (at start (bot_idle ?bot))
    )
    :effect (and
        (at start (not (bot_idle ?bot)))
        (at end (bot_idle ?bot))
        (at end (box_empty ?b))
        (at end (not (box_filled ?b)))
        (at end (content_at ?tongue_depressor ?l))
        (at end (medic_has ?m ?tongue_depressor))
        (at end (not (box_has_content ?tongue_depressor ?b)))
        (at end (not (content_available ?tongue_depressor)))
        (at end (has_tongue_depressor ?m))
    )
)

;; Unit movement
(:durative-action move_unit
    :parameters (?u - unit ?from ?to - location)
    :duration (= ?duration 2)
    :condition (and
        (at start (connected ?from ?to))
        (at start (unit_at ?u ?from))
        (at start (unit_free ?u))
        (at start (unit_idle ?u))
    )
    :effect (and
        (at start (not (unit_idle ?u)))
        (at end (unit_idle ?u))
        (at end (unit_at ?u ?to))
        (at end (not (unit_at ?u ?from)))
    )
)

;; Unit movement with a patient
(:durative-action move_patient_with_unit
    :parameters (?u - unit ?p - patient ?from ?to - location)
    :duration (= ?duration 3)
    :condition (and
        (at start (connected ?from ?to))
        (at start (unit_at ?u ?from))
        (at start (unit_busy ?u))
        (at start (unit_escorting ?u ?p))
        (at start (patient_at ?p ?from))
        (at start (unit_idle ?u))
    )
    :effect (and
        (at start (not (unit_idle ?u)))
        (at end (unit_idle ?u))
        (at end (unit_at ?u ?to))
        (at end (not (unit_at ?u ?from)))
        (at end (not (patient_at ?p ?from)))
        (at end (patient_at ?p ?to))
    )
)

;; Unit equivalent lo load a box with a patient
(:durative-action accompanies_patient
    :parameters (?u - unit ?p - patient ?l - location)
    :duration (= ?duration 1)
    :condition (and
        (at start (unit_at ?u ?l))
        (at start (unit_free ?u))
        (at start (patient_at ?p ?l))
        (at start (unit_idle ?u))
    )
    :effect (and
        (at start (not (unit_idle ?u)))
        (at end (unit_idle ?u))
        (at end (not (unit_free ?u)))
        (at end (unit_busy ?u))
        (at end (unit_escorting ?u ?p))
    )
)

;; Unit releases a patient at a location (equivalent to unattach a carrier from a bot)
(:durative-action leave_patient
    :parameters (?u - unit ?p - patient ?l - location)
    :duration (= ?duration 1)
    :condition (and
        (at start (unit_busy ?u))
        (at start (unit_escorting ?u ?p))
        (at start (unit_at ?u ?l))
        (at start (patient_at ?p ?l))
        (at start (unit_idle ?u))
    )
    :effect (and
        (at start (not (unit_idle ?u)))
        (at end (unit_idle ?u))
        (at end (not (unit_busy ?u)))
        (at end (unit_free ?u))
        (at end (not (unit_escorting ?u ?p)))
        (at end (patient_at ?p ?l))
    )
)

)