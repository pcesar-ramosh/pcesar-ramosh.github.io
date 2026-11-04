---
layout: page
title: Fiscal policy, informality and wealth distribution
description: A heterogeneous-agent model of fiscal policy in economies with high informality (M.Sc. thesis)
img: assets/img/projects/fiscal_policy_informality.png
importance: 1
category: Research
_styles: >
  html[data-theme="dark"] .adaptive-img { filter: invert(1) hue-rotate(180deg); }
---

**Question.** What are the effects of fiscal policy on wealth and consumption distribution in an economy with high informality?

This project was my M.Sc. thesis in Economic Engineering at the Universidad Nacional de Ingeniería (UNI, Lima, 2025), written with Ian Carrasco under the supervision of Hamilton Galindo, Ph.D. It builds on and extends the model of Galindo et al. (2024), adding consumption and income taxes and targeted transfers to study the distributional effects of fiscal policy.

**Model.**

- Heterogeneous agents: formal and informal workers. Informal workers face lower wages and higher borrowing costs, and are exempt from income taxes.
- Fiscal policy: income taxes (formal sector only), consumption taxes (all agents) and targeted transfers to informal workers.
- Solved in continuous time with the Hamilton–Jacobi–Bellman and Kolmogorov forward (Fokker–Planck) equations, using a finite-difference upwind scheme in MATLAB.

**The model, step by step:** [assumptions, equations and every derivation](/projects/fiscal-policy-informality/model/), from the household problem to the numerical solution.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/projects/thesis_consumption_policies.png" title="Consumption policy functions" class="img-fluid adaptive-img" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.liquid loading="eager" path="assets/img/projects/thesis_lorenz_wealth.png" title="Lorenz curve of wealth" class="img-fluid adaptive-img" %}
  </div>
</div>
<div class="caption">
  Baseline model of the thesis. Left: consumption as a function of assets for informal and formal workers. Right: Lorenz curve of wealth.
</div>

**Contributions.** The project brings informality into heterogeneous-agent macroeconomics as a structural feature of emerging economies, and evaluates fiscal policy under different levels of informality and under shocks such as COVID-19.

The work is part of the [Heterogeneous Agents Research Initiative](https://ri-ef.com/heterogeneous-agents-research-initiative/) at RIEF.

**Links:** [The model step by step](/projects/fiscal-policy-informality/model/) · [Code (GitHub)](https://github.com/pcesar-ramosh/fiscal_policy_informality) · [Publications](/publications/)
