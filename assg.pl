/*  for trying : 10 and 399 inclusive */
member(X,[X|_]).
member(X,[_|Tail]):- member(X,Tail).
member(X,[H|_]):- member(X,H). 

 								/* ICMP code */
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
icmp_drop(D,E) :- (\+icmp_accept(D,E)),(\+icmp_reject(D,E)).

packet(D,E):- icmp_reject(D,E), write('rejected').
packet(D,E):- icmp_accept(D,E), write(' accepted').
packet(D,E):- icmp_drop(D,E), write(' dropped').




