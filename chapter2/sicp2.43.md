# SICP - Exercise 2.43

The interchange makes the program run slowly because at every _kth_ step, it computes the _k-1th_ step `n` times (instead of just once, like in the original arrangement). This transforms the original linear recursive process into a tree recursive one.

## Analyzing time required to solve the eight-queens puzzle (n = 8)

Let us analyze the original program first.

### Original program

#### Process pattern

For a board-size of n, we evaluate `(queens n)` which results in a call to `(queen-cols n)` which then calls `(queen-cols (n - 1))` and so on ... going down to `(queen-cols 1)` and finally, to `(queen-cols 0)`.

We can say that for any k in 1...n, the resources required for computing `(queen-cols k)`,

    R(queen-cols k) =  R(queen-cols (k - 1))
                      + resources required for the other operations in (queen-cols k)

Notice the linear recursive pattern. 

Also, we will refer to the second term in the R.H.S. as _r(queen-cols k)_.

#### Cost of operations

The cost of operations at each level depends on three factors: *n*, *k* and the number of board-positions it operates on, i.e. *length (queen-cols (k - 1))* from the previous level's output.

Cost of the various operations is summarized below:

| Operation                         | Cost            |
| --------------------------------- | --------------  |
| `enumerate-interval`              |   __𝚹(n)__, repeated __length (queen-cols (k - 1))__ times |
| `adjoin-position`*                |   __𝚹(1)__ or __𝚹(k)__, repeated __n * length (queen-cols (k - 1))__ times  |
| `flatten (accumulate-append)`     |   __𝚹(n * length (queen-cols (k - 1)))__  |
| `filter`                          |   __𝚹(n * length (queen-cols (k - 1)))__  |
| `safe?`                           |   __𝚹(k)__, repeated __n * length (queen-cols (k - 1))__ times |


Across level, _n_ remains constant, _k_ changes diminuitively. The overall cost is most influenced by the number of board positions: *length (queen-cols (k - 1))*.

*Each `adjoin-position` can be __𝚹(1)__ or __𝚹(k)__, depending on whether we are appending to the list of positions at the beginning or at the end.

#### Size of inputs and outputs

While we can't predict how many positions will be filtered out by the `safe?` predicate for a given _n_ and _k_, we can assume that the size of the filtered output is roughly proportional to the input. 

Proceeding with this assumption, we can say that the current step's output will be _n_ times that of the previous: **length (queen-cols k) = n * length (queen-cols (k - 1))**.
This means that **length (queen-cols k) = n ^ k**.

Effectively, we are ignoring the filtering of safe positions here.

Looking back at the cost of operations, we can say that the cost for the _kth_ level is roughly __𝚹(length (queen-cols k))__.

#### Conclusion

So for the original program, 

 ```
R(queens n) = r(queen-cols n) + r(queen-cols (n - 1)) + ... r(0)
            = n^n + n^(n-1) + ... n^0
            = Σ n^k
```
Therefore, R(queens n) = __𝚹(n^n)__.

Observe that this progess generates (because we ignored filtering,) all possible board positions for an _n x n_ board. __𝚹(n^n)__ is a natural consequence of that (n * n * n ... n times).

Now coming to Louis program with the interchanged mappings.

### Louis' program

#### Process pattern

The process pattern is tree recursive due to multiple calls to the underlying level:

    R(queen-cols k) =  n * R(queen-cols (k - 1))
                        + r(queen-cols k)

In the tree generated, there are _n_ branches off of each internal node and the height of the tree is _n + 1_.

#### Cost of operations

The cost of operations at each level is, for most operations, identical:

| Operation                         | Cost            |
| --------------------------------- | --------------  |
| `enumerate-interval`              |   __𝚹(n)__, *a single operation now* |
| `adjoin-position`                 |   same as before |
| `flatten (accumulate-append)`     |   same as before  |
| `filter`                          |   same as before  |
| `safe?`                           |   same as before |

#### Size of inputs and outputs

The size of inputs and outputs is the same as well. We make the same assumption about filtering here.

#### Conclusion

For Louis' program,

```
R(queens n) = r(queen-cols n) + n * (r(queen-cols (n - 1)) + n * (r(queen-cols (n - 2)) + ...))
             = r(queen-cols n) + n * r(queen-col (n - 1)) + n^2 * r(queen-cols (n - 2)) + ... n^n * r(queen-cols 0)
             = Σ n^k * r(queen-cols (n - k)) ... for k = 0 to n
```

We can express the cost at each level in terms of the highest level, (queen-cols n):

__r(queen-cols (n - 1)) = r(queen-cols n) / n__ (because it operates on no. of board positions _n_ times smaller). Stated generally, __r(queen-cols (n - k)) = r(queen-cols n) / n^k__. 

Since the _kth_ level is computed _n^k_ times, this means each level of the recursive tree amounts to a cost of __r(queen-cols n)__. Since there are _n + 1_ levels, the total cost,
```
R(queens n) = (n + 1) * r(queen-cols n)
```

If we compare the two programs,
```
R_Louis(queens n) / R_original(queens n) = ((n+1) * n^n) / (n^n * (1 + 1/n + 1/n^2 + ... 1/n^n)) = (n+1) / (1 + 1/n + 1/n^2 + ... 1/n^n)
```
which is approximately __n+1__ (as n grows, the denominator approaches 1). Hence, if the original program solved the eight-queens puzzle in time __T__, we would expect Louis' program to solve it in __(n+1)T__.

P.S. If this does not seem big, then remember that the original process already has an exponential growth. This process will consume a multiple of that.
