# PMT slides: source code

This folder is not published on the website (Jekyll skips folders that start with `_`).
It rebuilds `assets/html/pmt-slides.html`. The survey data is **not** stored here.

| File | What it does |
| --- | --- |
| `template.html` | Text and design of the slides. Edit titles, bullets and slides here. |
| `build_slides.R` | R: data preparation, stepwise regressions, targeting errors, and writes the slides. |
| `replicate.py` | Python: same estimation; writes `results.json`. |
| `build.py` | Python: reads `results.json` + `template.html` and writes the slides. |

## Run in R

```r
install.packages(c("haven", "jsonlite"))   # once
# set DTA at the top of build_slides.R, then, from this folder:
source("build_slides.R")
```

## Run in Python

```bash
pip install pandas numpy scipy
python replicate.py "D:/path/to/EH2023_BID-UAEF_VFinal.dta" results.json
python build.py
```

Both routes write `../assets/html/pmt-slides.html`. Then commit and push.

Notes: R and Python draw different random numbers, so the 80/20 split (and the errors) differ by a few points between them. The random-forest results and variable importances are typed in by hand at the top of `build_slides.R` and in `build.py`.
