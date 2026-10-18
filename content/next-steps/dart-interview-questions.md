---
title: "Dart Interview Questions and Answers"
seoTitle: "Dart Interview Questions and Answers (Beginner to Advanced)"
linkTitle: "Interview questions"
description: "Forty common Dart interview questions with clear answers, covering basics, null safety, OOP, async, collections and Dart 3 features."
weight: 3
date: 2026-10-10
lastmod: 2026-10-10
keywords:
  - "dart interview questions"
  - "dart questions and answers"
  - "flutter interview dart"
  - "dart quiz"
  - "dart concepts"
---

These are the questions that come up most in Dart and Flutter interviews. Each answer is short on purpose, and links to the lesson that covers the topic in depth. Try to answer each one aloud before reading on.

## Language basics

**1. What is Dart, and where is it used?**  
Dart is a typed, object-oriented language from Google. It is the language of Flutter, and is also used for command-line tools, servers and web apps. See [what is Dart](/getting-started/what-is-dart/).

**2. What is the difference between `var`, `final` and `const`?**  
`var` can be reassigned. `final` can be set once, at run time. `const` is a compile-time constant and is deeply immutable. See [final and const](/dart-basics/final-and-const/).

**3. What is the difference between `dynamic`, `var` and `Object`?**  
`var` infers a fixed type from the first value. `dynamic` switches off static checking, so any member access compiles and may fail at run time. `Object` accepts any non-null value but only allows members that every object has, until you check the type.

**4. What is the difference between JIT and AOT compilation?**  
JIT compiles while the program runs, enabling hot reload and fast development. AOT compiles to native machine code beforehand, giving fast start-up and steady performance in release builds.

**5. What is the difference between `==` and `identical()`?**  
`identical` checks whether two references point to the same object. `==` checks equality, which a class can define by overriding the operator. See [equality and hashCode](/object-oriented-programming/equality-and-hashcode/).

**6. What does the cascade operator `..` do?**  
It performs several operations on the same object and evaluates to that object, as in `list..add(1)..add(2)`.

**7. What are the kinds of function parameter in Dart?**  
Required positional, optional positional (in `[]`), and named (in `{}`), which may be `required` or have default values. See [function parameters](/functions/function-parameters/).

**8. What is a closure?**  
A function that captures variables from the scope where it was created and can use them later, after that scope has ended. See [closures](/functions/anonymous-functions-and-closures/).

**9. What is a typedef?**  
An alias for a type, most often used to give a function type a readable name.

## Null safety

**10. What is sound null safety?**  
Types are non-nullable by default. A variable can hold `null` only if its type ends in `?`, and the compiler guarantees that a non-nullable expression never evaluates to null. See [null safety](/null-safety/null-safety-in-dart/).

**11. Explain `?.`, `??`, `??=` and `!`.**  
`a?.b` accesses `b` only if `a` is not null. `a ?? b` gives `b` when `a` is null. `a ??= b` assigns `b` only if `a` is null. `a!` asserts that `a` is not null and throws if it is. See [null-aware operators](/null-safety/null-aware-operators/).

**12. What does `late` do?**  
It declares a non-nullable variable that is initialized after its declaration. With an initializer, it is computed lazily on first use. Reading it before it is set throws a `LateInitializationError`. See [late variables](/null-safety/late-variables/).

**13. What is type promotion?**  
After a check such as `if (x != null)` or `if (x is String)`, Dart treats a local variable as the narrower type within that scope.

## Collections

**14. What is the difference between `List`, `Set` and `Map`?**  
A list is ordered and allows duplicates. A set holds unique values with fast lookup. A map stores key and value pairs with unique keys. See [collections overview](/collections/collections-overview/).

**15. What is the difference between `map`, `where`, `fold` and `reduce`?**  
`map` transforms each element. `where` filters. `reduce` combines elements into one value of the same type and fails on an empty collection. `fold` combines with an initial value and may return a different type. See [where, map, reduce and fold](/collections/where-map-reduce/).

**16. What does it mean that iterables are lazy?**  
Methods such as `map` and `where` do no work until the result is iterated, and repeat the work on every iteration. Calling `toList()` evaluates them once. See [iterables](/collections/iterables/).

**17. What are the spread operator, collection if and collection for?**  
`...list` inserts all the elements of a collection into another. `if` and `for` inside a collection literal add elements conditionally or in a loop. See [spread, if and for](/collections/spread-and-collection-if/).

## Object-oriented programming

**18. What kinds of constructor does Dart have?**  
Default, generative with initializing formals (`this.x`), named, redirecting, `const` and `factory`. See [constructors](/object-oriented-programming/constructors/).

**19. What is a factory constructor?**  
A constructor that can return an existing instance, a subtype, or a newly built object after some logic. It has no access to `this`. Common uses are caches, singletons and `fromJson`. See [factory constructors](/object-oriented-programming/factory-constructors/).

**20. What is the difference between `extends`, `implements` and `with`?**  
`extends` inherits the implementation of one superclass. `implements` adopts the interface of one or more classes and must define every member. `with` mixes in the implementation of one or more mixins.

