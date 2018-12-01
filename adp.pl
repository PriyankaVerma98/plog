 													/* GENERAL FUNCTIONS */
	
 /* member relation */

member(X,[X|_]).
member(X,[_|Tail]):- member(X,Tail).
member(X,[H|_]):- member(X,H). 

/*Function to check whether elements of one list are present in the other or not*/
allElementsInList([],L).
allElementsInList([X|Tail],L):- member(X,L), allElementsInList(Tail,L).

/* function to check if two lists have atleast one element is common */

match([Head|Tail], List2):- member(Head,List2).
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




ipv4_accept(0).

inRange([]).
inRange([H|T]):- between(0,255,H), inRange(Tail).

ipv4_reject(-1):- write('IPv4 adress cannot be null.... '). 
ipv4_reject(A):- write('IPv4 adress is not in range.... '), split(A,".","", Li), \+inRange(Li). 




/* rules to check accept, reject and drop condtions on packets. if all elements are in accept ranges then packet is accepted, if any one is in reject then packet is rejected, in all other conditions, packet is to be dropped */

accept(A,B):- adapter_accept(A),ipv4_accept(B).
reject(A,B):- adapter_reject(A);ipv4_reject(B).
drop(A):- ((\+accept(A)) , (\+reject(A))).

/* printing the final output */

packet(A,B):- accept(A,B), write('accept').
packet(A,B):- reject(A,B), write('reject').
packet(A,B):- drop(A,B), write('drop').
