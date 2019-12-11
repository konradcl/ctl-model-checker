:- (discontiguous check/5).

verify(Input) :- 
   see(Input), read(Transitions), read(Labeling),
   read(State), read(Formula), seen,
   check(Transitions, Labeling, State, [], Formula).

% Recurses through Labeling to find the Formulas of State.
get_state_formulas(Labeling, State, Formulas) :-
   member([State, Formulas], Labeling).

% Recurses through Transitions to find the adjacent states to State. 
% AdjacentStates may include State itself.
get_adjacent_states(Transitions, State, AdjacentStates) :-
   member([State, AdjacentStates], Transitions).

% FORMULA
check(_, Labeling, State, [], Formula) :-
   get_state_formulas(Labeling, State, Formulas),
   member(Formula, Formulas).
	
% NEGATION
check(_, Labeling, State, [], neg(Formula)) :-
   get_state_formulas(Labeling, State, Formulas),
   \+ member(Formula, Formulas).
	
% AND
check(Transitions, Labeling, State, [], and(X, Y)) :-
   check(Transitions, Labeling, State, [], X),
   check(Transitions, Labeling, State, [], Y).

% OR 1
check(Transitions, Labeling, State, [], or(X, _)) :-
   check(Transitions, Labeling, State, [], X).

% OR 2
check(Transitions, Labeling, State, [], or(_, Y)) :-
   check(Transitions, Labeling, State, [], Y).

% Checks that all states, i.e. [State|States], satisfy Formula.
check_all(_, _, [], _, _).
check_all(Transitions, Labeling, [State|States], PastStates, X) :-
   check(Transitions, Labeling, State, PastStates, X),
   check_all(Transitions, Labeling, States, PastStates, X).

% AX
check(Transitions, Labeling, State, [], ax(X)) :-
   get_adjacent_states(Transitions, State, AdjacentStates),
   check_all(Transitions, Labeling, AdjacentStates, [], X).

% AG1 and AG2
check(_, _, State, PastStates, ag(_)) :-
   member(State, PastStates).

check(Transitions, Labeling, State, PastStates, ag(X)) :-
   \+ member(State, PastStates),
   get_adjacent_states(Transitions, State, AdjacentStates),
   check(Transitions, Labeling, State, [], X),
   check_all(Transitions, Labeling, AdjacentStates,
      [State|PastStates], ag(X)).

% AF1 and AF2
check(Transitions, Labeling, State, PastStates, af(X)) :-
   \+ member(State, PastStates),
   check(Transitions, Labeling, State, [], X).

check(Transitions, Labeling, State, PastStates, af(X)) :-
   \+ member(State, PastStates),
   get_adjacent_states(Transitions, State, AdjacentStates),
   check_all(Transitions, Labeling, AdjacentStates,
      [State|PastStates], af(X)).

% Checks if there exists a state in [State|States] where Formula 
% is satsified.
find_state(Transitions, Labeling, [State|States], PastStates, X) :-
   check(Transitions, Labeling, State, PastStates, X);
   find_state(Transitions, Labeling, States, PastStates, X).

% EX
check(Transitions, Labeling, State, [], ex(X)) :-
   get_adjacent_states(Transitions, State, AdjacentStates),
   find_state(Transitions, Labeling, AdjacentStates, [], X).

% EG1 and EG2
check(_, _, State, PastStates, eg(_)) :-
   member(State, PastStates).

check(Transitions, Labeling, State, PastStates, eg(X)) :-
   \+ member(State, PastStates),
   check(Transitions, Labeling, State, [], X),
   get_adjacent_states(Transitions, State, AdjacentStates),
   find_state(Transitions, Labeling, AdjacentStates, 
      [State|PastStates], eg(X)).
	
% EF1 and EF2
check(Transitions, Labeling, State, PastStates, ef(X)) :-
   \+ member(State, PastStates),
   check(Transitions, Labeling, State, [], X).

check(Transitions, Labeling, State, PastStates, ef(X)) :-
   \+ member(State, PastStates),
   get_adjacent_states(Transitions, State, AdjacentStates),
   find_state(Transitions, Labeling, AdjacentStates, 
      [State|PastStates], ef(X)).

