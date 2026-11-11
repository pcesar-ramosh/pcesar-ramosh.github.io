"""Python replication of the PMT do-file (EH 2023). Outputs results.json for the slides."""
import json, sys
import numpy as np, pandas as pd
from scipy import stats

DTA = sys.argv[1]; OUT = sys.argv[2]
d = pd.read_stata(DTA, convert_categoricals=False)
isin = lambda s, *v: s.isin(v)
ge = lambda s, v: (s >= v) | s.isna()      # Stata: missing is +infinity
gt = lambda s, v: (s > v) | s.isna()
g = d.groupby('folio')

d['area'] = np.where(d['area'] == 2, 0, d['area'])
d['sexo'] = np.where(d['s01a_02'] == 2, 0, d['s01a_02'])
p = d['s01a_05']
d['parentco'] = np.select([p == 1, p == 2, p == 3, p.between(4, 9), p == 10, p.between(11, 12)], [1, 2, 3, 4, 5, 6], np.nan)
d['hh_member'] = d['parentco'].between(1, 4).astype(int)
d['hh_total'] = g['hh_member'].transform('sum')

# --- income per capita net of state transfers
z0 = lambda s: s.fillna(0)
ja1 = d['s02b_12a2'] * 50 / 12
ja2 = pd.Series(np.where(d['s02b_12b'] == 1, 10.0, np.nan), index=d.index)
rd = d['s05a_01e0']
per = lambda a, f: pd.Series(np.select([d[f] == 4, d[f] == 8], [d[a], d[a] / 12], np.nan), index=d.index)
disc, efe, esp = per('s05b_06aa', 's05b_06ab'), per('s05b_06ba', 's05b_06bb'), per('s05b_06ca', 's05b_06cb')
transf = z0(ja1) + z0(ja2) + z0(rd) + z0(disc) + z0(efe) + z0(esp)
d['transf'] = transf
ynolab_b = np.maximum(0, (d['ynolab'] - transf).fillna(-1))
d['yper_b'] = z0(d['ylab']) + ynolab_b
d['yper_gross'] = z0(d['ylab']) + z0(d['ynolab'])
mem = d['hh_member'] == 1
d['yhogpc_b'] = (d['yper_b'].where(mem)).groupby(d['folio']).transform('sum') / d['hh_total']
d['yhogpc_gross'] = (d['yper_gross'].where(mem)).groupby(d['folio']).transform('sum') / d['hh_total']
d.loc[~mem, ['yhogpc_b', 'yhogpc_gross']] = np.nan

# --- demographics
d['edad'] = d['s01a_03']
def memmean(cond):
    return cond.where(mem).astype(float).groupby(d['folio']).transform('mean').where(mem)
d['edad_0_6'] = memmean(d['edad'] < 7); d['edad_7_11'] = memmean((d['edad'] > 6) & (d['edad'] < 12))
d['edad_12_17'] = memmean((d['edad'] > 11) & (d['edad'] < 18)); d['edad_18_60'] = memmean((d['edad'] > 17) & (d['edad'] < 61))
dep, indep = memmean(d['edad'] < 18), memmean(d['edad'] > 17)
d['prop_dep'] = (dep / indep).replace([np.inf, -np.inf], np.nan)
ec = d['s01a_10']; d['union'] = isin(ec, 2, 3).astype(int)
aa, ccc = d['s04a_01'], d['s04a_03']
bb = d['s04a_02'].replace({1: 1, 2: 1, 3: 1, 4: 2, 5: 3, 6: 4, 7: 5, 8: 6, 9: 7})
emp = (aa == 1) | ((aa == 2) & bb.between(1, 6)) | ((aa == 2) & (bb == 7) & ccc.between(1, 9))
public = isin(d['s04b_13'], 1, 2) & emp
d['mtpub'] = (public & mem).astype(int).groupby(d['folio']).transform('max')
d['educ_max'] = g['aestudio'].transform('max'); d['educ_max2'] = d['educ_max'] ** 2
d['jefe'] = (d['parentco'] == 1).astype(int)
jf = d['jefe'] == 1
hmax = lambda s: s.groupby(d['folio']).transform('max')
d['jefe_sexo'] = hmax(((d['sexo'] == 1) & jf).astype(int))
d['prop_muj'] = (d['sexo'] == 0).astype(float).groupby(d['folio']).transform('mean')
d['jefe_edad'] = hmax(d['edad'] * d['jefe']); d['jefe_edad2'] = d['jefe_edad'] ** 2
d['jefe_educ'] = hmax(d['aestudio'] * d['jefe']); d['jefe_educ2'] = d['jefe_educ'] ** 2
d['jefe_casado'] = hmax(d['jefe'] * d['union'])
d['remesas_fam'] = hmax(((d['s05c_07'] == 1) & mem).astype(int))

