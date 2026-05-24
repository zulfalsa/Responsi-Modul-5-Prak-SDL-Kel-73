module fsm_queue(
    input wire clk,
    input wire reset,
    input wire ce,     // Clock Enable (Trigger eksekusi)
    input wire w,      // Arah: 0=Maju, 1=Mundur
    output reg y_batas,// Output LED menyala jika di batas
    output wire [1:0] state_display // UBAH: Menjadi 2-bit untuk display
);
    // UBAH: Hanya menggunakan 4 State
    parameter S0=2'd0, S1=2'd1, S2=2'd2, S3=2'd3;
    reg [1:0] curr, next;

    assign state_display = curr;

    // Register State
    always @(posedge clk or posedge reset) begin
        if (reset) curr <= S0;
        else if (ce) curr <= next;
    end

    // Kombinasional: Next State & Output Moore
    always @(*) begin
        y_batas = (curr == S0 || curr == S3) ? 1'b1 : 1'b0; // Batas di 0 dan 3
        case (curr)
            S0: next = (w) ? S3 : S1;
            S1: next = (w) ? S0 : S2;
            S2: next = (w) ? S1 : S3;
            S3: next = (w) ? S2 : S0;
            default: next = S0;
        endcase
    end
endmodule