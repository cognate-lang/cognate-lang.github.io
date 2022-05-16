(load "gen.lisp")

(setq title "Cognate: Readable and concise concatenative programming")

(page 'index
(large-header "Cognate")
(small-header "Readable and concise concatenative programming")
(code 'cognate
"~~ Fizzbuzz in Cognate

Def Multiple as (Zero? Modulo);

Def Fizzbuzz
   Case (Multiple of 15) is \"fizzbuzz\"
   Case (Multiple of 3)  is \"fizz\"
   Case (Multiple of 5)  is \"buzz\"
   otherwise ();

For each in Range 1 to 100 (Print Fizzbuzz)")
(text "Cognate is a project aiming to create a human readable programming language with as little syntax as possible. Where natural language programming usually uses many complex syntax rules, instead Cognate takes them away. What it adds is simple, a way to embed comments into statements.")
(code 'cognate
"~~ Towers of Hanoi in Cognate

Def Move discs as (

   Let N be number of discs;
   Let A be first rod;
   Let B be second rod;
   Let C be third rod;

   Unless Zero? N (
      Move - 1 N discs from A via C to B;
      Prints (\"Move disc \" N \" from \" A \" to \" C);
      Move - 1 N discs from B via A to C;
   )
);

Move 5 discs from \a via \b to \c")
  (text "As you can see, Cognate ignores words starting with lowercase letters, allowing them to be used to describe functionality and enhance readability. This makes Cognate codebases intuitive and maintainable.")
(code 'cognate
"~~ Square numbers in Cognate

Def Square as (* Twin);
Map (Square) over Range 1 to 10;
Print")
(text "Cognate is a stack-oriented programming language similar to Forth or Factor, except expressions are evaluated right to left. This gives the expressiveness of concatenative programming as well as the readability of prefix notation. Expressions can be delimited at arbitrary points, allowing them to read as sentences would in English.")
(code 'cognate
"~~ Prime numbers in Cognate

Def Factor (Zero? Modulo Swap);

Def Primes (
   Let U is upper bound;
   initially List ();
   For Range 2 to U (
      Let P is potential prime;
      Let Primes is found primes;
      Let To-check be Take-while (<= Sqrt P) Primes;
      When All (Not Factor of P) To-check (
         Append P
      ) to Primes
   )
);

Print Primes up to 1000;")
(text "Cognate borrows from other concatenative languages, but also adds unique features of its own.")
(unordered-list
  "Point-free functions"
  "Operation chaining"
  "Multiple return values"
  "Combinator oriented programming"
  "Predicate pattern matching"
  "Natural language programming"
  "Gradual typing with inference")
(text "Interested? Read the " (link "tutorial" 'learn) " or visit our "(link "GitHub repository" "https://github.com/cognate-lang/cognate") "."))

(page 'learn
(large-header "Learn Cognate")
(small-header "A brief introduction to the language")
(small-header "Install")
(text
  (para "First install " (mono "CognaC") " the Cognate Compiler from here using the provided instructions. Currently " (mono "CognaC") " will run on recent Linux or Mac systems. Windows users can install it onto the Windows Subsystem for Linux - native Windows support is planned.")
  (para "Invoking " (mono "CognaC") " is simple. If you have a file named " (mono "foo.cog") " containing a Cognate program, it can be compiled into an executable named " (mono "foo") " with the following command."))
(code 'none "cognac foo.cog")
(text "To compile into an optimized executable (this takes longer and worsens error messages) you can use the " (mono "-release") " flag. To automatically run the produced executable, you can use " (mono "-run") ".")
(small-header "First Programs")
(code 'cognate "Print \"Hello world!\";")
(text "Fairly simple right? This example calls the " (mono "Print") " function with one parameter - the string " (mono "\"Hello world!\"") ". Now let's do another simple example, adding two numbers.")
(code 'cognate "Print + 2 3;")
(text
  (para "Wait what? That isn't how maths works!")
  (para "Cognate doesn't care how maths works. Where in most programming languages, " (mono "+") " would be an operator and would be used in the infix position, in Cognate " (mono "+") " is a function. Like " (mono "Print") ", the " (mono "+") " function is called by being written before its arguments like shown above."))
(code 'cognate "Print - 10 36; ~~ Subtracts 10 from 36")
(text "Another thing to note is that the order of parameters for " (mono "-") " and " (mono "/") " are backwards. The reason for this will become clear later. Also note that line comments are started with " (mono "~~") ".")
(small-header "The Stack")
(text "Let's have a more complex example, this subtracts 12 from 15 and then multiplies the result by 2.")
(code 'cognate "Print * 2 - 12 15;")
(text "By now you may have realised that Cognate is evaluating our programs backwards - right to left. The subtraction is being performed before the multiplication above. This is being done using a stack, as explained here.")
(unordered-list
  "Place 15 on top of the stack"
  "Place 12 on top of the stack"
  "Remove the top two numbers from the stack, subtract them and put the result (3) on top of the stack"
  "Place 2 on top of the stack"
  "Remove the top two numbers from the stack, multiply them and put the result (6) on top of the stack"
  "Remove the top number from the stack, print it")
(text "Cognate comes with functions to manipulate the stack. The simplest of these is " (mono "Twin") ", which takes the top element from the stack, and puts it back on again - twice. The below snippet uses " (mono "Twin") " to square a number by multiplying it by itself.")
(code 'cognate "Print * Twin 8;")
(text "Now we don't want to write this every time we square a number right? So let's create a " (mono "Square") " function to do this for us.")
(small-header "First Functions")
(text "Functions in Cognate are defined using " (mono "Def") " and the name of the function. The function body is put in brackets after this.")
(code 'cognate
"Def Square (* Twin);
Print Square 8;")
(text "This is great, but it certainly could flow better. Cognate ignores words starting with lowercase letters, allowing them to be used as comments. This lets us write:")
(code 'cognate "Print the Square of 8;")
(text
  (para "In this example the readability isn't really improved much, but in more complex programs this informal syntax can be invaluable.")
  (para "By now you've probably noticed the semicolons. These delimit statements so that Cognate knows what order to evaluate functions in (remember that these are executed backwards). Definitions should also be terminated with semicolons. The stack persists between statements, letting us do things like this."))
(code 'cognate "8 ; Square ; Print ;")
(text "or this")
(code 'cognate "Square 8 ; Print ;")
(text "or this")
(code 'cognate "8 ; Print the Square ;")
(text "This flexible syntax allows Cognate programs to flow as if written in sentences. It also means that much of the time variables are not even needed. Of course, Cognate " (italic "does") " have variables.")
(small-header "Variables")
(text "Variables are defined in a fairly similar manner to functions using " (mono "Let") " and their name. This takes a value from the stack, binding it to this name. Variables are referenced with the same syntax in which functions are called.")
(code 'cognate
"Let X be 4;
Print X;")
  (text "We can use variables to define functions that take named parameters - here's an alternate version of the " (mono "Square") " function.")
(code 'cognate
"Def Square as (
   Let X;
   * X X
);")
(text "Notice that the last statement before a closing bracket does not need to be terminated with a semicolon. Also there is no return statement, since values are implicitly returned on the stack. This means we can actually define functions that return multiple values, such as the " (mono "Twin") " function we saw earlier.")
(code 'cognate
"Def Twin as (
   Let X;
   X X
);")
(small-header "Control Flow")
(text "Like most programming languages, Cognate has if statements and loops and all that jazz. The simplest form of control flow is " (mono "When") ", which simply executes a block of code if given "(mono "True")" or not if " (mono "False") ".")
(code 'cognate
"When == 1 1 (
   Print \"Who'd have guessed?\"
);")
(text "There is also " (mono "Unless") " that evaluates the block if given " (mono "False") ". " (mono "While") " takes a condition in brackets and evaluates the block of code until the condition is " (mono "False") ". " (mono "Until") ", you guessed it, is the opposite of " (mono "While") " and runs until the condition is " (mono "True") ".")
(code 'cognate
"While (True) (
   Print \"This may well print forever\"
);")
(text "What's with the second set of brackets? " (mono "When") " doesn't have them, so why should "(mono "While")"? This is because brackets denote blocks! These prevent code being instantly evaluated and instead push a reference onto the stack. Blocks also control variable scopes. We can evaluate a block using the "(mono "Do")" function - which is how our control flow functions are implemented.")
(code 'cognate
"Do (
   Print \"Hello from inside a block!\"
);")
(text
  (para "This explains the syntax for functions: "(mono "Def")" simply binds a block to a name, much like "(mono "Let")". Blocks can be passed around the program like any other value - even if they reference variables that go out of scope.")
  (para "Now that this (hopefully) makes some sense, we can finally introduce the "(mono "If")" statement! "(mono "If")" is a function that takes three parameters. The first is a boolean, if this is "(mono "True")" then the second argument is returned. If not, the third argument is returned. We can chain "(mono "If")"s together to have more complex control flow."))
(code 'cognate
"Print
   If == X 1 then \"foo\"
   If == X 2 then \"bar\"
             else \"baz\";")
(text "We can combine this with "(mono "Do")" to have conditional code execution.")
(code 'cognate
"Do
   If == X 1 then ( Print \"foo\" )
   If == X 2 then ( Print \"bar\" )
             else ( Print \"baz\" );")
(text "Now, lets use our knowledge of blocks to define our own control flow function: "(mono "Thrice")", which should evaluate a block three times in a row. This demonstrates a different use of Def in which we bind a block from the stack.")
(code 'cognate
"Def Thrice as (
   Def F;
   F F F
);

Thrice (
   Print \"hip hip hooray!\"
);"))
