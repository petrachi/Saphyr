# Saphyr

## DEMO

Once you have sucessfully installed ruby in your system, run the command `ruby crashtest.rb` within the repo folder. This will load the Spahyr-Lang library and execute the saphyr-written test)-file `nny.sy`.

## EXPLAINED

In Saphyr, Everything is method-driven. The goal of this philosophy is to achieve a simpler way to share behavior between objects. Here, objects are just containers for a pool of methods.

## EXAMPLE

```
Toto.prototype.toto = "toto"
```
We declare an object named 'Toto' in the global context, then we define an object named 'prototype' into the 'Toto' object, and then we defined a method named 'toto', inside the 'prototype' object. Everything right to the "=" sign define the body of the 'toto' method. It is not executed yet, but store as a form that can be executed later.

--
```
Toto.new =
  instance.class = self
  instance.methods = self.prototype.methods
  instance;
```
Then, we declare inside the 'Toto' object a method named 'new'. Here we have a multi-line declaration, that means that the method body is everything until the ";" sign. This 'new' method, when executed, will define an object called 'instance', add a method 'class' to that object, in that context the keyword "self" points to the 'Toto' object. Then, using the "method" keyword, we assign into this 'instance' object every methods assigned to the 'Toto.prototype' object. Then, we return the 'instance' object.


```
obj = Toto.new
```
Now, we declare in the global context a method named 'obj'.

```
obj.toto.print
```
And then, we call the 'obj' method, which will create a new instance of the 'Toto' class (the 'Toto' object has become a class through the ability of instantiating new objects), and on that, we call the 'toto' method, which return the "toto" string, on which we call the 'print' method (which is defined on every objects)