# --- housing
d['cuartos_per'] = hmax(d['viv_cuartos'] / d['hh_total'])
t = d['viv_tipo']; b = lambda c: c.astype(int)
d['viv_tipo1_depto'] = b(t == 3); d['viv_tipo2_cuarto'] = b(t == 4); d['viv_tipo3_casa'] = b(t == 1)
d['viv_tipo4_precaria'] = b((t == 2) | ge(t, 5))
te = d['viv_tenencia']
d['viv_prop1_otro'] = b(isin(te, 2, 4, 5, 6, 8)); d['viv_prop2_alq'] = b(te == 3); d['viv_prop3_prop'] = b(te == 1); d['viv_prop4_pres'] = b(te == 7)
pa = d['viv_matpared']
d['viv_pared1_lad'] = b(pa == 1); d['viv_pared2_adobe'] = b(pa == 2)
d['viv_rur_pared1_lad'] = b(pa == 1); d['viv_rur_pared2_mad'] = b(pa == 5); d['viv_rur_pared4_otros'] = b(isin(pa, 3, 4, 6, 7))
pi = d['viv_matpiso']; d['viv_piso1_avan'] = b(isin(pi, 3, 4, 6)); d['viv_piso2_med'] = b(isin(pi, 2, 5, 7))
tc = d['viv_mattecho']
d['viv_techo1_teja'] = b(tc == 2); d['viv_techo2_horm'] = b(tc == 3); d['viv_techo3_cal'] = b(tc == 1); d['viv_techo4_otros'] = b(ge(tc, 4))
ag = d['viv_agua']
d['viv_agua2_redfue'] = b(ag == 2); d['viv_rur_agua1_redden'] = b(ag == 1); d['viv_rur_agua2_mejorado'] = b(isin(ag, 2, 5, 6))
ba, de = d['viv_bano'], d['viv_bano_1_desague']
d['viv_bano1_agua'] = b(ba == 1); d['viv_bano2_pozo'] = b(ba == 2)
ne4 = (de != 4)
san = pd.Series(np.nan, index=d.index)
san[ba == 5] = 0
san[(ba == 1) & isin(de, 1, 2)] = 1
san[(isin(ba, 2, 4) & ne4) | ((ba == 1) & (de == 3))] = 1
san[isin(ba, 1, 2, 3) & (de == 4)] = 1
san[(ba == 3) & ne4] = 1
d['viv_sanitario'] = san
bs = d['viv_basura']; d['viv_dbasura'] = np.select([isin(bs, 5, 6), isin(bs, 1, 2, 3, 4, 7)], [1, 0], np.nan)
cb = d['viv_cocina_comb']; d['viv_rur_comb1_gas'] = b(isin(cb, 3, 4)); d['viv_rur_comb2_otros'] = b(isin(cb, 1, 2, 6, 7))
d['viv_eelec'] = d['viv_energiaelec']
ai, co = d['viv_acceso_internet'], d['viv_conexion_internet']
d['viv_internet_urb'] = np.select([ai == 2, (ai == 1) & isin(co, 2, 4), (ai == 1) & isin(co, 1, 3)], [0, 0, 1], np.nan)
d['viv_rur_internet'] = np.select([ai == 2, ai == 1], [0, 1], ai)
d['pobre_b'] = (d['yhogpc_b'] < d['z']).astype(int)
d['pobre_gross'] = (d['yhogpc_gross'] < d['z']).astype(int)

