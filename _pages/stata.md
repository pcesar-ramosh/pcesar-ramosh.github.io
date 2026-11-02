---
layout: page
permalink: /teaching/stata/
title: Stata Guide
description: The Stata commands I use in applied econometrics, each with a short description and an example you can copy and run.
nav: false
toc:
  sidebar: left
tabs: true
---

This guide collects the Stata commands I use most, from opening data to publication-ready tables. It follows the modules of the [Williams College ECON Stata Tutorial](https://pjakiela.github.io/stata/) by Pamela Jakiela and Owen Ozier, and adds the commands from my econometrics practice at the Center for Development Economics (simulation, OLS and inference by hand, hypothesis tests, graphs and tables) and from my work with household surveys.

Most examples use data that anyone can load: Stata's built-in datasets (`sysuse`, `webuse`) and the public example files of the Williams tutorial. Every code block has a copy button. Commands marked **(SSC)** are user-written: install them once with `ssc install name`.

## Getting around Stata

### Help and search

| Command | What it does |
| --- | --- |
| `help command` | Opens the help file: syntax, options, examples and stored results |
| `search keyword` | Searches the documentation and user-written packages |
| `help math_functions`, `help statistical_functions` | Lists of mathematical and statistical functions |
| `help subscripting`, `help in`, `help system variables` | How to refer to specific observations and to `_n`, `_N` |

```stata
help summarize
help twoway
help scheme
help statistical_functions
search lorenz
```

### Abbreviations

Commands and variable names can be shortened as long as the abbreviation is unique. Abbreviations save typing in the Command window; in do-files that others will read, full names are clearer.

```stata
display 7 - 4
dis 7 - 4
di 7 - 4            // all three are display
* d 7 - 4           // fails: d is short for describe

sysuse auto, clear
sum price           // summarize
tab foreign         // tabulate
reg price mpg       // regress
* tab t             // fails: ambiguous (trunk, turn)
```

### Keyboard shortcuts and comments

| Shortcut | Windows | Mac |
| --- | --- | --- |
| Previous / next command in the Command window | Page Up / Page Down | Ctrl-R / Ctrl-B |
| Run the do-file (or the selected lines) | Ctrl-D | Command-Shift-D |
| Indent / unindent selected lines in the Do-file Editor | Tab / Shift-Tab | Tab / Shift-Tab |

```stata
sysuse auto, clear
* A line that starts with an asterisk is a comment
// So is everything after two slashes
/* A block comment
   can span several lines */
regress price mpg weight ///
    foreign             // three slashes continue a command on the next line
```

## The top of a do-file

| Command | What it does |
| --- | --- |
| `clear all` | Removes data, macros, programs and stored results from memory |
| `set more off` | Lets long output scroll without pausing |
| `cls` | Clears the Results window |
| `capture log close` | Closes an open log; `capture` ignores the error if there is none |
| `log using file, text replace` | Records all output in a text file |
| `cd "folder"` | Sets the working folder, where Stata reads and saves files |
| `set seed #` | Makes random draws reproducible |
| `set scheme s1mono` | White-background graphs for the whole session |
| `set maxvar #` | Allows more variables (needed for large surveys such as DHS) |
| `version #` | Runs the code as that Stata version |

```stata
// Purpose: replicate Table 1 of my problem set
version 17
clear all
set more off
cls
capture log close
cd "C:/Users/me/project"
log using "results.txt", text replace
set seed 12345
set scheme s1mono

* ... analysis ...

log close
```

A seed only matters when the code draws random numbers. Without `set seed`, the code below gives different numbers each time it runs; with it, the numbers are always the same.

```stata
clear all
set obs 10
set seed 1793
generate u = runiform()
list
summarize u
```

## Opening and importing data

| Command | What it does |
| --- | --- |
| `sysuse name` | Opens an example dataset installed with Stata |
| `use file` | Opens a Stata dataset (.dta) from a folder or a web address |
| `webuse name` | Opens an example dataset from the web |
| `webuse set url` | Makes `webuse` read from another website; `webuse set` alone resets it |
| `import delimited` | Reads CSV and other text files (`stringcols()`, `numericcols()` force a type) |
| `import excel` | Reads Excel files (`sheet()`, `firstrow`, `allstring`) |

```stata
sysuse auto, clear
use "C:/Users/me/project/data/mpd2020.dta", clear
cd "C:/Users/me/project/data"
use mpd2020.dta, clear

* Data from the web
webuse set https://pjakiela.github.io/stata
webuse mpd2020.dta, clear
webuse set                       // back to Stata's default example site

* Text and Excel files
import delimited "nzEmploymentData.csv", clear
import delimited "nzEmploymentData.csv", stringcols(2) clear
import excel "airline.xls", sheet("Sheet1") firstrow clear
import excel "airline.xls", sheet("Sheet1") firstrow allstring clear
```

## Exploring a dataset

| Command | What it does |
| --- | --- |
| `browse` | Opens the data in a spreadsheet view |
| `count` | Number of observations (with `if`, those that meet a condition) |
| `describe` | Variables, storage types and labels (`fullnames` shows long names) |
| `codebook` | Range, missing values and labels of a variable |
| `label list` | Shows the value labels (what each code means) |
| `tabulate` | Frequency tables; with two variables, `col` and `row` add percentages |
| `list` | Prints observations, optionally with `in` or `if` |
| `summarize` | Mean, SD, min and max; `detail` adds percentiles, skewness and kurtosis |

```stata
sysuse auto, clear
browse
count
describe
describe price mpg
describe, fullnames
codebook foreign
label list origin
tabulate foreign
tabulate rep78 foreign, col
list make price in 1/5
list make price if price > 12000
summarize price mpg
summarize price, detail

* Missing values
count if missing(rep78)
count if rep78 == .
```

Wildcards apply a command to every variable that starts the same way:

```stata
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta, clear
webuse set
describe b_*
summarize b_*
tab coartemprice
tab c_act act_any, col
```

## Sorting, types and labels

| Command | What it does |
| --- | --- |
| `sort var` | Sorts in ascending order (alphabetical for text) |
| `gsort -var` | Sorts in descending order |
| `tostring`, `destring` | Converts numbers to text and text to numbers |
| `rename` | Renames a variable |
| `label variable` | Adds a description, used in tables and graphs |
| `label define`, `label values` | Attaches words to numeric codes |

```stata
webuse set https://pjakiela.github.io/stata
webuse mpd2020.dta, clear
webuse set
sort pop
drop if pop == .
gsort -pop
tostring year, replace
destring year, replace

sysuse auto, clear
rename rep78 repair_record
label variable price "Price (US dollars)"
label define yesno 0 "No" 1 "Yes"
generate expensive = price >= 9000
label values expensive yesno
tab expensive
```

## Creating variables

### Dummy variables

Three ways to create the same indicator. Comparisons inside a condition use `==`; a single `=` assigns a value.

```stata
sysuse auto, clear

* 1. Start at zero, then replace
generate expensive = 0
replace expensive = 1 if price >= 9000

* 2. A true/false expression is 1 or 0
drop expensive
generate expensive = price >= 9000

* 3. cond(condition, value if true, value if false)
drop expensive
generate expensive = cond(price >= 9000, 1, 0)

* Keep missing values missing (otherwise . counts as a very large number)
drop expensive
generate expensive = cond(price >= 9000, 1, 0) if !missing(price)
```

### More ways to build variables

| Command | What it does |
| --- | --- |
| `generate`, `replace` | Create a variable; change some of its values |
| `generate x = .` | Creates an empty (missing) variable |
| `egen` | Group and row functions: `mean()`, `rank()`, `rowtotal()` |
| `bysort group:` | Repeats a command within each group |
| `recode` | Regroups values, optionally into a new variable |
| `string(x, "%5.3f")` | Turns a number into formatted text |

```stata
sysuse auto, clear
generate ln_price = ln(price)
generate price_k = round(price/1000, 0.1)
generate insurance = .
replace insurance = 2500 if _n > 25

egen mean_price = mean(price), by(foreign)
bysort foreign: egen price_rank = rank(price)
egen cargo_space = rowtotal(headroom trunk)         // sum across variables
recode rep78 (1/2 = 1 "Poor") (3 = 2 "Average") (4/5 = 3 "Good"), generate(rep_cat)
generate obs_from_end = _N - _n
```

## Conditions, observations and logical operators

```text
==   equal to              !=   not equal to
>    greater than          >=   greater than or equal to
<    less than             <=   less than or equal to
&    and                   |    or                   !    not
```

| Tool | What it does |
| --- | --- |
| `if condition` | Applies a command only to observations that meet the condition |
| `in 1/5` | Applies a command to observations 1 to 5 |
| `var[#]` | The value of a variable in observation # (subscripting) |
| `_n`, `_N` | The current observation number and the number of observations |

```stata
sysuse auto, clear
count if weight < 3000 & price > 6000
list make if weight < 3000 & price > 6000
count if weight > 4000 | mpg < 15
list make weight mpg if weight > 4000 | mpg < 15

list in 1/5
list price in 6
summarize price in 6
display price[2]
display make[10]
```

## Math and probability functions

| Function | What it does |
| --- | --- |
| `floor()`, `ceil()`, `round(x, 0.01)` | Round down, round up, round to a chosen unit |
| `ln()` or `log()`, `exp()`, `sqrt()`, `abs()`, `^` | Natural log, exponential, square root, absolute value, power |
| `normal(z)` | Standard normal CDF: probability below z |
| `invnormal(p)` | Normal critical value, e.g. `invnormal(0.975)` = 1.96 |
| `normalden(z)` | Standard normal density |
| `ttail(df, t)`, `invttail(df, p)` | Upper-tail probability of the t distribution and its inverse |
| `invt(df, p)`, `tden(df, t)` | t quantile and t density |

```stata
display floor(4.999)
display ceil(4.0001)
display round(4.5)
display round(3.14159, 0.01)
display ln(5)
display exp(5)
display sqrt(64)
display 1^3 + 2^3 + 3^3 + 4^3

* Probabilities and critical values
display normal(1.96) - normal(-1.96)            // about 0.95
display invnormal(0.975)                        // 1.96
display 2*(1 - normal(345/154))                 // two-sided p-value of an estimate of 345 with SE 154
display 2*ttail(30, abs(2.1))                   // same idea with a t distribution, 30 df
display invttail(30, 0.025)                     // t critical value, 95%, 30 df
```

## Simulating data

| Command | What it does |
| --- | --- |
| `set obs #` | Creates an empty dataset with # observations |
| `runiform()` | Uniform draws between 0 and 1 |
| `rnormal()` | Standard normal draws (`rnormal()*3` has SD 3) |
| `cond(runiform() < p, 1, 0)` | Bernoulli draws with probability p |

```stata
* A small designed dataset
clear all
set obs 10
generate y = cond(_n <= 6, 1, 0)
generate x = cond(_n <= 3, 1, 0)
generate z = cond(_n >= 8, 1, 0)
regress y x z

* Known data-generating process: y = 5 + 4x + u
clear all
set seed 1793
set obs 800
generate x = rnormal()*3
generate u = rnormal()*16
generate y = 5 + 4*x + u
regress y x
twoway (scatter y x, msize(tiny) mcolor(gs12)) (lfit y x, lcolor(blue)), legend(off)

* Rescaling x: the slope halves and the intercept does not change
generate w = 2*x
regress y w

* Bernoulli draws, standardized
local p = 0.6
generate b = cond(runiform() < `p', 1, 0)
generate b_std = (b - `p')/sqrt(`p'*(1 - `p'))
summarize b b_std
```

{% details Checking the Central Limit Theorem and the 68-95 rule by simulation %}

```stata
clear all
set obs 10000
set seed 654321
generate z = rnormal()
histogram z
count if abs(z) < 1             // about 68 percent
count if abs(z) > 1.645         // about 10 percent

