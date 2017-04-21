# Async programming

The concept of asynchronous programming can at times seem arcane and mysterious. It's hard to reason about code when you do not know exactly in which order specific lines of code run. 
In .Net the whole process got a whole lot easier with the introduction of the `async` and `await` keywords a couple of years back (a feature that is about to come to JavaScript as well eventually). 
Although it's been a while since they were introduced many .Net programmers still have not had a chance (or will) to use them and can feel put off by all the `async` methods in the 
Contentful .Net SDK. The aim of this article is to give you a better understanding of how asynchronous programming works in .Net and the benefits it brings to your code.

## Why async?
Why even bother? Why can't everything just run synchronously? The answer is of course that everything _could_ run synchronously and the code would still work as expected, but lets look at
this small example.

```cs
var product = _client.GetEntry<Product>("123");

return product.Name;
```

This method is not asynchronous and thus runs synchronously. The call to `GetEntry` in turn calls methods on the `HttpClient` and fetches a response from the Contentful API. This means
that while we're waiting for the response from the API (quick as it might be there's still a significant latency in code execution terms) **no other code** can run on the thread. It is
busy doing **nothing** but waiting for the response from the Contentful API. It could be compared to if you stand in line to order a hamburger at your favorite burger joint and the cashier tells
you your order will be done in a minute and then just stands there staring at you for a full minute until your hamburger is done. This is of course extremely inefficient. There must be a
way to use that minute of wasted time. This is basically what we address when we add `async` and `await` to the mix. Lets rewrite our method slightly.

```cs
var product = await _client.GetEntryAsync<Product>("123");

return product.Name;
```

This little addition of `await` makes all the difference in the world. This means the code will now wait asynchronously for the result of `GetEntryAsync` meaning that _while_ it's waiting
the thread is actually free to do whatever other work needs to be done. It's like the cashier in our example above telling you that your order will be done in a minute and then going on to 
serve the next person in line.

Note that this might not get you your hamburger faster, but it is a more effecient use of resources. Exactly the same thing is true for our `GetEntry` call, making it asynchronously will not
make the call return the result any faster, but makes sure we use our resources as effeciently as possible.

## Can we await any method?
Unfortunately (or maybe fortunately) no, to be able to `await` a method the result from that method needs to be _awaitable_. What does this mean? Well, it's quite complex and means the return type of the 
method needs to be able to capture an execution context and all sorts of very low level things which are well beyond the scope of this article. Fortunately there are two simple 
awaitables already created and ready to be used in the .Net framework. `Task` and `Task<T>`.
If a method returns any of these two types it can be awaited.

This leads us to an interesting conclusion. There must be a difference between the return type of `GetEntry` and `GetEntryAsync`.

```cs
public T GetEntry<T>;
public Task<T> GetEntryAsync<T>;
```

This means that if you try to call the `GetEntryAsync` method without using `await` you'll actually end up with a `Task<T>` and not the `Product` class as you might've hoped. By placing
the `await` keyword before our method call the result will actually be the unwrapped result of `Task<T>` to a `T` or `Product` in our example.

## But then my method must also be async...

If you have a method like this.

```cs
public Product GetProductById(string id) {
  var product = await _client.GetEntryAsync<Product>(id);

  return product;
}
```

You'll notice that this does not compile. The error message is 
`The 'await' operator can only be used within an async method. Consider marking this method with the 'async' modifier and changing its return type to 'Task<Product>'`. This means that 
there is one more requirement to be able to use the `await` operator. The method itself must itself be asynchronous. Thus we must rewrite our method like this.

```cs
public async Task<Product> GetProductById(string id) {
  var product = await _client.GetEntryAsync<Product>(id);

  return product;
}
```

This compiles fine. We should also add the _async_ suffix to our method to adhere to common practise.

 ```cs
public async Task<Product> GetProductByIdAsync(string id) {
  var product = await _client.GetEntryAsync<Product>(id);

  return product;
}
```

