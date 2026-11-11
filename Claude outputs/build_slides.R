# ==============================================================================
#  PMT slides: estimation + interactive deck, in R
#  Run:  Rscript build_slides.R      (or open in RStudio and press Source)
#  Needs: install.packages(c("haven", "jsonlite"))
#  Input : the household survey .dta (same file used by the Stata do-file)
#  Output: pmt-slides.html, built from template.html (edit slide TEXT there)
# ==============================================================================

# ----------------------------- 1. SETTINGS (edit) -----------------------------
DTA      <- "D:/path/to/EH2023_BID-UAEF_VFinal.dta"   # <- your data file
TEMPLATE <- "template.html"
OUTPUT   <- "../assets/html/pmt-slides.html"          # where the site reads it
SEED     <- 202506      # random 80/20 split
TRAIN    <- 0.80
P_ENTER  <- 0.20        # stepwise: p-value to enter
N_SPLITS <- 40          # repeated splits for the robustness slide

# Candidate variables (same lists as the do-file)
demo_u <- c("edad_0_6","edad_7_11","edad_12_17","edad_18_60","prop_muj","jefe_sexo","jefe_educ",
            "jefe_casado","mtpub","remesas_fam","prop_dep","jefe_educ2","educ_max","educ_max2")
viv_u  <- c("cuartos_per","viv_tipo1_depto","viv_tipo2_cuarto","viv_prop1_otro","viv_prop2_alq",
            "viv_prop3_prop","viv_pared1_lad","viv_pared2_adobe","viv_piso1_avan","viv_techo1_teja",
            "viv_techo2_horm","viv_agua2_redfue","viv_bano1_agua","viv_bano2_pozo","viv_eelec",
            "viv_dbasura","viv_internet_urb")
demo_r <- c("edad_0_6","edad_7_11","edad_12_17","edad_18_60","prop_muj","jefe_educ","jefe_educ2",
            "jefe_casado","jefe_edad","jefe_edad2","mtpub","remesas_fam","educ_max","educ_max2")
viv_r  <- c("cuartos_per","viv_tipo1_depto","viv_tipo2_cuarto","viv_tipo4_precaria","viv_prop1_otro",
            "viv_prop2_alq","viv_prop4_pres","viv_rur_pared1_lad","viv_rur_pared2_mad",
            "viv_rur_pared4_otros","viv_piso1_avan","viv_piso2_med","viv_techo1_teja","viv_techo2_horm",
            "viv_techo3_cal","viv_techo4_otros","viv_rur_agua1_redden","viv_rur_agua2_mejorado",
            "viv_bano1_agua","viv_bano2_pozo","viv_dbasura","viv_rur_comb1_gas","viv_rur_comb2_otros",
            "viv_eelec","viv_rur_internet")
equip  <- c("equ_refrigerador","equ_ac","equ_lavadora","equ_automovil")

# Results of the machine-learning models (from the technical annex / notebook).
# Columns: method, urban exclusion, urban inclusion, rural exclusion, rural inclusion
methods <- list(
  list("OLS (stepwise)",            44.49, 38.23, 31.01, 26.89),
  list("Random forest",             43.65, 45.03, 25.33, 29.06),
  list("RF, class-weighted",        33.02, 48.03, 27.19, 28.31),
  list("RF, over/under-sampling",   29.83, 50.33, 27.19, 27.19),
  list("RF, person-level weighted", 35.21, 37.01, 25.74, 17.52))
imp <- list(
  urban = list(list("Rooms per person",12.5), list("Dependency ratio",11.0), list("Share aged 18\u201360",7.0),
               list("Head: schooling",6.8), list("Max schooling in household",6.7), list("Share of women",6.5),
               list("Member in public sector",3.4), list("Floor: parquet / tiles",2.8)),
  rural = list(list("Share aged 18\u201360",8.8), list("Head: schooling",7.9), list("Max schooling in household",6.6),
               list("Rooms per person",5.8), list("Share of women",5.0), list("Member in public sector",5.0),
               list("Dependency ratio",4.2), list("Cooking fuel: gas",3.8)))

