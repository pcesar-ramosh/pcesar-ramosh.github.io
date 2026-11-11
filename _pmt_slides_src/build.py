import json, os
D = os.path.dirname(os.path.abspath(__file__))
R = json.load(open(D + '/results.json'))
LAB = {
 'edad_0_6': 'Share aged 0–6', 'edad_7_11': 'Share aged 7–11', 'edad_12_17': 'Share aged 12–17', 'edad_18_60': 'Share aged 18–60',
 'prop_muj': 'Share of women', 'jefe_sexo': 'Head is male', 'jefe_educ': 'Head: years of schooling', 'jefe_educ2': 'Head: schooling squared',
 'jefe_casado': 'Head married / cohabiting', 'jefe_edad': 'Head: age', 'jefe_edad2': 'Head: age squared', 'mtpub': 'Member works in public sector',
 'remesas_fam': 'Receives remittances', 'prop_dep': 'Dependency ratio', 'educ_max': 'Max schooling in household', 'educ_max2': 'Max schooling squared',
 'cuartos_per': 'Rooms per person', 'viv_tipo1_depto': 'Dwelling: apartment', 'viv_tipo2_cuarto': 'Dwelling: rented room(s)', 'viv_tipo4_precaria': 'Dwelling: precarious',
 'viv_prop1_otro': 'Tenure: other', 'viv_prop2_alq': 'Tenure: rented', 'viv_prop3_prop': 'Tenure: owned', 'viv_prop4_pres': 'Tenure: lent by relatives',
 'viv_pared1_lad': 'Walls: brick / concrete', 'viv_pared2_adobe': 'Walls: adobe', 'viv_rur_pared1_lad': 'Walls: brick / concrete', 'viv_rur_pared2_mad': 'Walls: wood',
 'viv_rur_pared4_otros': 'Walls: other', 'viv_piso1_avan': 'Floor: parquet / tiles', 'viv_piso2_med': 'Floor: cement / brick', 'viv_techo1_teja': 'Roof: tiles',
 'viv_techo2_horm': 'Roof: concrete slab', 'viv_techo3_cal': 'Roof: metal sheet', 'viv_techo4_otros': 'Roof: straw / other', 'viv_agua2_redfue': 'Water: piped, outside dwelling',
 'viv_rur_agua1_redden': 'Water: piped, inside dwelling', 'viv_rur_agua2_mejorado': 'Water: improved source', 'viv_bano1_agua': 'Toilet: flush', 'viv_bano2_pozo': 'Toilet: pit latrine',
 'viv_eelec': 'Electricity', 'viv_dbasura': 'Garbage collection', 'viv_internet_urb': 'Broadband internet', 'viv_rur_internet': 'Internet access',
 'viv_rur_comb1_gas': 'Cooking fuel: gas', 'viv_rur_comb2_otros': 'Cooking fuel: wood / other', 'equ_refrigerador': 'Owns refrigerator', 'equ_ac': 'Owns air conditioner',
 'equ_lavadora': 'Owns washing machine', 'equ_automovil': 'Owns car'}
data = {}
for a in ('urban', 'rural'):
    r = R[a]
    data[a] = dict(curve=r['curve'], coef=[dict(l=LAB.get(c['v'], c['v']), b=c['b'], se=c['se']) for c in r['coef']],
                   dropped=[LAB.get(v, v) for v in r['dropped']], hist=r['hist'], bins=r['bins'], z=r['z_med'], decile=r['decile'],
                   rep_ex=r['rep_ex'], rep_inc=r['rep_inc'], ex=round(r['ex'] * 100, 1), inc=round(r['inc'] * 100, 1), rate=round(r['rate'] * 100, 1),
                   r2=round(r['r2'], 2), r2t=round(r['r2_test'], 2), n=r['n_households'], ntr=r['n_train'], nte=r['n_test'], nsel=r['nsel'],
                   pov=round(r['pov_net'] * 100, 1), povg=round(r['pov_gross'] * 100, 1))
data['methods'] = [["OLS (stepwise)", 44.49, 38.23, 31.01, 26.89], ["Random forest", 43.65, 45.03, 25.33, 29.06],
                   ["RF, class-weighted", 33.02, 48.03, 27.19, 28.31], ["RF, over/under-sampling", 29.83, 50.33, 27.19, 27.19],
                   ["RF, person-level weighted", 35.21, 37.01, 25.74, 17.52]]
data['imp'] = dict(urban=[["Rooms per person", 12.5], ["Dependency ratio", 11.0], ["Share aged 18–60", 7.0], ["Head: schooling", 6.8], ["Max schooling in household", 6.7], ["Share of women", 6.5], ["Member in public sector", 3.4], ["Floor: parquet / tiles", 2.8]],
                   rural=[["Share aged 18–60", 8.8], ["Head: schooling", 7.9], ["Max schooling in household", 6.6], ["Rooms per person", 5.8], ["Share of women", 5.0], ["Member in public sector", 5.0], ["Dependency ratio", 4.2], ["Cooking fuel: gas", 3.8]])
u, ru = data['urban'], data['rural']
html = open(D + '/template.html', encoding='utf8').read()
html = html.replace('/*DATA*/', 'const DATA=' + json.dumps(data, separators=(',', ':')) + ';')
for k, v in {'U_N': f"{u['n']:,}", 'R_N': f"{ru['n']:,}", 'U_POV': u['pov'], 'R_POV': ru['pov'], 'U_POVG': u['povg'], 'R_POVG': ru['povg'],
             'U_R2': u['r2'], 'R_R2': ru['r2'], 'U_NSEL': u['nsel'], 'R_NSEL': ru['nsel'], 'U_EX': u['ex'], 'U_INC': u['inc'], 'R_EX': ru['ex'], 'R_INC': ru['inc'],
             'U_R2T': u['r2t'], 'R_R2T': ru['r2t']}.items():
    html = html.replace('{{' + k + '}}', str(v))
assert '{{' not in html and '{%' not in html
open(os.path.join(D, '..', 'assets', 'html', 'pmt-slides.html'), 'w', encoding='utf8').write(html)
print(len(html))
