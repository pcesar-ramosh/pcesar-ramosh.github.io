---
layout: page
title: "Proxy Means Test: Targeting Poor Households"
description: Interactive slides on how we designed a first PMT for Bolivia, the targeting errors and how to reduce them
img: assets/img/projects/pmt_targeting.png
importance: 2
category: Policy
---

When income cannot be verified, a social registry needs another way to rank households by need. A proxy means test (PMT) predicts household welfare from characteristics that are easy to observe, such as demographics, housing and durable goods. These slides explain how a government technical team I was part of built a first PMT for Bolivia with the 2023 Household Survey.

**What the slides cover**

- The assumptions behind the design: the welfare metric, why state transfers are excluded, and why urban and rural areas get separate models.
- The model: weighted least squares with stepwise selection, validated on a 20% test sample, and compared with random forest variants.
- Exclusion and inclusion errors, the trade-off between them, and the options to reduce exclusion errors.
- The feedback we received from an external review, and the next steps.

<div style="position: relative; width: 100%; padding-bottom: 56.25%; margin: 1.5rem 0 0.5rem;">
  <iframe src="{{ '/assets/html/pmt-slides.html' | relative_url }}" title="Proxy Means Test slides" style="position: absolute; inset: 0; width: 100%; height: 100%; border: 1px solid #ccc; border-radius: 8px;" allowfullscreen loading="lazy"></iframe>
</div>
<div class="caption">
  Use the arrows or the keyboard to move between slides; the charts are interactive. <a href="{{ '/assets/html/pmt-slides.html' | relative_url }}" target="_blank" rel="noopener">Open the slides in a new tab</a> for full screen.
</div>

**Method in brief.** The target is monthly household income per capita net of state transfers. For each area, the log of income is regressed on demographic, housing and asset variables with survey weights; variables enter by forward stepwise selection and region effects are added. Households in the test sample are ranked by predicted income and classified with a cutoff, and the result is compared with their actual poverty status.

The charts marked "own calculations" come from my Python replication of the estimation with the public survey microdata.
