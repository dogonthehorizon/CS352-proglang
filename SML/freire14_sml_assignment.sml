(*
*  FILE  : freire14_sml.sml
*  AUTHOR: Fernando Freire
*  DATE  : 04/04/2013
*)

val intList = [7,5,7,2,43,1,7,8,2,42345,8365,73,456,34,56];
val realList = [1.0,2.0,3.14,7.8245,246.2468,241.234,234523452345.1234];
val boolList = [true,true,true,false,false,false,true,false];
val stringList = ["asdfasd","asfbqw","yrshtswtrhswet"];

fun min (x,y) = if x < y then x else y;
fun max (x,y) = if x > y then x else y;

(* If this exception is raised then the list in question is empty *)
exception ListEmpty;

(* Return the minimum value of a list. *)
fun minList [] = raise ListEmpty
|   minList [x] = x
|   minList (x::xs) =
        if x < minList xs then x else minList xs ;

(* Return the optimal value for the given operator using the given list. *)
fun pick operator [] = raise ListEmpty
|   pick operator [x] = x
|   pick operator (x::y::xs) =
        if operator (x , y) then pick operator (x::xs)
        else pick operator (y::xs);

(* Take a list of ints and return the max value. *)
val maxList = fn (x) => pick op > x;

(* Take a list of reals and return the max or min value. *)
val rMaxList = fn(x) => pick op > x:real;
val rMinList = fn(x) => pick op < x:real;

(*
*  To return the largest string, we must define our own operator
*  and then pass this operator to our pick function.
*)
fun stringOperator (x,y) = if size x > size y then true else false;
val sMaxList = fn(x) => pick stringOperator x;

(*
* This is a logical and operator function using foldr. It will always
* return false
*)
val logicAndList = foldr (fn(b1,b2) => b1 andalso b2) true [false, false, true];

