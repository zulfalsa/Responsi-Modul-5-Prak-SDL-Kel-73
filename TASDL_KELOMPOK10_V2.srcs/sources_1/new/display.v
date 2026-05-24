module display(
    input wire clk,
    input wire w_in,         // Status Switch 0 (Arah)
    input wire y_out,        // Status LED Batas (Output Y)
    input wire [1:0] state,  // UBAH: Menerima State antrean 2-bit saja
    output reg [6:0] seg,
    output reg [7:0] an
);
    reg [16:0] scan; 
    wire [2:0] sel = scan[16:14];

    always @(posedge clk) scan <= scan + 1;

    always @(*) begin
        an = 8'b11111111; // Matikan semua anoda
        an[sel] = 1'b0;   // Nyalakan satu anoda bergantian
        
        case (sel)
            // --- BAGIAN KIRI: wXyX ---
            3'd7: seg = 7'b1100011; // Huruf 'w'
            3'd6: seg = (w_in) ? 7'b1111001 : 7'b1000000; // Nilai W (1 atau 0)
            
            3'd5: seg = 7'b0010001; // Huruf 'y'
            3'd4: seg = (y_out) ? 7'b1111001 : 7'b1000000; // Nilai Y (1 atau 0)
            
            // --- BAGIAN KANAN: StXX ---
            3'd3: seg = 7'b0010010; // Huruf 'S'
            3'd2: seg = 7'b0000111; // Huruf 't'
            3'd1: seg = (state[1]) ? 7'b1111001 : 7'b1000000; // Bit Q1 (MSB dari State)
            3'd0: seg = (state[0]) ? 7'b1111001 : 7'b1000000; // Bit Q0 (LSB dari State)
            
            default: seg = 7'b1111111;
        endcase
    end
endmodule