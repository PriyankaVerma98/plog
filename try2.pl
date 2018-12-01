member(X,[X|_]).
member(X,[_|Tail]):- member(X,Tail).
member(X,[H|_]):- member(X,H). 

/*Function to check whether elements of one list are present in the other or not*/
allElementsInList([],L).
allElementsInList([X|Tail],L):- member(X,L), allElementsInList(Tail,L).

/* function to check if two lists have atleast one element is common */
match([Head|Tail], List2):- member(Head,List2).
match([_|Tail],List2):- match(Tail,List2).

/* function to check range */ 
inRange([],Lo,Hi).
inRange([H|T], Lo, Hi) :- between(Lo,Hi,H), inRange(T,Lo,Hi).


list_reject_ethernet([ipx,pppoe,arp,0,1,2,3,4,5,6,7,8,9]).
list_accept_ethernet([aarp,atalk,mpls,netbui,rarp,sna,xns]).

ethernet_proto_reject(A,C,B) :- match(B,R) , list_reject_ethernet(R), write('rejected') . 
ethernet_proto_reject(A,C,B) :- member(B,R) , list_reject_ethernet(R), write('rejected') . 
ethernet_proto_accept(A,C,B) :- inRange(B,10,399) ; between(10,399,B) . 

ethernet_vid_reject(A,C,B) :- member(C,R) , list_reject_ethernet(R). 
ethernet_vid_accept(A,C,B) :- inRange(C,10,399) ; between(10,399,C) .
/* put condition to check range of vid */ 

ethernet_reject(A,C,B) :- ethernet_proto_reject(A,C,B) ; ethernet_vid_reject(A,C,B).
ethernet_accept(A,C,B) :- ethernet_proto_accept(A,C,B), ethernet_vid_accept(A,C,B).
/* if both are null then accepted */ 

packet(A,C,B):- ethernet_accept(A,C,B) , write('accepted finally').
packet(A,C,B):- ethernet_reject(A,C,B), write('reject finally').

				/*  ICMP rules */

icmp_valid_msg(echo,unassigned,timestamp).
icmp(Type,Code).
Type = '0' ,  Code = 'Echo' 

icmp_accept(A,C,B,D,E) :-  icmp(D,E),  


/* ethernet_reject(A,B) :-  allElementsInList(B,L), list_reject_ethernet(L), write('rejected'). */ 

/* packet(A,<vid-no>,<proto- no or word>, icmp <type:no>, icmp <code: msg> ) */

/* packet(A,C,B)   				*/