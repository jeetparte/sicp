# SICP exercise 1.24

Since the Fermat test has an order of growth of 𝛩(log n), we would expect that testing the primes near 1,000,000 would take about twice as long as testing those near 1,000.

Let's look at the test results - 

#### Input data

Found in exercise 1.22:

* Near 1,000 - 983, 991 and 997
* Near 10,000 - 9949, 9967 and 9973
* Near 100,000 - 99971, 99989 and 99991
* Near 1,000,000 - 999961, 999979 and 999983

(__Note:__ I misread  exercise 1.22 and implemented it to find the three largest numbers smaller than _n_.)

#### Results
* **Prime number \*\*\* elapsed time**
* 983 *** 28
* 991 *** 30
* 997 *** 27
* 9949 *** 37
* 9967 *** 37
* 9973 *** 38
* 99971 *** 38
* 99989 *** 41
* 99991 *** 42
* 999961 *** 45
* 999979 *** 46
* 999983 *** 47



The time taken for the largest numbers is a little less than expected. Or rather the time taken for the smallest numbers tested is a bit more.

#### Conclusion

I think this must have something to do with the cost of the modulo operations we are performing. Compare the `expmod` procedure we are using here with  using the older `fast-expt` + a single module operation (we do this comparison in the next exercise).

The performance gains these operations in `expmod` give when `n` is larger, are significantly higher than when `n` is smaller. That must explain the test results.



