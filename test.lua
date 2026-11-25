-- smoke test for an install. Run: lua test.lua
local b  = require "balsa"
local bad = 0

local function auc(file)
  b.srand(b.k.seed)                 -- rewind: one rng stream per process
  local tb = b.Tbl(b.csv(file))
  local at = tb.cols.klass.at
  local y  = function(row) return row[at] end
  return b.aucs(b.votes(b.forest(tb, tb.rows, y), tb.rows, y))
end

local function ok(msg, cond)
  print((cond and "PASS  " or "FAIL  ") .. msg)
  bad = bad + (cond and 0 or 1)
end

local a1 = auc("data/diabetes.csv")
local a2 = auc("data/diabetes.csv")
ok("the rock loads and scores", a1 > 50)
ok("one seed, one model",       a1 == a2)
ok("auc 91.84 on diabetes",     math.abs(a1 - 91.84) < 0.01)
ok("the 14-row set works too",  auc("data/weather.csv") > 50)
os.exit(bad == 0 and 0 or 1)
