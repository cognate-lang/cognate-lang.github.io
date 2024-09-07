+++
title = "Prelude"
+++

# Prelude

## Drop

Discard the top stack item.

```cognate
Print Drop "foo" "bar";
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L8-L8">Source</a></summary>

```cognate
Def Drop as ( Let X );
```

</details>

## Swap

Swaps the top two stack items.

```cognate
Print Swap 1 2;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L17-L17">Source</a></summary>

```cognate
Def Swap as ( Let X ; Let Y ; Y X );
```

</details>

## Do

Execute a block.

```cognate
Do ( Print "hello world!" );
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L26-L26">Source</a></summary>

```cognate
Def Do as ( Def F ; F );
```

</details>

## Any?

Takes a parameter of any type and returns True

```cognate
Print Any? 12;
Print Any? "hello";
Print Any? List (1 2 3);
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L37-L37">Source</a></summary>

```cognate
Def Any? ( True Drop );
```

</details>

## Twin

Duplicate the top stack item.

```cognate
Def Square as (* Twin);
Print Square 8;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L48-L48">Source</a></summary>

```cognate
Def Twin as (Let X ; X X);
```

</details>

## Triplet

Triplicates the top stack item

```cognate
Def Cube as (* * Triplet);
Print Cube 8;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L58-L58">Source</a></summary>

```cognate
Def Triplet as (Twin ; Twin);
```

</details>

## When

Takes a boolean (`Cond`) and a block (`F`) as parameters. Executes `F`, given `Cond` is True.

```cognate
When True ( Print "hello!" );
When False ( Print "bye!" );
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L68-L72">Source</a></summary>

```cognate
Def When as (
	Let Cond;
	Def F;
	Do If Cond then ( F ) else ();
);
```

</details>

## Unless

Opposite of `When`. Takes a boolean (`Cond`) and a block (`F`) as parameters. Executes `F`, given `Cond` is False.

```cognate
Unless True ( Print "hello!" );
Unless False ( Print "bye!" );
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L82-L86">Source</a></summary>

```cognate
Def Unless as (
	Let Cond;
	Def F;
	Do If Cond then ( ) else ( F );
);
```

</details>

## While

Takes two block parameters (`Cond` and `F`). Continually execute `F` while `Cond` evaluates to True.

```cognate
While (True) ( Print "This will print forever..." );
While (False) ( Print "This won't print at all..." );
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L96-L101">Source</a></summary>

```cognate
Def While (
	Def Cond;
	Def F;
	Let Result be Cond;
	When Result then ( F ; While (Cond) (F) )
);
```

</details>

## Until

Opposite of While. Takes two block parameters (`Cond` and `F`). Continually execute `F` until `Cond` evaluates to True.

```cognate
Until (False) ( Print "This will print forever..." );
Until (True) ( Print "This won't print at all..." );
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L111-L116">Source</a></summary>

```cognate
Def Until (
	Def Cond;
	Def F;
	Let Result be Cond;
	Unless Result then ( F ; Until (Cond) (F) );
);
```

</details>

## Times

Takes a number (`N`) and a block (`F`) as parameters. Evaluates `F` `N` times.

```cognate
Times 3 ( Print "Hip Hip Hooray!" );
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L125-L129">Source</a></summary>

```cognate
Def Times (
	Let N be Of (Integer?);
	Def F;
	Unless Zero? N ( F ; Times - 1 N (F) );
);
```

</details>

## With

Takes symbol parameter `Mode`, string parameter `Filename` and block parameter `Body`. Opens the file `Filename` in mode `Mode`. Evaluates `Body`, passing it a reference to the file.

```cognate
With \read "foo.txt" (
	Let F be the file handle;
	Print Read-file F;
);
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L142-L149">Source</a></summary>

```cognate
Def With (
	Let Mode be Of (Symbol?);
	Let Filename be Of (String?);
	Def Body;
	Let Fp be Open as Mode Filename;
	Body Fp;
	Close Fp
);
```

</details>

## Reverse

Returns the list parameter reversed.

```cognate
Print Reverse List (1 2 3);
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L158-L160">Source</a></summary>

```cognate
Def Reverse (
	Fold ( Push ) from Empty over List!;
);
```

</details>

## For

Takes a block (`F`) and a list (`L`) as parameters. Applies a block to each element in a list

```cognate
For each in Range 1 to 100 ( Print );
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L169-L177">Source</a></summary>

```cognate
Def For (
	~~ Tail recursive;
	Let L be Of (List?);
	Def F;
	When Not Empty? L (
		F First L;
		For each in Rest L do (F);
	)
);
```

