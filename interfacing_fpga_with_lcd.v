module lcd(clk, lcd_rs, sf_d8, sf_d9, sf_d10, sf_d11, lcd_rw, lcd_e, sf_ce0);
    parameter k = 15;
    input clk;
    output lcd_rs, sf_d8, sf_d9, sf_d10, sf_d11, lcd_rw, lcd_e, sf_ce0;

    reg lcd_rs, sf_d8, sf_d9, sf_d10, sf_d11, lcd_rw, lcd_e, sf_ce0;
    reg [k+8-1:0] count;
    reg lcd_busy;
    reg [5:0] lcd_char;
    reg lcd_stb;
    reg [6:0] lcd_intf_signals;

    always @ (posedge clk)
        begin
            count <= count + 1;
            lcd_busy <= 1'b1;
            sf_ce0 <= 1; //-- disables Intel StrataFlash memory

            case (count[k+7:k+2])
                0: lcd_char <= 6'h03; //-- power-on initialization
                1: lcd_char <= 6'h03;

                2: lcd_char <= 6'h03; //-- power-on initialization continued
                3: lcd_char <= 6'h02;

                4: lcd_char <= 6'h02; //-- configures lcd for operation on Spartan 3E FPGA
                5: lcd_char <= 6'h08;

                6: lcd_char <= 6'h00; //-- sets lcd to automatically increment address pointer
                7: lcd_char <= 6'h06;

                8: lcd_char <= 6'h00; //-- turns lcd on and disables cursor and blinking
                9: lcd_char <= 6'h0C;

                10: lcd_char <= 6'h00; //-- clears lcd
                11: lcd_char <= 6'h01;

                12: lcd_char <= 6'h24; //-- H
                13: lcd_char <= 6'h28;

                14: lcd_char <= 6'h26; //-- e
                15: lcd_char <= 6'h25;

                16: lcd_char <= 6'h26; //-- l
                17: lcd_char <= 6'h2C;

                18: lcd_char <= 6'h26; //-- l
                19: lcd_char <= 6'h2C;

                20: lcd_char <= 6'h26; //-- o
                21: lcd_char <= 6'h2F;

                22: lcd_char <= 6'h22; //--
                23: lcd_char <= 6'h20;

                24: lcd_char <= 6'h25; //-- S
                25: lcd_char <= 6'h23;

                26: lcd_char <= 6'h26; //-- e
                27: lcd_char <= 6'h25;

                28: lcd_char <= 6'h26; //-- a
                29: lcd_char <= 6'h21;

                30: lcd_char <= 6'h26; //-- n
                31: lcd_char <= 6'h2E;

                32: lcd_char <= 6'h22; //-- !
                33: lcd_char <= 6'h21;

                default: lcd_char <= 6'h10;
            endcase

            lcd_stb <= ^count[k+1:k+0] & ~lcd_rw & lcd_busy;
            lcd_intf_signals <= {lcd_stb, lcd_char};
            {lcd_rs, sf_d8, sf_d9, sf_d10, sf_d11, lcd_rw, lcd_e} <= lcd_intf_signals;
        end
endmodule


/*
NETLIST

NET "lcd_e" LOC = "M18" | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;
NET "lcd_rs" LOC = "L18" | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;
NET "lcd_rw" LOC = "L17" | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;
NET "sf_d8" LOC = "R15" | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;
NET "sf_d9" LOC = "R16" | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;
NET "sf_d10" LOC = "P17" | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;
NET "sf_d11" LOC = "M15" | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;
NET "sf_ce0" LOC = "D16" | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;
NET "clk" LOC = "C9" | IOSTANDARD = LVCMOS33 ;
*/
