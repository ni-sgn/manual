---
Routing system(Uniform Resource Locators)
Application Container Platform(Docker)
Source @ https://github.com/apsnet
---

The Simplest and Barest way to explain what
a dynamic website is, is to generate a proper
response to an HTTP request. 
The space of possible requests are usually defined by 
developers.

HTTP uses URL-s and its format to send data to the server.
We have to map a response to that request.
In ASP.net it's done by the routing system.

IActionResult, ViewResult, or any primitive type can be
returned from the servet to the client. 
That is if the URL is mapped on to the Controller 
and that controller contains action method for that request.

We can return basically any type of data from the server 
to the client after the request,
but returning HTML, CSS, JavaScript, makes sense, because
browsers understand it and our data can be wrapped inside it
and represented beautifully.
```C#
inside controller:

public IActionResult Index()
{
	return View("MyView");
}
```

View method is probably virtual method defined in 
parent Controller class and we are 
overriding it.
Method looks for Views, which are
.cshtml types, inside Views/ControllerName/Myview.cshtml
or Views/Shared/..., 
'parses' that file for 'razor' syntax and final generated
HTML is send back to the client.

Controllers are named something like HomeController.cs
but the Controller part is basically ignored after that,
Home will have its controller, view and act on some model 
probably...???
Also, Cotrollers, Models, and View folder must be on the 
same level probably...

What can be passed to the client from controller?:
primitive types:
```C#
public string Index(){ return "hello world"; }
```
### renderd view:
```C#
public ViewResult() { return view("MyView");}
```

or

public IActionResult() { return view("MyView");}

don't know the difference yet.

redirect:
public RedirectResult() {...} ??

and

public HttpUnauthorizedResult() {...} ???

Ok... All of them are action results, so IActionResult will
work for all of them...

To use same html template for different data we must
be able to somehow pass that data from controller 
to the View. 
There are couple ways to do it

ViewBag object is a member of a Controller
base class. It is a 'dynamic object'??? 
Its arbitrary properties can be accessed by
whatever view is rendered subsequently. 

public ViewResult Index()
{
	//DateTime must be a static class
	int hour = DateTime.Now.Hour;
	ViewBag.Greeting = hour < 12 ? "Good Morning" : "Good Afternoon";
	return View("MyView");
}

Greetings property doesn't exist, it is created runtime,
therefore ViewBag.anything is possible.
Creating properties dynamically is weird,
what does it mean its created dinamically?
What's the logic behind it?
There must be C# runtime system that implements this 
features, so does it add library functions in 
my program code to implement these language features???

in MyView.cshtml:
<!DOCTYPE html>
...
<div>
<p>@ViewBag.Greetings From Slovenia</p>
</div>
...

Razor view engine is called the parser program
of .cshtml files.

Razor somehow has an access to the ViewBag.Greetings
This name is visible to him.

Now, we have a way to manipulate the data, and
then wrap that data in HTML for presentation, 
but what about the data itsef??

Models.
Model creates the universe, 
the domain of the application.
It basically defines the data that
the application can access.
It's basically all there is in the application.
Domain of Discourse for the application.(Not eulogy but ontology!!)

In C# it's usually implemented as Classes.
By convension Models/ClassName.cs 

namespace PartyInvites.Models 
{
	public class GuestResponse
	{
		public string Name { get; set; }
		public string Email { get; set; }
		public string Phone { get; set; }
		public bool? WillAttend { get; set; }
	}
}

Lets talk about properties first.

In C#, this is called a field:
	public string Name;

and this is a property:
	public string Name { get; set; }

Which is a so called syntax sugar,
which I think means that is, it's a shorthand
and it gets expanded into bigger C# code.
But I doubt it's that simple, but basically it's that

public class NameProperty()
{
	private int backing_Name;
	public void set_Name(string value)
	{
		backing_Name = value;
	}

	public string get_Name()
	{
		return backing_Name;
	}	 
}

We declare Name as a variable, but in reality 
it's a pair of methods. 
Which what methods are basically...
And when accessing:
	NameProperty.Name
it will call the methods...

Custom get and set can be declared too:
	public string Name {
		get{ return Name; }
		set {
			if(value == "") return "Empty String"; //some exception would be better
			else Name = value;
		}	
	}


Getter and setters are good practice because 
the values of the class members need validation, 
which setters and getters can be used for...


Now about:
	public bool? WillAttend { get; set;}
Weird question mark after the bool...
I think it just means that property can be 
true, false and bool too.
This is also used for Validation...


Back to controllers:

public ViewResult RsvpForm() 
{
	return View();
}

this action method returns View();
which has no file name as an argument;
In this case View is loocking for a
file with a name of this action method.

Which is weird because, something
that's parsing and analysing this code, 
must be saving and passing the action's
name to the View(), which feels bootleg to me.
RsvpForm.cshtml

in Views/Home/RsvpForm.cshtml:

@model PartyInvites.Model.GuestResponse

@{
	Layout = null;
}

<!DOCTYPE html>
...
...
</html>

Little bit about razor:
it's like a preprocessor in c, but it's razor engine.
Instead of # its expressions start with @ 

@model Namespace.Folder.Class
tells to razor that we are working with certain model,
which makes this View strongly typed and it basically 
means that this View is used for working with specifig model type.
MVC creates some helpful shortcuts to work with this namespace and model.

Layout = null; just tells razor that we don't want any layouts,
which I don't really know what it is  at this point.

In static html, to get a different page, we just request
another page by sending page's URL by href, but here
we have to trigger an action that returns the certain view I guess...

in Views/Home/index.cshtml:
...
<a asp-action="RsvpForm">Send me the RSPV</a>
...

Tag helpers:
asp-... tags are also analyzed by the razor engine.
This kind of tags are called tag helpers.
I guess that's because, instead of us 
typing href with a link to an action,
we can just asp-action="ActionName" and razor will replace it
with href and correct URL on its own.

I guess this action must be in the Controller
that's controlling the folder of View that the
current View is in.

