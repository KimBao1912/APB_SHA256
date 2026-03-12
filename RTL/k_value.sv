module k_value
  (input logic [5:0]addr,
   input logic process,
   output logic [31:0] k_val);
  
	reg [31:0] cnst;
	always_comb begin
		case(addr)
			6'd0 : cnst = 32'h 428a2f98;
			6'd1 : cnst = 32'h 71374491;
			6'd2 : cnst = 32'h b5c0fbcf;
			6'd3 : cnst = 32'h e9b5dba5;
			6'd4 : cnst = 32'h 3956c25b;
			6'd5 : cnst = 32'h 59f111f1;
			6'd6 : cnst = 32'h 923f82a4;
			6'd7 : cnst = 32'h ab1c5ed5;
			6'd8 : cnst = 32'h d807aa98;
			6'd9 : cnst = 32'h 12835b01;
			6'd10 : cnst = 32'h 243185be;
			6'd11 : cnst = 32'h 550c7dc3;
			6'd12 : cnst = 32'h 72be5d74;
			6'd13 : cnst = 32'h 80deb1fe;
			6'd14 : cnst = 32'h 9bdc06a7;
			6'd15 : cnst = 32'h c19bf174;
			6'd16 : cnst = 32'h e49b69c1;
			6'd17 : cnst = 32'h efbe4786;
			6'd18 : cnst = 32'h 0fc19dc6;
			6'd19 : cnst = 32'h 240ca1cc;
			6'd20 : cnst = 32'h 2de92c6f;
			6'd21 : cnst = 32'h 4a7484aa;
			6'd22 : cnst = 32'h 5cb0a9dc;
			6'd23 : cnst = 32'h 76f988da;
			6'd24 : cnst = 32'h 983e5152;
			6'd25 : cnst = 32'h a831c66d;
			6'd26 : cnst = 32'h b00327c8;
			6'd27 : cnst = 32'h bf597fc7;
			6'd28 : cnst = 32'h c6e00bf3;
			6'd29 : cnst = 32'h d5a79147;
			6'd30 : cnst = 32'h 06ca6351;
			6'd31 : cnst = 32'h 14292967;
			6'd32 : cnst = 32'h 27b70a85;
			6'd33 : cnst = 32'h 2e1b2138;
			6'd34 : cnst = 32'h 4d2c6dfc;
			6'd35 : cnst = 32'h 53380d13;
			6'd36 : cnst = 32'h 650a7354;
			6'd37 : cnst = 32'h 766a0abb;
			6'd38 : cnst = 32'h 81c2c92e;
			6'd39 : cnst = 32'h 92722c85;
			6'd40 : cnst = 32'h a2bfe8a1;
			6'd41 : cnst = 32'h a81a664b;
			6'd42 : cnst = 32'h c24b8b70;
			6'd43 : cnst = 32'h c76c51a3;
			6'd44 : cnst = 32'h d192e819;
			6'd45 : cnst = 32'h d6990624;
			6'd46 : cnst = 32'h f40e3585;
			6'd47 : cnst = 32'h 106aa070;
			6'd48 : cnst = 32'h 19a4c116;
			6'd49 : cnst = 32'h 1e376c08;
			6'd50 : cnst = 32'h 2748774c;
			6'd51 : cnst = 32'h 34b0bcb5;
			6'd52 : cnst = 32'h 391c0cb3;
			6'd53 : cnst = 32'h 4ed8aa4a;
			6'd54 : cnst = 32'h 5b9cca4f;
			6'd55 : cnst = 32'h 682e6ff3;
			6'd56 : cnst = 32'h 748f82ee;
			6'd57 : cnst = 32'h 78a5636f;
			6'd58 : cnst = 32'h 84c87814;
			6'd59 : cnst = 32'h 8cc70208;
			6'd60 : cnst = 32'h 90befffa;
			6'd61 : cnst = 32'h a4506ceb;
			6'd62 : cnst = 32'h bef9a3f7;
			6'd63 : cnst = 32'h c67178f2;
		endcase
	end
	assign k_val = process ? cnst : 0;
	
endmodule