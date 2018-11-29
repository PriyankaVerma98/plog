Format_input=  [adapter, ethernet, ip, icmp, tcp/ udp ].

in = [T, ethernet proto 2, ip src addr <ipv4-addr>, icmp type <protocol-type>, tcp src port <tcp-udp-port>  ].
/* how to check if the packet is incoming or outgoing ? */

sent_to_layer_2 :-  ( A <= in[H|T] <= H  ) or (any) or (null) .
/* Supported adapter clauses are "any" or */
/* the letters A through H. If you do not specify an adapter clause, */
/* the rule matches packets on any adapter */ 

sent_to_layer_3 :- sent_to_layer_2 ^ ( conditions to psd )




