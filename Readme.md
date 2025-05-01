Sure! Here's a clearer, more organized version of your `README.md` file for the Automated Planning project:

---

# Automated Planning Project – Healthcare Scenario

This academic project was developed for the **Automated Planning** course at **University of Trento**, held by **Prof. Marco Roveri**. It consists of **five exercises**, each building upon the previous one in complexity, within a hypothetical **healthcare domain**. The project progresses from **classical planning** to **temporal and hierarchical planning**, and finally integrates with a **ROS2-based environment**.

> Dockerfiles, planning tools, assignment details, planner outputs and the final report are all included in this repository.

---

## Requirements

To run different exercises, you’ll need the following tools:

- **Exercises 1, 2, and 4:** Docker with [planutils](https://github.com/aibasel/planutils) `Dockerfile_planutils`
- **Exercise 3:** `PANDA.jar` (included in the `exercise_3` folder)
- **Exercise 5:** ROS2 environment using `Dockerfile_plansys2`

---

## Project Structure

```
Automated_Planning_Project/
│
├── exercise_1/
│   └── domain_0_simple
│   └── domain_1_rigorous
│   └── planner_outputs
├── exercise_2/
│   └── domain_2
│   └── domain_2_numeric_fluent
│   └── planner_outputs
├── exercise_3/
│   └── PANDA.jar
│   └── planner_outputs
├── exercise_4/
│   └── planner_outputs
├── exercise_5/
│   └── launch (launch and problems)
│   └── pddl (domain)
│   └── src (all the .cpp for bot motion)
├── Dockerfile_planutils
├── Dockerfile_plansys2
├── assignment.pdf
└── final_report.pdf
```

---

## How to Run the Exercises

### Exercise 1 & 2 – Classical Planning

Inside Docker (with planutils):
```bash
planutils activate

# Using Downward planner
downward --alias domain1.pddl problem_1.pddl

# Or using FF planner
ff domain1.pddl problem_1.pddl
```

---

### Exercise 3 – Hierarchical Task Network (HTN) Planning

From the `exercise_3` directory:
```bash
java -jar PANDA.jar -parser hddl domain3.hddl problem_1.pddl
```

---

### Exercise 4 – Temporal Planning

Inside Docker (with planutils):
```bash
planutils activate

# Using Temporal Fast Downward
tfd domain4.pddl problem_1.pddl

# Optic
optic domain4.pddl problem_1.pddl

# or POPF
popf domain4.pddl problem_1.pddl

```

---

### Exercise 5 – ROS2 Integration (PlanSys2)

Inside Docker container:
1. **Build ROS workspace**:
   ```bash
   colcon build --symlink-install
   source install/setup.bash
   ```

2. **Launch the planner**:
   ```bash
   ros2 launch planner planner_launch.launch.py
   ```

3. **Open another terminal**, then:
   ```bash
   ros2 run plansys2_terminal plansys2_terminal
   ```

4. **Source the desired problem file**:
   ```bash
   source <path_to_repo>/exercise_5/src/planner/pddl/problem_0
   ```

5. In the terminal, type:
   ```bash
   run
   ```
   to solve and execute the plan.
