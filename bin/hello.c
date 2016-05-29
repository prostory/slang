typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef enum { False, True } Bool;
typedef struct { String name; } Greeter;
extern Integer Integer$$__add__(Integer self, Integer n);
extern Float Integer$$__div__(Integer self, Float n);
extern Float Float$$__mul__(Float self, Float n);
extern Bool Float$$__gt__$Float_Float(Float self, Float n);
extern Bool Float$$__gt__$Float_Integer(Float self, Integer n);
extern Integer String$$echo(String self);
extern Integer String$$len(String self);
extern String String$$__lsh__(String self, String s);
extern String String$$dup(String self);
extern Bool Bool$$or(Bool self, Bool n);
extern String Greeter$$set_name(Greeter * self, String name);
extern Integer Greeter$$say_hello(Greeter * self);
extern Integer puts(String);
extern Integer strlen(String);
extern String realloc(String, Integer);
extern String strcat(String, String);
extern String strdup(String);
Integer Integer$$__add__(Integer self, Integer n)
{
    return (self + n);
}
Float Integer$$__div__(Integer self, Float n)
{
    return (self / n);
}
Float Float$$__mul__(Float self, Float n)
{
    return (self * n);
}
Bool Float$$__gt__$Float_Float(Float self, Float n)
{
    return (self > n);
}
Bool Float$$__gt__$Float_Integer(Float self, Integer n)
{
    return (self > n);
}
Integer String$$echo(String self)
{
    return puts(self);
}
Integer String$$len(String self)
{
    return strlen(self);
}
String String$$__lsh__(String self, String s)
{
    Integer len = Integer$$__add__(Integer$$__add__(String$$len(self), String$$len(s)), 1);
    self = realloc(self, len);
    return strcat(self, s);
}
String String$$dup(String self)
{
    return strdup(self);
}
Bool Bool$$or(Bool self, Bool n)
{
    return (self || n);
}
String Greeter$$set_name(Greeter * self, String name)
{
    return self->name = name;
}
Integer Greeter$$say_hello(Greeter * self)
{
    return String$$echo(String$$__lsh__(String$$dup("hello, "), self->name));
}
Integer main(Void)
{
    String$$echo(String$$__lsh__(String$$dup("Hello"), " World"));
    Greeter * g = calloc(sizeof(Greeter), 1);
    Greeter$$set_name(g, "Prostory");
    Greeter$$say_hello(g);
    return Bool$$or(Float$$__gt__$Float_Float(1.5, Float$$__mul__(1.2, 1.8)), Float$$__gt__$Float_Integer(Integer$$__div__(5, 2.0), 2));
}