generate u = runiform()
histogram u, fcolor(midblue)
summarize u
display sqrt(1/12)              // theoretical SD of a uniform(0,1)
```

{% enddetails %}

## Dropping and keeping data

| Command | What it does |
| --- | --- |
| `drop if`, `keep if` | Removes or keeps observations |
| `drop var`, `keep var` | Removes or keeps variables |
| `preserve`, `restore` | Saves a copy of the data and returns to it later |

```stata
sysuse auto, clear
preserve
    drop if price < 5000
    keep if price < 10000
    summarize price
restore
summarize price                 // the full data are back

drop if missing(rep78)
keep make price mpg foreign
```

## Macros and scalars

| Tool | What it does |
| --- | --- |
| `local name ...` | Stores text or a number while the do-file runs; use it as `` `name' `` |
| `global name ...` | Stores text or a number for the whole session; use it as `$name` |
| `scalar name = exp` | Stores one number; use it by its name |
| `display` | Prints text, numbers and results; `%9.2f` sets the format |

```stata
sysuse auto, clear

* A list of control variables
local controls mpg rep78 headroom trunk weight length turn displacement
regress price `controls'
global controls mpg rep78 headroom trunk weight length turn displacement
regress price $controls

* Text and numbers
local greeting "Hello"
global year 2026
display "`greeting'"
display $year - 2000