# English labels shown in the charts
LAB <- c(edad_0_6="Share aged 0\u20136", edad_7_11="Share aged 7\u201311", edad_12_17="Share aged 12\u201317",
  edad_18_60="Share aged 18\u201360", prop_muj="Share of women", jefe_sexo="Head is male",
  jefe_educ="Head: years of schooling", jefe_educ2="Head: schooling squared", jefe_casado="Head married / cohabiting",
  jefe_edad="Head: age", jefe_edad2="Head: age squared", mtpub="Member works in public sector",
  remesas_fam="Receives remittances", prop_dep="Dependency ratio", educ_max="Max schooling in household",
  educ_max2="Max schooling squared", cuartos_per="Rooms per person", viv_tipo1_depto="Dwelling: apartment",
  viv_tipo2_cuarto="Dwelling: rented room(s)", viv_tipo4_precaria="Dwelling: precarious", viv_prop1_otro="Tenure: other",
  viv_prop2_alq="Tenure: rented", viv_prop3_prop="Tenure: owned", viv_prop4_pres="Tenure: lent by relatives",
  viv_pared1_lad="Walls: brick / concrete", viv_pared2_adobe="Walls: adobe", viv_rur_pared1_lad="Walls: brick / concrete",
  viv_rur_pared2_mad="Walls: wood", viv_rur_pared4_otros="Walls: other", viv_piso1_avan="Floor: parquet / tiles",
  viv_piso2_med="Floor: cement / brick", viv_techo1_teja="Roof: tiles", viv_techo2_horm="Roof: concrete slab",
  viv_techo3_cal="Roof: metal sheet", viv_techo4_otros="Roof: straw / other", viv_agua2_redfue="Water: piped, outside dwelling",
  viv_rur_agua1_redden="Water: piped, inside dwelling", viv_rur_agua2_mejorado="Water: improved source",
  viv_bano1_agua="Toilet: flush", viv_bano2_pozo="Toilet: pit latrine", viv_eelec="Electricity",
  viv_dbasura="Garbage collection", viv_internet_urb="Broadband internet", viv_rur_internet="Internet access",
  viv_rur_comb1_gas="Cooking fuel: gas", viv_rur_comb2_otros="Cooking fuel: wood / other",
  equ_refrigerador="Owns refrigerator", equ_ac="Owns air conditioner", equ_lavadora="Owns washing machine",
  equ_automovil="Owns car")
lab <- function(v) ifelse(v %in% names(LAB), LAB[v], v)

# ----------------------------- 2. DATA PREPARATION ----------------------------
library(haven); library(jsonlite)
d <- as.data.frame(zap_labels(read_dta(DTA)))

T_ <- function(x) !is.na(x) & x                       # TRUE only when known and true
inl <- function(x, ...) !is.na(x) & x %in% c(...)
ge  <- function(x, v) is.na(x) | x >= v               # Stata: missing counts as +infinity
z0  <- function(x) ifelse(is.na(x), 0, x)
hmax  <- function(x) ave(x, d$folio, FUN = function(v) if (all(is.na(v))) NA else max(v, na.rm = TRUE))
hmean <- function(x) ave(x, d$folio, FUN = function(v) mean(v, na.rm = TRUE))
hsum  <- function(x) ave(x, d$folio, FUN = function(v) sum(v, na.rm = TRUE))
b <- as.integer

d$area <- ifelse(d$area == 2, 0, d$area)              # 1 urban, 0 rural
d$sexo <- ifelse(d$s01a_02 == 2, 0, d$s01a_02)
p <- d$s01a_05
d$parentco <- ifelse(T_(p == 1), 1, ifelse(T_(p == 2), 2, ifelse(T_(p == 3), 3,
              ifelse(T_(p >= 4 & p <= 9), 4, ifelse(T_(p == 10), 5, ifelse(T_(p >= 11 & p <= 12), 6, NA))))))
mem <- inl(d$parentco, 1, 2, 3, 4)
d$hh_total <- hsum(b(mem))

# Income per capita net of state transfers
per <- function(a, f) ifelse(T_(d[[f]] == 4), d[[a]], ifelse(T_(d[[f]] == 8), d[[a]] / 12, NA))
transf <- z0(d$s02b_12a2 * 50 / 12) + z0(ifelse(T_(d$s02b_12b == 1), 10, NA)) + z0(d$s05a_01e0) +
          z0(per("s05b_06aa", "s05b_06ab")) + z0(per("s05b_06ba", "s05b_06bb")) + z0(per("s05b_06ca", "s05b_06cb"))
ynolab_b <- pmax(0, ifelse(is.na(d$ynolab), -1, d$ynolab - transf))
yper_b   <- z0(d$ylab) + ynolab_b
yper_g   <- z0(d$ylab) + z0(d$ynolab)
d$yhogpc_b     <- ifelse(mem, hsum(ifelse(mem, yper_b, NA)) / d$hh_total, NA)
d$yhogpc_gross <- ifelse(mem, hsum(ifelse(mem, yper_g, NA)) / d$hh_total, NA)

