# SICP exercise 1.33

Notice how the names of the procedures get bigger, describing higher level operations in a sentence-like manner.
Also, note how the iterative variant of `filtered-accumulate` avoids the long line of text involved in the recursive call.

That can also be avoided in the recursive variant by enclosing the recursive procedure in a new outer procedure and pushing the parameters that don't change from across calls to the outer one. Note that the outer procedure now becomes the public API. 