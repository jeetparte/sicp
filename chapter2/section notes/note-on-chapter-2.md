# SICP Note on Chapter 2

In the last chapter, we learn about procedural abstraction I.e., being able to think about a procedure in terms of what it does while ignoring how it does it. The analogous notion for data is called _data abstraction_.

The parts of our programs that use data should manipulate the data at the level of abstraction	it provides and should not be concerned with the underlying "concrete" implementation that realises that abstraction. The interface between parts of our programs that use abstract data and those that implement them is a set of procedures called _constructors_ and _selectors_.


The language provides a compound structure called a _pair_. It is implemented by the primitive procedures `cons`, `car` and `cadr`.