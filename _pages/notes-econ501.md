---
layout: page
permalink: /notes/econ501/
title: "ECON 501: Economic Growth — Class Notes"
description: My study notes for ECON 501 at the Center for Development Economics, Williams College, Fall 2026.
nav: false
toc:
  sidebar: left
---

> These are my personal study notes for ECON 501 (Economic Growth), taught by Professor Quamrul Ashraf at the Center for Development Economics, Williams College, in Fall 2026. They summarize the lectures and readings in my own words: the models and results are not my original work, and any errors are mine. Problem-set solutions are not included.

## PPP, the Penn effect and Balassa–Samuelson

To compare living standards across countries, use PPP exchange rates, not market rates. Non-traded goods are much cheaper in poor countries, so market rates make poor countries look poorer than they are.

- **Law of one price:** a traded good costs the same everywhere in a common currency; it pins down the market exchange rate.
- **PPP exchange rate:** the rate that makes the same basket of goods cost the same in both countries.
- **Penn effect:** price levels are higher in richer countries, so for poor countries GDP at PPP is above GDP at market rates. At market rates, more people fall below a common poverty line.

$$
e_{mkt} = \frac{p_T^{A}}{p_T^{B}}, \qquad e_{PPP} = \frac{\text{cost of basket in } A}{\text{cost of basket in } B}
$$

**Balassa–Samuelson.** Workers move freely between sectors, so each country has one wage:

$$
w = p_T \, MPL_T = p_N \, MPL_N \quad\Rightarrow\quad p_N = \frac{p_T \, MPL_T}{MPL_N}
$$

The price of traded goods is the same everywhere. A rich country with much higher productivity in traded goods pays higher wages, and those wages raise the price of non-traded goods: a haircut costs more in Norway than in Nepal even if barbers are equally productive. The condition is that the rich country's productivity advantage is larger in traded than in non-traded goods.

## Inequality: Lorenz curve, Gini and Kuznets

The Lorenz curve plots the cumulative income share against the cumulative population share, from poorest to richest, and always lies below the 45° line. The Gini coefficient goes from 0 (perfect equality) to close to 1.

$$
\text{Gini} = 1 - 2 \times (\text{area under the Lorenz curve}) = 1 - \sum_i (x_i - x_{i-1})(y_i + y_{i-1})
$$

One limitation: two Lorenz curves that cross can have the same Gini, so a single number hides the shape of the distribution.

**Kuznets hypothesis:** as income per capita rises, inequality first rises and then falls (an inverted U).

- **Mechanisms:** structural change from a low-income rural sector to a high-income urban one (inequality peaks when both groups are large); early industrialization rewards capital owners and skilled workers.
- **Why inequality falls later:** mass education lowers the skill premium; redistribution; democratization; labor becomes scarce.
- **Evidence:** weak. The cross-country pattern is partly driven by middle-income Latin American countries, and inequality has risen again in many rich countries since about 1980. It is a pattern, not a law.

Inequality can help growth (the rich save more) or hurt it (credit constraints on education, political instability, pressure for distortionary redistribution).

## Growth arithmetic and factor shares

$$
y_t = y_0 (1+g)^t, \qquad g = \left(\frac{y_t}{y_0}\right)^{1/t} - 1, \qquad t = \frac{\ln(y_t / y_0)}{\ln(1+g)}
$$

Years for a poorer country (2) that grows faster to catch up with a richer one (1):

$$
t = \frac{\ln(y_1 / y_2)}{\ln\left[(1+g_2)/(1+g_1)\right]}
$$

- **Rule of 72:** doubling time is about 72 divided by the growth rate in percent.
- **Trend and volatility:** the long-run trend reflects growth policy; deviations around it reflect volatility and stabilization policy.
- **Convergence:** the data show no strong unconditional catch-up. The Solow model predicts conditional convergence: each country moves toward its own steady state.

**Factor shares.** The capital share is MPK·K/Y. With Cobb–Douglas production $$Y = AK^{\alpha}L^{1-\alpha}$$ the capital share equals α whatever the level of capital, and the data suggest α ≈ 1/3. The Solow exponent α/(1−α) is then 1/2: four times more investment gives only twice the income, so differences in capital explain only part of income gaps and productivity explains the rest.

## The Solow model

Notation: y output per worker, k capital per worker, γ investment rate, δ depreciation, n population growth, A productivity, α capital share.

$$
y = A k^{\alpha}, \qquad \Delta k = \gamma A k^{\alpha} - (n+\delta)\,k
$$

Steady state, where Δk = 0:

$$
k_{ss} = \left(\frac{\gamma A}{n+\delta}\right)^{\frac{1}{1-\alpha}}, \qquad y_{ss} = A^{\frac{1}{1-\alpha}} \left(\frac{\gamma}{n+\delta}\right)^{\frac{\alpha}{1-\alpha}}
$$

$$
c_{ss} = (1-\gamma)\,y_{ss}, \qquad \gamma_{gold} = \alpha \;\; (MPK = n+\delta), \qquad \hat{k} = \gamma A k^{\alpha-1} - (n+\delta)
$$

- The steady state is where saving γf(k) crosses the break-even line (n+δ)k. To the left, saving is above the line and k rises; to the right, k falls. The steady state is stable.
- To tell whether a country is above or below its steady state, compare γf(k) with (n+δ)k at today's k.
- If γ is above the Golden Rule level, lowering it raises consumption both now and in the long run (dynamic inefficiency).

