**MadHatter**
A golfing language, who wants nothing but the most basic functionality a golfing language needs. (For now at least)

For a complete list of commands, just go into the Mad-Hatter.rb source and read the Commands Hash.

MadHatter is newline dependant, as some of it functionality comes from newlines, and clever placement of them.
An example is how the pointer moves. It starts on line 0 (-1,0) and moves from left to right, and executes commands as they are seen.
When a line is about to wrap a line, it moves either up or down, depending on the value on the end of the stack. 

x<=0 moves it up, (And if value is a string, although i may change this) PS: Its a bug i very well know how to fix, but it is a tedious one.
x>0 moves it down, to the next line. (if the stack is empty, it moves down)

There is also some simple logic implemented to make this easier.

There are 2 data types supported as for now. Integers and strings.

There are one more different from many other stack based languages, and that is the fact that stacks scale pretty much the same way
as brainf*ck cells. One can move between them, and choose which one to use at any point in the execution.

Other than that, its worth noticing there are no mirrors or anything, even though it may be considered a 2d language.

Name is inspired by the story Alice in Wonderland with the language being a bit ugly and wierd.
An example of this, is the & (Repeat command) command, being able to repeat itself, and producing wierd results.
