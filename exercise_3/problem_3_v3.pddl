(define (problem problem3_3)
  (:domain healthcare_scenario_3)

   (:objects
    bot1 - bot
    entrance geriatric_dept pediatrics_dept surgery_dept cardiology_dept warehouse - location
    surgeon pediatrician general_practitioner cardiologist - medic
    box1 box2 box3 box4 - box
    car1 car2 - carrier
    cap1 cap2 cap3 cap4 cap5 cap6 - capacity
    aspirine1 - aspirine
    scalpel1 scalpel2 - scalpel
    tongue_depressor1 - tongue_depressor
    maid - unit
    kid granpa - patient
  )

  (:htn
    :parameters ()
    :subtasks (and
      (task0 (deliver_tongue_depressor_to_medic general_practitioner))
      (task1 (deliver_scalpel_to_medic surgeon))
      (task2 (deliver_aspirine_to_medic pediatrician))
      (task3 (deliver_scalpel_to_medic cardiologist))
      (task4 (escort_patient maid granpa geriatric_dept))
      (task5 (escort_patient maid kid pediatrics_dept))
    )
    :ordering (and
      (task0 < task1)
      (task1 < task2)
      (task2 < task3)
      (task3 < task4)
      (task4 < task5)
    )
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
    ;; new connections to simulate the second problem
    (connected warehouse cardiology_dept)
    (connected cardiology_dept warehouse)

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
    (bot_free bot1)

    ;; carrier
    (bot_has_carrier bot1 car2)
    (carrier_at car1 warehouse)
    (is_empty car1 cap1)
    (is_empty car1 cap2)
    ;; carrier 2
    (carrier_at car2 warehouse)
    (is_empty car2 cap3)
    (is_empty car2 cap4)
    (is_empty car2 cap5)
    (is_empty car2 cap6)

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

    ;; contents availability
    (content_available aspirine1)
    (content_available scalpel1)
    (content_available scalpel2)
    (content_available tongue_depressor1)

    ;; maid
    (unit_at maid warehouse)
    (unit_free maid)

    ;; patients
    (patient_at kid entrance)
    (patient_at granpa entrance)
  )
)