# Demographics
d$edad <- d$s01a_03
memmean <- function(cond) ifelse(mem, hmean(ifelse(mem, as.numeric(T_(cond)), NA)), NA)
d$edad_0_6   <- memmean(d$edad < 7);                 d$edad_7_11  <- memmean(d$edad > 6 & d$edad < 12)
d$edad_12_17 <- memmean(d$edad > 11 & d$edad < 18);  d$edad_18_60 <- memmean(d$edad > 17 & d$edad < 61)
dep <- memmean(d$edad < 18); indep <- memmean(d$edad > 17)
d$prop_dep <- ifelse(is.finite(dep / indep), dep / indep, NA)
union <- b(inl(d$s01a_10, 2, 3))
aa <- d$s04a_01; ccc <- d$s04a_03; bb <- d$s04a_02
bb <- ifelse(inl(bb, 1, 2, 3), 1, ifelse(is.na(bb), NA, bb - 2))
emp <- T_(aa == 1) | (T_(aa == 2) & T_(bb >= 1 & bb <= 6)) | (T_(aa == 2) & T_(bb == 7) & T_(ccc >= 1 & ccc <= 9))
d$mtpub <- hmax(b(inl(d$s04b_13, 1, 2) & emp & mem))
d$educ_max <- hmax(d$aestudio); d$educ_max2 <- d$educ_max^2
d$jefe <- b(T_(d$parentco == 1)); jf <- d$jefe == 1
d$jefe_sexo <- hmax(b(T_(d$sexo == 1) & jf))
d$prop_muj  <- hmean(as.numeric(T_(d$sexo == 0)))
d$jefe_edad <- hmax(d$edad * d$jefe);     d$jefe_edad2 <- d$jefe_edad^2
d$jefe_educ <- hmax(d$aestudio * d$jefe); d$jefe_educ2 <- d$jefe_educ^2
d$jefe_casado <- hmax(d$jefe * union)
d$remesas_fam <- hmax(b(T_(d$s05c_07 == 1) & mem))

# Housing
d$cuartos_per <- hmax(d$viv_cuartos / d$hh_total)
t <- d$viv_tipo
d$viv_tipo1_depto <- b(T_(t == 3)); d$viv_tipo2_cuarto <- b(T_(t == 4)); d$viv_tipo4_precaria <- b(T_(t == 2) | ge(t, 5))
te <- d$viv_tenencia
d$viv_prop1_otro <- b(inl(te, 2, 4, 5, 6, 8)); d$viv_prop2_alq <- b(T_(te == 3))
d$viv_prop3_prop <- b(T_(te == 1));            d$viv_prop4_pres <- b(T_(te == 7))
pa <- d$viv_matpared
d$viv_pared1_lad <- b(T_(pa == 1)); d$viv_pared2_adobe <- b(T_(pa == 2))
d$viv_rur_pared1_lad <- b(T_(pa == 1)); d$viv_rur_pared2_mad <- b(T_(pa == 5)); d$viv_rur_pared4_otros <- b(inl(pa, 3, 4, 6, 7))
pi_ <- d$viv_matpiso
d$viv_piso1_avan <- b(inl(pi_, 3, 4, 6)); d$viv_piso2_med <- b(inl(pi_, 2, 5, 7))
tc <- d$viv_mattecho
d$viv_techo1_teja <- b(T_(tc == 2)); d$viv_techo2_horm <- b(T_(tc == 3)); d$viv_techo3_cal <- b(T_(tc == 1)); d$viv_techo4_otros <- b(ge(tc, 4))
ag <- d$viv_agua
d$viv_agua2_redfue <- b(T_(ag == 2)); d$viv_rur_agua1_redden <- b(T_(ag == 1)); d$viv_rur_agua2_mejorado <- b(inl(ag, 2, 5, 6))
ba <- d$viv_bano; de <- d$viv_bano_1_desague; ne4 <- is.na(de) | de != 4
d$viv_bano1_agua <- b(T_(ba == 1)); d$viv_bano2_pozo <- b(T_(ba == 2))
san <- rep(NA_real_, nrow(d))
san[T_(ba == 5)] <- 0
san[T_(ba == 1) & inl(de, 1, 2, 3)] <- 1
san[inl(ba, 2, 4) & ne4] <- 1
san[inl(ba, 1, 2, 3) & T_(de == 4)] <- 1
san[T_(ba == 3) & ne4] <- 1
d$viv_sanitario <- san
bs <- d$viv_basura; d$viv_dbasura <- ifelse(inl(bs, 5, 6), 1, ifelse(inl(bs, 1, 2, 3, 4, 7), 0, NA))
cb <- d$viv_cocina_comb
d$viv_rur_comb1_gas <- b(inl(cb, 3, 4)); d$viv_rur_comb2_otros <- b(inl(cb, 1, 2, 6, 7))
d$viv_eelec <- d$viv_energiaelec
ai <- d$viv_acceso_internet; co <- d$viv_conexion_internet
d$viv_internet_urb <- ifelse(T_(ai == 2), 0, ifelse(T_(ai == 1) & inl(co, 2, 4), 0, ifelse(T_(ai == 1) & inl(co, 1, 3), 1, NA)))
d$viv_rur_internet <- ifelse(T_(ai == 2), 0, ifelse(T_(ai == 1), 1, ai))

