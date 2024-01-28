---
title: Variables
foo: bar
---

# {{ page.title }}

## Context

{{ context(navigation) }}

## Page

{{ context(page) | pretty }}

## Config

{{ context(config) | pretty }}

Frontmatter var - foo: {{ page.meta.foo }}

{% include 'footer.md' %}