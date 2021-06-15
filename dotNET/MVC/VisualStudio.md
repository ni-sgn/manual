# These are IMPORTANT
```C#
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extendions.DependencyInjection; 
```

Some Breakpoint stuff, some bundling and minifying.
Seems like browsers downloads static files one by one when it reads <link>...
</link> or a <script>...</script> files...

<br/>
And its downloading whole files, whitespaces and variables that aren't really, 
needed for client, therefore minify meands deleting the whitespaces and the
variables that aren't needed. Bundling means combining different static files
so that browser will download them in one HTTP request... 
