"""enuf out of the box: grow a forest, score it.
Run: pypy3 demo.py [file.csv]"""
import sys, enuf as b

file = sys.argv[1] if len(sys.argv) > 1 else "data/diabetes.csv"
tb = b.Tbl(b.csv(file))                       # read; label cells -> 0..nk-1
at = tb.cols.klass.at
y  = lambda row: row.labels[at]               # a row's label
f  = b.Forest(tb, tb.rows, y)                 # b.the.trees (30) of them
print("%-22s auc %.2f   (%d rows, train on all, test on all)"
      % (file, b.aucs(f.votes(tb.rows, y)), len(tb.rows)))
