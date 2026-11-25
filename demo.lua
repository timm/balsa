-- balsa out of the box: grow a forest, score it. Run: lua demo.lua
local b    = require "balsa"
local file = arg[1] or "data/diabetes.csv"

local tb = b.Tbl(b.csv(file))                 -- read; label cells -> 1..nk
local at = tb.cols.klass.at
local y  = function(row) return row[at] end   -- a row's label
local f  = b.forest(tb, tb.rows, y)           -- b.k.trees (30) of them

print(string.format("%-22s auc %.2f   (%d rows, train on all, test on all)",
                    file, b.aucs(b.votes(f, tb.rows, y)), #tb.rows))