d = d[~isin(d['parentco'], 5, 6)]
d = d[d['viv_sanitario'].notna()].copy()
d['prop_dep'] = d['prop_dep'].fillna(3)

demo_u = "edad_0_6 edad_7_11 edad_12_17 edad_18_60 prop_muj jefe_sexo jefe_educ jefe_casado mtpub remesas_fam prop_dep jefe_educ2 educ_max educ_max2".split()
viv_u = "cuartos_per viv_tipo1_depto viv_tipo2_cuarto viv_prop1_otro viv_prop2_alq viv_prop3_prop viv_pared1_lad viv_pared2_adobe viv_piso1_avan viv_techo1_teja viv_techo2_horm viv_agua2_redfue viv_bano1_agua viv_bano2_pozo viv_eelec viv_dbasura viv_internet_urb".split()
demo_r = "edad_0_6 edad_7_11 edad_12_17 edad_18_60 prop_muj jefe_educ jefe_educ2 jefe_casado jefe_edad jefe_edad2 mtpub remesas_fam educ_max educ_max2".split()
viv_r = "cuartos_per viv_tipo1_depto viv_tipo2_cuarto viv_tipo4_precaria viv_prop1_otro viv_prop2_alq viv_prop4_pres viv_rur_pared1_lad viv_rur_pared2_mad viv_rur_pared4_otros viv_piso1_avan viv_piso2_med viv_techo1_teja viv_techo2_horm viv_techo3_cal viv_techo4_otros viv_rur_agua1_redden viv_rur_agua2_mejorado viv_bano1_agua viv_bano2_pozo viv_dbasura viv_rur_comb1_gas viv_rur_comb2_otros viv_eelec viv_rur_internet".split()
equip = "equ_refrigerador equ_ac equ_lavadora equ_automovil".split()


def wls(X, y, w):
    """Weighted LS with HC1 robust SEs (Stata pweights)."""
    Xw = X * w[:, None]
    XtX = X.T @ Xw
    bta = np.linalg.lstsq(XtX, Xw.T @ y, rcond=None)[0]
    e = y - X @ bta
    n, k = X.shape
    XtXi = np.linalg.pinv(XtX)
    S = (Xw * e[:, None]).T @ (Xw * e[:, None])
    V = XtXi @ S @ XtXi * n / (n - k)
    se = np.sqrt(np.clip(np.diag(V), 1e-30, None))
    pv = 2 * stats.t.sf(np.abs(bta / se), n - k)
    yb = np.average(y, weights=w)
    r2 = 1 - (w * e ** 2).sum() / (w * (y - yb) ** 2).sum()
    return bta, se, pv, r2


def forward(df, y, w, cands, pe=0.20):
    sel = []; rest = [c for c in cands if df[c].std() > 0]
    while rest:
        best = None
        for c in rest:
            X = np.column_stack([np.ones(len(df))] + [df[v].values for v in sel + [c]])
            if np.linalg.matrix_rank(X) < X.shape[1]: continue
            pv = wls(X, y, w)[2][-1]
            if best is None or pv < best[1]: best = (c, pv)
        if best is None or best[1] >= pe: break
        sel.append(best[0]); rest.remove(best[0])
    return sel


def errors(poor, sel, w):
    ex = (w * (poor & ~sel)).sum() / (w * poor).sum()
    inc = (w * (~poor & sel)).sum() / max((w * sel).sum(), 1e-12)
    return ex, inc


