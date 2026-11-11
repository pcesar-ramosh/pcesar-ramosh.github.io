---
layout: page
title: "Proxy Means Test: Targeting Poor Households"
description: Econometric and machine-learning household classification with Bolivia's 2023 Household Survey
img: assets/img/projects/pmt_targeting.png
importance: 2
category: Policy
---

**Authors:** **Evelyn Mamani, Cesar Ramos and Varinia Tarqui** (alphabetical order by surname).

A social registry has to rank households by need, but in an economy with high informality income cannot be verified. A proxy means test (PMT) predicts household welfare from characteristics that an interviewer can observe: demographics, housing conditions and durable goods. The slides below present the PMT we estimated for Bolivia with the 2023 Household Survey, as part of a government technical team.

**Contents**

- Design assumptions: the welfare metric, the exclusion of state transfers, and separate models for urban and rural areas.
- Estimation: weighted least squares with stepwise selection, validated on a 20% test sample and compared with random forest variants.
- Exclusion and inclusion errors, the trade-off between them, and the options to reduce exclusion errors.
- Recommendations from an external review, and next steps.

<div style="position: relative; width: 100%; padding-bottom: 56.25%; margin: 1.5rem 0 0.5rem;">
  <iframe src="{{ '/assets/html/pmt-slides.html' | relative_url }}" title="Proxy Means Test slides" style="position: absolute; inset: 0; width: 100%; height: 100%; border: 1px solid #ccc; border-radius: 8px;" allowfullscreen loading="lazy"></iframe>
</div>
<div class="caption">
  Move with the arrows or the keyboard. <a href="{{ '/assets/html/pmt-slides.html' | relative_url }}" target="_blank" rel="noopener">Open in a new tab</a> for full screen.
</div>

**Method.** The target is monthly household income per capita net of state transfers. For each area, log income is regressed on demographic, housing and asset variables using survey weights; variables enter by forward stepwise selection and region effects are added. Households in the test sample are ranked by predicted income and classified with a cutoff, and the classification is compared with their actual poverty status.

Charts labelled "own calculations" are computed from the public survey microdata.
