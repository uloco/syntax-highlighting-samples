library(highr)
hilight("x=1 # assignment")

txt = c("a <- 1 # something", "c(y=\"world\", z=\"hello\")", "b=function(x=5) {", 
    "for(i in 1:10) {\n  if (i < x) print(i) else break}}", "z@child # S4 slot", 
    "'special chars <>#$%&_{}'")
cat(hi_latex(txt), sep = "\n")
cat(hi_html(txt), sep = "\n")

# the markup data frames
highr:::cmd_latex
highr:::cmd_html
