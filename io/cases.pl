:- module(cases, [title/1, case/3]).
:- use_module('../prolog/ploptypes').
:- use_module(engine).
title('ploptypes').
f_g(N, F) :- Top is N - 1, rnd_int(0, Top, I), rnd_int(0, Top, J), rnd_int(1, 9, D), rnd_pick([in(I), shift(I, D), plus(I, J), const(D)], F).
prog_g(N, Fs) :- rnd_int(1, 5, M), length(Fs, M), maplist(f_g(N), Fs).
str_g(N, S) :- length(S, N), maplist([X]>>rnd_int(0, 9, X), S).
itype_g(S) :- rnd_int(1, 4, K), length(S0, K), maplist([X]>>rnd_int(0, 9, X), S0), sort(S0, S).
case(types, [Fs, Ts], types) :- rnd_int(1, 4, N), prog_g(N, Fs), length(Ts, N), maplist(itype_g, Ts).
case(interval, [S], interval) :- itype_g(S).
case(possible, [Fs, Ts, Out], possible_bool) :- rnd_int(1, 3, N), prog_g(N, Fs), length(Ts, N), maplist(itype_g, Ts), length(Fs, L), str_g(L, Out).
possible_bool(Fs, Ts, Out, B) :- ( possible(Fs, Ts, Out) -> B = true ; B = false ).
