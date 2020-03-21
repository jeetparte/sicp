# SICP exercise 1.25

In the `expmod` procedure written for the Fermat test, the modulo operations are built into the computation of the exponential value.
Since, for any number _k_, _k mod n_ lies between _0_ and _n - 1_, at most the input to one of these modulo operations will be `square (n - 1)`. Keeping the range of the module operations in this smaller range (_0 ... n ^ 2_) is much more efficient than doing just one modulo operation on _a ^ n_, which is a number incredibly larger than n (for a > 1 and any but the smallest values of n).

It intuitively makes sense that operating on such a large number might be costlier, but without knowing the internals of the computation process it is hard to explain why that is so.

But let's compare the actual performance first - 

### The test numbers:

Found in exercise 1.22:

* Near 1,000 - 983, 991 and 997
* Near 1,000,000 - 999961, 999979 and 999983

### Test results
* **Prime number tested \*\*\* computation time - using the original `exp-mod` procedure** / **using the modified one**
* 983 *** 28 / 143
* 991 *** 30 / 157
* 997 *** 27 / 139
* 999961 *** 45 / 10679548
* 999979 *** 46 / 8820971
* 999983 *** 47 / 10363251

## Conclusion

On studying other answers to this exercise, I came upon a reasonable conclusion.
On computer machines, there is specialized hardware to efficiently perform arithmetic computation. There is a limit to the size of numbers (in terms of the number of bits usually) whose computations the hardware can directly perform. Above this threshold, the computer must rely on software implementations (built on top of the hardware layer) to perform computation. This is significantly more expensive.

In our case here, operating on __a ^ n__ is very likely to be above that threshold, in contrast to operating in the range __0 ... n ^ 2__.




