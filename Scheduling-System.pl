/*Project 1 Concepts of Programming Language*/


/*week_schedule (A)*/
week_schedule([],_,_,[]).
week_schedule([H|T],TAs,DayMax,[DaySched|T1]):-
   day_schedule(H,TAs,RemTAs,DaySched),
   max_slots_per_day(DaySched,DayMax),
   week_schedule(T,RemTAs,DayMax,T1).


/* day_schedule (B)*/
day_schedule([N1,N2,N3,N4,N5], TAs, RemTAs, [A1,A2,A3,A4,A5]):-
   slot_assignment(N1, TAs, R1, A1),
   slot_assignment(N2, R1, R2, A2),
   slot_assignment(N3, R2, R3, A3),
   slot_assignment(N4, R3, R4, A4),
   slot_assignment(N5, R4, RemTAs, A5).

   /*max_slots_per_day (C)*/
max_slots_per_day(DaySched,Max):-
   flatten(DaySched,Labs),
   unique(Labs,TAs),
   maxLabs(Labs,TAs,Comp),
   Max>=Comp,!.

/*slot_assignment (D)*/
slot_assignment(LabsNum,TAs,RemTAs,Assignment):-
   length(TAs,L),
   random_sublist(TAs,LabsNum,L,Assignment),
   updateRemTA(LabsNum,TAs,RemTAs,Assignment).


/*ta_slot_assignment (E)*/
ta_slot_assignment([ta(Name,Load)|T],[ta(Name,Load1)|T],Name):-
    Load>0,
    Load1 is Load-1,!.
    

ta_slot_assignment([ta(N,Load)|T],[ta(N,Load)|T1],Name):-
    Name \=N,
    ta_slot_assignment(T,T1,Name).



/*helpers

helper predicate returns counts occurence of each TA in labs and returns the highest occurence (number of labs of TA that worked most) */
maxLabs(_,[],0).
maxLabs(Labs,[H|T],N):-
   count(H,Labs,N1),
   maxLabs(Labs,T,N2),
   max(N1,N2,N).
   
/*helper predicate returns maximum from 2 numbers*/
max(A,B,B):-
   B>A.
max(A,B,A):-
   A>=B.

/*helper that counts number of occurence of X in list*/
count(_, [], 0).
count(X, [X | T], Count) :- count(X, T, Count1), Count is Count1 + 1.
count(X, [Y | T], Count) :- X \= Y, count(X, T, Count).

unique([], []).
unique([H | T], Unique) :- member(H, T), !, unique(T, Unique).
unique([H | T], [H | Unique]) :- unique(T, Unique).


/*helper that gets a sublist (size n) of random elements in main list (size m) where m>n*/
random_sublist(_, 0, _, []).
random_sublist([ta(Name,_)|Xs], M, N, [Name|Ys]) :-
    M > 0,
    M1 is M - 1,
    N1 is N - 1,
    random_sublist(Xs, M1, N1, Ys).
random_sublist([_|Xs], M, N, Ys) :-
    M > 0,
    random_sublist(Xs, M, N - 1, Ys).


/*helper that updateRemTA after it calls on a list of Assignment*/
updateRemTA(0,RemTAs,RemTAs,[]).
updateRemTA(LabsNum,TAs,RemTAs,[H|T]):-
   LabsNum1 is LabsNum-1,
   ta_slot_assignment(TAs,Res,H),
   updateRemTA(LabsNum1,Res,RemTAs,T).