# Poverty and sample adjustments
d$pobre_b     <- b(T_(d$yhogpc_b < d$z))
d$pobre_gross <- b(T_(d$yhogpc_gross < d$z))
d <- d[!inl(d$parentco, 5, 6) & !is.na(d$viv_sanitario), ]
d$prop_dep[is.na(d$prop_dep)] <- 3

# ----------------------------- 3. ESTIMATION TOOLS ----------------------------
wmean <- function(x, w) sum(x * w) / sum(w)

# Weighted least squares with robust (HC1) standard errors, like Stata [pw=]
wls <- function(X, y, w) {
  XtX <- crossprod(X, X * w); XtXi <- MASS_ginv(XtX)
  beta <- as.vector(XtXi %*% crossprod(X, w * y))
  e <- as.vector(y - X %*% beta); n <- nrow(X); k <- ncol(X)
  S <- crossprod(X * (w * e)); V <- XtXi %*% S %*% XtXi * n / (n - k)
  se <- sqrt(pmax(diag(V), 1e-30))
  list(b = beta, se = se, p = 2 * pt(-abs(beta / se), n - k),
       r2 = 1 - sum(w * e^2) / sum(w * (y - wmean(y, w))^2))
}
MASS_ginv <- function(A) { s <- svd(A); tol <- max(dim(A)) * max(s$d) * .Machine$double.eps
  pos <- s$d > tol; s$v[, pos, drop = FALSE] %*% (t(s$u[, pos, drop = FALSE]) / s$d[pos]) }

# Forward stepwise selection (Stata: stepwise, pe(.20))
forward <- function(df, y, w, cands, pe = P_ENTER) {
  sel <- c(); rest <- cands[sapply(cands, function(v) sd(df[[v]]) > 0)]
  repeat {
    if (!length(rest)) break
    pv <- sapply(rest, function(v) {
      X <- cbind(1, as.matrix(df[, c(sel, v), drop = FALSE]))
      if (qr(X)$rank < ncol(X)) return(1)
      tail(wls(X, y, w)$p, 1) })
    if (min(pv) >= pe) break
    best <- rest[which.min(pv)]; sel <- c(sel, best); rest <- setdiff(rest, best)
  }
  sel
}

errors <- function(poor, sel, w) c(ex  = sum(w * (poor & !sel)) / sum(w * poor),
                                   inc = sum(w * (!poor & sel)) / max(sum(w * sel), 1e-12))
pctile <- function(x, q = 100) ceiling(rank(x, ties.method = "first") / length(x) * q)

