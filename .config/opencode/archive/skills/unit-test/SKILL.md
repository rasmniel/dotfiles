---
name: unit-test
description: This simple outline of how to write pretty and efficient unit tests must be used whenever writing unit testing.
---

# Core testing values

Unit tests should be simple, thorough, and easy to maintain.


## Full coverage

Tests should be exhaustive but not verbose.
When testing we have a strong focus on coverage.
Statement and branch coverage of 100% is always desired, unless otherwise stated.


## Separation of concerns

When writing test cases, it is crucially important to employ appropriate separation of concerns between the units being tested.

**Correct example 1**
A class has a method that returns a string if the input is valid and throws an error if it is not.
We implement a test case such that we can verify that the output string is correct and no error is thrown.
If errors are thrown the test case was incorrect, so we know that errors will not be thrown if the test works.
We ALSO implement a different test case that only provides invalid inputs and asserts that the error is thrown every time.
If errors are not thrown, the test case was incorrect, so we know that errors must be thrown if the test works.
These two test cases are great, and we can know when behavior goes wrong for invalid inputs and when it goes wrong for valid inputs explicitly, because we didn't chunk these two cases into one.

**Correct example 2**
A simple function returns some non-empty string value if the input is valid and an empty string if it is not.
We implement a test case that inputs valid strings and verify that the output is correct.
In this case we add a few lines to add null-values and other invalid values to the input, and successfully assert that the resulting string is empty.
Because the function is simple, we can assert that a branch inside it returns either a non-empty string or falls back to an empty string.
If this function breaks, it would likely return incorrect results regardless if the input is valid or not.
Because the assertions are so simple and because valid inputs are handled identically to invalid inputs, that we don't achieve anything by splitting them into multiple test cases.

**Incorrect example**
A class concatenates strings with the use of chaining for easier syntax.
We produce a test case for this class, that simply puts in a few strings and verifies the output to be correct.
However, we also want to verify the chaining works as intended.
Since we already did chaining to verify the concatenation works, we can just add a single expect statement to the case that asserts object returns as-is after chaining.
This would be wrong, and would result in a test case that handles multiple units, and that can break for more than one reason.

**Rule of thumb**
This separation concept can be boiled down to: if the name of the test case includes the word "and", you are probably writing two test cases into one and should reconsider the case.


## Brevity and reuse

It is important to remember that tests may very likely be let to a human to maintain.
Because of this, a smaller amount of testing code is better than being very expressive with test implementation.

Reuse of variables as they would be in conventional development is required to avoid repetetive dot notation and indexing of arrays and object fields.

In test cases comparing more than 1 object (e.g. a model) to mocked data, it is better to build a small function to generate them than to list the literal objects verbatim, 
This is predicated upon the function not taking up more code than a single object or than the repetetive code it would otherwise replace.


## Mock data

Do not reference literal mock data in test cases.
When modifying data for the purpose of testing, change a clone of the data to avoid polluting scoped test data.
