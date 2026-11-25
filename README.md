# balsa : an ultra-lightweight tree builder

Balsa's claim to fame is strength-to-weight, not strength. Same here:
247 lines of [yue](https://yuescript.org) that stay within two AUC
points of LightGBM's 36,328 lines of C++ over 98 classification sets,
and win outright on the 61 software-engineering ones. In the box:
csv reading, equal-frequency bins, deep random forests that cut on
bin numbers, tie-aware AUC, and a seeded Park-Miller random so one
seed gives one model on any Lua, anywhere.

The code, pretty-printed three-up: [docs/index.html][docs]. The rock
ships two files: `balsa.lua` (what Lua loads) and `balsa.yue` (what a
person edits; `balsa.lua` is GENERATED from it).

[docs]: https://timm.github.io/balsa/

## Quick start

    git clone https://github.com/timm/balsa && cd balsa
    make test      # 4 checks: does this work here?
    make demo      # grow a forest on the bundled data, print its auc

Both also run without make: `lua test.lua`, `lua demo.lua`. The two
csvs in `data/` come from [moot](https://github.com/timm/moot) (too
big to clone just to kick the tyres).

## Install

Each step only if the one before is missing:

1. **a Lua.** Best: `brew install luajit` (or `apt install luajit`).
   Plain `lua` 5.1+ works too, slower.
2. **luarocks** (optional, only for the one-line install):
   `brew install luarocks` / `apt install luarocks`.
3. **balsa:** `luarocks install balsa` -- or skip luarocks and copy
   `balsa.lua` anywhere on your `LUA_PATH`. No dependencies.
4. **yue** (optional, only to hack the source):
   `luarocks install yuescript` (needs cmake).
5. **data:** `git clone https://github.com/timm/moot ~/gits/moot`
   -- 100+ classification csvs in the format below.

## Input format

One csv, first row names the columns. The names are the schema:

| name looks like | meaning |
|---|---|
| starts uppercase (`Age`)  | numeric column |
| starts lowercase (`sex`)  | symbolic column |
| ends in `!` (`class!`)    | the class to predict |
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

```lua
local b  = require "balsa"
local tb = b.Tbl(b.csv("~/gits/moot/classify/diabetes.csv"))
local at = tb.cols.klass.at
local y  = function(row) return row.labels[at] end -- its class label
local f  = b.forest(tb, tb.rows, y)                -- 30 trees
print(b.aucs(b.votes(f, tb.rows, y)))              -- 0..100
```

Note every cell is labeled at load: `row.labels[col.at]` holds a
small int `1..n` (`?` becomes `-1`), and each column's legend maps
back (`tb.cols.klass.labels[i]` = the i-th class's name). That is
why one seed gives one answer on any Lua.

Knobs sit in `b.the` (defaults in parentheses): `trees` (30),
`bins` (16), `cap` (200 rows per class), `leaf` (2), `maxd` (30),
`rf` (true: sqrt(|x|) columns per cut), `seed`, and for the rig's
stats, `prudence` (0.01: mean gaps smaller than this are never
called different). Set before `Tbl`/`forest`.

Exports: `the srand rand shuffle bisect csv Tbl adds div tree leaf_of
forest votes auc aucs`.

## Output format

The experiment rigs (in balsa-dev, not this rock) print one line per
cross-validation fold:

    data|auc1 auc2 ..|secs1 secs2 ..|test row ids

one auc and seconds per learner, and the 0-based csv row numbers of
that fold's test set -- so any other tool can replay the exact same
folds. That replay is how LightGBM and TabICL were scored against
balsa on identical splits.

## Hack

Edit `balsa.yue`, then `yue -c -s balsa.yue`, and commit both files.
Everything else -- experiment rigs, the Lisp twin, LightGBM/TabICL
hooks, all scores, charts, and the Makefile that regenerates this
repo's `docs/` -- lives in
[balsa-dev](https://github.com/timm/balsa-dev); there, `make package`
rebuilds and refreshes this repo.

(c) 2026 Tim Menzies <timm@ieee.org>, MIT license.
