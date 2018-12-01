 													/* GENERAL FUNCTIONS */
	
 /* member relation */

member(X,[X|_]).
member(X,[_|Tail]):- member(X,Tail).
member(X,[H|_]):- member(X,H). 

/*Function to check whether elements of one list are present in the other or not*/
allElementsInList([],_).
allElementsInList([X|Tail],L):- member(X,L), allElementsInList(Tail,L).

/* function to check if two lists have atleast one element is common */

match([Head|_], List2):- member(Head,List2).
match([_|Tail],List2):- match(Tail,List2).

/* function to check range */ 
range([],Lo,Hi).
range([H|T], Lo, Hi) :- between(Lo,Hi,H), inRange(T,Lo,Hi).

inRange([],_,_).
inRange([H|T], Lo, Hi):- number_codes(X,H), between(Lo,Hi,X), inRange(T,Lo,Hi).



														/*ADAPTER CLAUSE*/

/* list of accepted and rejected adapters. All other values are dropped by default */

adapter_accepted_list([a,b,c,d,e]).
adapter_rejected_list([f,g,h]).

/*rules for accepted adapters. Any is an acceptable adapter. Null value is taken as -1 and is accepted. input can be a single adapter or a list of adapters. */

adapter_accept(any).
adapter_accept(-1). 
adapter_accept(A):-adapter_accepted_list(L), member(A,L). 
adapter_accept(A):- adapter_accepted_list(Al), allElementsInList(A,Al).

/* rules for rejected adapters. input can be single adapter or list of adapters. if any members of input lie in the range of rejected adapters, then the adapter list is to be rejected. for reject all adapters must be in the rejected range, else it is dropped by default */

adapter_reject(A):-adapter_rejected_list(L1), member(A,L1), write('adapter rejected.... ').
adapter_reject(A):- adapter_rejected_list(AR), match(A,AR), write('adapter rejected.... ').


													/* ETHERNET CLAUSE */

list_reject_ethernet([ipx,pppoe,arp,0,1,2,3,4,5,6,7,8,9]).
list_accept_ethernet([aarp,atalk,mpls,netbui,rarp,sna,xns]).

ethernet_proto_reject(B) :- match(B,R) , list_reject_ethernet(R), write('rejected') . 
ethernet_proto_reject(B) :- member(B,R) , list_reject_ethernet(R), write('rejected') . 
ethernet_proto_accept(B) :- range(B,10,399) ; between(10,399,B) . 

ethernet_vid_reject(C) :- member(C,R) , list_reject_ethernet(R). 
ethernet_vid_accept(C) :- range(C,10,399) ; between(10,399,C) .

ethernet_reject(C,B) :- ethernet_proto_reject(B) ; ethernet_vid_reject(C).
ethernet_accept(C,B) :- ethernet_proto_accept(B), ethernet_vid_accept(C).




													/* IPv4 ADDRESS CLAUSE */



ipv4_accept(A):- split_string(A,".",".", L), inRange(L,100,255).  

ipv4_reject(-1):- write('IPv4 adress cannot be null.... '). 
ipv4_reject(A):- split_string(A,".",".", Li), inRange(Li,0,100), write('IPv4 address is in reject range.... '). 


													/* TCP CLAUSE AND UDP CLAUSES */

tcpsrc_acceptrange(X):- (split_string(X,",",",",L), inRange(L,0,100)).
tcpdes_acceptrange(X):- (split_string(X,",",",",L), inRange(L,0,100)).

tcpsrc_rejectrange(X):- (split_string(X,",",",",L), inRange(L,101,200)).
tcpdes_rejectrange(X):- (split_string(X,",",",",L), inRange(L,101,200)).

tcp_accept(-1,-1).
tcp_accept(A,B):- tcpsrc_acceptrange(A),tcpdes_acceptrange(B).

tcp_reject(A,B):- (tcpsrc_rejectrange(A); tcpdes_rejectrange(B)), write('TCP source or destination address is in reject range.... ').

udpsrc_acceptrange(X):- (split_string(X,",",",",L), inRange(L,0,200)).
udpdes_acceptrange(X):- (split_string(X,",",",",L), inRange(L,0,200)).

udpsrc_rejectrange(X):- (split_string(X,",",",",L), inRange(L,201,500)).
udpdes_rejectrange(X):- (split_string(X,",",",",L), inRange(L,201,500)).

udp_accept(-1,-1).
udp_accept(A,B):- udpsrc_acceptrange(A),udpdes_acceptrange(B).

udp_reject(A,B):- (udpsrc_rejectrange(A); udpdes_rejectrange(B)), write('UDP source or destination address is in reject range.... ').


tcpudp_accept(A,B,C,D):- tcp_accept(A,B),udp_accept(C,D).
tcpudp_reject(A,B,C,D):- (tcp_reject(A,B);udp_reject(C,D)).

													/* ICMP CLAUSES */

icmp(0,echo).
icmp(1,redirect).
icmp(-1,echo).
icmp(-1,redirect).
icmp(0,-1).
icmp(1,-1).
icmp(-1,-1).

icmp(2,unassigned).
icmp(11,timeExceeded).
icmp(_,-1).
icmp(-1,_).
				

icmp_accept_type([0,1,-1]).
icmp_reject_type([2,11]).

icmp_accept_code([echo,redirect,-1]).
icmp_reject_code([unassigned,timeExceeded]). 


icmp_reject(D,E) :- icmp(D,E), ((member(D,K) , icmp_reject_type(K)) ; (member(E,L), icmp_reject_code(L) ) ) .
/* reject is not working */ 
icmp_accept(D,E) :- icmp(D,E), ((member(D,L),icmp_accept_type(L));( member(E,P), icmp_accept_code(P))).


												/* ACCEPT, REJECT AND DROP CONDITIOND FOR PACKET */

/* rules to check accept, reject and drop condtions on packets. if all elements are in accept ranges then packet is accepted, if any one is in reject then packet is rejected, in all other conditions, packet is to be dropped */

accept(A,B,V,P,C,D,E,F,G,H):- adapter_accept(A), ipv4_accept(B), ethernet_accept(V,P), tcpudp_accept(C,D,E,F), icmp_accept(G,H).
reject(A,B,V,P,C,D,E,F,G,H):- adapter_reject(A); ipv4_reject(B); tcpudp_reject(C,D,E,F); ethernet_reject(V,P); icmp_reject(G,H).
drop(A,B,V,P,C,D,E,F,G,H):- ((\+accept(A,B,V,P,C,D,E,F,G,H)) , (\+reject(A,B,V,P,C,D,E,F,G,H))).

/* printing the final output */

packet(A,B,V,P,C,D,E,F,G,H):- accept(A,B,V,P,C,D,E,F,G,H), write('accept').
packet(A,B,V,P,C,D,E,F,G,H):- reject(A,B,V,P,C,D,E,F,G,H), write('reject').
packet(A,B,V,P,C,D,E,F,G,H):- drop(A,B,V,P,C,D,E,F,G,H), write('drop').