</details>

## Fold

Takes a block (`F`), initial value (`I`), and list (`L`) as parameters. Applies `F` to each element in `L`, pushing `I` to the stack first.

```cognate
Fold (*) from 1 over Range 1 to 10;
Print;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L187-L192">Source</a></summary>

```cognate
Def Fold (
	Def F;
	Let I;
	Let L be Of (List?);
	I ; For each in L do (F);
);
```

</details>

## Puts

Builds a string from a block parameter and prints it to standard output, without a newline.

```cognate
Puts ( "The square of 10 is " * Twin 10 "\n");
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L201-L201">Source</a></summary>

```cognate
Def Puts ( Put Fold ( Join Show ) from "" over Reverse List);
```

</details>

## Prints

Builds a string from a block parameter and prints it to standard output, with a newline.

```cognate
Puts ( "The square of 10 is " * Twin 10);
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L210-L210">Source</a></summary>

```cognate
Def Prints ( Print Fold ( Join Show ) from "" over Reverse List);
```

</details>

## Filter

Takes a block parameter `Predicate` and a list `L`. Applies `Predicate` to each element in `L`. Returns a list containing only the elements where `Predicate` evaluated to True.

```cognate
Def Even? as (Zero? Modulo 2);
Filter (Even?) over Range 1 to 100;
Print;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L221-L231">Source</a></summary>

```cognate
Def Filter (
	Def Predicate;
	Let L be Of (List?);
   Empty;
	For each in L (
		Let I;
		Let R be Predicate I;
		When R ( Push I );
	);
	Reverse;
);
```

</details>

## Min

Takes two number parameters and returns the smaller one.

```cognate
Print Min 3 10;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L240-L244">Source</a></summary>

```cognate
Def Min as (
	Let A be Of (Number?);
	Let B be Of (Number?);
	If < A B then B else A;
);
```

</details>

## Max

Takes two number parameters and returns the larger one.

```cognate
Print Max 3 10;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L253-L257">Source</a></summary>

```cognate
Def Max as (
	Let A be Of (Number?);
	Let B be Of (Number?);
	If < A B then A else B;
);
```

</details>

## Take-while

Takes a predicate block (`F`) and a list (`L`) as parameters. Builds a new list by taking elements one by one from `L` and evaluating `F` on them. Stops building the list when the `F` first evaluates to False.

```cognate
Print Take-while (< 10) Range 1 to 100;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L266-L281">Source</a></summary>

```cognate
Def Take-while (
	Def F;
	Let L be Of (List?);
	Def H as (
		Let L;
		Unless Empty? L (
			Let I be First L;
			Let R be F of I;
			When R then (
				Push I;
				H Rest L
			)
		)
	);
	Reverse H L Empty;
);
```

</details>

## All

Takes a predicate block (`F`) and list (`L`) as parameters. Applies `F` to each element of `L`, returning True if `F` returned True every time, else returning False.

```cognate
Print All (< 100) Range 1 to 10;
Print All (< 10) Range 1 to 100;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L291-L300">Source</a></summary>

```cognate
Def All (
	Def F;
	Let L be Of (List?);
	Do If Empty? L then ( True )
	else (
		Do If F on First L
			then ( All (F) of Rest of L )
			else ( False )
	)
);
```

</details>

## None

Takes a predicate block and list as parameters. Returns True if evaluating the predicate on all of the list elements gives False, else returns False.

```cognate
Print None (> 100) Range 1 to 10;
Print None (> 10) Range 1 to 100;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L310-L314">Source</a></summary>

```cognate
Def None (
	Def P;
	Let L;
	All ( Not P ) of L;
);
```

</details>

## Append

Takes two list parameters and returns a new list created by joining the first list onto the end of the second list.

```cognate
Print Append List (4 5 6) to List (1 2 3);
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L323-L330">Source</a></summary>

```cognate
Def Append (
	Let L2;
	Let L1;
	L2;
	For each in Reverse L1 (
		Push;
	)
);
```

</details>

## Prepend

Takes two list parameters and returns a new list created by joining the second list onto the end of the first list.

```cognate
Print Prepend List (1 2 3) to List (4 5 6);
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L339-L339">Source</a></summary>

```cognate
Def Prepend ( Swap ; Append );
```

</details>

## Case

Takes a predicate block `Pred` and two other blocks `If-true` and `If-false`. Returns a block that takes one parameter (`X`) and applies the predicate to it. If this gives True then `If-true` is evaluated with `X` as a parameter. If not `If-false` is evaluated with `X` as a parameter.

```cognate
Def Multiple as ( Zero? Modulo );

