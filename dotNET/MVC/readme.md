###Routing system(Uniform Resource Locators)###
###Application Container Platform(Docker)###
###Source @ https://github.com/apsnet   ####


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

inside controller:

public IActionResult Index()
{
	return View("MyView");
}

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
public string Index(){ return "hello world"; }

renderd view:
public ViewResult() { return view("MyView");}

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

