What classes does each implementation include? Are the lists the same?

The three classes are CartEntry, ShoppingCart, and Order. Both implementations hold the same classes.




Write down a sentence to describe each class.

CartEntry holds information about an item that has been added to a ShoppingCart. ShoppingCarts holds an array of CartEntries. Order contains a ShoppingCart and calculates the final price of the order.




How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.

All three classes have a compositional relationship to each other. ShoppingCarts holds an array of CartEntries. Order holds a ShoppingCart.




What data does each class store? How (if at all) does this differ between the two implementations?

The data stored in each class of both implementations are the same. CartEntry stores information on net price and quantity. ShoppingCart stores information on entries. And Order stores a ShoppingCart and the sales tax.




What methods does each class have? How (if at all) does this differ between the two implementations?

In Implementation A, CartEntry and ShoppingCart do not contain any methods. Order contains the method total price. 

In Implementation B, CartEntry contains the price method, ShoppingCart contains a different price method, and Order contains the total price method.




Consider the Order#total_price method. In each implementation:

Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?

In Implementation A the logic to compute price is all within the Order class. In Implementation B, the logic is delegated between all classes.




Does total_price directly manipulate the instance variables of other classes?
total_price reads the instance variables of other classes but it doesn't write to them. 




If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
I would need more information on the logic behind bulk pricing. If it's the same discount for all products once they hit a certain quantity limit then it could go into wherever the price calculations methods are as a percent multiplier if quantity > bulk_quantity_min. Or if the discount differs from product to product, it could be stored as one or more instance variables under CartEntry (e.g. bulk_price, bulk_quantity_min, or discount).

Implementation B would be easier to modify.





Which implementation better adheres to the single responsibility principle?

Implementation B.





