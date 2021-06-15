# Razor

## View Import
By configuration called in <i>Startup.cs</i>, first requests are sent 
to the controller called 'Home'. 
<br/>

Razor Engine is looking up models in namespaces which can be imported
in _ViewImports.cshtml 

in Views/_ViewImports.cshtml:
```C#
using Razor.Models;
```
Razor is a project name;

in Views/Home/Index.cshtml:
```C#
@model Product
```
instead of importing @model Razor.Models.Product, we are able
to see Product right away... 

Therefore yes, we are including <b>Namespaces</b> with <b>Using</b>
<br/>
Namespace:<b>Razor.Models ,Type:<b>Product</b>

<br/>
Razor Views compiled into C# classes and for example <b>Layout</b>
is its property...

## View Layout
self-contained view = @{ Layout = null; }
<br/>
If Views have shared html, this can be expressed through Layouts...
<br/>
Layouts are created in Views/Shared folder 

in Views/Shared/_BasicLayout.cshtml:
```C#
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content"width=device-width" />
	<title>@ViewBag.Title</title>
</head>
<body>
	<h1> Product Animation </h1>
	<div style="...">
		@RenderBody()
	</div>
</body>
</html>	
```

<b>@RenderBody</b> insert the View specified by the action method
into the layout markup. 

in View/Home/Index.cshtml:
```C#
@model Product
@{
	Layout = "_BasicLayout";
	ViewBag.Title = "Product Name";
}

Product Name: @Model.Name
```

Why is it @Model.Name and not @Product.Name???
Maybe the intermediary between the Controller classes and the
View classes is this Model class, where we add objects from
controller and then read from View...

<br/>

the result of this is an <b>Unified HTML Response</b>

## View Start
If there is a view that is shared between all the views
we want to be able to express that, so that if we change the
name of that view we don't have to change it in every single
View file.
<br/>
Layout imported in the _ViewStart.cshtml is shared between
all the Views, if it's located inside the Views/Shared folder.

in Views/Shared/_ViewStart.cshtml:
```C#
@{
	Layout = "_BasicLayout";
}
```

Good thing is that we can override this...
<br/>
Closest ViewStart file will override the others,
or we can even override the Layout property inside the view 
itself. 

If we don't set view to null, engine will automatically assume
that we want to use the layout which is inside the ViewStart.

## Formatting Vs Processing
Formatting goes into View, processing goes into Controllers!!!

## Expressions
<b>@{@:text}</b> inside the razor block <b>@:</b> tells the 
engine that te text next to it isn't C# or html?...
<br/>

<b>Model</b> doesnt need <b>@</b> when it's part of the bigger
expression.

