---
name: web-prototype
description: Use this skill when specifically asked to produce any web-related prototype.
---

# Purpose

Sometimes we need to quickly produce a prototype of a website, which we can then present as a demo.
Using prototypes to demonstrate a potential product to a client can be a very advantageous way to progress a conversation about a new sale of a website solution.


# Requirements

Because we are building on-the-spot, we need to build fast and and we must be able to quickly iterate on the result afterwards.

The resulting website must be responsive and fast in terms of rendering and navigation.
I am not looking for code optimizations, but prefer cutting technical corners to make implementations as fast as possible.
E.g. by hard-coding data examples instead of finding real data by analyzing external APIs or similar.


## Architecture

The prototype must be served from a Node.js server and all the code should be raw javascript.
This is the baseline file structure. Unnecessary directories and files should be omitted:

- data/
- pages/
- server.js
- package.json

We want the option to provide API endpoints for the prototype, so we can call them from the frontend with no extra strings attached if needed.
The server should be contained in its entirety inside a single javascript file called `server.js`, which should employ static serving of the files.

Data should be declared as json and kept in the `data/` directory.
Whenever serving data from the API, it must always be served as-is, which means that the json data must appear exactly as it is required to be used.

The website code itself should aim to be pure html/css.
You are absolutely not allowed to produce html payloads on the server. All html code MUST be inside an html file.
In some cases we may need to implement javascript code for some requirements, but only when absolutely necessary.
Each page of the website should be represented by a single html file in the directory called `pages/`

The prototype should not need any authentication or authorization at all.
If you need to add a login screen to the website, do not implement actual authentication, just make a screen that mocks a login screen.
In fact, we won't need any *hard features* and everything should be mocked to appear like what it is, not actually be exactly that.

The project should include a short `package.json`, but no `.env`, `.gitignore` or similar meta files or secrets.


# Design

You will be provided with a set of visual parameters that define key visual elements of the website.
This set of parameters are much akin to a moodboard or design-guidelines and should be treated as such.

This set of parameters could include, but are not limited to:
- Color palette
    - Primary color
    - Secondary color
    - Action color
    - Text color
- Border radius
    - General border radius
    - Button border radius
    - Card border radius
- Seneral spacing sizes
    - Paddings
    - Element separation distance
- Page layout strategy
    - Header/footer
    - Menus
    - Side/top bars

If a design parameter or constraint is not specified, it does not need to be included, but you can still include it if you feel it would improve the design within the given constraints.
If you decide to include something outside the specified parameters, make sensible assumption that take into account the given design parameters.
It is of utmost importance that the prototype be implemented using *all of the given* visual parameters effectively.


## Design classes

**Minimal**
A website with Minimal design includes as few elements as necessary.
For this design class, only the specified baseline must be implemented and only the most necessary additions to bring the UI together can be extrapolated.

Rules for the Minimal design class:
- Do not use excessive animations or transitions.
- Do not use gradient colors unless explicitly specified.

**Professional**
A website with Professional design requires a strict visual expression to align with a company's existing visual branding.
This means that we are going to keep a middle road between fancyful and minimalist to keep as much relevant to the company brand but without adding unnecessary flourishes.
Usually when working in this design class, more detailed information about the requirements will be provided to you.

Rules for the Professional design class:
- Adhere strictly to the given design guidelines.
- Make up as little of the design as possible by using known and given concepts.
- Avoid using gradients for colors unless explicitly specified.
- Implement animations and transitions based on the mood conveyed by the company's brand.

**Fancy**
A website with a Fancy design takes more liberties in the visual department to wow or entice the visitor.
We rarely have constraints when working in the fancy domain and unless specified any well known strategies can be used to create a fancy design.

