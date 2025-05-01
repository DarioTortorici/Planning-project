(define (problem problem_2_scenario_1)
  (:domain healthcare_scenario_1)

  (:objects
    bot1 - bot
    entrance geriatric_dept pediatrics_dept surgery_dept cardiology_dept warehouse corridor1 corridor2 corridor3 - location
    surgeon pediatrician general_practitioner cardiologist - medic
    box1 box2 box3 box4 - box
    aspirine1 scalpel1 scalpel2 tongue_depressor1 - content
    maid - unit
    kid granpa - patient
  )

  (:init
    ;; location connected biderectionally
    (connected entrance corridor1) ;; entrance with corridor1
    (connected corridor1 entrance)
    (connected entrance corridor2) ;; corridor2
    (connected corridor2 entrance)
    (connected entrance corridor3) ;; and corridor3
    (connected corridor3 entrance)
    (connected corridor1 pediatrics_dept) ;; corridor1 with pediatrics_dept
    (connected pediatrics_dept corridor1)
    (connected corridor1 geriatric_dept) ;; and geriatric_dept
    (connected geriatric_dept corridor1)
    (connected corridor2 warehouse) ;; corridor2 with warehouse
    (connected warehouse corridor2)
    (connected corridor3 cardiology_dept) ;; corridor 3 with cardiology_dept
    (connected cardiology_dept corridor3)
    (connected corridor3 surgery_dept) ;; and surgery_dept
    (connected surgery_dept corridor3)

    ;; box location
    (box_at box1 warehouse)
    (box_at box2 warehouse)
    (box_at box3 warehouse)
    (box_at box4 warehouse)

    ;; box empty
    (box_empty box1)
    (box_empty box2)
    (box_empty box3)
    (box_empty box4)

    ;; bot
    (bot_at bot1 warehouse)
    (bot_unloaded bot1 box1)
    (bot_unloaded bot1 box2)
    (bot_unloaded bot1 box3)

    ; medic location
    (medic_at surgeon surgery_dept)
    (medic_at pediatrician pediatrics_dept)
    (medic_at general_practitioner geriatric_dept)
    (medic_at cardiologist cardiology_dept)

    ;; contents location
    (content_at aspirine1 warehouse)
    (content_at scalpel1 warehouse)
    (content_at scalpel2 warehouse)
    (content_at tongue_depressor1 warehouse)

    ;; maid
    (unit_at maid warehouse)
    (unit_free maid)

    ;; patients
    (patient_at kid entrance)
    (patient_at granpa entrance)
  )

  (:goal (and
    (bot_at bot1 warehouse)
    (unit_at maid entrance)
    ;; (medic_has surgeon scalpel1)
    ;; (medic_has cardiologist scalpel2)
    (medic_has pediatrician aspirine1)
    (medic_has general_practitioner tongue_depressor1)
    (patient_at kid pediatrics_dept)
    (patient_at granpa cardiology_dept)
  ))
)