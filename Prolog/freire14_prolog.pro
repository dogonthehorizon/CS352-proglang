% File      : freire14_prolog.pro
% Author    : Fernando Freire
% Date      : 02/05/2013


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% FACTS %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dinner Party members
gender(hal, male) .
gender(barry, male).
gender(sam, male).
gender(frank, male).
gender(hilary, female).
gender(barbara, female).
gender(sylvia, female).
gender(felicity, female).

% Marital relationships
married(hal, hilary).
married(barry,barbara).
married(sam,sylvia).
married(frank,felicity).
isMarried(X,Y) :- once( married(X,Y) ; married(Y,X) ).

isHost(hal).
isHostess(Hostess) :- isMarried(Host, Hostess)
                    , isHost(Host).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% RULES %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check the across cases
%            1,2,3,4,5,6,7,8
across(X,Y, [X,_,_,_,_,Y,_,_]).
across(X,Y, [_,X,_,_,Y,_,_,_]).
across(X,Y, [_,_,_,X,_,_,Y,_]).
across(X,Y, [_,_,X,_,_,_,_,Y]).
acrossFrom(X,Y, List) :- across(Y,X, List).
acrossFrom(X,Y, List) :- across(X,Y, List).

%Check the next to cases
%          1,2,3,4,5,6,7,8
next(X,Y, [X,_,_,_,_,_,_,Y]).
next(X,Y, [X,Y|_Tail]).
next(X,Y, [_Head|Tail]) :- next(X,Y, Tail).
nextOnRight(X,Y,List) :- next(Y,X,List).
nextTo(X,Y,List) :- once( next(X,Y, List) ; next(Y,X, List) ).

populateGuests(GuestList) :- findall(Name, gender(Name,_), GuestList).

% Create a seating arrangement, not necessarily valid.
seatTable([], _DinnerTable).
seatTable([Name|GuestListTail], DinnerTable) :- member(Name, DinnerTable)
											  , seatTable(GuestListTail, DinnerTable).

seatSchlemielAndSchlimazel(Schlemiel,Schlimazel,[Schlemiel,Schlimazel|_Tail]).

seatHost(_Schlemiel,Schlimazel,DinnerTable) :- isHost(Host)
											 , nextOnRight(Host,Schlimazel,DinnerTable).

seatBarry(_Schlemiel,_Schlimazel,DinnerTable) :- isHostess(Hostess)
											   , nextOnRight(barry,Hostess,DinnerTable).

seatSylvia(Schlimazel,_Schlemiel,DinnerTable) :- married(Schlimazel, Spouse)
											   , nextTo(sylvia,Spouse,DinnerTable).

manAcrossFromWoman(_Schlemiel, _Schlimazel, DinnerTable) :- findall(Man, gender(Man, male), Men)  
														  , seatManAcrossFromWoman(Men, DinnerTable).

seatManAcrossFromWoman([Man], List) :- gender(Woman, female)
									 , acrossFrom(Man, Woman, List).

seatManAcrossFromWoman([Man|Tail], List) :- gender(Woman, female)
										  , acrossFrom(Man, Woman, List)
										  , seatManAcrossFromWoman(Tail, List).

nextToPerson(_Schlemiel,_Schlimazel,DinnerTable) :- findall(Male, gender(Male, male), Men)
												  , seatNextToPerson(Men,DinnerTable).

seatNextToPerson([PrevMan], List) :- gender(Woman, female)
								   , gender(Man, male)
								   , nextTo(PrevMan, Woman, List)
								   , nextTo(PrevMan, Man, List).

seatNextToPerson([PrevMan|Tail], List) :- gender(Woman, female)
										, gender(Man, male)
										, nextTo(PrevMan, Woman, List)
										, nextTo(PrevMan, Man, List)
										, seatNextToPerson(Tail, List).

spouses(_Schlemiel, _Schlimazel, DinnerTable) :- findall(Male, gender(Male,male), Men)
											  , seatSpouses(Men, DinnerTable).

seatSpouses([Man], DinnerTable) :- isMarried(Man, Woman)
								 , acrossFrom(Man, Female, DinnerTable)
								 , Female \== Woman.

seatSpouses([Man|Tail], DinnerTable) :- isMarried(Man, Woman)
									  , acrossFrom(Man, Female, DinnerTable)
									  , Female \== Woman
									  , seatSpouses(Tail, DinnerTable).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
schl(Schlemiel,Schlimazel) :- length(DinnerTable, 8)
							, populateGuests(GuestList)
							, seatTable(GuestList, DinnerTable)
							, seatSchlemielAndSchlimazel(Schlemiel,Schlimazel,DinnerTable)
							, seatHost(Schlemiel,Schlimazel,DinnerTable)
							, seatBarry(Schlemiel,Schlimazel,DinnerTable)
							, seatSylvia(Schlemiel,Schlimazel,DinnerTable)
							, manAcrossFromWoman(Schlemiel,Schlimazel,DinnerTable)
							, nextToPerson(Schlemiel,Schlimazel,DinnerTable)
							, spouses(Schlemiel,Schlimazel,DinnerTable).