This is all fine **but** this means that any code calling our `GetProductByIdAsync` method **also needs to be asynchronous**, at least to be able to use the `await` operator (which you should).

Some people have refered to the async/await pattern to a contagion that slowly consumes your entire code base. While this is of course an exaggeration introducing asynchronous methods does 
tend to force you to change more than just the calling method into an asynchronous one. While this can be tedious the upside is that you're, with a few simple keywords, making sure your
code is as performant and non-blocking as possible.

## Deadlocks ahoy!

While the async/await keywords makes asynchronous programming almost invisible to us it also does increase the complexity under the hood. Lets again look at a simple example to better
illustrate what we're talking about.

```cs
public async Task SomeAsyncMethod(){
  var i = 5 +7;

  await DoSomethingWithSomeNumberAsync(i);

  i += 36;
}
```

This fairly useless function runs asynchronously, but is all of it asynchronous? In fact no, the code will run synchronously until it reaches the `await` operator. Now `await` grabs
the _awaitable_ returned from the `DoSomethingWithSomeNumberAsync` method and examines if it has already completed. If so it then just resumes code execution normally and synchronously.
If it has not completed however it actually returns and exits the current method and tells the awaitable to execute the reminder of the method once it completes. This means that 
`i += 36;` will not execute until the `DoSomethingWithSomeNumberAsync` is completed, thus giving us the illusion of synchronous code while actually being run asynchronously.

We could force our method to block while waiting for the asynchronous method. Lets look at an example in a web context. Imagine we have the following controller action.

```cs
public IActionResult ShowProduct(string id) {

  var product = _client.GetEntryAsync<Product>(id).Result;

  return View(product);
}
```

Here we've gotten lazy and not made our method `async`, instead we _block_ the method by calling `.Result` on our awaitable, effectiviely making our asynchronous calls useless as the
thread is now being blocked waiting for the result of `GetEntryAsync` to return. Not only does this make our call synchronous and our async calls further down the call chain superfluous
but it can also be a recipe for deadlocks.

Every `async` call in .Net is by default trying to keep track of the _context_ in which it was called. In our Asp.Net example above this would be the `RequestContext` of the current request.
When the `async` method returns it tries to get ahold of this context again to make sure the reminder of the code is executed in the same context as where the method entered. This poses a
real problem in our simple example above, when the `async` method tries to get ahold of the `RequestContext` it is already occupied waiting for the `Result` of the asynchronous method,
which in turn is waiting for the `RequestContext` to become available. Deadlock!

Luckily the Contentful SDK mitigates this problem by disregarding the context in which it was called. It simply isn't necessary for the SDK to return the result of the calls in any 
specific context. This means that the code above actually does work when using the Contentful .Net SDK directly, but it's still not good practice. Here's a better way to write that
same method.

```cs
public async Task<IActionResult> ShowProduct(string id) {

  var product = await _client.GetEntryAsync<Product>(id);

  return View(product);
}
```

Non-blocking asynchronous code and no risk for deadlocks.

## Why not expose synchronous calls as well?

We could of course double the api surface of `IContentfulClient` and `IContentfulManagementClient` by adding a block synchronous method for each call. We would then have two methods
for every call to the api, for example.

```cs
public T GetEntry<T>(string id);
public Task<T> GetEntryAsync<T>(string id);
```

We do not believe in this however. The Contentful SDK is at its core an asynchronous library. Every call through the API is basically routed to the `HttpClient` and the `SendAsync` method.
By exposing two methods to chose from we are hiding this fact from the consumer and making available a less performant way to make the same call, which makes no real sense. It is also 
hard for us to make speculations about consuming code, by keeping everything asynchronous we force ourselves to never depend on the threading environment and make sure our SDK is as 
performant and lean as possible.

If a consumer of the SDK still wishes to call the methods synchronously this is of course entirely up to him or her, but then at least you do so with your eyes open fully aware that you
are actually blocking asynchronous methods in a potentially wasteful way.