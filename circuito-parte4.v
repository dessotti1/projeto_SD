module controlador (clk,ch_vm,enb_3,Vint_z,qs,qes,qees,rstn,se,see,seee ;
	input clk,ch_vm,enb_3,Vint_z;
    	input [3:0] qs,qes,qees;
	output reg rstn;
   	 output reg [3:0] se,see,seee;
  	reg [1:0] state;
  	reg ch_ref,ch_zr;
	parameter a = 2'b00,
		      b = 2'b01,
		      c = 2'b10,
		      d = 2'b11;
	initial begin
      		rstn = 1'b1;
		state = a;
	end
	always@(negedge clk)begin
		case(state)
			a: begin
          				if(ch_vm == 1'b1)begin 
//Muda de estado apos a chave inicial ser ativada
					ch_zr <= 1'b0;
					state <= b;
         			end
			else 
				state <=a;
			end
			b: begin
          				if(enb_3 == 1'b1)begin 
//Muda de estado apos o tempo definido
					state <= c;
				end
				else
					state <= b;
			end
			c: begin
         				if(Vint_z == 1'b1)begin 
//Muda o estado quando a tensao eh zero
					se <= qs;
					see <= qes;
					seee <= qees;
					ch_zr <= 1'b1;
					state <= d;
         				end	
				else
					state <= c;
			end
			d: begin
         				 if(ch_vm == 1'b1) 
//Retorna ao primeiro estado para realizar mais medidas
					state <= a;
				else
					state <= d;
			end
		endcase
	end
	

always @(state) begin
		case(state)
          			b: begin
            				rstn =1'b0;
          			end
			c: begin 
				ch_ref = 1'b1;
			end
			d: begin
				rstn = 1'b1;
			end
		endcase
	end
endmodule

module combinado (clk, reset, q, qe, qee, qs, qes,  qees, a1, b1, c1, d1, e1, f1,g1, a2, b2, c2, d2, e2, f2, g2, a3, b3, c3, d3, e3, f3, g3,  Vint_z, ch_vm,enb_3, se, see, seee) ;
	input clk;
  	input Vint_z,ch_vm;
    	output reg reset;
  	output reg[3:0] q,qe,qee,qs,qes,qees,se,see,seee;
    	output reg enb_3;
	output a1, b1, c1, d1, e1, f1, g1;
	output a2, b2, c2, d2, e2, f2, g2;
	output a3, b3, c3, d3, e3, f3, g3;
  	initial begin
    		enb_3 = 1'b0;
    	end

   	 contador4b u1 (clk, reset, q, qe, qee, qs, qes, qees, a1, b1, c1, d1, e1, f1,g1, a2, b2, c2, d2, e2, f2, g2, a3, b3, c3, d3, e3, f3, g3);

    	controlador u2 (clk, ch_vm, enb_3, Vint_z, qs, qes, qees, reset, se, see, seee);
   	always @ * begin
      	if(q == 4'b0111)//Definir tempo. No exemplo, t=7
      		enb_3 = 1'b1;
      	else
        		enb_3 = 1'b0;
    	end   
 endmodule
