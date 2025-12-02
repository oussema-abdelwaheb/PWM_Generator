# 🤖 PWM Generator & 4-DOF Robot Arm Controller — VHDL

This project implements a **PWM signal generator** with configurable duty cycle and period, and extends it into a **4-channel robotic arm controller** for simulating servo actuation using VHDL. The entire system is simulated using ModelSim.

---

## 📌 Overview

Servomotors require PWM signals with specific timing:
- Fixed period: **20 ms**  
- Duty cycle: **1 ms → 0°**, **2 ms → 180°**

This project builds a clean and modular PWM architecture, then scales it to four channels to control a 4-DOF arm.

---

## 🚀 Features

- Adjustable PWM duty cycle  
- Configurable PWM period  
- Glitch-free transitions  
- 4 simultaneous PWM channels  
- Angle-to-duty conversion block  
- Fully verified in ModelSim  
- Synthesizable VHDL design  

---

## 🧱 Architecture Overview

PWM signal path:

Angle → Duty_Converter → PWM_Generator → Servo_Output

4-channel arm:

Angle1 → PWM1
Angle2 → PWM2
Angle3 → PWM3
Angle4 → PWM4


## 🧪 Simulation

Run using:

vsim work.tb_robot_arm
run -all



The testbench confirms:
- Duty cycle mapping  
- PWM waveform stability  
- Multi-channel synchronization  
- Angle responses  

---

## 👤 Author  
Developed by **Oussema** as part of a hardware-level robotics experimentation project.
