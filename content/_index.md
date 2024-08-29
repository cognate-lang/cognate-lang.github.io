+++
menus = 'main'
title = 'About'
+++

# Cognate

## Readable and concise concatenative programming

```cognate
~~ Fizzbuzz in Cognate

Def Multiple as (Zero? Modulo);

Def Fizzbuzz
   Case (Multiple of 15) is "fizzbuzz"
   Case (Multiple of 3)  is "fizz"
   Case (Multiple of 5)  is "buzz"
   otherwise ();

For each in Range 1 to 100 (Print Fizzbuzz)
```

Cognate is a project aiming to create a human readable programming language with as little syntax as possible. Where natural language programming usually uses many complex syntax rules, instead Cognate takes them away. What it adds is simple, a way to embed comments into statements.

```cognate
~~ Towers of Hanoi in Cognate

Def Move discs as (

   Let N be number of discs;
   Let A be first rod;
   Let B be second rod;
   Let C be third rod;

   Unless Zero? N (
      Move - 1 N discs from A via C to B;
      Prints ("Move disc " N " from " A " to " C);
      Move - 1 N discs from B via A to C;
   )
);

Move 5 discs from "a" via "b" to "c"
```

As you can see, Cognate ignores words starting with lowercase letters, allowing them to be used to describe functionality and enhance readability. This makes Cognate codebases intuitive and maintainable.

```cognate
~~ Square numbers in Cognate

Def Square as (* Twin);
Map (Square) over Range 1 to 10;
Print
```

Cognate is a stack-oriented programming language similar to Forth or Factor, except statements are evaluated right to left. This gives the expressiveness of concatenative programming as well as the readability of prefix notation. Statements can be delimited at arbitrary points, allowing them to read as sentences would in English.

```cognate
~~ Prime numbers in Cognate

Def Factor (Zero? Modulo Swap);

Def Primes (
   Let U is upper bound;
   initially List ();
   For Range 2 to U (
      Let P is potential prime;
      Let Found be list of found primes;
      Let To-check be Take-while (<= Sqrt P) Found;
      When All (Not Factor of P) To-check (
         Append P
      ) to Found
   )
);

Print Primes up to 1000;
```

Cognate borrows from other concatenative languages, but also adds unique features of its own.

- Point-free functions
- Operation chaining
- Multiple return values
- Combinator oriented programming
- Predicate pattern matching
- Natural language programming


Interested? Read the [tutorial](/learn/), check out the [interactive web playground](https://cognate-playground.hedy.dev/), or visit our [GitHub repository](https://github.com/cognate-lang/cognate).