| Change | Long run | Transition |
| --- | --- | --- |
| Higher investment rate γ | higher steady-state k and y (level only) | growth jumps, then returns to zero |
| Higher n or δ | lower steady-state k and y | negative growth, then zero |
| Higher productivity A | y jumps, then rises further as k grows | positive growth, then zero |
| Capital destroyed (war) | same steady state | fast catch-up growth |
| One-time aid or FDI | same steady state | temporary effect only |

Policy changes the level of steady-state income, not the long-run growth rate.

## Poverty traps in Solow-type models

Any variant of the model changes one of three pieces: the production function, the saving curve or the break-even line.

$$
\Delta k = s(k) - \big(n(k)+\delta\big)\,k
$$

1. Identify which piece changes.
2. Draw f(k), the saving curve and the break-even line.
3. Every crossing is a steady state; k = 0 is one too if saving is zero there.
4. Where saving is above the line, k rises; where it is below, k falls. A steady state is stable if saving cuts the line from above.
5. Interpret: the number of steady states, the threshold, and which policies work.

The textbook model has no poverty trap: γAk^α is concave and starts steeper than the line, so there is a single stable steady state with positive capital. Multiple steady states need something that bends saving up (or the line down) at some point. In a trap, small aid has no lasting effect; only a big push past the threshold does.

| Variant | What changes | Typical result |
| --- | --- | --- |
| Subsistence consumption | no saving until income covers subsistence | depending on δ, a trap at zero and a high stable steady state |
| Fertility falls above a threshold | break-even line drops at the threshold | two stable steady states separated by the threshold |
| Linear technology above a threshold | saving becomes a straight line | two clubs: stagnation or sustained growth |
| Saving rate or productivity jumps at a threshold | saving curve jumps up | two stable steady states separated by the threshold |
| Hump-shaped population growth | the line bends up, then down | low stable, middle unstable, high stable |

## The Malthusian model

$$
Y = A X^{\beta} L^{1-\beta} \quad\Rightarrow\quad y = A\left(\frac{X}{L}\right)^{\beta}
$$

Land X is fixed, so more people lower income per person; higher income raises population growth. In the steady state, population growth is zero.

| Shock | Short run | Long run |
| --- | --- | --- |
| Better technology or more land | income rises, population grows | income back to its steady state, larger population |
| Plague | fewer people, income rises | income and population return |
| More children at every income | population grows, income falls | lower income, larger population |
| Fewer children at every income (late marriage) | population falls | higher income, smaller population |

- Long-run income depends on the population-growth curve (culture, disease, marriage norms), not on technology. Before about 1800, more advanced places were denser, not richer.
- Malthus failed after about 1800 because technology grew faster than population, and the demographic transition made fertility fall as income rose.

## The demographic transition

Mortality falls first and fertility later; the gap between them produces fast population growth.

1. High births and deaths: slow growth.
2. Deaths fall, births stay high: fast growth.
3. Births fall: growth slows.
4. Low births and deaths: slow or zero growth, and the population ages.

**Measures:** crude birth and death rates (per 1,000 people a year); total fertility rate (replacement is about 2.1); life expectancy at birth; net reproduction rate (equal to 1 means a stable population in the long run).

**Why mortality fell:** better nutrition, public health (clean water, sanitation) and medicine (vaccines, germ theory, antibiotics).

**Europe and today's developing countries.** In Western Europe mortality fell slowly, from about 1750 to 1950, together with rising income, and population growth peaked at about 1% a year. In today's developing countries mortality fell fast after 1945 thanks to imported medicine and public health, at low income, while births stayed high for decades: population grew 2.5–3% a year, and the whole transition took a few decades.

**Why fertility fell:**

- Lower child mortality: fewer births are needed for the same number of surviving children.
- Income and substitution effects: higher income lets parents afford more children, but higher wages, especially women's, raise the cost of the time spent on children. In the data the substitution effect dominates.
- The quantity–quality trade-off (Becker): higher returns to education lead to fewer children and more investment in each.
- Children are less useful economically: less child labor, pensions for old age.
- Women's education and wages, contraception and urbanization.

## Age structure and the demographic dividend

When fertility falls, the working-age share rises for a few decades, so income per capita rises even if output per worker does not.

$$
D = \frac{\text{pop}_{0-14} + \text{pop}_{65+}}{\text{pop}_{15-64}} \times 100, \qquad W = \frac{100}{D + 100}, \qquad \frac{Y}{\text{population}} = \frac{Y}{\text{workers}} \times \frac{\text{workers}}{\text{population}}
$$

- **Pyramid shapes:** a true pyramid (high fertility), then a "beehive" with a working-age bulge (the dividend window is open), then a column or urn (aging).
- **Channels:** more workers per person, more women in the labor force, more saving and more schooling per child.
- **Not automatic:** the dividend needs jobs, education and financial markets, and the window closes after about 40–50 years.
- **Policy by stage:** before the window, family planning, girls' education and lower child mortality; while it is open, jobs, skills and saving; as it closes, pensions, old-age care and later retirement.
- **Population momentum:** even at replacement fertility, population keeps growing for decades.

## Income and happiness

**Easterlin paradox:** within a country richer people are happier, and richer countries are happier on average, but as a country grows its average happiness rises little or not at all.

- GDP misses leisure, home production, the informal sector, the environment, inequality and freedom. Alternatives include the HDI and subjective wellbeing (life evaluation and emotional wellbeing).
- **Explanations:** relative income (status comparisons), adaptation (the hedonic treadmill), rising aspirations and positional goods; also the costs of growth, weaker social ties, rising inequality and bounded survey scales.
- **Counter-evidence:** Stevenson and Wolfers (2008) find that happiness does rise with log income over time in many countries.
- **Implication:** in poor countries growth still raises wellbeing a lot; in rich countries, health, jobs and social ties may matter more.
