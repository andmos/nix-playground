# 95 % of all nix syntax:

## Attribute set

Attribute sets are records of key=value data, similar to `dict` in Python or an object in JavaScript / JSON:

```nix
{
    meaningOfLife = 42;
    pi = 3.14159;
    someOtherKeyString = "myKey";
}
```

Items in the set can't reference other items in the same set unless the set is marked as recursive: 

```nix
rec {
    pi_int = 3;
    pi_decimal = 0.14159;
    
    pi = pi_int + pi_decimal;
}
```

Access specific items:

```nix
({ item = 1; }).item 
```

And merge sets by using `//`

```nix
{
    one = 1; 
    three = 3;
    four = 3;
    five = 5;

} // {
    two = 2;
    four = 4; 
}
```

## Lists

Lists are separated by whitspace:

```nix

[ A B C D ]
```

Lists have higher precedence than almost all other constructs, so any complex items must be in parenthesis:

```nix
[ 1 (1 + 1) 3 ]
```

## Lambdas

Anonymous functions that can only take one argument

```nix
val: val + 1 
```

Since they can be returned, you can simulate a function with more than one parameter:

```nix
lhs: (rhs: lhs + rhs)
```

Invoke the lambda by putting the argument after the lambda:

```nix
(val: val +1) 5
```

Similar to lists, no delimiter.

## Let-binding

Assign readable names to values:

```nix
let 
    bump = val: val +1;
in 
    (bump 5) + (bump 2)

```

Different from sets, they can refer to themselves without recursive (`rec`) marker:

```nix
let
    a = 1;
    b = a + 1;
    c = b + 1; 
in 
    (
a + b + c 
)
```

## With-statement

With statements imports all items inside a set:

```nix
with {
    a = 1;
    b = 2;
};

a + b 
```

But best practices, prefer `let` statements to define variables. Use `with` sparingly.

## If-statements

Decide values based on conditions:

```nix

if 2 == 2 
    then "Math isn't broken"
    else "Panic!"
```

## Assert-statement

Asserts are like if-statements, but yields an evaluation error if a condition is false: 

```nix
assert 2 == 2; 

"Math isn't broken" 
```

## Paths and URLs

Nix has special syntax for file paths and URL's, which can be observed using the `toString` build-in.

```nix
{
    #  Becomes the absolute path to ./test.nix
    # i.e /home/user/nix/test.nix
    file = toString ./test.nix; 

    # Literally becomes "https://google.com" 
    url = toString https://google.com;
}
```

## Imports

Imports are nothing special, they merge files:

```nix
# default.nix:
let 
    lib = import ./lib.nix;
in 
    lib.fac 5
```

```nix
# lib.nix:
{
fac = n: if n == 0
    then 1
    else n * (fac (n - 1));
}
```

Becomes:

```nix
# default.nix:
let 
    
    lib = {
        fac = n: if n == 0
            then 1
            else n * (fac (n - 1));
};

in 
    lib.fac 5
```

## Patterns

When importing, it is possible to destruct a set of parameters with default values on-the-fly, which is why `nix` has basic pattern matching:

```nix
# default.nix:
{
    user1 = (import ./user.nix) { firstname = "Bob"; lastname = "Smith"; };
    user2 = (import ./user.nix) { lastname = "Doe"; };
}

# user.nix: 
{ firstname ? "Mr. ", lastname }: 
{
    type = "user; 
    fullname = firstname + " " + lastname; 
}

```

Patterns can take optional values:

```nix
optional ? "default"
```,

Or Required: 

```nix
required, 
```

And ignore extra arguments:

```nix
...
```

Bind the entire set of pattern matching using 

```nix
{ a, b, c, ... } @ myset: ...
```

or

```nix
myset @ { a, b, c, ... }: ...
```

results in a set where `a`, `b`, and `c` exists as well as possibly some other values (thanks to the ellipsis).

### String interpolation

Because `nix` is used to generate a lot of files, being able to effortlessly fill in variables in strings is valuable:

```nix
let
     name = "Bob Smith";
in
    "Greetings, ${name}!" 
```

## Multiline strings

Multiline strings:

```nix
let
    name = "Bob Smith";
    string = ''
        Greetings, ${name}!
        It's a good day today, innit?
        '';
in string 
```
