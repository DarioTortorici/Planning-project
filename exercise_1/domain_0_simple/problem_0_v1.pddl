(define (problem problem_1_scenario_1)
  (:domain healthcare_scenario_1)

  (:objects
    bot1 - bot
    entrance geriatric_dept pediatrics_dept surgery_dept warehouse - location
    surgeon pediatrician general_practitioner - medic
    box1 box2 box3 - box
    aspirine scalpel tongue_depressor - content
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
    (bot_unloaded bot1 box1)
    (bot_unloaded bot1 box2)
    (bot_unloaded bot1 box3)

    ;; medic location
    (medic_at surgeon surgery_dept)
    (medic_at pediatrician pediatrics_dept)
    (medic_at general_practitioner geriatric_dept)

    ;; contents location
    (content_at aspirine warehouse)
    (content_at scalpel warehouse)
    (content_at tongue_depressor warehouse)


    ;; maid
    (unit_at maid warehouse)
    (unit_free maid)

    ;; patient
    (patient_at kid entrance)

  )

  (:goal (and
    (bot_at bot1 warehouse)
    (unit_at maid entrance)
    (medic_has surgeon scalpel)
    (medic_has pediatrician aspirine)
    (medic_has general_practitioner tongue_depressor)
    (patient_at kid pediatrics_dept)
  ))
)