"""smoke test for an install. Run: pypy3 test.py (exit 1 on any FAIL)"""
import sys, enuf as b
bad = 0

def auc(file):
  b.srand(b.the.seed)               # rewind: one rng stream per process
  tb = b.Tbl(b.csv(file))
  at = tb.cols.klass.at
  y  = lambda row: row.labels[at]
  return b.aucs(b.Forest(tb, tb.rows, y).votes(tb.rows, y))

def ok(msg, cond):
  global bad
  print(("PASS  " if cond else "FAIL  ") + msg)
  bad += not cond

a1, a2 = auc("data/diabetes.csv"), auc("data/diabetes.csv")
ok("enuf loads and scores",   a1 > 50)
ok("one seed, one model",      a1 == a2)
ok("auc 93.49 on diabetes",    abs(a1 - 93.49) < 0.01)
ok("the 14-row set works too", auc("data/weather.csv") > 50)
sys.exit(bad > 0)
