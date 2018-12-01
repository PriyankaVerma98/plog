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




													/* IPv4 ADDRESS CLAUSE */



inRange([],_,_).
inRange([H|T], Lo, Hi):- number_codes(X,H), between(Lo,Hi,X), inRange(T,Lo,Hi).
	
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




/* rules to check accept, reject and drop condtions on packets. if all elements are in accept ranges then packet is accepted, if any one is in reject then packet is rejected, in all other conditions, packet is to be dropped */

accept(A,B,C,D,E,F):- adapter_accept(A), ipv4_accept(B), tcpudp_accept(C,D,E,F).
reject(A,B,C,D,E,F):- adapter_reject(A); ipv4_reject(B); tcpudp_reject(C,D,E,F).
drop(A,B,C,D,E,F):- ((\+accept(A,B,C,D,E,F)) , (\+reject(A,B,C,D,E,F))).

/* printing the final output */

packet(A,B,C,D,E,F):- accept(A,B,C,D,E,F), write('accept').
packet(A,B,C,D,E,F):- reject(A,B,C,D,E,F), write('reject').
packet(A,B,C,D,E,F):- drop(A,B,C,D,E,F), write('drop').