Yes, that's right:
"Insert a URL for an action method defined by the same
controller for which the current view is being rendered."

The important principle:
"You should use the features provided by MVC
to generate URLs, rather than hard-code them into
your views.
When the tag helper created the href attribute 
for the a element, it inspected the configuration 
of the application to figure out what the URL 
should be. This allows the configuration of the 
application to be changed to support different URL
formats without needing to update any views."

We can use tag-helpers to build a simple form
in Views/Home/RsvpForm.cshtml:
:
:
...
<form asp-action="RsvpForm" method="post">
	<p>
		<label asp-for="Name">Enter Name:</label>
		<input asp-for="Name"/>
	</p>
...
:
:
	<p>
		<label>Will you atetend?</label>
		<select asp-for="WillAttend">
			<option value="">Choose</option>
			<option value="true">Yes</option>
			<option value="false">No</option>
		</select>
	</p>
	<button type="submit">Submit RSVP</button>
</form>
:
...

asp-for tag helper associates each element
with the model property

what it does basically, is that it modifies elements
to fit to the model. When parsed they look like this:
<p>
	<label for="Name">Enter Name:</label>
	<input type="text" id="Name" name="Name" value="">
</p>

and

<form method="post" action="/Home/RsvpForm">

Receving Form Data...
HTTP has two ways of encapsulating and 
sending data from client to the server.

1) HTTP GET
This is when the request/data is sent by
URL, why is it resource locator?
probably because we designed it so that
certain resources are located on the server. 

2) HTTP POST
The request/data is encapsulated in special packet/file??
it's sent more securely, server has to open and analyse it.

We can overload our RsvpForm action method,
so that one responds to a GET method and another
to a POST method.

GET method is usually a default method, but
there's something like Html.BeginForm()... 
Don't know what that is yet...

To tell an action method which HTTP requst to process:

[HttpGet]
public ViewResult RsvpForm(){
	return View();
}

[HttpPost]
public ViewResult RsvpForm(GuestResponse guestResponse)
{
        // Some logic has to be added here...	
	return View();
}


Model Binding...

We created a form in RsvpForm, which 
sends data from client's filled form to the server.
How can we access that data??

In overloaded RsvpForm action method we added 
GuestResponse object.
Because this method is handling the POST method
from the form, the data send from that form
come to this method, and through something called
"MODEL BINDING", which basically means parsing
the POST requst file and using key/value pairs,
probably name/value or id/value in html,
the corresponding class members are populated.

This works well because we created a strongly typed view 
that's fit for a certain model and used tag-helpers
to generate the correct html tags.   
https://stackoverflow.com/questions/558304/can-anyone-explain-ienumerable-and-ienumerator-to-me

Continueing with Models...

For some reason we are adding new model,
/Models/Repository.cs/, which stores data 
about responses...
I guess just to make an example???
Why couldnt make this collection in the previous model??

Now, inside /Models/Repository.cs/:

using System.Collections.Generic;

namepsace PartyInvites.Models{
public static class Repository	{
	private static List<GuestResponse> responses = new List<GuestResponse>();
	public static IEnumerable<GuestResponse> Responses {
		get {
			return responses;
		}
	}

	public static void AddResponse(GuestResponse response)
	{
		responses.Add(reponse);
	}
}
}

Lets analyse C# thingies.

List<T> is just a stronlgy typed list of objects.
It has a generic type T, which basically means that
we can create List of any type of object.
These objects can be accessed by index.
List is muttable and Provides methods for
search, sort, and manipulate list...

About statics... I think that,
static methods and variables are 
added to the static memory, and class that
wraps them just becomes name mangling thingie...
They are accessable from 'whole program'?
And they don't need to be created as objects and
pushed into the stack...

Does static class mean that its every member must be
static too???
Yes, it does...


Weird part:
	public static IEnumerable<GuestResponse> Responses{
		get{	return responses; }
	}

This looks like a Property...
With type of IEnumerable<GuestResponse>, but it 
returns responses, which is just a List, 
List of GuestResponse, is it turned into IEnumerable?
And what does that mean?

Type Parameters...

Thing with Generic Programming in C# is that
we can pass a parameter, which is a type parameter.
Which means that we are passing a Type as a parameter(argument)
which in a class or a method was described and looks like a
variable.
Yes..., its a variable, which is substituted at runtime
by the type which is recongnized by the compiler...
://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/generics/generics-in-the-run-time
This needs more research and explanation in a different place...

	public static IEnumerable<GuestResponse> Responses{
		get{
			return responses;
		   }
	}
"Enumerables standardize looping over collections, and enables 
the use of LINQ query syntax, as well as other useful extension
methods like List.Where() or List.Select()."
Its basically enables us to write custom logic for
iterating throught the collection...

And libraries are working with this standardized Interfaces,
using their methods, because it gives the flexibility of
having different logic but having same way of calling them.

REMEMBER, MEMBERS OF INTERFACES MUST GET OVERRIDEN.
It feels like Mathematical Induction...

foreach (Int element in list)
{
	//code
}

is translated to:

IEnumerator enumerator = list.GetEnumerator();
while(list.MoveNext())
{
	element = (Int)enumerator.Current
	//code
}

IEnumerable interface returns a reference to the IEnumerator
which has 
MoveNext() //+1 in Peano's, rule to climb the ladder 
Current    //reference to the current object

With this we are able to traverse any? collection...

In our case, we don't have an access to the
IEnumerable interface of the List we've created,
so because IEnumerable is a base for List,
because that's how List implements traversability,
we can return List as IEnumerable interface 
and this interface will be a reference to
the List object adn  we will have an interface which we 
will be able to use for traversing...

This is a better way than having an array/list
public and iterating over it.

Also:
var toPrint = input.Where((item) => item.Length > length);

doesn't return a newly generate list into the toPrint,
instead it returns reference to the IEnumerator, which
has integrated logic inthe MoveNext()
which we used in 'Where(...)'
and will be used in the foreach...

To return list:
var toPrint = input.Where((item) => item.Length > length).toList();