def run(area, cands, seed, detail=False):
    h = d[(d['jefe'] == 1) & (d['area'] == area)].copy()
    h = h.dropna(subset=cands + ['yhogpc_b', 'factor', 'depto'])
    rng = np.random.default_rng(seed)
    h['train'] = (rng.random(len(h)).argsort().argsort() < 0.8 * len(h))
    pct = np.ceil(h['yhogpc_b'].rank(method='first') / len(h) * 100)
    h = h[(pct > 1) & (pct < 100) & (h['yhogpc_b'] > 0)].copy()
    h['ly'] = np.log(h['yhogpc_b'])
    tr, te = h[h['train']], h[~h['train']].copy()
    sel = forward(tr, tr['ly'].values, tr['factor'].values, cands)
    deps = sorted(h['depto'].unique())[1:]
    mk = lambda df: np.column_stack([np.ones(len(df))] + [df[v].values for v in sel] + [(df['depto'] == k).values.astype(float) for k in deps])
    bta, se, pv, r2 = wls(mk(tr), tr['ly'].values, tr['factor'].values)
    te['yhat'] = mk(te) @ bta
    w = te['factor'].values; poor = te['pobre_b'].values.astype(bool)
    pc = np.ceil(te['yhat'].rank(method='first').values / len(te) * 100)
    rate = np.average(poor, weights=w)
    ex, inc = errors(poor, pc < rate * 100, w)
    res = dict(ex=ex, inc=inc, rate=rate, r2=r2, n_train=len(tr), n_test=len(te), nsel=len(sel))
    if detail:
        curve = []
        for i in range(1, 100):
            s = pc <= i
            e1, e2 = errors(poor, s, w)
            curve.append([i, round(e1 * 100, 2), round(e2 * 100, 2), round((w * s).sum() / w.sum() * 100, 2)])
        res['curve'] = curve
        res['coef'] = [dict(v=v, b=round(float(bta[i + 1]), 4), se=round(float(se[i + 1]), 4), p=round(float(pv[i + 1]), 4)) for i, v in enumerate(sel)]
        res['dropped'] = [c for c in cands if c not in sel]
        r2t = 1 - (w * (te['ly'] - te['yhat']) ** 2).sum() / (w * (te['ly'] - np.average(te['ly'], weights=w)) ** 2).sum()
        res['r2_test'] = float(r2t)
        # predicted vs actual by actual decile (regression to the mean)
        dec = np.ceil(te['ly'].rank(method='first').values / len(te) * 10)
        res['decile'] = [[int(k), round(float(np.exp(np.average(te['ly'][dec == k], weights=w[dec == k]))), 1),
                          round(float(np.exp(np.average(te['yhat'][dec == k], weights=w[dec == k]))), 1)] for k in range(1, 11)]
    return res


out = {}
heads = d[d['jefe'] == 1]
for area, name, cands in [(1, 'urban', demo_u + viv_u + equip), (0, 'rural', demo_r + viv_r + equip)]:
    h = heads[heads['area'] == area]
    w = h['factor']
    main = run(area, cands, 202506, detail=True)
    reps = [run(area, cands, s) for s in range(1, 41)]
    main['rep_ex'] = [round(r['ex'] * 100, 2) for r in reps]; main['rep_inc'] = [round(r['inc'] * 100, 2) for r in reps]
    main['n_households'] = int(len(h))
    main['pov_net'] = float(np.average(h['pobre_b'], weights=w)); main['pov_gross'] = float(np.average(h['pobre_gross'], weights=w))
    hp = h[h['yhogpc_b'] > 0]
    ly = np.log(hp['yhogpc_b']); bins = np.linspace(3, 10.5, 46)
    hist, _ = np.histogram(ly, bins=bins, weights=hp['factor']); main['hist'] = [round(float(x), 5) for x in hist / hist.sum()]
    main['bins'] = [round(float(x), 3) for x in bins]
    main['z_med'] = float(h['z'].median()); main['y_med'] = float(hp['yhogpc_b'].median())
    main['means'] = {c: round(float(np.average(h[c].dropna(), weights=h.loc[h[c].notna(), 'factor'])), 3) for c in cands}
    out[name] = main
    print(name, {k: (round(v, 4) if isinstance(v, float) else v) for k, v in main.items() if k in ('ex', 'inc', 'rate', 'r2', 'r2_test', 'n_train', 'n_test', 'nsel', 'n_households', 'pov_net', 'pov_gross')})
    print('  reps ex mean/sd', np.mean(main['rep_ex']).round(2), np.std(main['rep_ex']).round(2), 'inc', np.mean(main['rep_inc']).round(2), np.std(main['rep_inc']).round(2))
    print('  dropped', main['dropped'])
json.dump(out, open(OUT, 'w'))