run <- function(area, cands, seed, detail = FALSE) {
  h <- d[d$jefe == 1 & d$area == area, ]
  h <- h[complete.cases(h[, c(cands, "yhogpc_b", "factor", "depto")]), ]
  set.seed(seed)
  h$train <- rank(runif(nrow(h))) <= TRAIN * nrow(h)
  pc <- pctile(h$yhogpc_b)
  h <- h[pc > 1 & pc < 100 & h$yhogpc_b > 0, ]          # trim top and bottom 1%
  h$ly <- log(h$yhogpc_b)
  tr <- h[h$train, ]; te <- h[!h$train, ]
  sel <- forward(tr, tr$ly, tr$factor, cands)
  deps <- sort(unique(h$depto))[-1]
  mk <- function(df) cbind(1, as.matrix(df[, sel, drop = FALSE]), sapply(deps, function(k) as.numeric(df$depto == k)))
  fit <- wls(mk(tr), tr$ly, tr$factor)
  te$yhat <- as.vector(mk(te) %*% fit$b)
  w <- te$factor; poor <- te$pobre_b == 1
  pcy <- pctile(te$yhat); rate <- wmean(poor, w)
  e <- errors(poor, pcy < rate * 100, w)
  res <- list(ex = e[["ex"]], inc = e[["inc"]], rate = rate, r2 = fit$r2, nsel = length(sel))
  if (detail) {
    res$curve <- t(sapply(1:99, function(i) { s <- pcy <= i; ee <- errors(poor, s, w)
      round(c(i, ee[["ex"]] * 100, ee[["inc"]] * 100, sum(w * s) / sum(w) * 100), 2) }))
    idx <- seq_along(sel) + 1
    res$coef <- data.frame(l = unname(lab(sel)), b = round(fit$b[idx], 4), se = round(fit$se[idx], 4))
    res$dropped <- unname(lab(setdiff(cands, sel)))
    res$r2t <- 1 - sum(w * (te$ly - te$yhat)^2) / sum(w * (te$ly - wmean(te$ly, w))^2)
    dec <- pctile(te$ly, 10)
    res$decile <- t(sapply(1:10, function(k) c(k, round(exp(wmean(te$ly[dec == k], w[dec == k])), 1),
                                                  round(exp(wmean(te$yhat[dec == k], w[dec == k])), 1))))
  }
  res
}

# ----------------------------- 4. RUN BOTH AREAS ------------------------------
build_area <- function(area, cands) {
  h <- d[d$jefe == 1 & d$area == area, ]
  m <- run(area, cands, SEED, detail = TRUE)
  reps <- lapply(1:N_SPLITS, function(s) run(area, cands, s))
  hp <- h[!is.na(h$yhogpc_b) & h$yhogpc_b > 0, ]
  bins <- seq(3, 10.5, length.out = 46)
  ly <- log(hp$yhogpc_b); keep <- ly >= 3 & ly <= 10.5
  hist <- tapply(hp$factor[keep], cut(ly[keep], bins, include.lowest = TRUE), sum); hist[is.na(hist)] <- 0
  list(curve = m$curve, coef = m$coef, dropped = I(m$dropped),
       hist = round(as.vector(hist / sum(hist)), 5), bins = round(bins, 3), z = median(h$z), decile = m$decile,
       rep_ex = round(sapply(reps, function(r) r$ex) * 100, 2), rep_inc = round(sapply(reps, function(r) r$inc) * 100, 2),
       ex = round(m$ex * 100, 1), inc = round(m$inc * 100, 1), rate = round(m$rate * 100, 1),
       r2 = round(m$r2, 2), r2t = round(m$r2t, 2), n = nrow(h), nsel = m$nsel,
       pov = round(wmean(h$pobre_b, h$factor) * 100, 1), povg = round(wmean(h$pobre_gross, h$factor) * 100, 1))
}
u <- build_area(1, c(demo_u, viv_u, equip))
r <- build_area(0, c(demo_r, viv_r, equip))
cat(sprintf("Urban: exclusion %.1f%%, inclusion %.1f%%, R2 %.2f, %d variables\n", u$ex, u$inc, u$r2, u$nsel))
cat(sprintf("Rural: exclusion %.1f%%, inclusion %.1f%%, R2 %.2f, %d variables\n", r$ex, r$inc, r$r2, r$nsel))

# ----------------------------- 5. WRITE THE SLIDES ----------------------------
DATA <- list(urban = u, rural = r, methods = methods, imp = imp)
html <- paste(readLines(TEMPLATE, encoding = "UTF-8", warn = FALSE), collapse = "\n")
html <- sub("/*DATA*/", paste0("const DATA=", toJSON(DATA, auto_unbox = TRUE, digits = NA), ";"), html, fixed = TRUE)
fill <- c(U_N = format(u$n, big.mark = ","), R_N = format(r$n, big.mark = ","), U_POV = u$pov, R_POV = r$pov,
          U_POVG = u$povg, R_POVG = r$povg, U_R2 = u$r2, R_R2 = r$r2, U_NSEL = u$nsel, R_NSEL = r$nsel)
for (k in names(fill)) html <- gsub(paste0("{{", k, "}}"), fill[[k]], html, fixed = TRUE)
dir.create(dirname(OUTPUT), showWarnings = FALSE, recursive = TRUE)
writeLines(enc2utf8(html), OUTPUT, useBytes = TRUE)
cat("Slides written to", normalizePath(OUTPUT), "\n")