* Results in macros, used in a graph title
quietly summarize price
local mean_price = round(r(mean))
twoway scatter mpg price, xline(`mean_price') title("Mean price: about `mean_price' dollars")

* Scalars and formats
quietly summarize mpg
scalar mean_mpg = r(mean)
display "Mean mpg = " %5.2f mean_mpg
```

## Stored results

After most commands Stata saves results: `r()` for descriptive commands such as `summarize`, `count`, `correlate` and `ttest`, and `e()` for estimation commands such as `regress`. They are overwritten by the next command, so save the ones you need in a macro or scalar.

| Result | Where it comes from |
| --- | --- |
| `r(N)`, `r(mean)`, `r(sd)`, `r(Var)`, `r(min)`, `r(max)`, `r(sum)` | `summarize` (`count` saves `r(N)`) |
| `r(p50)`, `r(p95)` and other percentiles | `summarize, detail` |
| `r(cov_12)`, `r(C)` | `correlate x y, covariance` |
| `r(p)`, `r(t)`, `r(se)` | `ttest` |
| `e(N)`, `e(r2)`, `e(rmse)`, `e(df_r)`, `e(rss)`, `e(mss)`, `e(cmdline)` | `regress` |
| `_b[x]`, `_se[x]`, `_b[_cons]` | Coefficients and standard errors after an estimation |
| `r(table)`, `e(b)`, `e(V)` | Matrices with all coefficient statistics |

```stata
sysuse auto, clear
summarize price
return list
generate price_centered = price - r(mean)
generate price_std = (price - r(mean))/r(sd)
display "Distance from max to min: " r(max) - r(min)

count if price > 10000 & weight > 3000
local n_heavy = r(N)
count
display "Share of expensive heavy cars: " `n_heavy'/r(N)

regress price mpg
ereturn list
display _b[mpg]
display _se[mpg]
display _b[_cons]
display "R-squared: " e(r2)
display "Command: " e(cmdline)
matrix list r(table)

quietly correlate price mpg, covariance
matrix C = r(C)
display "cov = " r(cov_12) "   var(price) = " C[1,1]
```

## Loops and conditions

| Command | What it does |
| --- | --- |
| `forvalues i = 1/3 { }` | Repeats commands for consecutive numbers |
| `foreach v of varlist ... { }` | Repeats commands for each variable in a list |
| `if condition { }` | Runs commands only when a condition holds (programming `if`) |
| `capture` | Runs a command and continues even if it fails |

```stata
sysuse auto, clear

* Powers of mpg
forvalues i = 1/3 {
    generate mpg`i' = mpg^`i'
}

