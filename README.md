# APB Protocol Verification using UVM

## Overview

This project demonstrates the verification of an **AMBA APB3 (Advanced Peripheral Bus)** Slave using the **Universal Verification Methodology (UVM)** in SystemVerilog. The APB Master functionality is implemented through the **UVM Driver**, while the Design Under Test (DUT) is a synthesizable APB Slave.

The verification environment generates randomized APB transactions, drives them to the DUT, monitors bus activity, and validates the DUT response using a scoreboard.

---

## Project Objectives

* Design a synthesizable APB3 Slave.
* Develop a reusable UVM verification environment.
* Verify APB read and write transactions.
* Validate protocol compliance.
* Demonstrate transaction-level verification using UVM.

---

## Project Architecture

```
                   APB Sequence
                         │
                         ▼
                  APB Sequencer
                         │
                         ▼
              APB Driver (Master)
                         │
                         ▼
                 APB Interface
                         │
                         ▼
                APB Slave (DUT)
                         ▲
                         │
                  APB Monitor
                         │
                         ▼
                APB Scoreboard
```

---

## Directory Structure

```
APB_UVM_Project/

├── interface/
│   └── apb_if.sv
│
├── sequence_item/
│   └── apb_transaction.sv
│
├── sequence/
│   └── apb_sequence.sv
│
├── sequencer/
│   └── apb_sequencer.sv
│
├── driver/
│   └── apb_driver.sv
│
├── monitor/
│   └── apb_monitor.sv
│
├── agent/
│   └── apb_agent.sv
│
├── scoreboard/
│   └── apb_scoreboard.sv
│
├── env/
│   └── apb_env.sv
│
├── test/
│   └── apb_test.sv
│
├── rtl/
│   └── apb_slave.sv
│
└── top/
    └── tb_top.sv
```

---

## Components

### APB Interface (`apb_if.sv`)

Defines the APB bus signals shared between the DUT and the UVM components.

### Transaction (`apb_transaction.sv`)

Represents an APB transaction containing address, data, read/write control, ready, and error information.

### Sequence (`apb_sequence.sv`)

Generates randomized APB read and write transactions for verification.

### Sequencer (`apb_sequencer.sv`)

Supplies transactions from the sequence to the driver.

### Driver (`apb_driver.sv`)

Acts as the APB Master by converting transaction objects into APB protocol signal activity.

### Monitor (`apb_monitor.sv`)

Observes APB bus activity and converts bus signals back into transaction objects.

### Agent (`apb_agent.sv`)

Groups the sequencer, driver, and monitor into a reusable verification component.

### Scoreboard (`apb_scoreboard.sv`)

Implements a reference memory model to compare expected and actual DUT behavior.

### Environment (`apb_env.sv`)

Instantiates and connects the agent and scoreboard.

### Test (`apb_test.sv`)

Creates the verification environment and starts the APB sequence.

### APB Slave (`apb_slave.sv`)

Synthesizable APB3 Slave implementing:

* 256 × 32-bit memory
* Read operations
* Write operations
* PREADY generation
* PSLVERR generation for invalid addresses

### Top Module (`tb_top.sv`)

Instantiates the DUT, interface, clock, reset, and launches the UVM test.

---

## APB Transfer Flow

### Write Transaction

1. Sequence generates a write transaction.
2. Sequencer forwards it to the driver.
3. Driver performs:

   * Setup Phase
   * Access Phase
4. Slave writes data into memory.
5. Monitor captures the transaction.
6. Scoreboard updates the reference model.

### Read Transaction

1. Sequence generates a read transaction.
2. Driver initiates the APB read.
3. Slave returns data from memory.
4. Monitor captures the returned data.
5. Scoreboard compares the DUT response against the reference model.

---

## APB Signals

| Signal  | Description         |
| ------- | ------------------- |
| PCLK    | APB Clock           |
| PRESETn | Active-low Reset    |
| PSEL    | Slave Select        |
| PENABLE | Access Phase Enable |
| PWRITE  | Read/Write Control  |
| PADDR   | Address Bus         |
| PWDATA  | Write Data          |
| PRDATA  | Read Data           |
| PREADY  | Transfer Complete   |
| PSLVERR | Error Indicator     |

---

## Verification Features

* UVM-based reusable verification environment
* Randomized transaction generation
* APB read/write verification
* Reference memory model
* Protocol monitoring
* PASS/FAIL reporting using UVM messaging
* Modular and reusable architecture

---

## Simulation Flow

```
Generate Transaction
        │
        ▼
     Sequencer
        │
        ▼
      Driver
        │
        ▼
    APB Slave
        │
        ▼
     Monitor
        │
        ▼
   Scoreboard
        │
        ▼
    PASS / FAIL
```

---

## Tools Used

* SystemVerilog
* Universal Verification Methodology (UVM)
* ModelSim / QuestaSim (or equivalent simulator)

---

## Learning Outcomes

This project demonstrates understanding of:

* AMBA APB3 Protocol
* UVM Testbench Architecture
* Transaction-Level Verification
* Driver, Monitor, Sequencer, Agent, Environment, and Scoreboard implementation
* Functional verification methodology
* Random stimulus generation
* RTL verification using SystemVerilog and UVM

---

## Future Enhancements

* Functional coverage
* Assertion-Based Verification (SVA)
* Multiple APB Slaves
* Configurable address map
* Constrained random sequences
* Error injection test cases
* Regression test suite
* APB4 feature support

---

## Author

**N. Adithya Sharma**

B.Tech – Electronics and Communication Engineering (VLSI)

Project: **APB Protocol Verification using UVM**
