% ploptypes: infer a type for each output character: the exact set of values it can take,
% given the set each input position can take (and an interval, the cheaper type that contains
% it). Types let later stages pick the smallest storage, reject impossible outputs, or prove
% two characters never collide.
% Input types are lists of value sets, one per position.
%?- char_type(plus(0, 1), [[1,2], [5]], T).                  % T = [6,7]
%?- types([in(0), shift(1, 9), const(4)], [[0,1], [3,4]], T).  % T = [[0,1], [2,3], [4]]
%?- interval([2,3,9], I).                                      % I = 2-9
:- module(ploptypes, [eval_char/3, run/3, dep/2, char_type/3, types/3, interval/2, possible/3]).
:- use_module(library(lists)).
:- use_module(library(apply)).

% Per-character formulas, as in plop2: in(I), shift(I, D) (+D mod 10), plus(I, J) (mod 10), const(C).
eval_char(in(I), In, C) :- nth0(I, In, C).
eval_char(shift(I, D), In, C) :- nth0(I, In, X), C is (X + D) mod 10.
eval_char(plus(I, J), In, C) :- nth0(I, In, X), nth0(J, In, Y), C is (X + Y) mod 10.
eval_char(const(C), _, C).
run(Fs, In, Out) :- maplist([F, C]>>eval_char(F, In, C), Fs, Out0), Out = Out0.
dep(in(I), [I]).
dep(shift(I, _), [I]).
dep(plus(I, J), D) :- sort([I, J], D).
dep(const(_), []).

char_type(in(I), Ts, S) :- nth0(I, Ts, S0), sort(S0, S).
char_type(shift(I, D), Ts, S) :- nth0(I, Ts, S0), findall(V, ( member(X, S0), V is (X + D) mod 10 ), V0), sort(V0, S).
char_type(plus(I, J), Ts, S) :- nth0(I, Ts, A), nth0(J, Ts, B), findall(V, ( member(X, A), ( I == J -> Y = X ; member(Y, B) ), V is (X + Y) mod 10 ), V0), sort(V0, S).
char_type(const(C), _, [C]).

types(Fs, Ts, T) :- maplist([F, S]>>char_type(F, Ts, S), Fs, T0), T = T0.
interval(S, Lo-Hi) :- S \== [], min_list(S, Lo), max_list(S, Hi).

% possible(+Formulas, +InputTypes, +Output): could the program give Output? (by the types: a quick no)
possible(Fs, Ts, Out) :- types(Fs, Ts, T), maplist([V, S]>>memberchk(V, S), Out, T).
