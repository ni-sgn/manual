# Configuration
Dependency injection( <i> Chapter 18 </i> )

## Startup.cs
<br/>
public void ConfigureServices(IServiceCollection services){}
<br/>
AddMvc();
<br/>
public void Configure(IApplicationBuilder app, IHostingEnvironment env)
<br/>
UseDeveloperExceptionPage();
<br/>
UseStatusCodePages();
<br/>
UseStaticFiles();
<br/>
UseMvc();
<br/>
One thing to think about is that these methods are <b>Extension Methods</b>

## _ViewImport.cshtml
@using SportsStore.Models
<br/>
@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers;

## Domain Model
Classes are like database schemas, therefore one can easily be turned into 
other...
<br/>
If I create a class like this:
```C#
namespace MyProject.Models
{
	public class Article
	{
		public int ArticleId{ get; set; }
		public string Title { get; set; }
		public string Body  { get; set; }
		public string Picture { get; set; }
	}	
}
```

This can be turned into database schema for an Article.
But some questions arise:<br/>
1)When I have this class in C#  and getting a database instance from 
the db, is how does it work? Create one object with Article type and then
bind the values from the db, or create an object for each db instance. 
2) Why do I have to create a repository for this class, when database is
already a repository and I can filter out the objects I want using the
queries... I guess if I want to hold those objects for a while I have to
put them in the collection? Then add them inside of an array...

## Repository
loosely coupled components - sustad shekavshirebuli
<br/>
AddTransient<..., ...>();
<br/>
### Very important... (dependency injection)
When MVC needs to create a new instance of the ProductController class to handle an HTTP request,
it will inspect the constructor and see that it requires an object that implements the IProductRepository
interface. To determine what implementation class should be used, MVC consults the configuration in
the Startup class, which tells it that FakeRepository should be used and that a new instance should be
created every time. MVC creates a new FakeRepository object and uses it to invoke the ProductController
constructor in order to create the controller object that will process the HTTP request.
<br/>
<b>Implementation Class</b> yes... Interfaces have implementation classes...
which means that interface can be implemented by different classes.

Now, lets look at this code:
```C#
using Microsoft.AspNetCore.Mvc;
using SportsStore.Models;

namespace SportsStore.Controllers
{
	public class ProductController : Controller
	{
		//this interface will be automatically implemented
		//as FakeProductRepository
		//because of the dependency injection

		private IProductRepository repository;
	        
		public ProductController(IProductRepository repo)
		{
			//Dependency injection sends a new instance
			//of FakeProductRepository throught the constructor
			//after evaluating the dependency injection...
			repository = repo;	
		}

		public ViewResult List() => View(repository.Products);
	}
}
```

FakeProductRepository inherits from IProductRepository therefore
IProductRepository can be implemented by FakeProductRepository, which has
statically added objects inside the Products property with a type of Product.

## _Layout.cshtml


## _ViewStart.cshtml


### Important:
The view doesn’t know where the Product objects came from, how they were obtained, or whether
they represent all of the products known to the application. Instead, the view deals only with how details of
each Product is displayed using HTML elements, which is consistent with the separation of concerns
<br/>
Separation of Concerns - Movaleobata gadanawileba...


