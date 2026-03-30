# QoS-based Smart Healthcare Simulation (Marathon Scenario)

This project presents a MATLAB-based smart healthcare communication simulation system designed to evaluate reliable and low-latency transmission of emergency medical data in large-scale outdoor events, specifically using a half-marathon scenario as a case study.

The system integrates **Device-to-Device (D2D) relay communication** and **Quality of Service (QoS) priority scheduling** to mitigate network congestion and transmission challenges in wide-area, highly mobile environments.

## System Architecture and Core Mechanisms

The simulation models runner mobility and data transmission along a race course, incorporating the following three key mechanisms:

### 1. Traffic Classification and Generation

Data generated from wearable devices is categorized into four priority levels based on medical urgency:

* **P1 (Critical Medical Data):**
  Represents emergency conditions such as abnormal heart rate events. This class has the highest priority and the shortest Time-To-Live (TTL), set to 20 minutes by default.

* **P2 (Abnormal Data):**
  Indicates non-critical anomalies. Assigned medium priority with a TTL of 30 minutes.

* **P3 (Routine Periodic Data):**
  Includes regular telemetry such as heart rate and step count. This class has the lowest priority, highest generation frequency, and a TTL of 60 minutes.

* **TRACK (Checkpoint Logging):**
  Automatically generated when a runner enters the coverage area of a gateway (Gate).

### 2. D2D Relay Communication (Peer-to-Peer Forwarding)

To address sparse gateway deployment, the system enables D2D relay transmission. When two runners are within a predefined communication range (e.g., 8 meters), high-priority P1 packets can be broadcast and replicated between devices.

To prevent excessive network overhead and broadcast storms, the mechanism enforces:

* A maximum hop count (`max_hops_p1`)
* A maximum number of packet replicas (`max_copies_p1`)

### 3. QoS-based Priority Scheduling

When a runner enters the coverage of a medical station or gateway, packet transmission follows a **non-preemptive priority queue** instead of traditional FIFO (First-In, First-Out).

This ensures that:

* P1 packets are transmitted with the highest priority
* Critical data is not delayed by large volumes of low-priority P3 traffic

## Project Structure

### Main Simulation

* `main_marathon_simulation.m`
  The primary simulation script, implementing the full lifecycle including position updates, packet generation, relay exchange, gateway upload, and packet expiration handling.

### Initialization and Configuration

* `init_marathon_params.m`
  Defines global parameters such as race distance (21.0975 km), number of runners (120), speed distribution, gateway placement, packet TTL, and traffic generation rates.

* `init_runners.m` / `init_gates.m`
  Initialize properties of runner and gateway nodes.

### Core Functional Modules

* `update_runner_positions.m`
  Updates runner positions based on velocity and time step (`dt`).

* `generate_runner_packets.m`
  Generates P1, P2, P3, and TRACK packets according to probabilistic and periodic models.

* `peer_relay_exchange.m`
  Implements D2D relay logic for packet forwarding and replication.

* `gate_exchange.m`
  Handles packet uploads when runners enter gateway coverage.

### Scheduling Algorithms

* `pick_packet.m`
  FIFO scheduling implementation.

* `pick_packet_by_priority.m`
  QoS-based priority scheduling implementation.

### Utilities and Metrics

* `remove_expired_packets.m`
  Removes packets that exceed their TTL.

* `summarize_metrics.m`
  Computes performance metrics, including delivery rate and average delay per priority class.

## Expected Results and Tuning Guidelines

This simulation enables comparison between two configurations:

* **Baseline:** No relay + FIFO scheduling
* **Proposed:** D2D relay + QoS scheduling

Key observations include:

* **Reduced latency for critical data (P1):**
  QoS scheduling significantly lowers transmission delay for high-priority packets under constrained resources.

* **Improved delivery rate for P1:**
  Performance can be further enhanced by tuning parameters in `init_marathon_params.m`, such as:

  * Increasing gateway density (e.g., one station every 2.5 km)
  * Expanding communication range (`peer_range`)
  * Increasing relay hop limits (`max_hops_p1`)

  With appropriate configuration, P1 delivery rates can exceed 95%.
  Note: A global deduplication mechanism is recommended to ensure data consistency in multi-gateway deployments.