They Use Something Called *Deferred Execution*
more research ... 
https://www.tutorialsteacher.com/linq/linq-deferred-execution


Because these methods are static we can reach them from 
controller without creating object, and store the data:

In the action method we defined:

[HttpPost]
public ViewResult RsvpForm(GuestResponse guestResponse)
{
	Repository.AddResponse(guestResponse);
	return View("Thanks", guestResponse);
}

Therefore, we are sending back the View called
"Thanks.cshtml", but before parsing that view
we are sending GuestResponse to that view.

Which will be accessed by the Razor Engine...
But exchanging the data betweeen two different
filetypes and it also looks dynamic, makes 
me think that there is some standardized way of
doing it?? maybe using JSON???

in Thanks.cshtml:

@model PartyInvites.Models.GuestResponse

@{
	Layout = null;
}
<!DOCTYPE html>
...
<h1> Thank you @Model.Name</h1>
<p>
@if (Model.WillAttend == true)
{
	@:great
} else {
	@:sad
}
</p>
<p> Who's Coming?? <a asp-action="ListResponses">here</a>...</p>
...
...


The object that we send using the View method
is accessable using @Model.PropertyName,
@model ...
itself specifies the domain model,
which makes this View strongly typed...


We need a new action method called ListResponses:

using System.Linq;
...
[HttpGet]
public IActionResult ListResponses()
{
	return View(Repository.Responses.Where(x => x.WillAttend == true));
}

in Views/Home/ListResponses.cshtml:

...
@model IEnumerable<PartyInvites.Models.GuestResponse>
<!DOCTYPE html>
<html>
...
@foreach(PartyInvites.Models.GuestResponse item in Model)
{
<tr>
	<td>@item.name</td>
	<td>@item.phone</td>
	...
<tr>
}
...
</html>

Usin the view method, the IEnumerable is send to 
the view, which is not quit new List, but more like
the logic of how to traverse the List ???

Then we make the corresponding view strongly typed,
which in the and is till weird to me,
looks like it tells the razor view engine that
it's designed to work with this certain type of model...

Because in the view we are getting
Model as IEnumerabe interface with the type of 
PartyInvites.Models.GuestResponse,
We can use razor's foreach to traverse that model. 

in the @foreach body we can use html tags and their
attributes...


*Validation...*

First of all, we can get many types of junk
from the client.  
This becomes dangerous when the application is listening
to these requests and expecting some data.
We don't want to analyze, save, and use in any way 
the data that we don't care about, especially when it can 
be malicious. We must not collect garbage...
Therefore we have to set a filter that filters out
what we don't need, and define the type of
data that we are interested in. 

In MVC validation is added to the model,
therefore it becomes the model validation.
This way, instead of validating the input 
from a certain user interface, we have valiadation
on the model itself, and it's validated
throughout the whole application.

Attributes in C#
://www.geeksforgeeks.org/c-sharp-dynamic-coding-attributes-in-depth/?ref=rp
This topic needs a research on its own...
Attributes are objects that somehow act at runtime...
I don't quite understand C#'s Runtime environment...

Basically attributes are metadata about classes
or types or properties or fields...

Attributes are used for validation...

in GuestResponse.cs:

using System.ComponentModel.DataAnnotations;
...
[Required(ErrorMessage = "Please enter your name")]
public string Name {get; set;}

[Required(ErroMessage = "Please enter your email address")]
[RegularExpression(".+\\@.+\\..+",
	ErrorMessage = "Please enter a valid email address")]
public string Email { get; set; }
...
...

Validation of these properties happens during
model-binding...

checking the reuslt of validation
in Controllers/HomeController.cs:

...
[HttpPost]
public ViewResult RsvpForm(GuestResponse guestResponse)
{
	if(ModelState.IsValid)
	{
		Repository.AddResponse(guestResponse);
		return View("Thanks", guestResponse);
	}
	else {
		//There was a validation error
		return View();
	}
}
...

Because validation happens during the model binding,
in the consequent ModelState we get validation for 
current model that was being binded...

This ModelState class is contained in the Controller 
and contains information about conversion of
HTTP request data into C#, (which basically what binding is?)


Razor engine has access to th validation errors associated with 
the requst,
Requst->Starts Binding->Validation->Binding is Interrupted
->Validation results written in ModelState and ValidationSummary

Razor has access to the enumeration ValidationSummary,
which contains error messages of validations,
I don't understand the intermediary space between
Controllers and Views, how is data exchanged...

in Views/Home/RsvpForm.cshtml:
...
...
<form asp-action="RsvpForm" method="post">
<div asp-validation-summary="All"></div>
...
...
</div>
</form>
...
...

with asp-validation-summary="All" tag-helper attribute we are 
accessing to all validation error messages. 

when using 'asp-for' to associate model property to a
HTML element, if validation for that property is failed
razor generated different attribute:

<input type="text" class="input-validation-error"
data-val="true" data-val-required="Please enter...:"
id="Phone" name="Phone" value=""/> 

The difference is this class="input-validation-error"
which can be used to be accessed by js or to add 
styling with CSS 

Another Convention in MVC:
Static components delivered to the clients
is placed into the wwwroot folder...

