# balsa : a light wood for tabular learning

Balsa's claim to fame is strength-to-weight, not strength. So is this
learner's: 218 lines of [yue](https://yuescript.org) that stay within
two AUC points of LightGBM's 36,328 lines of C++ over 98 data sets,
and win outright on the 61 software-engineering ones.

What is in the box: csv reading (moot header conventions: uppercase =
numeric, trailing `!` = class, trailing `X` = skip), equal-frequency
discretization, deep random forests that cut on bin numbers, a
tie-aware AUC, and a seeded Park-Miller random so the same seed gives
the same model in Lua, Lisp or Python.

## Install

    luarocks install balsa

or just copy `balsa.lua` somewhere on your `LUA_PATH`; it has no
dependencies.

## Use

```lua
local b  = require "balsa"
local tb = b.Tbl(b.csv("data.csv"))
local at = tb.cols.klass.at
local y  = function(row) return row[at] end
local f  = b.forest(tb, tb.rows, y)
print(b.aucs(b.votes(f, tb.rows, y)))
```

## Hack

`balsa.lua` is GENERATED from `balsa.yue`; edit the `.yue`, then

    yue -c -s balsa.yue

Experiments, rigs, stats, the Lisp twin and all the results live next
door in [balsa-dev](https://github.com/timm/balsa-dev). This repo is
only what the rock ships.

(c) 2026 Tim Menzies <timm@ieee.org>, MIT license.
