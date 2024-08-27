
+++
menus = 'main'
title = 'Learn'
+++


## A brief introduction to the language


## Install


First install `CognaC` the Cognate Compiler from here using the provided instructions. Currently `CognaC` will run on recent Linux or Mac systems. Windows users can install it onto the Windows Subsystem for Linux - native Windows support is planned.

Invoking `CognaC` is simple. If you have a file named `foo.cog` containing a Cognate program, it can be compiled into an executable named `foo` with the following command.


```
cognac foo.cog
```


To compile a debug executable, which will run slower but give a nice backtrace if there's an error, you can use the `-debug` flag.

Alternatively, you can use the interactive web playground [here](https://cognate-playground.hedy.dev/) which runs Cognate programs client-side in the browser. It also has intelligent syntax highlighting, code folding, and error reporting in the editor


## First Programs


```
Print "Hello world!";
```

Fairly simple right? This example calls the `Print` function with one parameter - the string `"Hello world!"`. Now let's do another simple example, adding two numbers.

```
Print + 2 3;
```


Wait what? That isn't how maths works!

Cognate doesn't care how maths works. Where in most programming languages, `+` would be an operator and would be used in the infix position, in Cognate `+` is a function. Like `Print`, the `+` function is called by being written before its arguments like shown above.


```
Print - 10 36; ~~ Subtracts 10 from 36
```

Another thing to note is that the order of parameters for `-` and `/` are backwards. The reason for this will become clear later. Also note that line comments are started with `~~`.

## The Stack

Let's have a more complex example, this subtracts 12 from 15 and then multiplies the result by 2.

```
Print * 2 - 12 15;
```

By now you may have realised that Cognate is evaluating our programs backwards - right to left. The subtraction is being performed before the multiplication above. This is being done using a stack, as explained here.

- Place 15 on top of the stack
- Place 12 on top of the stack
- Remove the top two numbers from the stack, subtract them and put the result (3) on top of the stack
- Place 2 on top of the stack
- Remove the top two numbers from the stack, multiply them and put the result (6) on top of the stack
- Remove the top number from the stack, print it


Cognate comes with functions to manipulate the stack. The simplest of these is `Twin`, which takes the top element from the stack, and puts it back on again - twice. The below snippet uses `Twin` to square a number by multiplying it by itself.

```
Print * Twin 8;
```

Now we don't want to write this every time we square a number right? So let's create a `Square` function to do this for us.

## First Functions

Functions in Cognate are defined using `Def` and the name of the function. The function body is put in brackets after this.

```
Def Square (* Twin);
Print Square 8;
```

This is great, but it certainly could flow better. Cognate ignores words starting with lowercase letters, allowing them to be used as comments. This lets us write:

```
Print the Square of 8;
```


In this example the readability isn't really improved much, but in more complex programs this informal syntax can be invaluable.

By now you've probably noticed the semicolons. These delimit statements so that Cognate knows what order to evaluate functions in (remember that these are executed backwards). Definitions should also be terminated with semicolons. The stack persists between statements, letting us do things like this.


```
8 ; Square ; Print ;
```

or this

```
Square 8 ; Print ;
```

or this

```
8 ; Print the Square ;
```

This flexible syntax allows Cognate programs to flow as if written in sentences. It also means that much of the time variables are not even needed. Of course, Cognate *does* have variables.

## Variables

Variables are defined in a fairly similar manner to functions using `Let` and their name. This takes a value from the stack, binding it to this name. Variables are referenced with the same syntax in which functions are called.

```
Let X be 4;
Print X;
```

We can use variables to define functions that take named parameters - here's an alternate version of the `Square` function.

```
Def Square as (
   Let X;
   * X X
);
```

Notice that the last statement before a closing bracket does not need to be terminated with a semicolon. Also there is no return statement, since values are implicitly returned on the stack. This means we can actually define functions that return multiple values, such as the `Twin` function we saw earlier.

```
Def Twin as (
   Let X;
   X X
);
```


## Control Flow

Like most programming languages, Cognate has if statements and loops and all that jazz. The simplest form of control flow is `When`, which simply executes a block of code if given `True` or not if `False`.

```
When == 1 1 (
   Print "Who'd have guessed?"
);
```

There is also `Unless` that evaluates the block if given `False`. `While` takes a condition in brackets and evaluates the block of code until the condition is `False`. `Until`, you guessed it, is the opposite of `While` and runs until the condition is `True`.

```
While (True) (
   Print "This may well print forever"
);
```

What's with the second set of brackets? `When` doesn't have them, so why should `While`? This is because brackets denote blocks! These prevent code being instantly evaluated and instead push a reference onto the stack. Blocks also control variable scopes. We can evaluate a block using the `Do` function - which is how our control flow functions are implemented.

```
Do (
   Print "Hello from inside a block!"
);
```


This explains the syntax for functions: `Def` simply binds a block to a name, much like `Let`. Blocks can be passed around the program like any other value - even if they reference variables that go out of scope.

Now that this (hopefully) makes some sense, we can finally introduce the `If` statement! `If` is a function that takes three parameters. The first is a boolean, if this is `True` then the second argument is returned. If not, the third argument is returned. We can chain `If`s together to have more complex control flow.


```
Print
   If == X 1 then "foo"
   If == X 2 then "bar"
             else "baz";
```

We can combine this with `Do` to have conditional code execution.

```
Do
   If == X 1 then ( Print "foo" )
   If == X 2 then ( Print "bar" )
             else ( Print "baz" );
```

Now, lets use our knowledge of blocks to define our own control flow function `Thrice`, which should evaluate a block three times in a row. This demonstrates a different use of `Def` in which we bind a block from the stack.

```
Def Thrice as (
   Def F;
   F F F
);

Thrice (
   Print "hip hip hooray!"
);
```

A more general version of this function, `Times` can be defined using recursion.

```
Def Times (
	Let N number of repetitions;
	Def F function to repeat;
	Unless Zero? N ( F ; Times - 1 N (F) );
);

Times 5 (
	Print "wow!";
);
```

Now you may see a small problem with this. If the user calls `Times` with a non-integer parameter it will loop forever - that won't do at all! We use the `Integer!` function to throw a type error if a decimal is given.

```
Def Times (
	Let N is Integer! number of repetitions;
	Def F function to repeat;
	Unless Zero? N ( F ; Times - 1 N (F) );
);
```


We could also use the `Block!` function for `F` but we'll already get a type error when we use `Def` to bind anything that isn't a block, so there is no point.

The `Times` function is also our first loop. We don't need to define it every time though as it's also in the standard library. Another loop is `While`.


```
While (!= "done" Twin Input) (
  Print
);
Drop;
```


`While` takes two block parameters. The first one is the condition and is evaluated immediately, returning a boolean. If this is `True` then the second block (the loop body) is evaluated and then the loop repeats, if not the loop finishes. The example above shows the use of a `While` loop. The program simply echoes the user's inputs back to them until they write `"done"`.

This loop is most useful in imperative code where intermediary values are passed on the stack between iterations. It is less useful for iterating over data structures such as lists. Lists?


## Lists

In Cognate, lists are generated using - you guessed it - a function. The `List` function takes a block as a parameter. It evaluates this block *in a new stack* and then returns that stack as a list.

```
Print List (1 2 3 4 5);
```

This allows Cognate's list creation to be much more flexible than other languages - for example what if we wanted a list of 100 ones?

```
Print List ( Times 100 (1) );
```


The three most fundamental list functions are `Push`, `First`, and `Rest`.

 The `Push` function takes a value and a list as parameters, and returns the list with the value *pushed* to it's first element. `First` simply returns the first element of a list. `Rest` returns a list without its first element.


```
Let L be Push "foo" to List ( "bar" "baz" );
Print First element of L;
Print Rest of L;
```

`Range` creates a list of numbers from a starting (inclusive) and an ending (exclusive) number. `For` is a higher order function that applied an operation to each element of a list - it is the loop for iterating over lists.

```
Def Square as (* Twin);
For each in Range 1 to 20 (Print the Square);
```

`Map` is like `For` but the result of the computation is stored in a new list.

```
Let Evens be Map (* 2) over Range 1 to 50;
Print Evens;
```

`Filter` applies a function to each element of a list also. This function should return a boolean - if this is `False` then the function is removed from the returned list.

```
Let Even? be (Zero? Modulo 2);
Let Evens be Filter (Even?) over Range 1 to 100;
Print Evens;
```

The functional programmers reading this are likely expecting a Fold or Reduce function next - which applies an operation to a list with an accumulator. However Cognate needs no fold function, as `For` can store intermediary values on the stack, acting like a fold.

```
Def Factorial as (
   Let N be Integer!;
   For each in Range 1 to N (*) from 1;
);

Print Factorial 10;
```


## Boxes


While storing state between loop iterations is very useful, in some cases you just need mutable variables. Cognate's boxes are references used to generalise the concept of mutation.

 The `Box` function takes a value and places it in a box. `Unbox` returns the item stored in a box. `Set` takes a box and a value as parameters and mutates the box to hold the value, updating all references to it.


```
Let X be Box 1;
Print Unbox X; ~~ prints 1

Set X to 2;
Print Unbox X; ~~ prints 2
```

Boxes aren't limited to mutating variables, they can be used for any value.

```
Let L be Map (Box) over Range 1 to 10;
Print L;

For each in L (
   Let X;
   Set X to * 2 Unbox X; ~~ double the element in place
);
Print L;
```

While boxes may not seem as ergonomic as mutation in other languages, they are both more flexible than mutable variables and more predictable than implicit references. We can also easily extend mutation, like this:

```
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


## Todo

This tutorial isn't finished yet!