Def Fizzbuzz
	Case (Multiple of 15) then ( "Fizzbuzz" Drop )
	Case (Multiple of 3)  then ( "Fizz" Drop )
	Case (Multiple of 5)  then ( "Buzz" Drop )
	else ( just return the number );
```

For each in Range 1 to 100 ( Print Fizzbuzz )

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L356-L365">Source</a></summary>

```cognate
Def Case as (
	Def Pred;
	Def If-true;
	Def If-false;
	(
		Let X;
		Let B be Pred X;
		Do If B then (If-true X) else (If-false X)
	);
);
```

</details>

## Sort

Takes a list of numbers as a parameter and returns a list containing the same numbers in ascending order.

```cognate
Print Sort List ( 9 6 2 5 7 4 1 3 8);
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L374-L383">Source</a></summary>

```cognate
Def Sort
	Case (Empty?) ()
	else (
		Let L;
		Let Pivot be First of L;
		Sort Filter (<  Pivot) L;
		Sort Filter (>= Pivot) Rest of L;
		Push Pivot;
		Append
	);
```

</details>

## Map

Takes a block (`F`) and a list (`L`) as parameters. Creates a new list where each element is the result of applying `F` to the corresponding element in `L`.

```cognate
Def Square as (* Twin);
Map (Square) over the Range from 1 to 10;
Print
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L394-L405">Source</a></summary>

```cognate
Def Map (
	Def F;
	Let L be a List!;

	Do If Empty? L ( L )
	else (
		Let X be First of L;
		Let Res be F X;

		return Push Res to Map (F) over Rest of L;
	);
);
```

</details>

## Discard

Takes an integer (`N`) and a list (`L`) as parameters. Returns a list created by removing the first `N` elements of `L`.

```cognate
Print Discard 4 from Range 1 to 10;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L414-L421">Source</a></summary>

```cognate
Def Discard (
	Let N be Of (Integer?);
	Let L be Of (List?);
	Do If Zero? N ( L ) else (
		When Empty? L ( Error "Cannot Discard more elements than in list" );
		Discard - 1 N from Rest L
	);
);
```

</details>

## Take

Takes an integer (`N`) and a list (`L`) as parameters. Returns a list containing only the first `N` elements of `L`.

```cognate
Print Take 4 from Range 1 to 10;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L430-L438">Source</a></summary>

```cognate
Def Take (
	Let N be Of (Integer?);
	Let L be Of (List?);

	Do If Zero? N ( Empty list ) else (
		When Empty? L ( Error "Cannot Take more elements than in list" );
		Push First L to Take - 1 N from Rest of L
	);
);
```

</details>

## Index

Takes an integer (`N`) and a list (`L`) as parameters. Returns the `N`th element (indexed from zero) of `L`.

```cognate
Print Index 4 of Range 0 to 100;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L447-L458">Source</a></summary>

```cognate
Def Index (
	Let N be Of (Integer?);
	Let L be List!;

	When < 0 N ( Error Join "Invalid index " Show N );

	Do If Zero? N ( return First element of L )
	else (
		When Empty? L ( Error "Index is beyond end of list" );
		Index - 1 N of Rest of L
	);
);
```

</details>

## Range

Takes two number parameters (`Start` and `End`). Returns a list of numbers ranging from `Start` to `End` inclusive of `Start` but not `End` with a step of 1.

```cognate
Print Range 1 to 100;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L467-L481">Source</a></summary>

```cognate
Def Range (
	Let Start be Number!;
	Let End be Number!;

	When > End Start ~~ TODO? maybe we could have this create a reverse range.
	(
		Error Join Join Join "Invalid range " Show Start "..." Show End;
	);

	Reverse List (
		Start;
		While (Triplet ; < End) ( + 1 );
		Drop; Drop;
	)
);
```

</details>

## Assert

Takes a string (`Assertion`) and a boolean (`Result`). If `Result` is not True then throws an error, with the text of `Assertion` in the error message.

```cognate
Assert "This assertion will pass" True;
Assert "This assertion will fail" False;
```

<details><summary><a href="https://github.com/cognate-lang/cognate/blob/master/src/prelude.cog#L491-L496">Source</a></summary>

```cognate
Def Assert (
	Let Assertion be String!;
	Let Result be Boolean!;

	Unless Result ( Error Join Join "Failed assertion: '" Assertion "'" );
);
```

</details>

