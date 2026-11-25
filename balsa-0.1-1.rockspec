package = "balsa"
version = "0.1-1"
source = {
  url = "git+https://github.com/timm/balsa",
  tag = "v0.1"
}
description = {
  summary  = "An ultra-lightweight tree builder",
  detailed = [[
    218 lines of yue (a whitespace Lua dialect): csv, equal-frequency
    bins, deep random forests and AUC, within two points of LightGBM
    at 1% of the code. The compiled balsa.lua is checked in, so the
    rock needs only Lua; edit balsa.yue and rebuild if hacking.]],
  homepage = "https://github.com/timm/balsa",
  license  = "MIT"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = { balsa = "balsa.lua" }
}
