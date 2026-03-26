# QoS-based Smart Healthcare Simulation (MATLAB)

## Overview
This project simulates QoS scheduling in O-RAN-based smart healthcare systems using MATLAB.

## Features
- FIFO vs Priority Scheduling
- Non-preemptive priority queue model
- Metrics:
  - Latency
  - Packet Loss Rate
  - Critical Delivery Rate

## Structure
- main_qos_simulation.m : main simulation script
- simulate_queue_nonpreemptive.m : queue logic
- generate_* : traffic generation

## Results
Priority scheduling significantly reduces latency for high-priority medical data but may cause starvation for low-priority traffic.
