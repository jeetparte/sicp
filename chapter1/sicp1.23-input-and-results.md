# SICP exercise 1.23

## Input data

Found in the previous exercise:

* Near 1,000 - 983, 991 and 997
* Near 10,000 - 9949, 9967 and 9973
* Near 100,000 - 99971, 99989 and 99991
* Near 1,000,000 - 999961, 999979 and 999983

(__Note:__ I misread the previous exercise and implemented it to find the three largest numbers smaller than _n_.)

***
## Results

* **Method call - elapsed time**
* `(test 983)` - 4
* `(test 991)` - 4
* `(test 997)` - 4
* `(test 9949)` - 6
* `(test 9967)` - 7
* `(test 9973)` - 7
* `(test 99971)` - 14
* `(test 99989)` - 14
* `(test 99991)` - 15
* `(test 999961)` - 39
* `(test 999979)` - 39
* `(test 999983)` - 40

### Comparison with previous results (from 1.22)

* 983, 991 and 997 - 2.33
* 9949, 9967 and 9973 - 6
* 99971, 99989 and 99991 - 18
* 999961, 999979 and 999983 - 53.33


## Conclusion
Even though our modification halves the number of test steps, it does not run twice as fast.

**Reason:** The conditional check which is the `next` function has a fixed 𝛩(1) cost. The cost of checking a test divisor grows proportional to the test divisor (and also to `n`) as 𝛩(n). __*__

For smaller `n` (~ 1000), the test divisors are accordingly small. For this combination of small `n` and small test divisors, it is cheaper to check every divisor than to first filter and check only the filtered half i.e., the total cost of calling `next` is greater than the benefit it offers at this size. 

The cost of `next` is offset, however, as `n` increases. The average size of the test divisors is now greater and so is the cost of checking them against `n`. Filtering with `next` becomes a trivial cost because of the checking it saves.

***
__*__ checking a divisor involves testing the conditions:
* `(> (square test-divisor) n)`  
* `(= (remainder n test-divisor) 0)`



