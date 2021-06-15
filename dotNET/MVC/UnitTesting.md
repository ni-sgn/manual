# xUnit

### Arrange, Act, Assert 

Lets put this here:
```C#
Func<T, T, bool> func ... ;
```
This is like pure functional programmig, Haskell, where the last
argument is a return argument and others are just arguments that 
func is taking. 

<br/>
Reusability again, passing types as arguments to classes means that
there should be cases when... Oh, when the class has methods that can
be defined as generic templates(C++), instead of creating templates
inside the classes themselves, C# syntax integrates classes and
templates I guess...  

<br/>
Its basically a trick to bypass the one limitaion that strong typing
creates... Because compiler won't let us pass parameter of another 
type to the function, even thought it would make sense if it let us 
pass.
```C#
public class TestClass<T> 
{
	//is this right ?
	public T addition(T a, T b) => a + b;
	
	//or
	public T addition = (a,b) => a + b;
}
```
I guess the error will be still raised if we pass the class
the type that wouldn't make sense in a + b, which is good...

What's the difference.?
```C#
public class TestClass
{
	public int addition(int a, int b) => a + b;
}
```
Func is a delegate that points to a method that accepts
one or more arguments and returns a value.
<br/>
Action is a delegate that points to a method which in 
turn accepts one or more arguments but returns no valuel.

<br/>
Func delegate can be defined by anonymous method or
lambda expression;
```C#
Func<int> what = delegate(){
				return 32;
			   };
```

