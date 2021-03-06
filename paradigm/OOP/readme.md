**********OOP ESSENTIALS*********
https://www.parashift.com/c++-faq/

****ENCAPSULATION******
Encapsulation wise class differs from struct
with having methods, which  are probably saved
as a pointer in obect's variable(offset). 
If the method is not virtual, or static
then it's probably implemented as a normal function
plus some NAME MANGLING(name decoration), so that 
unique name for every entity is resolved, and 
methods are marked. 
https://en.wikipedia.org/wiki/Name_mangling


*******INHERITENCE*******
B is kind of A.
Saying that using classes is an INHERITENCE.
B has everything that A has and more.

Therefore, if we encapsulate data in A,
which defines A, we don't have to rewrite
that definition for B.

class B : public A {}
and compiler will do it for us.
It will add everything from A to B
except constructor, destructor and private members?

Base class' members are stored first,
derived class' members next,
because of this base class type pointer
to the child works, because it can access
members in memory before derived 
class' members start, it can't reach further.

Therefore, even if we reload methods in derived
class, using the method's name will call base's
method, because of name mangling these methods are
different methods with different names, and parent 
can't reach('see') child's method... method... method...
https://isocpp.org/wiki/faq/basics-of-inheritance

*******POLYMORPHISM*********
What if B fits as a derivative of A
but its one function from A should be
a little bit different? We can't just 
reload functions.

virtual functions...
Solution is to have a table of such functions
in static memory and if derived class
changes the corresponding method that's
coming from base, this table gets updated.
Therefore derivde in derived class table
the method the base class method will be 
overridden by a new method.

The table is called v-table(virtual table)
and we can add methods to that table using
'virtual' keyword.

To access those tables we need a variable
that points at it. Compiler automatically
adds v-pointer(virtual pointer) to the base class, 
every virtual method is accessed with 
an offset from that pointer.
Therefore it looks at the very first virtual method.
Constructor sets up the v-pointer.

Because v-pointer is a member of a base class,
derived class inherits that member.
But we don't want derived class to be looking at
base's v-table.
We want to keep those functions that are unchanged,
and override those who we want to change.
Therefore, derived class builds a new v-table
where everything is same except that
methods that we wanted to override
are replaced with new ones.

In the end constructor sets up a v-pointer,
which was inherited from the base class,
and which was looking at the base's v-table, 
to look at derived's v-table.

Now, when base pointer is looking at the
devide object, it will be able to reach
v-pointer, because it also exits in base,
but now it is modified to look at derived's v-table,
so when the offset is used to reach a method,
on that address there will be a new function sitting.

######INTERFACES########
class Base
{
public:
	virtual void abstract_func() = 0;
};

This is a pure virtual function,
which means that every class
derived from Base MUST override it.

Now, we can not directly create a Base
type object.
Because pure functions can exist without 
definition, object can't be created,
compiler wouldn't know what to do with that kind
of function.

This is useful when we know that
some class will have many derivatives
and they will have their versions of 
methods.

Base class becomes interface,
which means that even if 
we want to change the
functionality of some derived class'
method, we can just modify it
in the class, but the way it was 
accessed won't change. 

Also user of the class isn't working
every detail and functionality of derivatives,
it's only working with methods which are
designed for interactivity...

^^^^^^^C#^^^^^^^
C# is more OOP than C++,
and it has additional syntax to 
work with classes.

We can define abstract class
using 'abstract' keyword'
which means that creating objects of 
this type directly won't be possible.
It will be inherited from the another class.

abstract class abstr_cls
{
	public abstract void beforeIwasEqualToZero();
	public void justA_Method()
	{
		Console.WriteLine("Zzz");
	}
}	

We don't have to create an virtual method and
set it equal to zero, we can use an 'abstract'
keyword, and derived class will be obligated 
to define it's body. 

class derived : abstr_cls
{
	public override void beforeIwasEqualToZero()
	{
		Console.WriteLine("My version of it");
	}
}

I guess C# won't just override because methods have the 
same name, 'override' keyword must be used then...

We can't create abstract class directly
we do this

abstr_cls abstr_obj = new derived;

abstract class can still have it's own 
non-virtual methods.

we can create complitely abstract class
using keyword 'interface'.

interface IAbstract
{
	void automaticallyAbstract_1();
	void automaticallyAbstract_2();
}

class derived : IAbstract
{
	public void automaticallyAbstract_1()
	{
		Console.WriteLine("My version");
	}
	public void automaticallyAbstract_2()
	{
		Console.WriteLine("My version");
	}
}


And then used like this

IAbstract abstract_object = new derived; 

Interface can contain
methods,
properties,
indexers,
events.

Interface can't contain
fields,
auto-implemented properties.

There aren't access modifiers
public, private,
in an Interface.
Derived class inherits everything 
from the interface with public access modifier.
https://www.tutorialsteacher.com/csharp/csharp-interface

The difference between interface function
and abstract function, needs more research.
Interface function is like normal function, 
not part of a class, and it's always public.
while abstract function is a method without
declaration. Which means that it must be 
checked wether it's private/public/protected,
and then look them up in the v-table which
happens in run-time(??), therefore interfaces
are much faster than abstract functions.
But aren't interfaces classes as well???
If not how are we able to make inherited classes
to it???? More research needed.....

###MORE ABOUT POLYMORPHISM###

Dynamic dispatch plays a big role in polymorphism.
Dynamic dispatch is type of a Dynamic name binding.
What is it?

In high-level languages programmer doesn't manipulate
register and memory(usually), he works with names of things.
When we want to address, or reference objects, we access them
by the names that we defined for them.
Machine doesn't have concept of names.
No names in machine language.
It knows addresses, and offsets(using arithmetic).

To my understanding this is how it goes:
Static binding(the function referenced can not change runtime)
1)names of local variables are turned into offsets in a stack frame.
2)names of normal functions and global or static variables are pushed 
into a static memory and in assembly labels are added to them 
which marks those addresses.


When we are accesing a virtual function from
a base class pointer, one name can be interpreted
into many different functions, so which label(address in memory)
should it be bound to?
"The actual method referenced is not known until runtime."

Simple name-mingling won't do it either,
which can be used for method overloading probably,
because names can be mangled using number of parameters,
and unique label generated for every method.

###Dynamic Dispatch###
https://en.wikipedia.org/wiki/Dynamic_dispatch
https://en.wikipedia.org/wiki/Virtual_method_table

*Dispatch as sending a call to a specifig method.

In C++ it is implemented using v-tables.
Each class has it's own v-table,
it's shared between all the object for that class.

v-table contains all the addresses of base's 
virtual functions. 
method name is just offset in the table.
By fetching the address from the v-table
we can call a method on that address which is 
specific for the class of the object.

Language that have duck typing
use hash table instead of virtual tables...
More research is needed for this...!!!!!!
https://en.wikipedia.org/wiki/Duck_typing
https://en.wikipedia.org/wiki/Hash_table
