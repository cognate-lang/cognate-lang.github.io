+++
menus = 'main'
title = 'Learn Cognate'
+++

# Learn Cognate

## A brief introduction to the language


## Setup

First get hold of one of Cognate's implementations; installation and invocation instructions are on the respective pages.

- [CognaC](https://github.com/cognate-lang/cognate) is the original compiler -- it performs type inference and produces efficient binaries.
- [Cognate Playground](https://cognate-playground.hedy.dev/) (developed by [hedyhli](https://github.com/hedyhli)) runs Cognate programs in a web browser, requiring no installation.
- [Cogni](https://github.com/dragoncoder047/cogni) (developed by [dragoncoder047](https://github.com/dragoncoder047)) interprets Cognate programs and is optimised to run on microcontrollers.

If you're using `CognaC`, you can compile a Cognate file named `foo.cog` into an executable named `foo` with the following command.
```
cognac foo.cog
```

To compile a debug executable, which will run slower but give a nice backtrace if there's an error, you can use the `-debug` flag.

## First Programs

```cognate
Print "Hello world!";
```

Fairly simple right? This example calls the `Print` function with one parameter -- the string `"Hello world!"`. Now let's do another simple example, adding two numbers.

```cognate
Print + 2 3;
```


Wait what? That isn't how maths works!

Cognate doesn't care how maths works. Where in most programming languages, `+` would be an operator and would be used in the infix position, in Cognate `+` is a function. Like `Print`, the `+` function is called by being written before its arguments like shown above.


```cognate
Print - 10 36; ~~ Subtracts 10 from 36
```

Another thing to note is that the order of parameters for `-` and `/` are backwards. The reason for this will become clear later. Also note that line comments are started with `~~`.

## The Stack

Let's have a more complex example, this subtracts 12 from 15 and then multiplies the result by 2.

```cognate
Print * 2 - 12 15;
```

By now you may have realised that Cognate is evaluating our programs backwards -- right to left. The subtraction is being performed before the multiplication above. This is being done using a stack, as explained here.

- Place 15 on top of the stack
- Place 12 on top of the stack
- Remove the top two numbers from the stack, subtract them and put the result (3) on top of the stack
- Place 2 on top of the stack
- Remove the top two numbers from the stack, multiply them and put the result (6) on top of the stack
- Remove the top number from the stack, print it


Cognate comes with functions to manipulate the stack. The simplest of these is `Twin`, which takes the top element from the stack, and puts it back on again -- twice. The below snippet uses `Twin` to square a number by multiplying it by itself.

```cognate
Print * Twin 8;
```

Now we don't want to write this every time we square a number right? So let's create a `Square` function to do this for us.

## First Functions

Functions in Cognate are defined using `Def` and the name of the function. The function body is put in brackets after this.

```cognate
Def Square (* Twin);
Print Square 8;
```

This is great, but it certainly could flow better. Cognate ignores words starting with lowercase letters, allowing them to be used as comments. This lets us write:

```cognate
Print the Square of 8;
```


In this example the readability isn't really improved much, but in more complex programs this 'informal syntax' can be invaluable.

By now you've probably noticed the semicolons. These delimit statements so that Cognate knows what order to evaluate functions in (remember that these are executed backwards). Definitions should also be terminated with semicolons. The stack persists between statements, letting us do things like this.


```cognate
8 ; Square ; Print ;
```

or this

```cognate
Square 8 ; Print ;
```

or this

```cognate
8 ; Print the Square ;
```

This flexible syntax allows Cognate programs to flow as if written in sentences. It also means that much of the time variables are not even needed. Of course, Cognate *does* have variables.

## Variables

Variables are defined in a fairly similar manner to functions using `Let` and their name. This takes a value from the stack, binding it to this name. Variables are referenced with the same syntax in which functions are called.

```cognate
Let X be 4;
Print X;
```

We can use variables to define functions that take named parameters -- here's an alternate version of the `Square` function.

```cognate
Def Square as (
	Let X;
	* X X
);
```

Notice that the last statement before a closing bracket does not need to be terminated with a semicolon. Also there is no return statement, since values are implicitly returned on the stack. This means we can actually define functions that return multiple values, such as the `Twin` function we saw earlier.

```cognate
Def Twin as (
	Let X;
	X X
);
```


## Control Flow

Like most programming languages, Cognate has if statements and loops and all that jazz. The simplest form of control flow is `When`, which simply executes a block of code if given `True` or not if `False`.

```cognate
When == 1 1 (
   Print "Who'd have guessed?"
);
```

There is also `Unless` that evaluates the block if given `False`. `While` takes a condition in brackets and evaluates the block of code until the condition is `False`. `Until`, you guessed it, is the opposite of `While` and runs until the condition is `True`.

```cognate
While (True) (
   Print "This may well print forever"
);
```

What's with the second set of brackets? `When` doesn't have them, so why should `While`? This is because brackets denote blocks! These prevent code being instantly evaluated and instead push a reference onto the stack. Blocks also control variable scopes. We can evaluate a block using the `Do` function -- which is how our control flow functions are implemented.

```cognate
Do (
   Print "Hello from inside a block!"
);
```


This explains the syntax for functions: `Def` simply binds a block to a name, much like `Let`. Blocks can be passed around the program like any other value -- even if they reference variables that go out of scope.

Now that this (hopefully) makes some sense, we can finally introduce the `If` statement! `If` is a function that takes three parameters. The first is a boolean, if this is `True` then the second argument is returned. If not, the third argument is returned. We can chain `If`s together to have more complex control flow.


```cognate
Print
	If == X 1 then "foo"
	If == X 2 then "bar"
	          else "baz";
```

We can combine this with `Do` to have conditional code execution.

```cognate
Do
	If == X 1 then ( Print "foo" )
	If == X 2 then ( Print "bar" )
	          else ( Print "baz" );
```

Now, let's use our knowledge of blocks to define our own control flow function `Thrice`, which should evaluate a block three times in a row. This demonstrates a different use of `Def` in which we bind a block from the stack.

```cognate
Def Thrice as (
	Def F;
	F F F
);

Thrice (
   Print "hip hip hooray!"
);
```

A more general version of this function, `Times` can be defined using recursion.

```cognate
Def Times (
	Let N number of repetitions;
	Def F function to repeat;
	Unless Zero? N ( F ; Times - 1 N (F) );
);

Times 5 (
	Print "wow!";
);
```

Now you may see a small problem with this. If the user calls `Times` with a non-integer parameter it will loop forever -- that won't do at all! We can use the `Of` function here -- it checks a value against a predicate (in this case `Integer?`) and throws an error if it fails.

```cognate
Def Times (
	Let N be Of (Integer?) number of repetitions;
	Def F function to repeat;
	Unless Zero? N ( F ; Times - 1 N (F) );
);
```

We could also use `Of (Block?)` for `F` but we'll already get a type error if we use `Def` to bind anything that isn't a block, so there is no point.


## Lists

In Cognate, lists are generated using -- you guessed it -- a function. The `List` function takes a block as a parameter. It evaluates this block *in a new empty stack* and then returns that stack as a list.

```cognate
Print List (1 2 3 4 5);
```

This allows Cognate's list creation to be much more flexible than other languages -- for example what if we wanted a list of 100 ones?

```cognate
Print List ( Times 100 (1) );
```

The three most fundamental list functions are `Push`, `First`, and `Rest`.

The `Push` function takes a value and a list as parameters, and returns a new list list with the value as it's first element and the list parameter providing following elements. `First` simply returns the first element of a list. `Rest` returns a list without its first element.


```cognate
Let L be Push "foo" to List ( "bar" "baz" );
Print First element of L;
Print Rest of L;
```

There's also an `Index` function which takes an integer parameter and a list, returning the corresponding list index (indexed from zero of course).

`Range` creates a list of numbers from a starting (inclusive) and an ending (exclusive) number. `For` is a higher order function that applied an operation to each element of a list -- it is the loop for iterating over lists.

```cognate
Def Square as (* Twin);
For each in Range 1 to 20 (Print the Square);
```

`Map` is like `For` but the result of the computation is stored in a new list.

```cognate
Let Evens be Map (* 2) over Range 1 to 50;
Print Evens;
```

`Filter` applies a function to each element of a list also. This function should return a boolean -- if this is `False` then the function is removed from the returned list.

```cognate
Def Even? as (Zero? Modulo 2);
Let Evens be Filter (Even?) over Range 1 to 100;
Print Evens;
```

The functional programmers reading this are likely expecting a Fold or Reduce function next -- which applies an operation to a list with an accumulator. However Cognate needs no fold function, as `For` can store intermediary values on the stack, acting like a fold.

```cognate
Def Factorial as (
   Let N be Of (Integer?);
   For each in Range 1 to N (*) from 1;
);

Print Factorial 10;
```

For the sake of convenience Cognate *does* provide `Fold`, which has the order of parameters swapped:

```cognate
Def Factorial as (
   Let N be Of (Integer?);
   Fold (*) from 1 over Range 1 to N;
);

Print Factorial 10;
```

## Boxes

While storing state between loop iterations is very useful, in some cases you just need mutable variables. Cognate's box type implements a reference and generalises mutation.

 The `Box` function takes a value and places it in a box. `Unbox` returns the item stored in a box. `Set` takes a box and a value as parameters and mutates the box to hold the value -- this affects all references to it.


```cognate
Let X be Box 1;
Print Unbox X; ~~ prints 1

Set X to 2;
Print Unbox X; ~~ prints 2
```

Boxes aren't limited to mutating variables, they can be used for any value.

```cognate
Let L be Map (Box) over Range 1 to 10;
Print L;

For each in L (
   Let X;
   Set X to * 2 Unbox X; ~~ double the element in place
);
Print L;
```

While boxes may not seem as ergonomic as mutation in other languages, they're both more flexible than mutable variables and more predictable than implicit references. We can also easily extend mutation, like this:

```cognate
Def Box-list as ( Map (Box) );

Def Inplace-map as (
	Def F;
	Let L;
	For each in L ( Let X ; Set X to F Unbox X );
);

Let L be Box-list Range 1 to 10;
Print L;

Inplace-map (* 2) over L;
Print L;
```

## Tables

The table type provides an efficient, immutable, unordered mapping between keys and values, which can be used to implement many more complex data structures. `Table` creates a table in the same manner in which `List` creates a list, though taking key-value pairs. `.` is used to extract the value corresponding to a key.

```cognate
Let T be Table (
	"foo" is 1;
	"bar" is Range 2 to 10;
	12 is 13; ~~ Keys can be of any type except box or block
);

Print . "foo" T;
Print . "bar" T;
```

`Insert` returns the table with an extra key-value pair, `Remove` returns the table without a specified key, and `Has` checks whether a key is in the table.

```cognate
Def Remove-baz (
	Remove "baz"
	from Of (Has "baz")
	     Of (Table?);
);

Insert "baz" is Range 11 to 100 into T;
Print Twin;
Remove-baz;
Print;
```

`Keys` and `Values` returns lists of the keys and values respectively in a table, in no particular order. Tables are implemented as self-balancing binary trees, and are optimised for fast immutable insertions.

## Symbols

Typically, you'd want to use a *symbol* as a key for your table. Symbols will be familiar to Lisp programmers and can be considered as either a limited string or an unlimited enum, depending how you like to think.

```cognate
\foo ~~ This is a symbol
```

Symbols can't be modified in any way, but can be compared very efficiently (which is why they're great keys for tables) and put into any data structure.

## Begin

Earlier when we defined loops, you may have noticed something missing -- the break statement. Being a functional language, Cognate discourages this sort of control flow, but sometimes you've just gotta get out of a block early. Introducing `Begin` -- this function takes a block parameter and evaluates it, passing it *another* block on the stack. Evaluating *that* block will jump you out of the original block. Confused? Here's an example.

```cognate
~~ Let's print the numbers up to 100 in an unnecessarily complicated manner.
Let I be 1;

Begin (
	Def Break;
	While (True) (
		Print Unbox I;
		Set I to + 1 of Unbox I;
		When == 101 Unbox I ( Break out of the begin );
	)
);
```

This essentially allows any control flow to have a break statement, not just loops. `Begin` can also be used to implement a return statement to break out of a function early.

```cognate
~~ Inefficiently decrements a number 100 times
~~ If it reaches zero, returns zero instead.
Def F (
	Begin (
		Def Return;
		Let X be Box Of (Integer?);

		Times 100 (
			Set X to - 1 Unbox X;
			When Zero? Unbox X ( Return 0 );
		);
		Return Unbox X;
	)
);
```

An advantage of `Begin` over traditional programming languages' break and return statements is that it gives fine-grained control over which block you break out of, since nested `Begin` statements can have their exit blocks bound to different names.

## End

Nope, there isn't an `End` function. This is just the end of the tutorial.

Check out the [prelude](/reference/prelude/) to continue exploring.
