---
layout: page
permalink: /repositories/
title: Repositories
description: Code for my research and teaching.
nav: true
nav_order: 4
---

<!-- The cards on this page come from _data/repositories.yml. Edit that file to add, remove or change a repository. -->

<style>
  .repo-card .card-title { font-size: 1.15rem; margin-bottom: 0.5rem; }
  .repo-card .card-text { font-size: 0.95rem; }
  .repo-card .repo-name { font-size: 0.8rem; color: var(--global-text-color-light); }
  .repo-card .repo-lang {
    display: inline-block; font-size: 0.75rem; padding: 0.1rem 0.5rem; margin: 0 0.25rem 0.25rem 0;
    border: 1px solid var(--global-divider-color); border-radius: 1rem; color: var(--global-text-color);
  }
  .repo-profile { margin-bottom: 1rem; }
</style>

{% assign repo_data = site.data.repositories %}

<p class="repo-profile">
  <a href="https://github.com/{{ repo_data.github_user }}" target="_blank" rel="noopener noreferrer"><i class="fa-brands fa-github"></i> See all my repositories on GitHub (github.com/{{ repo_data.github_user }})</a>
</p>

<div class="projects">
{% for group in repo_data.groups %}
  <h2 class="category">{{ group }}</h2>
  <div class="row row-cols-1 row-cols-md-2">
  {% for repo in repo_data.repositories %}
    {% if repo.group == group %}
    <div class="col">
      <a href="https://github.com/{{ repo.name }}" target="_blank" rel="noopener noreferrer">
        <div class="card h-100 hoverable repo-card">
          <div class="card-body">
            <h3 class="card-title"><i class="fa-brands fa-github"></i> {{ repo.title }}</h3>
            <p class="card-text">{{ repo.description }}</p>
            <div>
              {% for language in repo.languages %}<span class="repo-lang">{{ language }}</span>{% endfor %}
            </div>
            <div class="repo-name">{{ repo.name }}</div>
          </div>
        </div>
      </a>
    </div>
    {% endif %}
  {% endfor %}
  </div>
{% endfor %}
</div>
