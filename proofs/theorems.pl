% Theorems, proved by exhaustion. Run: swipl -g main -t halt proofs/theorems.pl
:- module(theorems, [main/0]).
:- use_module(prove).
:- discontiguous theorem/1.
:- use_module(library(lists)).
:- use_module(library(apply)).
main :- prove_all(theorems).
:- use_module('../prolog/ploptypes').

% Domain: every formula over two positions; every pair of input types that are non-empty subsets of 0..3.
formula(F) :- member(F, [in(0), in(1), shift(0, 3), shift(1, 9), plus(0, 1), plus(1, 1), const(5)]).
subset_of([], []).
subset_of([X|Xs], [X|Ys]) :- subset_of(Xs, Ys).
subset_of([_|Xs], Ys) :- subset_of(Xs, Ys).
itype(S) :- subset_of([0, 1, 2, 3], S), S \== [].
types2([A, B]) :- itype(A), itype(B).
inputs([A, B], [X, Y]) :- member(X, A), member(Y, B).

% 1. Sound: every value the character really takes on typed inputs is in its type.
theorem(types_are_sound) :- forall(( formula(F), types2(Ts), inputs(Ts, In) ), ( eval_char(F, In, V), char_type(F, Ts, S), memberchk(V, S) )).

% 2. Exact: every value in the type is really taken by some typed input.
theorem(types_are_exact) :- forall(( formula(F), types2(Ts), char_type(F, Ts, S), member(V, S) ), once(( inputs(Ts, In), eval_char(F, In, V) ))).

% 3. The interval contains the set.
theorem(interval_contains_set) :- forall(( formula(F), types2(Ts), char_type(F, Ts, S) ), ( interval(S, Lo-Hi), forall(member(V, S), ( V >= Lo, V =< Hi )) )).

% 4. possible is never wrong to say no: an output it rules out is never produced.
theorem(impossible_is_never_produced) :- forall(( formula(F), formula(G), types2(Ts), inputs(Ts, In) ), ( run([F, G], In, Out), possible([F, G], Ts, Out) )).
