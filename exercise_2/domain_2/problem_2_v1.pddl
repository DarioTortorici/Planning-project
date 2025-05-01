(define (problem problem_1_scenario_2)
  (:domain healthcare_scenario_2)

  (:objects
    bot1 - bot
    entrance geriatric_dept pediatrics_dept surgery_dept warehouse - location
    surgeon pediatrician general_practitioner - medic
    box1 box2 box3 - box
    car1 - carrier
    cap1 cap2 - capacity
    aspirine1 - aspirine
    scalpel1 - scalpel
    tongue_depressor1 - tongue_depressor
    maid - unit
    kid - patient
  )

  (:init
    ;; location connected biderectionally
    (connected warehouse surgery_dept)
    (connected surgery_dept warehouse)
    (connected surgery_dept pediatrics_dept)
    (connected pediatrics_dept surgery_dept)
    (connected pediatrics_dept geriatric_dept)
    (connected geriatric_dept pediatrics_dept)
    (connected geriatric_dept entrance)
    (connected entrance geriatric_dept)

    ;; box location
    (box_at box1 warehouse)
    (box_at box2 warehouse)
    (box_at box3 warehouse)

    ;; box empty
    (box_empty box1)
    (box_empty box2)
    (box_empty box3)

    ;; bot
    (bot_at bot1 warehouse)
    (bot_free bot1)

    ;; carrier
    (carrier_at car1 warehouse)
    (is_empty car1 cap1)
    (is_empty car1 cap2)

    ;; medic location
    (medic_at surgeon surgery_dept)
    (medic_at pediatrician pediatrics_dept)
    (medic_at general_practitioner geriatric_dept)

    ;; contents location
    (content_at aspirine1 warehouse)
    (content_at scalpel1 warehouse)
    (content_at tongue_depressor1 warehouse)

    ;; contents availability
    (content_available aspirine1)
    (content_available scalpel1)
    (content_available tongue_depressor1)

    ;; maid
    (unit_at maid warehouse)
    (not (unit_busy maid))
    (unit_free maid)

    ;; patient
    (patient_at kid entrance)

  )

  (:goal (and
    (bot_at bot1 warehouse)
    (unit_at maid entrance)
    (has_scalpel surgeon)
    (has_aspirine pediatrician)
    (has_tongue_depressor general_practitioner)
    (patient_at kid pediatrics_dept)
  ))
)