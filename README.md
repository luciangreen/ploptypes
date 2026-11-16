# ploptypes

infer a type for each output character: the exact set of values it can take, given the set each input position can take (and an interval, the cheaper type that contains it). Types let later stages pick the smallest storage, reject impossible outputs, or prove two characters never collide. Input types are lists of value sets, one per position.

## Use

```prolog
?- use_module(prolog/ploptypes).
?- char_type(plus(0, 1), [[1,2], [5]], T).                  % T = [6,7]
?- types([in(0), shift(1, 9), const(4)], [[0,1], [3,4]], T).  % T = [[0,1], [2,3], [4]]
?- interval([2,3,9], I).                                      % I = 2-9
```

## Proofs

`proofs/theorems.pl` proves 4 theorems by exhaustion: each one is checked for every case in a finite domain that covers every branch of the definitions. every formula over two positions; every pair of input types that are non-empty subsets of 0..3.

1. Sound: every value the character really takes on typed inputs is in its type.
2. Exact: every value in the type is really taken by some typed input.
3. The interval contains the set.
4. possible is never wrong to say no: an output it rules out is never produced.

```sh
swipl -g main -t halt proofs/theorems.pl
```

## 200 inputs and outputs

`io/ios.txt` lists 200 inputs and outputs from real runs, and `io/ios.pl` has the same as Prolog facts. The inputs come from a fixed seed (`io/cases.pl`). `swipl -g check -t halt io/run.pl` runs them again. It fails if any output changes, or if a predicate doesn't confirm its own recorded output, which checks steadfastness. GitHub Actions runs the proofs and the examples on every push, and records the examples on the first push.

Licence: BSD-3-Clause.
