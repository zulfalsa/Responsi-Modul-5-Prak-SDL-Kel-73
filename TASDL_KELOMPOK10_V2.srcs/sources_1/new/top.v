module top(
    input wire clk_100MHz, 
    input wire sw0,          // SW0: Arah (0 Maju, 1 Mundur) / Input W
    input wire sw1,          // SW1: Mode (0 Manual, 1 Auto 2s)
    input wire btnc,         // BTNC: Manual Next Enter
    input wire btnd,         // BTND: Reset
    output wire led_batas,   // LD0: Batas Antrean / Output Y
    output wire led_hb,      // LD15: Heartbeat
    output wire [6:0] seg,   // Katoda
    output wire [7:0] an     // Anoda
);
    wire enter_p, rst_l;
    wire timer_2s;
    wire [2:0] current_queue;
    wire y_status; // Kabel internal penampung status batas

    // 1. Debouncer
    debouncer db_e (.clk(clk_100MHz), .btn_in(btnc), .btn_pulse(enter_p), .btn_level());
    debouncer db_r (.clk(clk_100MHz), .btn_in(btnd), .btn_pulse(), .btn_level(rst_l));
    
    // 2. Timer (Clock Divider)
    clock_divider tmr (.clk_100MHz(clk_100MHz), .reset(rst_l), .ce_2s(timer_2s), .led_hb(led_hb));
    
    // 3. MULTIPLEXER TRIGGER
    wire fsm_trigger = (sw1) ? timer_2s : enter_p;

    // 4. FSM Moore (Menghasilkan output y_status)
    fsm_queue fsm (
        .clk(clk_100MHz), 
        .reset(rst_l), 
        .ce(fsm_trigger), 
        .w(sw0), 
        .y_batas(y_status), 
        .state_display(current_queue)
    );

    // 5. Tampilan 7-Segment (Kini disuplai sw0 dan y_status)
    display disp (
        .clk(clk_100MHz), 
        .w_in(sw0),            // UPDATE: Masukkan switch 0 sebagai w_in
        .y_out(y_status),      // UPDATE: Masukkan hasil output FSM sebagai y_out
        .state(current_queue), 
        .seg(seg), 
        .an(an)
    );

    // Menyambungkan kabel internal y_status ke lampu LED fisik
    assign led_batas = y_status; 

endmodule