# enuf : trees that are good enough

Small enough, fast enough, close enough. Here, enough means
262 lines of Python that stay within two AUC points of LightGBM's
36,328 lines of C++ over 98 classification sets, win outright on the
61 software-engineering ones, and also do regression (MAE within a
point of LightGBM) and optimization (rank, label 5, keep the best).
In the box: csv reading, equal-frequency bins, deep random forests
that cut on small-integer labels, tie-aware AUC, distance-to-heaven
over many goals, and a seeded Park-Miller random so one seed gives
one answer on any interpreter.

The code, pretty-printed three-up: [docs/index.html][docs]. One file:
`enuf.py`. No dependencies. Run it with pypy3 for speed (the big
corpus runs use it), or any Python 3.11+.

[docs]: https://timm.github.io/enuf/

## Install

1. **a Python.** Best: `brew install pypy3` (or `apt install pypy3`).
   Plain CPython 3.11+ works too, slower.
2. **enuf:** copy `enuf.py` next to your code -- that is the whole
   install -- or `pip install -e .` from this repo for a module on
   your path.
3. **data:** `git clone https://github.com/timm/moot ~/gits/moot`
   -- hundreds of csvs in the format below.

## Input format

One csv, first row names the columns. The names are the schema:

| name looks like | meaning |
|---|---|
| starts uppercase (`Age`)  | numeric column |
| starts lowercase (`sex`)  | symbolic column |
| ends in `!` (`class!`)    | the class to predict |
| ends in `+` / `-`         | a goal to maximize / minimize |
| ends in `X` (`idX`)       | ignored |
| cell holds `?`            | unknown value |

E.g. `moot/classify/weather.csv` -- `Temp`, `Humid` numeric;
`outlook`, `windy` symbolic; `play!` the (symbolic) class
(cells may be padded for alignment; whitespace is trimmed):

```csv
outlook,  Temp, Humid, windy, play!
sunny,      85,    85, FALSE, no
sunny,      80,    90, TRUE,  no
overcast,   83,    86, FALSE, yes
rainy,      70,    96, FALSE, yes
```

## Use

```python
import enuf as b
tb = b.Tbl(b.csv("~/gits/moot/classify/diabetes.csv"))
at = tb.cols.klass.at
y  = lambda row: row.labels[at]              # its class label
f  = b.Forest(tb, tb.rows, y)                # 30 trees
print(b.aucs(f.votes(tb.rows, y)))           # 0..100
```

Regression: pass the Num summary and read `predict` --
`f = b.Forest(tb, tb.rows, y, b.Col); f.predict(row)`.
Optimization: `tb.disty(row)` is a row's distance to heaven over
the `+`/`-` goals; regress on that, sort by the prediction.

Note every cell is labeled at load: `row.labels[col.at]` holds a
small int `0..n-1` (`?` becomes `-1`), and each column's legend maps
back (`tb.cols.klass.labels[i]` = label i's name). That is why one
seed gives one answer anywhere.

Knobs sit in `b.the` (defaults in parentheses): `trees` (30),
`bins` (16), `cap` (200 rows per class), `leaf` (2), `maxd` (30),
`rf` (True: sqrt(|x|) columns per cut for classification, |x|/3 for
regression), `seed`, and for the rig's stats `prudence` (0.01: mean
gaps smaller than this are never called different).

## Output format

The experiment rigs (in enuf-dev, not this repo) print one line per
cross-validation fold:

    data|scores|secs|test row ids

one score and seconds per learner, and the 0-based csv row numbers of
that fold's test set -- so any other tool can replay the exact same
folds. That replay is how LightGBM and TabICL were scored against
enuf on identical splits.

## Hack

Edit `enuf.py`; there is no build step. Everything else --
experiment rigs, the Lisp twin, the retired Lua/Yue line (it lives
in the attic), LightGBM/TabICL hooks, all scores, charts, and the
Makefile that regenerates this repo's `docs/` -- is in
[enuf-dev](https://github.com/timm/enuf-dev); there, `make
package` refreshes this repo.

(c) 2026 Tim Menzies <timm@ieee.org>, MIT license.
