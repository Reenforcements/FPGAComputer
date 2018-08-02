`timescale 1 ps / 1 ps

package PS2KeyboardMemoryCodes;
typedef enum logic [7:0] {
	sc_1_exclamation = 8'h16,
	sc_2_at = 8'h1E,
	sc_3_pound = 8'h26,
	sc_4_dollar = 8'h25,
	sc_5_percent = 8'h2E,
	sc_6_caret = 8'h36,
	sc_7_ampersand = 8'h3D,
	sc_8_asterisk = 8'h3E,
	sc_9_leftparenthesis = 8'h46,
	sc_0_rightparenthesis = 8'h45,
	sc_dash_underscore = 8'h4E,
	sc_plus_equals = 8'h55,
	sc_backspace = 8'h66,
	
	sc_tab = 8'h0D,
	sc_q_Q = 8'h15,
	sc_w_W = 8'h1D,
	sc_e_E = 8'h24,
	sc_r_R = 8'h2D,
	sc_t_T = 8'h2C,
	sc_y_Y = 8'h35,
	sc_u_U = 8'h3C,
	sc_i_I = 8'h43,
	sc_o_O = 8'h44,
	sc_p_P = 8'h4D,
	sc_leftbracket_leftcurly = 8'h54,
	sc_rightbracket_rightcurly = 8'h5B,
	sc_pipe_backslash = 8'h5D,
	
	sc_a_A = 8'h1C,
	sc_s_S = 8'h1B,
	sc_d_D = 8'h23,
	sc_f_F = 8'h2B,
	sc_g_G = 8'h34,
	sc_h_H = 8'h33,
	sc_j_J = 8'h3B,
	sc_k_K = 8'h42,
	sc_l_L = 8'h4B,
	sc_colon_semicolon = 8'h4C,
	sc_doublequote_singlequote = 8'h52,
	sc_enter = 8'h5A,
	
	sc_leftshift = 8'h12,
	sc_z_Z = 8'h1A,
	sc_x_X = 8'h22,
	sc_c_C = 8'h21,
	sc_v_V = 8'h2A,
	sc_b_B = 8'h32,
	sc_n_N = 8'h31,
	sc_m_M = 8'h3A,
	sc_lessthan_comma = 8'h41,
	sc_greaterthan_period = 8'h49,
	sc_questionmark_forwardslash = 8'h4A,
	sc_rightshift = 8'h59,
	
	sc_ctrl = 8'h14,
	sc_alt = 8'h11,
	
	sc_space = 8'h29,
	
	// Extended
	// (Two bytes per key code)
	// These have the same codes but get an E0 byte first.
	//sce_rightalt = 8'h11,
	//sce_rightctrl = 8'h14,
	
	sce_up = 8'h75,
	sce_down = 8'h72,
	sce_left = 8'h6B,
	sce_right = 8'h74
	
} ScanCode;

typedef enum logic [7:0] {
	ascii_null = 8'h0,
	
	ascii_tab = 8'h9,
	ascii_nl = 8'hA,

	ascii_space = 8'h20,
	ascii_exclamation = 8'h21,
	ascii_doublequote = 8'h22,
	ascii_pound = 8'h23,
	ascii_dollarsign = 8'h24,
	ascii_percent = 8'h25,
	ascii_ampersand = 8'h26,
	ascii_singlequote = 8'h27,
	ascii_leftparenthesis = 8'h28,
	ascii_rightparenthesis = 8'h29,
	ascii_asterisk = 8'h2A,
	ascii_plus = 8'h2B,
	ascii_comma = 8'h2C,
	ascii_dash = 8'h2D,
	ascii_period = 8'h2E,
	ascii_forwardslash = 8'h2F,
	
	ascii_0 = 8'h30,
	ascii_1 = 8'h31,
	ascii_2 = 8'h32,
	ascii_3 = 8'h33,
	ascii_4 = 8'h34,
	ascii_5 = 8'h35,
	ascii_6 = 8'h36,
	ascii_7 = 8'h37,
	ascii_8 = 8'h38,
	ascii_9 = 8'h39,
	ascii_colon = 8'h3A,
	ascii_semicolon = 8'h3B,
	ascii_lessthan = 8'h3C,
	ascii_equals = 8'h3D,
	ascii_greaterthan = 8'h3E,
	ascii_questionmark = 8'h3F,
	ascii_at = 8'h40,
	ascii_A = 8'h41,
	ascii_B = 8'h42,
	ascii_C = 8'h43,
	ascii_D = 8'h44,
	ascii_E = 8'h45,
	ascii_F = 8'h46,
	ascii_G = 8'h47,
	ascii_H = 8'h48,
	ascii_I = 8'h49,
	ascii_J = 8'h4A,
	ascii_K = 8'h4B,
	ascii_L = 8'h4C,
	ascii_M = 8'h4D,
	ascii_N = 8'h4E,
	ascii_O = 8'h4F,
	ascii_P = 8'h50,
	ascii_Q = 8'h51,
	ascii_R = 8'h52,
	ascii_S = 8'h53,
	ascii_T = 8'h54,
	ascii_U = 8'h55,
	ascii_V = 8'h56,
	ascii_W = 8'h57,
	ascii_X = 8'h58,
	ascii_Y = 8'h59,
	ascii_Z = 8'h5A,
	ascii_leftbracket = 8'h5B,
	ascii_backslash = 8'h5C,
	ascii_rightbracket = 8'h5D,
	ascii_caret = 8'h5E,
	ascii_underscore = 8'h5F,
	
	ascii_backtick = 8'h60,
	ascii_a = 8'h61,
	ascii_b = 8'h62,
	ascii_c = 8'h63,
	ascii_d = 8'h64,
	ascii_e = 8'h65,
	ascii_f = 8'h66,
	ascii_g = 8'h67,
	ascii_h = 8'h68,
	ascii_i = 8'h69,
	ascii_j = 8'h6A,
	ascii_k = 8'h6B,
	ascii_l = 8'h6C,
	ascii_m = 8'h6D,
	ascii_n = 8'h6E,
	ascii_o = 8'h6F,
	ascii_p = 8'h70,
	ascii_q = 8'h71,
	ascii_r = 8'h72,
	ascii_s = 8'h73,
	ascii_t = 8'h74,
	ascii_u = 8'h75,
	ascii_v = 8'h76,
	ascii_w = 8'h77,
	ascii_x = 8'h78,
	ascii_y = 8'h79,
	ascii_z = 8'h7A,
	
	ascii_leftcurlybrace = 8'h7B,
	ascii_pipe = 8'h7C,
	ascii_rightcurlybrace = 8'h7D,
	ascii_tilde = 8'h7E,
	ascii_delete = 8'h7F,

	// These are special keys that I encode as ascii characters
	ascii_up = 8'hC1,
	ascii_down = 8'hC2,
	ascii_right = 8'hC3,
	ascii_left = 8'hB4,

	ascii_shift = 8'hCB,
	ascii_ctrl = 8'hCD,
	ascii_alt = 8'hC4
} AsciiCode;
endpackage

import PS2KeyboardMemoryCodes::*;
module PS2KeyboardMemory(
input logic clk,
input logic rst,

input logic [7:0]scanCode,
input logic scanCodeReady,

input logic [7:0]asciiKeyAddress,
output logic [31:0]keyValue
);

AsciiCode asciiCode_next;

logic keyUp;
logic keyUp_next;
// There's two of each control key
logic [1:0]shift;
logic [1:0]alt;
logic [1:0]ctrl;
logic extended;
logic extended_next;

logic secondary;

// This array holds whether or not the key with the given ascii
//  value is being held down (1) or not (0).
logic keyMemory[255];

logic [7:0]asciiKeyAddress_d0;

always_ff @ (posedge clk or negedge rst) begin
	if (rst == 1'b0) begin
		keyUp <= 1'b0;
		shift <= 2'd0;
		ctrl <= 2'd0;
		alt <= 2'd0;
		extended <= 1'b0;
		asciiKeyAddress_d0 <= 8'd0;
	end
	else begin		

		asciiKeyAddress_d0 <= asciiKeyAddress;
		
		// Did we get the key up code?
		keyUp <= keyUp_next;
		
		// Save the key press (or release) to memory.
		if (asciiCode_next != ascii_null) begin
			keyMemory[8'(asciiCode_next)] <= ~keyUp;
			// Special keys
			unique case (asciiCode_next)
				ascii_shift: begin
					shift <= shift + ( keyUp == 1'b1 ? -2'd1 : 2'd1 );
					keyMemory[8'(asciiCode_next)] <= (shift + ( keyUp == 1'b1 ? -2'd1 : 2'd1 )) != 0;
				end
				ascii_ctrl: begin
					ctrl <= ctrl + ( keyUp == 1'b1 ? -2'd1 : 2'd1 );
					keyMemory[8'(asciiCode_next)] <= (ctrl + ( keyUp == 1'b1 ? -2'd1 : 2'd1 )) != 0;
				end
				ascii_alt: begin
					alt <= alt + ( keyUp == 1'b1 ? -2'd1 : 2'd1 );
					keyMemory[8'(asciiCode_next)] <= (alt + ( keyUp == 1'b1 ? -2'd1 : 2'd1 )) != 0;
				end 
				default: begin end
			endcase
			// Clear modifiers
			keyUp <= 1'b0;
			extended <= 1'b0;
		end
		
	end
end


always_comb begin
	asciiCode_next = ascii_null;
	keyUp_next = keyUp;
	secondary = shift > 2'd0;
	
	extended_next = extended;
	if (scanCodeReady == 1'b1) begin
		unique case (ScanCode'(scanCode))
			sc_1_exclamation: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_1;
				else
					asciiCode_next = ascii_exclamation;
			end
			sc_2_at: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_2;
				else
					asciiCode_next = ascii_at;
			end
			sc_3_pound: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_3;
				else
					asciiCode_next = ascii_pound;
			end
			sc_4_dollar: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_4;
				else
					asciiCode_next = ascii_dollarsign;
			end
			sc_5_percent: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_5;
				else
					asciiCode_next = ascii_percent;
			end
			sc_6_caret: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_6;
				else
					asciiCode_next = ascii_caret;
			end
			sc_7_ampersand: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_7;
				else
					asciiCode_next = ascii_ampersand;
			end
			sc_8_asterisk: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_8;
				else
					asciiCode_next = ascii_asterisk;
			end
			sc_9_leftparenthesis: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_9;
				else
					asciiCode_next = ascii_leftparenthesis;
			end
			sc_0_rightparenthesis: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_0;
				else
					asciiCode_next = ascii_rightparenthesis;
			end
			sc_dash_underscore: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_dash;
				else
					asciiCode_next = ascii_underscore;
			end
			sc_plus_equals: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_plus;
				else
					asciiCode_next = ascii_equals;
			end
			sc_backspace: begin
				asciiCode_next = ascii_delete;
			end
			
			sc_tab: begin
				asciiCode_next = ascii_tab;
			end
			sc_q_Q: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_q;
				else
					asciiCode_next = ascii_Q;
			end
			sc_w_W: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_w;
				else
					asciiCode_next = ascii_W;
			end
			sc_e_E: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_e;
				else
					asciiCode_next = ascii_E;
			end
			sc_r_R: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_r;
				else
					asciiCode_next = ascii_R;
			end
			sc_t_T: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_t;
				else
					asciiCode_next = ascii_T;
			end
			sc_y_Y: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_y;
				else
					asciiCode_next = ascii_Y;
			end
			sc_u_U: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_u;
				else
					asciiCode_next = ascii_U;
			end
			sc_i_I: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_i;
				else
					asciiCode_next = ascii_I;
			end
			sc_o_O: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_o;
				else
					asciiCode_next = ascii_O;
			end
			sc_p_P: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_p;
				else
					asciiCode_next = ascii_P;
			end
			sc_leftbracket_leftcurly: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_leftbracket;
				else
					asciiCode_next = ascii_leftcurlybrace;
			end
			sc_rightbracket_rightcurly: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_rightbracket;
				else
					asciiCode_next = ascii_rightcurlybrace;
			end
			sc_pipe_backslash: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_pipe;
				else
					asciiCode_next = ascii_backslash;
			end
			
			sc_a_A: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_a;
				else
					asciiCode_next = ascii_A;
			end
			sc_s_S: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_s;
				else
					asciiCode_next = ascii_S;
			end
			sc_d_D: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_d;
				else
					asciiCode_next = ascii_D;
			end
			sc_f_F: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_f;
				else
					asciiCode_next = ascii_F;
			end
			sc_g_G: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_g;
				else
					asciiCode_next = ascii_G;
			end
			sc_h_H: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_h;
				else
					asciiCode_next = ascii_H;
			end
			sc_j_J: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_j;
				else
					asciiCode_next = ascii_J;
			end
			sc_k_K: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_k;
				else
					asciiCode_next = ascii_K;
			end
			sc_l_L: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_l;
				else
					asciiCode_next = ascii_L;
			end
			sc_colon_semicolon: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_colon;
				else
					asciiCode_next = ascii_semicolon;
			end
			sc_doublequote_singlequote: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_doublequote;
				else
					asciiCode_next = ascii_singlequote;
			end
			sc_enter: begin
				asciiCode_next = ascii_nl;
			end
			
			sc_z_Z: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_z;
				else
					asciiCode_next = ascii_Z;
			end
			sc_x_X: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_x;
				else
					asciiCode_next = ascii_X;
			end
			sc_c_C: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_c;
				else
					asciiCode_next = ascii_C;
			end
			sc_v_V: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_v;
				else
					asciiCode_next = ascii_V;
			end
			sc_b_B: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_b;
				else
					asciiCode_next = ascii_B;
			end
			sc_n_N: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_n;
				else
					asciiCode_next = ascii_N;
			end
			sc_m_M: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_m;
				else
					asciiCode_next = ascii_M;
			end
			sc_lessthan_comma: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_lessthan;
				else
					asciiCode_next = ascii_comma;
			end
			sc_greaterthan_period: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_greaterthan;
				else
					asciiCode_next = ascii_period;
			end
			sc_questionmark_forwardslash: begin
				if (secondary != 1'b1)
					asciiCode_next = ascii_questionmark;
				else
					asciiCode_next = ascii_forwardslash;
			end
			
			sc_space:begin
				asciiCode_next = ascii_space;
			end
			
			sc_leftshift: begin
				asciiCode_next = ascii_shift;
			end	
			sc_rightshift: begin
				asciiCode_next = ascii_shift;
			end

			// Extended
			// (Two bytes per key code)
			sc_ctrl: begin
				asciiCode_next = ascii_ctrl;
			end	
			sc_alt: begin
				asciiCode_next = ascii_alt;
			end
			
			sce_up: begin
				asciiCode_next = ascii_up;
			end
			sce_down: begin
				asciiCode_next = ascii_down;
			end
			sce_left: begin
				asciiCode_next = ascii_left;
			end
			sce_right: begin
				asciiCode_next = ascii_right;
			end
			default: begin
				// Keep the same ascii code we had before.
			end
		endcase
		
		// Extended scancode?
		if (scanCode == 8'hE0) begin
			extended_next = 1'b1;
		end
		// Releasing a key?
		if (scanCode == 8'hF0) begin
			keyUp_next = 1'b1;
		end
	end

	keyValue = { {7{1'b0}}, keyMemory[ asciiKeyAddress_d0[7:0] ]};
end



endmodule






