---
name: recipe-scraper
description: Scrape recipes off of the internet. Use this skill when asked to scrape recipes off of the internet.
---

# Recipe Scraper

You scrape food recipes off of the internet and create markdown files with their content.
These recipes are typically website articles or blog posts, and they are most often in Danish or English.

You must follow these rules when scraping food recipes.

- You must retain the existing language the recipe is written in.
- You must include JSON-LD data where available.
- You must include the entire recipe and only the recipe content.
- You must not add to, remove from, infer, summarize, clarify, or otherwise alter the recipe text.

You are allowed to use any available tool you deem the most efficient at completing the task.
You must keep all file manipulation local the the current working directory.


## Strategy

Prioritize fetching all data into local markdown files first, roughly following the formatting outline.
After fetching, report the results briefly and let the user determine when to proceed.
Only when recipe text data is available locally should you begin formatting the content in detail.

The original content is the ultimate, single source of truth and must not be manipulated.
When the recipe content includes an ingredient list, it must be used instead of JSON-LD ingredient data to retain sub-headers, sub-sections, and other details.


## Content

The output content should be pretty, human readable, and pleasant to peruse.

All machine readable data should be translated to human readable text.

You must make an effort to scrape around content that is unrelated to the recipe itself.

Do not include the following:

- Ads
- Links to related or suggested recipes
- Nutrition tables not directly related to the recipe
- Newsletter blocks
- Comment sections
- Interactive elements, including "add to shopping cart" or "add to diet plan", etc.
- Website components like headers, footers, sidebars, menus, etc.
- Other similar features unrelated to the recipe

### Format

You should follow the format, but do not mangle the recipe.
If the recipe itself calls for specialized explanations, include such sections as they are represented in the recipe.

The format is not exhaustive, so add fields that are not included in the example.
Do not include fields in the markdown that are not present in the recipe data.

Use this format for recipe markdown file contents:

```
# Dish Name

Source: https://example.com/recipe-slug/

Recipe summary...

## Details

- **Servings:** 4 servings
- **Prep time:** 20 minutes
- **Cook time:** 40 minutes
- **Total time:** 1 hour
- **Category:** Dinner
- **Cuisine:** Danish

## Ingredients

- 400 g. meat
- 1 onion
- 2 cloves of garlic

### Optional header

- fresh basil
- salt/peber
- 1 clove of garlic
- pinch of ginger

## Instructions

Instruction text body, which may include lengthy explanation.

1. It may also include a list.
2. The list boundaries should be respected.

More instructions that are not included in the list above.

- Some lists are not numbered.
- Such lists must also be included.

Include all recipe related text.

### Optional header

Recipes may include extra headers as part of the text.
```

### Editorializing

- Avoid text bodies of alternating text lines and blank lines by grouping lines in natural paragraphs where it makes sense.
- Avoid long lines of text with multiple sentences by breaking them sensibly into multiple lines.
- If the recipe contains several steps presented in a list, retain that list.
- If a list only has a single element, attempt to break it up into a more sensible list.
- If a single-element list cannot be meaningfully be broken into smaller items, convert the list into a text body.

#### Headers

Make sure to include appropriate header markup in the recipe text, even if the text doesn't have any.
Headers could be created with CSS and we should attempt to recreate what was lost in scraping.

Attempt to create meaningful headers in the text content where they appear missing.
Typically missing headers are a single word or a few words making up a concept that is itself not a sentence or recipe instruction.

This is an example of how missing header markup could appear.

```
First step <-- this should be a header

Gather the ingredients and...
Lets prepare...

Cutting <-- YES, this should be a header

Cut the vegetables in sizes of... 
Remember to...

Cooking time <-- YES, this should be a header

Cook in the oven for...
Serve the dish like...

Enjoy <-- NO, clearly not a meaningful header
```


## Failure

Keep a running markdown failure log in the local project/repository/folder root or use an existing file created for this exact purpose, if one exists.
Add any relevant message returned by the server or recap the unexpected results.

Keep the list short and sweet, as it is meant to help understand why the request failed and if anything can be done.

We are not trying to document failures specifically.

Include every failure grouped by URL like this:

```
- https://recipes.com/food-dish
    - HTTP 404 Not Found
- https://example.com/recipe
    - Website appears abandoned or owner has changed.
```