* One flag for several variables
generate large = 0
foreach v of varlist headroom trunk weight length {
    replace large = 1 if `v' >= 3000
}

* One regression per variable, with its stored results
foreach v of varlist mpg headroom trunk {
    quietly regress price `v'
    display "Command: " e(cmdline) "   coefficient: " _b[`v'] "   SE: " _se[`v']
}

* Loop over groups with numbered locals
forvalues g = 0/1 {
    quietly summarize price if foreign == `g'
    local n`g'  = r(N)
    local m`g'  = r(mean)
    local sd`g' = r(sd)
}
display "Domestic mean: " `m0' "   Foreign mean: " `m1'
```

{% details A Monte Carlo experiment: t versus normal critical values with 5 observations %}

With only 5 observations the sample SD is noisy, so using the normal cutoff (1.96) instead of the t cutoff rejects a true null hypothesis much more often than 5 percent of the time.

```stata
clear all
set seed 98765
local n = 5
local reps = 1000
local zcrit = invnormal(0.975)
local tcrit = invttail(`n' - 1, 0.025)
local reject_z = 0
local reject_t = 0
set obs `n'
forvalues i = 1/`reps' {
    capture drop draw
    quietly generate draw = rnormal()
    quietly summarize draw
    local tstat = r(mean)/(r(sd)/sqrt(`n'))
    if abs(`tstat') > `zcrit' {
        local reject_z = `reject_z' + 1
    }
    if abs(`tstat') > `tcrit' {
        local reject_t = `reject_t' + 1
    }
}
display "Rejection rate, normal cutoff: " `reject_z'/`reps'
display "Rejection rate, t cutoff:      " `reject_t'/`reps'
```

{% enddetails %}

## Descriptive statistics and differences in means

| Command | What it does |
| --- | --- |
| `tabulate a b, col` / `row` | Two-way table with column or row percentages |
| `tabstat` | Chosen statistics, by group (`col(stat)` puts statistics in columns) |
| `correlate`, `pwcorr` | Correlations (`pwcorr` adds significance) |
| `ttest y, by(group)` | Difference in means with its t-test (`unequal` allows different variances) |

```stata
sysuse auto, clear
tabulate rep78 foreign, col
tabstat price mpg weight, by(foreign) statistics(mean sd p50 n)
correlate price mpg weight
pwcorr price mpg weight, sig star(0.05)

* Difference in means by hand
forvalues g = 0/1 {
    quietly summarize price if foreign == `g'
    local n`g'  = r(N)
    local m`g'  = r(mean)
    local sd`g' = r(sd)
}
local diff = `m1' - `m0'
local se   = sqrt(`sd1'^2/`n1' + `sd0'^2/`n0')
local tval = `diff'/`se'
display "Difference: " `diff' "   SE: " `se' "   t: " `tval'
display "p-value (normal): " 2*(1 - normal(abs(`tval')))

* The same test with ttest
ttest price, by(foreign) unequal
display "p-value: " r(p) "   t: " r(t) "   SE: " r(se)
```

## Regression

### OLS, fitted values and robust standard errors

| Command | What it does |
| --- | --- |
| `regress y x` | Ordinary least squares |
| `predict yhat` / `predict e, residuals` | Fitted values / residuals |
| `regress ..., robust` | Heteroskedasticity-robust standard errors (also `vce(cluster id)`) |
| `level(90)` | Reports 90 percent confidence intervals |
| `estat hettest`, `rvfplot` | Breusch-Pagan test and residual-versus-fitted plot |
| `i.var`, `c.var`, `##` | Dummies for categories, continuous variables, interactions |
| `test`, `margins` | Joint tests; predictions and marginal effects |

```stata
sysuse auto, clear
regress price mpg
predict price_hat
predict price_res, residuals
twoway (scatter price mpg) (line price_hat mpg, sort)

regress price mpg weight, robust
regress price mpg weight, robust level(90)
regress price mpg weight
estat hettest
rvfplot

regress price mpg weight i.foreign, vce(robust)
test mpg weight
regress price c.mpg##i.foreign, vce(robust)
margins foreign

* Sensitivity to one observation (for example an outlier country)
regress price mpg if make != "Cad. Seville"
```

### OLS and inference by hand

The slope is cov(x, y)/var(x) and the intercept is mean(y) minus the slope times mean(x). The standard error of the slope is the root MSE divided by the square root of var(x)(N - 1).

```stata
sysuse auto, clear
quietly correlate price mpg, covariance
scalar cov_xy = r(cov_12)
quietly summarize mpg
scalar var_x  = r(Var)
scalar mean_x = r(mean)
quietly summarize price
scalar mean_y = r(mean)
scalar slope     = cov_xy/var_x
scalar intercept = mean_y - slope*mean_x
display "Slope: " slope "   Intercept: " intercept

quietly regress price mpg
display "SE by hand: " e(rmse)/sqrt(var_x*(e(N) - 1)) "   SE from Stata: " _se[mpg]

scalar t_stat = _b[mpg]/_se[mpg]
scalar t_crit = invttail(e(df_r), 0.025)
display "t: " t_stat "   p-value: " 2*ttail(e(df_r), abs(t_stat))
display "95% CI: [" _b[mpg] - t_crit*_se[mpg] ", " _b[mpg] + t_crit*_se[mpg] "]"
display "R-squared by hand: " 1 - e(rss)/(e(rss) + e(mss)) "   from Stata: " e(r2)
display "Prediction at mpg = 25: " _b[_cons] + _b[mpg]*25
```

{% details Heteroskedasticity in simulated data %}

```stata
clear all
set seed 1793
set obs 800
generate x = rnormal()*4
generate u_homo = rnormal()*67
generate u_hetero = rnormal()*67*(1 + abs(x))
generate y_homo = 1 + 4*x + u_homo
generate y_hetero = 1 + 4*x + u_hetero
regress y_hetero x
regress y_hetero x, robust            // same coefficients, larger standard errors
twoway (scatter y_hetero x, msize(tiny)) (lfit y_hetero x), legend(off)
```

{% enddetails %}

### Other models

| Command | What it does |
| --- | --- |
| `logit`, `probit` | Binary-outcome models; `margins, dydx(*)` gives average marginal effects |
| `ivregress 2sls` | Instrumental variables (`first` shows the first stage) |

```stata
sysuse auto, clear
logit foreign price mpg
margins, dydx(*)
probit foreign price mpg

webuse hsng2, clear
ivregress 2sls rent pcturban (hsngval = faminc i.region), first
estat firststage
```

The same regression with robust standard errors in Stata, R and Python:

{% tabs ols %}

{% tab ols Stata %}

```stata
sysuse auto, clear
regress price mpg weight, vce(robust)
```

{% endtab %}

{% tab ols R %}

```r
library(haven)
library(fixest)
auto <- read_dta("https://www.stata-press.com/data/r17/auto.dta")
feols(price ~ mpg + weight, data = auto, vcov = "hetero")
```

{% endtab %}

{% tab ols Python %}

```python
import pandas as pd
import statsmodels.formula.api as smf
auto = pd.read_stata("https://www.stata-press.com/data/r17/auto.dta")
smf.ols("price ~ mpg + weight", data=auto).fit(cov_type="HC1").summary()
```

{% endtab %}

{% endtabs %}

## Merging, appending and reshaping

| Command | What it does |
| --- | --- |
| `merge 1:1 key using file` | Each observation matches one observation in the other file |
| `merge m:1 key using file` | Many observations match one (like VLOOKUP in Excel) |
| `_merge` | 1 = only in memory, 2 = only in the using file, 3 = matched |
| `append using file` | Stacks observations from another file |
| `collapse` | Replaces the data with group statistics |
| `reshape long` / `reshape wide` | Switches between wide and long (panel) formats |
| `tempfile`, `save` | Saves an intermediate dataset that disappears when Stata closes |

```stata
webuse set https://pjakiela.github.io/stata

* 1:1 merge: two files about the same classes
webuse classdata2.dta, clear
tempfile grades
save `grades'
webuse classdata1.dta, clear
merge 1:1 classnumber using `grades'
drop _merge

* m:1 merge: many orders, one price per item
webuse food-prices.dta, clear
tempfile prices
save `prices'
webuse food-orders.dta, clear
merge m:1 fooditem using `prices'
tab fooditem if _merge == 2          // items nobody ordered
keep if _merge == 3
summarize price
display "Total cost of all orders: " r(sum)

webuse set

* Group means added back to the data, and stacking files
sysuse auto, clear
preserve
    collapse (mean) mean_price=price (count) n_cars=price, by(foreign)
    tempfile means
    save `means'
restore
merge m:1 foreign using `means', nogenerate

sysuse auto, clear
keep if foreign == 0
tempfile domestic
save `domestic'
sysuse auto, clear
keep if foreign == 1
append using `domestic'

* Wide to long and back
webuse reshape1, clear
reshape long inc ue, i(id) j(year)
reshape wide inc ue, i(id) j(year)
```

## Household surveys: weights, percentiles and inequality

This is the workflow I use with Bolivia's Household Survey (EH), where `yhogpc` is household income per capita and `factor` is the expansion factor (survey weight). DHS surveys work the same way with their own weight, `v005`.

| Command | What it does |
| --- | --- |
| `[pw=w]`, `[aw=w]`, `[fw=w]` | Survey (probability), analytic and frequency weights |
| `pctile`, `xtile` | Weighted percentile cut-offs; the percentile group of each observation |
| `svyset` + `svy:` | Declares the survey design so standard errors account for it |
| `ineqdeco` **(SSC)** | Gini coefficient and generalized-entropy indices |
| `lorenz` **(SSC)** | Lorenz curves and their graphs |

```stata
use EH2023_Persona, clear
drop if yhogpc == 0 | missing(yhogpc)

pctile cut10 = yhogpc [pw=factor], nq(10)
xtile decile = yhogpc [pw=factor], nq(10)
tabstat yhogpc [aw=factor], by(decile) statistics(mean p50 min max n)

ineqdeco yhogpc [aw=factor]
lorenz estimate yhogpc [pw=factor]
lorenz graph, aspectratio(1)

* DHS: keep valid answers (0 or 1) and set other codes to missing; weighted shares
generate has_tv = cond(inlist(v121, 0, 1), v121, .)
generate cannotread = cond(v106 != 3 & v106 != 2 & v155 == 0, 1, 0)
summarize cannotread [aw=v005]
```

{% details Survey design and weighted estimates (syntax) %}

Declare the design once; afterwards every `svy:` command uses the weights, strata and clusters. Replace `psu_var` and `stratum_var` with the design variables in your survey files.

```stata
svyset psu_var [pw=factor], strata(stratum_var)
svy: mean yhogpc
svy: proportion decile
generate log_yhogpc = ln(yhogpc)
rename s01a_03 edad                 // age in the EH person files
svy: regress log_yhogpc edad
```

{% enddetails %}

## Panel data

| Command | What it does |
| --- | --- |
| `xtset` | Declares the panel: unit and time variables |
| `xtdescribe`, `xtsum` | Panel structure; between and within variation |
| `xtreg, fe` / `xtreg, re` | Fixed- and random-effects models |
| `hausman` | Chooses between fixed and random effects |
| `reghdfe` **(SSC)** | Fast regressions with several sets of fixed effects |

```stata
webuse nlswork, clear
xtset idcode year
xtdescribe
xtsum ln_wage hours

xtreg ln_wage age c.age#c.age tenure, fe
estimates store fe
xtreg ln_wage age c.age#c.age tenure, re
estimates store re
hausman fe re

xtreg ln_wage age c.age#c.age tenure, fe vce(cluster idcode)
reghdfe ln_wage age c.age#c.age tenure, absorb(idcode year) vce(cluster idcode)
```

## Time series

| Command | What it does |
| --- | --- |
| `tsset` | Declares the time variable |
| `L.`, `D.`, `F.` | Lags, differences and leads |
| `dfuller` | Augmented Dickey-Fuller unit-root test |
| `var` | Vector autoregression |
| `irf create`, `irf graph` | Impulse-response functions after a VAR |

```stata
webuse lutkepohl2, clear
tsset qtr
generate g_inv = D.ln_inv
regress ln_inv L.ln_inv L2.ln_inv
dfuller ln_inv, lags(2) trend

var dln_inv dln_inc dln_consump, lags(1/2)
irf create order1, set(myirf, replace)
irf graph oirf, impulse(dln_inc) response(dln_consump)
```

## Graphs

### Scatter plots, fitted lines and options

| Option | What it does |
| --- | --- |
| `scheme(s1mono)`, `scheme(s2color)`, `scheme(economist)`, `scheme(sj)` | Overall look of the graph |
| `mcolor()`, `mfcolor()`, `msymbol()`, `msize()` | Marker color, fill, shape and size |
| `mlabel(var)`, `mlabsize()` | Labels each point with the value of a variable |
| `lcolor()`, `lwidth()`, `lpattern(dash)` | Line color, width and pattern |
| `title()`, `xtitle()`, `ytitle()`, `note()` | Titles and notes |
| `xline(#)`, `xlabel(0(5000)20000)` | Reference line; axis ticks |
| `legend(off)`, `legend(order(1 "A" 2 "B"))`, `legend(rows(1) position(6))` | Hide, relabel or arrange the legend |

```stata
sysuse auto, clear
twoway scatter price mpg, mcolor(purple) msymbol(diamond) msize(small) ///
    title("Car price and mileage") ytitle("Price (dollars)") xtitle("Miles per gallon")
twoway scatter mpg price, scheme(s1mono)
scatter price mpg, mlabel(make) mlabsize(tiny)

* Scatter with fitted lines for all cars and for domestic cars only
twoway (scatter price mpg, mcolor(blue) mfcolor(yellow)) ///
       (lfit price mpg, lcolor(red)) ///
       (lfit price mpg if foreign == 0, lcolor(black) lpattern(dash)), ///
       legend(order(1 "Cars" 2 "All cars" 3 "Domestic only"))

* Two groups in different colors
twoway (scatter mpg weight if foreign == 0) (scatter mpg weight if foreign == 1), ///
       legend(label(1 "Domestic") label(2 "Foreign") position(6) rows(1))

graph export "price_mpg.png", as(png) width(3000) replace
```

### Histograms and combined graphs

| Option or command | What it does |
| --- | --- |
| `bin()`, `width()`, `start()` | Number of bins, bin width, first bin |
| `discrete` | One bar per value (for categorical variables) |
| `percent`, `fraction`, `frequency` | What the vertical axis shows |
| `by(var)` | One panel per group |
| `name(g1, replace)` + `graph combine` | Keeps several graphs in memory and puts them together |

```stata
sysuse auto, clear
histogram weight, bin(30)
histogram rep78, discrete percent
histogram rep78, discrete by(foreign)
histogram foreign, discrete xlabel(0 1, valuelabel)
histogram price, percent xline(6165, lcolor(red)) note("Red line: mean price")

histogram price if foreign == 0, start(0) width(2500) fraction name(domestic, replace) title("Domestic")
histogram price if foreign == 1, start(0) width(2500) fraction name(foreign, replace) title("Foreign")
graph combine domestic foreign, title("Car prices by origin")
```

{% details Drawing density functions in a separate frame %}

A frame is a second dataset in memory. It is useful for building a graph without touching the main data.

```stata
capture frame drop densities
frame create densities
frame densities: set obs 1001
frame densities: generate x = (_n - 501)/100
frame densities: generate normal_pdf = normalden(x)
frame densities: generate t4_pdf = tden(4, x)
frame densities: twoway (line normal_pdf x) (line t4_pdf x, lpattern(dash)), ///
    legend(order(1 "Normal" 2 "t, 4 df")) xtitle("x") ytitle("Density")
frame drop densities
```

{% enddetails %}

### Tips for clear graphs

1. Use `set scheme s1mono` (or the `scheme()` option) for a white background.
2. Use color on purpose, and prefer colorblind-friendly palettes: the **blindschemes** package **(SSC)** adds the Okabe-Ito colors (`set scheme plotplainblind`).
3. Title both axes with words, not variable names.
4. Turn the legend off when it adds nothing, for example for a scatter plot with one fitted line.
5. Use `legend(rows(1))` or `legend(cols(1))` so legend entries line up.
6. Give every figure a self-explanatory title and a note that explains the variables.
7. Export at high resolution with `graph export ..., width(3000)`; `graph set window fontface "Times New Roman"` changes the font.

## Tables

The examples use the data from Cohen, Dupas and Schaner (2015, *American Economic Review*) on subsidies for malaria treatment, as distributed in the Williams tutorial. `c_act` is the use of ACT treatment, `coartemprice` the randomized price, `act_any` the treatment dummy and `b_*` the baseline variables.

```stata
clear all
set more off
webuse set https://pjakiela.github.io/ECON523/exercises
webuse E1-CohenEtAl-data.dta, clear
webuse set
label variable coartemprice "Randomized Price"
label variable c_act "Treated with ACT"
label variable b_h_edu "Education"
label variable b_knowledge "Malaria Knowledge"
label variable b_hh_size "Household Size"
label variable b_acres "Acres of Land"
label variable b_dist_km "Distance to Health Center"
label variable b_h_age_imputed "Age"
label variable b_h_age_missing "Age Data Missing"
```

### Summary statistics table

| Command | What it does |
| --- | --- |
| `estpost summarize` **(SSC: estout)** | Stores summary statistics of several variables as matrices (`e(mean)`, `e(sd)`, `e(min)`, `e(max)`, `e(count)`) |
| `esttab, cells()` | Prints the table; `using file.rtf` sends it to Word |
| `noobs`, `nonum`, `nomtitle`, `collabels()`, `fmt()` | Remove the N row, column numbers and titles; name and format columns |

```stata
estpost summarize b_*
matrix list e(mean)
esttab, cells("mean sd min max count")
esttab using summary-stats.rtf, replace ///
    cells("mean(fmt(2)) sd(fmt(2)) min max count(fmt(%9.0g))") ///
    label noobs nonum nomtitle varwidth(28) ///
    collabels("Mean" "S.D." "Min." "Max." "N") ///
    title(Summary Statistics)
```

### Balance table

```stata
eststo clear
eststo treatment: estpost summarize b_* if act_any == 1
eststo control:   estpost summarize b_* if act_any == 0
eststo diff:      estpost ttest b_*, by(act_any)
esttab treatment control diff using balance-table.rtf, ///
    replace label varwidth(28) ///
    cell(mean(pattern(1 1 0) fmt(2)) & b(pattern(0 0 1) star fmt(3)) ///
         sd(pattern(1 1 0) par([ ]) fmt(2)) & se(pattern(0 0 1) par fmt(3))) ///
    collabels(none) mtitles("Treatment" "Control" "Difference") nonum ///
    note(Standard deviations in brackets; standard errors in parentheses.)
```

### Regression table

| Command or option | What it does |
| --- | --- |
| `eststo:` / `eststo name:` | Stores a regression (`eststo dir` lists them, `eststo clear` erases them) |
| `esttab using file.rtf` / `.csv` / `.tex` | Word, Excel or LaTeX table |
| `label`, `se`, `b(2) se(3)` | Variable labels; standard errors in parentheses; decimals |
| `mtitles()`, `nonumbers`, `nogaps` | Column titles; no column numbers; compact rows |
| `keep()`, `drop()`, `indicate()` | Show some coefficients, hide others, or flag hidden controls |
| `varwidth()`, `modelwidth()`, `title()`, `note()`, `nostar` | Widths, title, notes, no significance stars |

```stata
replace coartemprice = coartemprice/1000
label variable coartemprice "Price (1000s of Shillings)"
eststo clear
eststo: regress c_act coartemprice
eststo: regress c_act coartemprice b_*
eststo dir
esttab, se label varwidth(28) modelwidth(16)
esttab, se label indicate(Baseline Controls = b_*) mtitles("No Controls" "With Controls")
esttab using reg-table.rtf, se label varwidth(28) modelwidth(16) replace ///
    note(OLS estimates. Standard errors in parentheses.)
esttab using reg-table.csv, keep(coartemprice) se label nogaps nonumbers replace
esttab using reg-table.tex, label b(2) se(2) nostar replace ///
    title(Regression Table\label{tab1})
```

A `.tex` table can be compiled in Overleaf with `\input{reg-table.tex}` inside a LaTeX document.

{% details Tables built by hand: tabstat, matrices, putexcel and putdocx %}

```stata
* Statistics into a matrix
tabstat b_*, stat(mean sd min max N) col(stat) save
matrix mystats = r(StatTotal)
matrix mystats = mystats'                 // one row per variable
matrix colnames mystats = Mean SD Minimum Maximum Observations
matrix list mystats

* Excel
putexcel set summary-stats.xlsx, replace
putexcel A1:F1 = "Table 1: Summary Statistics", bold merge border(bottom)
putexcel A2 = matrix(mystats), names nformat(#.00)
putexcel A2:F2, bold border(bottom)

* Word
putdocx clear
putdocx begin
putdocx table tbl1 = matrix(mystats), rownames colnames nformat(%9.2f)
putdocx save summary-stats, replace

* One number per cell (for example a weighted mean from each survey)
quietly summarize c_act
local share = string(r(mean), "%5.3f")
local n = r(N)
putexcel set results.xlsx, replace
putexcel A1 = "Share treated with ACT", bold
putexcel B1 = `share'
putexcel A2 = "Observations", bold
putexcel B2 = `n'
```

The user-written `matmap` command (find it with `search matmap`) can round a whole matrix, for example `matmap mystats roundstats, map(round(@, 0.01))`. Excel cells can also be formatted from Stata with Mata's `xl()` class (column widths, borders, bold text).

{% enddetails %}

{% details One-line tables to Word with asdoc (SSC) %}

```stata
sysuse auto, clear
asdoc tabstat price mpg weight, by(foreign) statistics(mean sd min max) replace
asdoc regress price mpg weight, nest replace
```

{% enddetails %}

## Common mistakes

Five errors from my debugging practice, each with its fix.

| Problem | Cause | Fix |
| --- | --- | --- |
| A local prints nothing | The name is misspelled (`` `minpirce' ``); an undefined local is empty, not an error | Check the spelling |
| A stored result is missing | The name does not exist (`r(standarddev)`) | Run `return list` or `ereturn list` to see the real names (`r(sd)`) |
| A dummy has no zeros | `generate d = 1 if x > m` leaves the other observations missing | `generate d = cond(x > m, 1, 0)` or create it as 0 first |
| Random results change every run | No seed | `set seed` before drawing |
| A local does not work in a calculation | Wrong quotes, `'avglength'` | Open with a backtick and close with an apostrophe: `` `avglength' `` |

```stata
sysuse auto, clear
summarize price
local minprice = r(min)
local maxprice = r(max)
display "Min and max prices: " `minprice' " and " `maxprice'
display r(mean) + 2*r(sd)

summarize mpg
generate above_avg = cond(mpg > r(mean), 1, 0)
tab above_avg

summarize length
local avglength = r(mean)
display 2*`avglength'
```

Two more habits that prevent errors: stored results change after every command, so save them right away; and after `webuse set`, run `webuse set` again to return to Stata's default example data.