**21. What is the difference between an abstract class and an interface?**  
An abstract class cannot be instantiated and may contain both abstract and implemented members; subclasses `extend` it. Dart has no separate interface declaration: every class defines an implicit interface that others can `implement`. See [interfaces](/object-oriented-programming/interfaces/).

**22. What is a mixin, and when would you use one?**  
A reusable set of members that can be added to classes with `with`, without inheritance. Use it to share behaviour across unrelated classes. See [mixins](/object-oriented-programming/mixins/).

**23. How is privacy handled in Dart?**  
An identifier that starts with `_` is private to its library, which is usually one file. There are no `private` or `protected` keywords. See [private members](/object-oriented-programming/private-members/).

**24. Does Dart support method overloading or multiple inheritance?**  
No to both. Optional and named parameters and named constructors replace overloading. Mixins and interfaces replace multiple inheritance.

**25. Why must you override `hashCode` when you override `==`?**  
Hash-based collections use `hashCode` to locate objects. If equal objects had different hash codes, sets and maps would treat them as different.

**26. What are extension methods?**  
A way to add members to an existing type without changing or subclassing it. They are resolved statically, from the declared type. See [extension methods](/object-oriented-programming/extension-methods/).

**27. What are generics, and why use them?**  
Type parameters such as `List<T>` let one class or function work with many types while keeping static type safety and avoiding casts. See [generics](/object-oriented-programming/generics/).

**28. What is an enhanced enum?**  
An enum that declares fields, a const constructor, methods, and can implement interfaces. See [enums](/object-oriented-programming/enums/).

## Dart 3 features

**29. What is a record?**  
An immutable, fixed-size aggregate of values with positional and named fields and built-in value equality, as in `(String, int)` or `({String name, int age})`. Often used to return several values. See [records](/records-and-patterns/records/).

**30. What is pattern matching?**  
Testing a value against a shape and destructuring it into variables in one step, in `switch`, `if-case`, declarations and loops. See [patterns](/records-and-patterns/patterns/).

**31. What is a sealed class?**  
An abstract class whose direct subtypes must all be in the same library. The compiler therefore knows every subtype and can check that a `switch` handles them all. See [sealed classes](/records-and-patterns/sealed-classes/).

**32. What do the class modifiers `base`, `interface` and `final` do?**  
They restrict use from other libraries. `base` allows extending but not implementing. `interface` allows implementing but not extending. `final` allows neither. See [class modifiers](/object-oriented-programming/class-modifiers/).

**33. What is an extension type?**  
A compile-time wrapper around an existing type that creates a distinct static type with no run-time cost. See [extension types](/object-oriented-programming/extension-types/).

## Asynchronous programming

**34. What is a Future?**  
An object representing a value or an error that will be available later. It is uncompleted, completed with a value, or completed with an error. See [futures](/async/futures/).

**35. What do `async` and `await` do?**  
`async` marks a function that returns a `Future` and may use `await`. `await` suspends that function until a future completes, without blocking the thread. See [async and await](/async/async-await/).

**36. What is the difference between a Future and a Stream?**  
A future delivers one result. A stream delivers a sequence of results over time. See [streams](/async/streams/).

**37. What is the difference between single-subscription and broadcast streams?**  
A single-subscription stream allows one listener and buffers events until it is listened to. A broadcast stream allows many listeners and does not buffer, so late listeners miss earlier events. See [stream types](/async/stream-types/).

**38. Is Dart single-threaded? How does it handle concurrency?**  
Each isolate runs on one thread with an event loop. Asynchronous I/O is handled by overlapping waiting time on that thread. True parallelism uses several isolates, which share no memory and communicate by messages. See [the event loop](/async/event-loop/) and [isolates](/async/isolates/).

**39. What is the difference between the microtask queue and the event queue?**  
Microtasks, such as future completions, run first and the queue is emptied completely before the next event. Events, such as timers and I/O, are then handled one at a time.

**40. How do you run several futures in parallel?**  
Start them all and await them together with `Future.wait([...])` or the `.wait` extension on a record or list. See [parallel futures](/async/parallel-futures/).

## Questions that test understanding

Interviewers often follow up with "what does this print?" Make sure you can explain these.

```dart
void main() {
  print('A');
  Future(() => print('B'));
  Future.microtask(() => print('C'));
  print('D');
}
```

```output
A
D
C
B
```

Synchronous code runs first, then microtasks, then events.

```dart
void main() {
  final a = [1, 2];
  final b = a;
  b.add(3);
  print(a);

  const c = [1, 2];
  print(identical(c, const [1, 2]));
}
```

```output
[1, 2, 3]
true
```

`final` fixes the variable, not the list's contents, and `b` refers to the same list. Equal constants are the same object.

## How to prepare

- Do not memorise answers. For each question, write a five-line example that demonstrates it.
- Practise explaining aloud. Being able to say it clearly matters as much as knowing it.
- Be ready to talk about a project you built: what was hard, what you would change.
- If you do not know something, say so, and then reason towards an answer.

## Try it yourself

Cover the answers and work through ten questions a day for four days. Mark the ones you could not answer, revisit the linked lessons, and try again a week later.
