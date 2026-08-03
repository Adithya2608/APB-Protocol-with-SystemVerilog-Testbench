`ifndef APB_ENV_SV
`define APB_ENV_SV

class apb_env extends uvm_env;

    `uvm_component_utils(apb_env)

    // Components
    apb_agent      agent;
    apb_scoreboard sb;

    // Constructor
    function new(string name = "apb_env",
                 uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        agent = apb_agent::type_id::create("agent", this);
        sb    = apb_scoreboard::type_id::create("sb", this);

    endfunction

    // Connect Phase
    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        // Connect Monitor to Scoreboard
        agent.mon.monitor_port.connect(sb.sb_port);

    endfunction

endclass

`endif