in wwwroot/css/styles.cc:
.field-validation-error { color: #600; }
.input-validation-error { border: 1px solid #f00; background-color:#fee;}
...
.validation-summary-errors { font-weight: bold; color: #f00; }

in Views/Home/Rsvp.cshtml:
...
<head>
	<link rel="stylesheet" href="/css/styles.css" />
...
</head>
...


MVC configuration assumes wwwroot folder for static files...

This tiny project is done here... I'm skipping the bootstrap
styling parts, because it's not my concern yet.


*Chapter 3: MVC pattern*

*	Model     *
Basically model in mvc represents
what the application is 'all about'.
Model is a domain of discourse, also 
called the universe of discourse, universal set,
or simply universe, of data and
operation on it  for the application.

Two types of Modles :
View Models, which are models passed from controller to the view,
Domain Models,which contain the data in a business domain. 

----
I have a parrot on my hand right now...
He is so confused of what's going on ...
----

Data Transfer Object (DTO)
https://en.wikipedia.org/wiki/Data_transfer_object

Programs are become running processes 
in OS on the CPU, when one program(browser)
gets a data from the server program(apache?)
this data exchange actually happens between processes.
But how is this data exchanged??

When this processes are located on differrent computers,
this communication between processes is happening remotely,
(e.g. web services). 
I guess on client server model this exchange(call) is costly
because it takes a round-trip.	 
What Data Transfer Object does is that it encapsulates a bunch 
of data that was transfered using many calls into an object
which onlny needs one call.

This type of objects are simple and have functionality only
for storing, retrieving, serializing and deserializing its
own data.

Data Access Object (DAO)
https://en.wikipedia.org/wiki/Data_access_object

This is an abstract interface to some type of database
that only reveals specific Data Operations without exposing
details of the database

Business Model
Its just business model I guess,
although why did they choose business, 
it still weirds me out... 

*Controllers*
or What is displayd and when,

Only thing that model cares is data,
what kind of data do I need?
How do I store that data? 
How do I retrieve that data?
What kind of operations on that data do I need?

It doesn't take into consideration how the application
is supposed to be interacted by users.
It just represents what application supports and can be
accessed to be displayed.

But what is displayed and when?
That's what controllers are designed for...
They look at  client's HTTP requests and send them
appropriate data through deliberately defined action methods.

It also communicates with the model through the interfaces,
so that data model gets updated whenever needed... 

Client wants to view the resources, so he must send
some requst for that resource.
But our application allows client to view the data,
which is relevant to our application... 
Therefore there must be resource locators embedded 
inside a view which can be triggered by the user... 

These resource locators(URL), must be somehow mapped
to the actual resources, simplest way of doing it 
just send the full location of a resource on the server???
Doing this with URI-s(Uniform Resource Identifier),
which is a string that provides a unique address 
to the resource...

All URL-s are URI-s, not all URI-s are URL-s.
https://en.wikipedia.org/wiki/Uniform_Resource_Identifier

Client can also send additional data/parameters using
URL to to the server... 

C# MVC has Routing engine, which sets the mapping 
rules from URL-s to Resources,
then parses the incoming URL-s and maps them to resources
using following these rules... 

Now, because resources in MVC web apps are governed by
actions in Controllers, URL-s are usually mappped to 
actions in controllers. 

In Single Page Applications, Routes are just certain
state of Application...
Basically URL-s are mapped to the certain states of the
application...

But why is it called routing??
Where is this route leading us???

Routes between two different pages or 'states' in
case of SPA-s.


*Views*
or How is it displayed 

server can send data in many different formats,
but we want it to be presentable, 
comprehensive view, therefore 
sending the html which browser understands, 
can be used to display and present the requested data.

This html results also contain embedded interactive parts inside
of them and basically dynamic website is formed like this.

For the separation of View to be possible, we must be able 
to write logic for generating this html.

C# has razor view engine, which has similar syntax to C#
and enables us to implement logic inside .cshtml files,
which are then parsed and final html is generated. 


*Data Access Layers(DAL)*

Simplified access to data stored in persistent
storage of some kind, such as an entity-relational
database.

*Business Logic Layer*

These is created separately too, 
even though we have Model in mvc
application... ??? why thought???

*Chapter 4: Language Features*

Project: LanguageFeatures

Models/Product.cs:

namespace LanguageFeatures.Models
{
	public class Product 
	{
		public string Name {get;set;}
		public decimal? Prince {get;set;}
	
		public static Product[] GetProducts()
		{
			Product kayak = new Product
			{
				Name = "Kayak",
				Price = 275M
			};
			Product lifejacket = new Product
			{
				Name = "Lifejacket",
				Price = 48.95M
			};
			
			return new Product[] { kayak,
						lifejacket,
						null};
		}
	}
}
 
Lookint at this code...
First of all it is wrapped inside of a namespace,
isn't URI already creating this LanguageFeatures.Modles namespace itself??
Probably it doesn't, and it is generated according to the relative location
to the project.
But how can this namespace imported?
I haven't seen something like "using namespace std;"
namespaces are for name manglings, it can't be that I import namespace like

using LanguageFeatures.Models;

because this import a classes inside of files inside of 
LanguageFeatures.Models...

when is the namespace opened??


decimal is a type used for financial calculation 
for no roundoff errors... 
decimal? probably can take null as a value too.
decima? is probably a derived class from decimal and
has additional features.

About static members in the class...
I still think that it does nothing except the name binding,
which is the simplest form of encapsulation...

Question is, is the static member created before 
the object creation of that type of class, or after the first
object is created...

Probably after the first object is created,
if its a static class, then we can't create objects,
and its every member is static therefore they are
allocated in the memory before the object creation...

Yes, using allocation in memory is a better word than creation
I like it more...

We have to call GetProducts() for Products object 
to get List of statically defined objects...

Also:

Product kayak = new Product {
		Name = "Kayak",
		Price = 275M
		};

creating kayak object with the type of
Product. 
This happens without a constructor...

*in Controllers/HomeController.cs:

using Microsoft.AspNetCore.Mvc;

namespace LanguageFeatures.Controllers
{
	public class HomeController : Controller {
	
		public ViewResult Index()
		{
			return View(new string[] {"C#", 
						  "Language",
						  "Features"});
		}
	}
}

Mvc features are inside Microsoft.AspNetCore.Mvc 
namespace?
Is it a namespace or a class, or what kind of location is this???
More research needed for this?? how the different files and
classes are imported.

One more interesting point,
we are sending the array of strings to the view
but in Views/Home/Index.cshtml:

@model IEnumerable<string>
@{ Layout = null; }

<!DOCTYPE html>
<html>
<head>
	<meta name="viewport"	content="width=device-width" />
	<title> Language Features </title>
</head>
<body>
	<ul>
		@foreach (string s in Model)
		{
			<li>@s</li>
		}
	</ul>
</body>
</html>
</html>

In view the @model is IEnumerable<string>

Which probably makes sense because IEnumerable is 
base class for collections...

*Null Conditional Operator*
Makes detecting the null values more elegant 

example in Controllers/HomeController.cs:

using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using LanguageFeatures.Models;

namespace LanguageFeatures.Controllers
{
	public class HomeController : Controller 
	{
		public ViewResult Index()
		{
			List<string> results = new List<string>(); 
			
			foreach ( Product p in Product.GetProduct())
			{
				// '?' is a null conditional operator
				// if p == null then name = null
				// else	if p != null name = p.name
				string name = p?.name;
				decimal? price = p?.price;
				
				//string.Format is a method  
				//it replaces string wholes with 
				//arguments according to their
				//ordinal numbers
				results.Add(string.Format("Name {0}, Price {1}", name, price);
			}
			View(results);
		}
	}
}


Chaining Null Conditional Operators
In Models/Product.cs:

namespace LanguageFeaturs.Models
{
	public class Product
	{
		public string Name { get; set; }
		public decimal? Price { get; set; }
		
		//This creates a nested object
		public Product  Related { get; set; }
		
		public static Product[] GetProduct()
	 	{
			// This syntax applies to Lists too?
			Product kayak =	new Product 
			{ Name = "Kayak", Price = 65M }; 	
			Product lifejacket = new Product
			{ Name = "Lifejacket", Price = 13.21M };

		        //calling GetProduct() creates 2 objects
			//we set Related for only 1 of them	
			//therefore for second its null
			kayak.Related = lifejacket;

			return new {kayak, lifejacket, null};
		}
	}
}


in Controllers/HomeController.cs:

using Microsoft.AspNetCore.Mvc;
using System.Collection.Generic;
using LanguageFeatures.Models;

namespace LanguageFeatures.Controllers
{
	public class HomeController : Controller 
	{
		public ViewResult Index()
		{
			List<string> results = new List<string>();
			
			foreach (Product p in Product.GetProducts())
			{
				//just making sure that obj p
				//is not null
				string name = p?.Name;
				decimal? price = p?.Price;
				
				//we can chain null conditionals 
				//making sure that p != null &&
				//p.Related != null 
				string relatedName = p?.Related?.Name;
	
				results.Add(string.Format("Name: {0},
							   Price: {1},
						    relatedName: {2},"
						    name,
						    price,
						    relatedName);

			}
			
			return	View(results);
		}
	}
}

*Null Coalescing Operator ??*
in Controllers/HomeController.cs:


using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using LanguageFeatures.Models;

namespace LanguageFeatures.Controllers
{
	public class HomeController : Controller
	{
		public ViewResult Index()
		{
			List<string> results = new List<string>();
			
			foreach( Product p in Product.GetProducts())
			{
				// if p == null then name = "<No Name"
				// else name = p.Name
				string name = p?.Name ?? 0; 
				decimal? price = p?.Price ?? <No P>";
				
				string relName = p?.Related?.Name ?? "None";
				results.Add(string.Format("Name: {0},
							  Price: {1},
							Related: {2}",
							name,price,
							relatedName));
			}
			return 	View(results);
		}
	}
}


*Automatically Implemented Properties*
in Controllers/HomeController.cs:


public class Product
{
	public string Name { get; set; }
	public decima? Price { get; set; }
	public Product Related { get; set; }
...
}
...

These properties get implemented automatically:

...
public string Name{
	get { return name;}
	set { name = value;}
}	
...

In actuality properties turn into:

private string name;
public string get_name() { return name; }
pubic  void set_name(string value) { name = value; }


*Auto-Implemented Property Initializers*
in Controllers/HomeController.cs:

...
// use setter to initialize value 
// this can be changed in constructor 
public string Category { get; set; } = "Watersports";
...

in GetProducts():
...
//This is another way for constructor
//then???
Product kayak = new  Product
{
...
Category = "water splash";
}
...

This is espacially useful when
we want to set an initial value
for read-only auto-implemented properties

...
//I have no setter
bool InStock { get;} = true;
...

Value of get-only or read-only \ 
property can not be changed... but \
the initial value can be changed \
during creation using Constructor \

...
public class Product()
{
	Product(bool stock)
	{
		InStock = stock;
	}
	public bool InStock { get; set;} = true;

	public Product[] GetProducts()
	{
		Product kayak = new Product(false)
		{
			...
		}			
		
		return new Product[] { ..., kayak, null };

	}
}
...

*String Interpolation*
Interpolation... Interpolation...
It's just a better syntax for string formating... 

in Controllers/HomeController.cs:
...
results.Add(@"Name: {name}, Price: {price:C2}");

C# will locate references inside { } and replace them 
with strings corresponding to their values...
C2 means will format the values as a currency with two
decimal digits... These little things about formatting
needs more research... 


***Object and Collection Initializers***<br/> 
The answer to the good old question is here<br/> 
Before, we called it "another way of writing<br/> 
constructor" or something like that...

<br/>
Behold, we have a <b> Collection Initializers </b>
in our hands <br/>

```C#
...
Product kayak = new Product
{	Name = "Kayak",
	Category = "water craft",
	Price = 274M
};
...
```
This is translated into:
```C#
...
Product kayak = new Product();
kayak.Name = "Kayak";
kayak.Price = 232M;
kayak.Category = "Water Polo";
...
```
It's basically a syntax sugar to access<br/> 
and initialize public member of an object<br/> 

Same thing can be applied to Collections.<br/> 
Instead of: 
```C#
...
string[] names = new string[3];
name[0] = "tsotne";
name[1] = "entost";
name[2] = "Billy";
return View("Index", names);
```

Cleaner syntax is:
```C#
return View("Index", new string[] { "tsotne", "entost", "billy" } );
```
This allows the collection to be defined inside a method call.<br/>

### Index initializer
Indexes but I think it's more specific for Key-Value pairs,
this type of collections, have better way for initialization...
<br/>
old way:
```C#
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using LanguageFeatures.Models;

namespace LanguageFeatures.Controllers
{
	public class HomeController : Controller
	{
		public ViewResult Index()
		{
			Dictionary<string, Product> products =  \
			new Dictionary<string, Product>
			{
				{"Kayak", new Product {Name = "Kayak", Price = 234M}},
				{"LifeJacket', new LifeJacket {Name="LifeJacket", Price = 12M}}
			};
			return View("Index", products.Keys);
		}	
	}
}
```

New better way, using index initializers:
```C#
...
public ViewResult Index()
{
	Dictionary<string, Product> products = new Dictionary<string, Product>
	{
		["Kayak"] = new Product { Name = "Kayak", Price = 234M },
		["Lifejacket"] = new Product { Name = "LifeJacket", Price = 123M}
	};
	
	return View("Index", products.Keys);
}
```

### Pattern matching
I still think that they are giving the language features some weird names
but what can you do... When I heard about pattern matching, first thing that came in my 
mind was the regular-expressions. But it's actually about type-checking...
<br/> 

in Controllers/HomeController.cs:
```C#
public ViewResult Index()
{
	//object is base of all classes ??
	//therefore it can reference to any object
	object[] data = new object[] { "123", "abc", 231.2, 123};
	decimal total = 0;
	
	for(int i = 0; i < data.Length; i++)
	{
		//I don't know how to feel about this syntax
		// 'is' type-checks data[i] and if true then d = data[i]
		if(data[i] is decimal d)
		{
			total += d;
		}
	}

	return View("Index" , new string[] { $"Total: {total:C2}" });
}
...
			
```

This is better mixed with <b>case</b> statement:
```C#
...
public ViewIndex Index()
{
	object[] data = new object[] { "help", "me", 231, 123.21};
	decimal total = 0;	
	for(int i = 0; i < data.Length; i++)
	{
		switch(data[i])
		{
			//type-checks for decimal	
			case decimal decimalValue:
				total += decimalValue;
				break;
			//being more selective using when
			//I don't know where-else can when be added
			case int intValue when intValue > 50:
				total += intValue;
				break;
		}
	}
}
```

# Extention Methods

This is some real unusual stuff if you ask me...
<br/> 
In C# classes, with member methods can also use Extension methods...
<br/>
We can define a method outside the class which will act as if its the part of that class...
<br/>
But it can only act on the accessible/public members of the class.
<br/>
Basically it's an additional logic which can be accessed using ObjectName.Method syntax.
<br/>

Little wrapper class for Product, in Modles/ShoppingCart.cs:
```C#
using System.Collections.Generic;

namespace LanguageFeatures.Models
{
	public class ShoppingCart
	{
		// When returned, we will be to access only
		// GetEnumerator() method of IEnumerable
		public IEnumerable<Product> Products { get; set; }
	}
}
```

Lets define <b>Extension Method</b> in Models/ExtensionMethods.cs:
```C#
namespace LanguageFeaturs.Models
{
	pubic static class ExtensionMethods
	{
		//I guess extension methods must be static
		//In this case that's for sure because it's in the static class
		public static decimal TotalPrices(this ShoppingCart cartParam)
		{
			decimal total = 0;
			foreach(Product prod in cartParam.Products)
			{
				total += prod?.Price ?? 0;
		        }		
			return total;
		}
	}
}
```

'this' keyword in the list of parameters tells C# that this method will be used
as an extension method, class(type) after that means the extensino method will be used on
that of class(type) and the 'cartParam' can be used inside the body as parameter...
<br/>

Now because I defined this extension method for 'ShoppingCart' type, it will be
accessable only that type of objects will be able to access it. We can implement
IEnumerable class in the ShoppingCart class, make our class a child of an IEnumerable,
and then define this extension method for IEnumerable. Therefore because all collections
are children of IEnumerable we'll be able to use this extension method on any kind of 
collections of the type 'Product'...
<br/>

### !!!!
in Models/ShoppingCart.cs:
```C#
using System.Collections.Generic;

namespace LanguageFeatures.Models
{
	public class ShoppingCart : IEnumerable<Product>
	{
		public IEnumerable<Product> products {get; set;}
		
		//overriding? GetEnumerator() and
		//referencing it to the products Enumerator
		//which is what we need in this logic
		//but can it be overriden without the keyword override?
		public IEnumerator<Product> GetEnumerator()
		{
			return products.GetEnumerator();
		} 

		//I don't know what this does...????
		//its private, but IEnumerable.GetEnumerator() where
		//is it taking us???
		IEnumerator IEnumerable.GetEnumerator()
		{
			//is this the GetEnumerator() that I've overriden?
			return GetEnumerator();
		} 
	}
}
	
```

in updated Models/ExtensionMethods.cs:
```C#
namespace LanguageFeatures.Models
{
	public static ExtenshionMethods
	{
		public static decimal TotalPrice(this IEnumerable<Product> products)
		{
			decimal total = 0;
			foreach(Product prod in products)
			{
				total += prod?.Price ?? 0;
			}
		return total;
	}
}	
```

now in Controllers/HomeController.cs:
```C#
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using LanguageFeatures.Models;

namespace LanguageFeatures.Controllers
{
	public HomeController : Contoller
	{
		ShoppingCart cart = new ShoppingCart { Products = Product.GetProduct(); };
		Product[] productArray = {
			new Product { Name = "Kayak", Price = 234M},
			new Product { Name = "LifeJacket", Price = 32M}
		};
	decimal cartTotal = cart.TotalPrices();
	decimal arrayTotal = producetArray.TotalPrices();

	return View("Index", new string[] {
			$"Cart Total: {cartTotal:C2}",
			$"Array Total: {arrayTotal:C2}" });
	}
}
					
```

### Creating Filter Functions with Extension methods
in Models/ExtensionMethods.cs:

```C#
...

public static IEnumerable<Product> FilterByPrice( this IEnumerable<Product> productEnum, decimal minimumPrice)
{
	foreach(Product prod in productEnum)
	{
		if((prod?.Price ?? 0) >= minimumPrice)
		{
			//return usually breaks the foreach loop
			//but yield breaks for the current object
			//and then continues execution for the next one?
			//to return each element one at a time
			yield return prod;
		}
	}
}
...
```

in Controllers/HomeController.cs:

```C#
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using LanguageFeatures.Models;

namespace LanguageFeatures.Controllers
{
	public class HomeController : Controller
	{
		public ViewResult Index()
		{
			Product[] productArray =	
			{
				new Product {Name="Kaya", Price=23M},
				new Product {Name="Life", Price=12M},
				new Product {Name="Ball", Price=19M},
				new Product {Name="Flag", Price=21M}
			};
			
		decimal arrayTotal = productArray.FilterByPrice(20).TotalPrices();
		return View("Index", new string[] { $"Array Total: {arrayTotal:C2}" });
		}
	}
}
```
What happened here is very important... 
<br/>
We created an array of objects type Product,
<br/>
which is a collection therefore inherits from IEnumerable,
because collections are enumerables...
<br/>
Because we defined Selector Extension Method for IEnumerable,
it will work for any collection, and because that method returns
another IEnumerable and on this enumerable we can use another
extension method which extends IEnumerable but returns decimal...
<br/>
In the end reference it in with ```C# decimal arrayTotal ...```
<br/>


##  Lambda Functions
Selectors,Filters, can be many different kinds. 
<br/>
But the core of them is that they have predicates as Logic.
<br/>
Predicate is a statement/expression which can be either true or false.
<br/>
It would be goold if we could pass this predicate logic to the filter
or select method and it could use that logic.
<br/>
It is actually possible to pass the logic using the lambda functions... 

in Models/ExtendedMethods.cs:
```C#
...
//Func is probably base object for all 'referenceable logic'
public static IEnumerable<Product> Filter(this IEnumerable<Product> productEnum, Func<Product, bool> selector)
{
	foreach(Product prod in productEnum)
	{
		if(selector(prod))
		{
			yield return prod;
		}
	}
}
..
```
in Controllers/HomeController.cs:
```C#
using System;
...

bool FilterByPrice(Product p)
{
	return (p?.Price ?? 0) >= 20;
}

public ViewResult Index()
{
	Product[] productArray =
	{ 
	{...},
	{...}
	};

	//no 'new' for delegate?
	//this is kinda weird
	//delegate is like a funcion pointer
	//if I remember correclty
	//which is basically a pointer to some logic
	//isn't the func the same thing??
	//more research needed...
	Func<Product, bool> nameFilter = delegate (Product prod){	
		return prod?.Name?[0] == 'S'; 
	};

	decimal priceFilterTotal = productArray 
		.Filter(FilterByPrice)
		.TotalPrices();

	decimal nameFilterTotal = productArray
		.Filter(nameFilter)
		.TotalPrices();

	return View("Index", new string[] {
		$"Price Total: {priceFilterTotal:C2}",
		$"Name total:  {nameFilterTotal:C2} });
}	
	

...
```

These are both <b>BAD</b> ways to pass the Block of Logic...
<br/>

FilterByPrice(...) method doesn't really belong there and it clutters	
up the HomeController class definition...
<br/>

Creating Func<Product, bool> and assigning it to the delegate is weird
syntax wise and I don't really understand what's happening there,
it also looks bad...
<br/>

Lambda functions are more elegant and overall better way to define
methods, inline methods and are more expressive...

instead of previous code we will only have:
```C#
...
public ViewResult Index()
{
	Product[] productArray =  { new Product {...}, ... };


	//types of lambda functions are inferred automatically
	// '=>' reads as 'goes to'
	//links a parameter to the result expression
	//Product parameter p goes to a bool result !!!
	decimal priceFilter = productArray
		.Filter(p => (p?.Price ?? 0 ) => 20)
		.TotalPrice();

	decimal nameFilter = productArray
		.Filter((p) => (p?.Name[0] == 'S')) 
		.TotalPrice();

	return View("Index", new string[] { ... };
}
...
	
```

important thing, multiple line lambda expression:
```C#
(prod, count) => {
	//multiple line logic
	return result;
}
```

## Smalltalk about Delegates
Delegates are type-safe pointers of any methods...
<br/>
Delegates are of so called <i>reference types</i> in C#.
<br/>
Which mean that they hold references to objects...(to methods in this
case)...
<br/>
Delegates are mainly used in implementing call-back methods and events.
<br/>

Delegates are type-safe because while declearing them the definition
of the return type and parameter number and type is necessery...
Therefore the methods type and parameters are checked to fit the 
format of the delegate...
<br/>

<i>Func<T, TResult></i> - a delegate that points to a method which returns a value.
<br/>
<i>Action</i> - a delegate that points to a method which return no value.
<br/>

Lambda Expression in C# LINQ's Select:
```C#
using System.Linq;
...

return View("Index", Product.GetProducts().Select(p => p?.Name));
...
```

Action Method expressed as Lambda Expression:
```C#
public ViewResult Index() => 
	View("Index", Product.GetProducts().Select(p => p?.Name));	
```


Lambda Expression defining Properties:
```C#
public class Product
{
...
public string Name {get;set;}
public bool NameBeginsWithS => Name?[0] == 'S';
...
```

## Type Inference and Anonymous Types

C# is a strictly-typed, compiled language, but it has some features that
look like something that belongs to dynamic-typed language
<br/>

With type inference we can ask compiler to infere the types for some
objects... 
```C#
public ViewResult Index()
{
	var names = new [] {"Jacob", "Moses", "Abraham"};
	return View("Index", names);
}
```
This combined with object initializers we can construct something called
anonymous types...
<br/>
Anonymous types, but anonymous for whom?? For us?? 
<br/>
Trick here is that we must initialize same properties in every object
so that compiler is able to find the right class therefore the right
type... But if we know the properties of the class, why shouldn't
know the identifier for that class itself???
<br/>
Also, 'var' doesn't dynamically enlarge the variable table, it is 
still strongly typed but during compilation by compiler itself...
Compiler probably goes through all the classes, therefore it has
a table of classes, and tries to match the properties that are being
declared to some class in the table... 

Anonymous types in Controllers/HomeController.cs:
```C#
...
public ViewResult Index()
{
	var products = new []
	{
		new { Name="kayak", Price=234M},
		new { Name="Balls", Price=21M}
	};

	return View(products.Select(p => p.Name));	
}
```

But then the book says that compiler <b>Generates</b> the class for the
two anonymously typed objects that have the same property names.
<br/>
So which is it then: <b>Mathching</b> or <b>Generating</b>?
<br/>

I thinks it generates a class that wraps those properties,
and assigns them as their type.
Because if this is compiled:
```C#
...
return View(products.Select(p => p.GetType().Name));
...
```

When printed output is:
```C#
<>f__AnonymousType0`2
<>f__AnonymousType0`2
```

Which means that the class with the name <b><>f__AnonymousType0`2</b>
has been generated with those two Name and Price properties...
<br/>
Which is kind of weird...
<br/>

# Asynchronous Methods

"Synchronously means using the same clock, so when two instructions
are synchronous they use the same clock and must happen one after another
. Asynchronous means not using the same clock, so the instructions are
not concerned with being in step with each other."

Asynchronous execution doesn't need multiple threads in the processor,
it...
<br/>
Like the CPU time is split between different processes, so is the
process divided into multiple tasks. These tasks are blocks of 
code(which needs more research), and these tasks can happen 
synchronously or asynchronously...

In reality this to work asynchronous task must be 2 tasks at least,
<br/>
First, synchronous to the caller, which will initiazte the 
asynchronous task and where the asynchronous task will return after
complition
<br/>
Second, the asynchronous task itself...
<br/>
Also, the second task must somehow tell the caller task that
it has been completed... Either this happens with interrupt or
by first task checking if the second has completed or not...
Turns out this mechanis is implemented in many different ways..
<br/>
https://en.wikipedia.org/wiki/Asynchronous_I/O

https://en.wikipedia.org/wiki/Thread_pool

https://en.wikipedia.org/wiki/Futures_and_promises

https://en.wikipedia.org/wiki/Thread_(computing)

https://en.wikipedia.org/wiki/Computer_multitasking

<br/>
This is how I understand asynchronousity in C#.
<br/>
methods that are 'async' are fully asynchronous, which means what?
maybe they are executed on another thread, maybe on the same thread but
have their own timer and are scheduled 'stand-alonedly' from the main
process. Which I suppose means that the scheduling goes on different 
levels, one on process level and then inside processes thread or task
level. 
<br/>

Lets write two methods that are not depended on each other:
```C#
class Program
{
	public static void Main(string[] args)
	{
		Method_1();
		Method_2();
		Console.ReadKey();
	}

	public static async Task Method_1()
	{
		await Task.Run( () => 
			{
				for (int i = 0; i<100; i++)
				{
					Console.WriteLine(" Method_1");
				}
			});
	}

	public static void Method_2()
	{
		for (int i = 0; i < 30; i++)
		{
			Console.WriteLine(" Method_2");
		}
	}
}
		
	
```
Ouput will be something like this:
```C#
 Method_1
 Method_1
 Method_2
 Method_2
 Method_2
 Method_1
 ...
```
Because Method_1 is a different Task from the 'main Task', it becomes
something like two different processes inside a process.
<br/>

Because both of these tasks are outputting in the same standard output,
they have to somehow share it, and plus because both of these funcs
are  void, side-effect funcs, they return Task type, which is a future
in C# without a specifig type on its own... 

<br/>
'await' stops the function's execution on the line and  
waits for that action to be finished, but it stops couple of times
before that action can be fully finished, because its time on CPU is
over, then it has to return something to the 'main Task', but 
because the function isn't fully executed it returns Task-type,
which basically is a 'future', which means that its type isn't
known yet, but it will be known in the future and handle it as that... 
Function that assigns the final value to the 'future' is called 
a 'Promise'. I think these are used in lazy evaluations too, 
because functions values are not calculated right away(during 
assignment), but when its value is actually needed, therefore
during assignment the type must be given to these kind of objects and
its 'future'.
<br/>
When the 'await' action is fully executed during on of the executions
of the Task on the CPU, it then assings a value to the 'Task', 
and continues executing what's left in the function... 
<br/>
 
If we want to use the returned value of asynchronous value
we have to do something like this:
```C#
class Program
{
	public static void Main(string[] args)
	{
		CallAsyncMethods();
	}


	public static async Task CallAsyncMethods()
	{
		Task<int> task = Method_1();
		Method_2();
		//This must be fully finished 
		//before going to the next line
		int count = await task;
		Method_3(count);
	}

	public static async Task<int> Method_1()
	{
		await Task.Run(() =>
		{
			int count = 0;
			for(int i = 0; i < 100; i++)
			{
				Console.WriteLine(" Method_1");
				count++;
			}
		});
		return count;
	}

	public static void Method_2()
	{
		for(int i = 0; i < 25; i++)
		{
			Console.WriteLine(" Method_2");
		}
	}

	public static voic Method_3(int count)
	{
		Console.WriteLine($"Count: {count}");	
	}
}
```

In order to create a Sequence between asynchronous methods or a 
synchronous method and a asynchronous method, we have to wrapper
asynchronous method( CallAsynchMethods() ), so that we can use
await on those asynchronous methods and sort them out... 

This topic is very interesting and useful, so defenitiley more research on this one!!!!!!!!!!!!!!!!

# Getting Names
This is just a better name for displaying info as names of propertis, stable 
after changes and so on.. and so on...:
```C#
namespace LanguageFeatures.Controllers
{
	public class HomeController : Controller
	{
		public ViewResult Index()
		{
			Product[] products = new Product[]
			{ 
				new Product { Name = "Kayak", Price = 23M},
				new Product { Name = "Ball",  Price = 21M}
			};
			return View(products.Select(p => 
				$"{nameof(p.Name)}: {p.Name}, {nameof(p.Price)}: {p.Price}"));
		}
	}
}
```
