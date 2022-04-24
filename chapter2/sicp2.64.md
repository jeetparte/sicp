a. partial-tree processes the first n elements of the list given to it in left-to-right order. A partial-tree of the first ⌊(n-1)/2⌋ elements gives us the left (balanced) sub-tree and the remaining elements from the original list. The first of those remaining elements becomes the root of this tree, while a partial-tree of the rest gives us the right sub-tree (upto the nth element) and the (n+1th and onwards) elements that will not be part of this tree. A tree is formed from the root and the left and right sub-trees and forms the `car` of partial-tree; the elements not in the tree form the `cdr` of partial-tree. When n is even, there is 1 less element in the left sub-tree compared to the right sub-tree; otherwise, when n is odd, there are equal elements in both sub-trees. The tree produced by list-tree for the list (1 3 5 7 9 11) is

      _________5___________
      |                   |
      |                   |
 _____1____         ______9______  
 |         |        |            |
 |         |        |            |
 ()        3   _____7_____  _____11_____
               |         |  |           |
               |         |  |           |
               ()        () ()          ()
               
b. For a list of n elements, list-tree's order of growth is 𝝝(n) in the number of steps - there are n elements to be processed and the cost of processing each element is a constant number of steps.
