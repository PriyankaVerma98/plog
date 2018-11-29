Format_input=  [adapter, ethernet, ip, icmp, tcp, udp ].
in = [T, ethernet proto 2, ip src addr <ipv4-addr>, icmp type <protocol-type>, tcp src port <tcp-udp-port> ].
/* input format: if a particular value is missing null is to be passed for it. */
/* case when input is passed in wrong format then  */

/* precedence order: accept < drop < reject */  
/* result_x = 0 , 1, 2   respectively  */ 
	

/* Step1 : extracting the values */ 

adapter_x = in[H|T].
etherenet_x = in [H|H|T].
tcp_x :- = 3rd element of list . 


	 /* Rules for accepting */ 
adapter_accept( ) :- (adapter_x == any) or (a <= adapter_x <= h).
etherenet_accept() :- 
tcp_accept() :- 
ipv4_accept():-
icmp_code() :-
udp_accept() :- 

(result_x = 0 ) :- adapter_accept( ) or etherenet_accept() or tcp_accept() or .......... other conditions . 

	 /* Rules for dropping */ 
adapter_drop( ):- 
etherenet_drop() :- 
tcp_drop() :- 
ipv4_drop():-
icmp_drop() :-
udp_drop() :-

(result_x = 1) :- adapter_drop( ) or etherenet_drop() or ...... other conditions. 

	 /* Rules for rejecting */ 

  
(result_x = 2) :- adapter_reject( ) or etherenet_reject() or ...... other conditions. 


if    (  !(result_x == 0) and !(result_x == 1) and !(result_x == 2) ) 
   paas the input again 











