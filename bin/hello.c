typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef enum { False, True } Bool;
typedef struct { String id; } Greeter1;
typedef struct { String name; Integer id; } Greeter2;
typedef struct { Integer id; } Greeter3;
extern Integer Integer$$__add__(Integer self, Integer n);
extern Float Integer$$__div__(Integer self, Float n);
extern Float Float$$__mul__(Float self, Float n);
extern Bool Float$$__gt__$Float(Float self, Float n);
extern Bool Float$$__gt__$Integer(Float self, Integer n);
extern Integer String$$echo(String self);
extern Integer String$$len(String self);
extern String String$$__lsh__(String self, String s);
extern String String$$dup(String self);
extern Bool Bool$$or(Bool self, Bool n);
extern String Greeter2$$set_name(Greeter2 * self, String name);
extern Integer Greeter2$$say_hello(Greeter2 * self);
extern String Greeter1$$set_id$String(Greeter1 * self, String id);
extern Integer Greeter2$$set_id$Integer(Greeter2 * self, Integer id);
extern Integer Greeter3$$set_id$Integer(Greeter3 * self, Integer id);
extern String Greeter1$$get_id(Greeter1 * self);
extern Integer Greeter3$$get_id(Greeter3 * self);
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
Bool Float$$__gt__$Float(Float self, Float n)
{
    return (self > n);
}
Bool Float$$__gt__$Integer(Float self, Integer n)
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
String Greeter2$$set_name(Greeter2 * self, String name)
{
    return self->name = name;
}
Integer Greeter2$$say_hello(Greeter2 * self)
{
    return String$$echo(String$$__lsh__(String$$dup("hello, "), self->name));
}
String Greeter1$$set_id$String(Greeter1 * self, String id)
{
    return self->id = id;
}
Integer Greeter2$$set_id$Integer(Greeter2 * self, Integer id)
{
    return self->id = id;
}
Integer Greeter3$$set_id$Integer(Greeter3 * self, Integer id)
{
    return self->id = id;
}
String Greeter1$$get_id(Greeter1 * self)
{
    return self->id;
}
Integer Greeter3$$get_id(Greeter3 * self)
{
    return self->id;
}
Integer main(Void)
{
    String$$echo(String$$__lsh__(String$$dup("Hello"), " World"));
    Greeter1 * f = calloc(sizeof(Greeter1), 1);
    Greeter2 * g = calloc(sizeof(Greeter2), 1);
    Greeter3 * h = calloc(sizeof(Greeter3), 1);
    Greeter3 * i = calloc(sizeof(Greeter3), 1);
    Greeter1$$set_id$String(f, "01");
    Greeter1$$get_id(f);
    Greeter2$$set_name(g, "Prostory");
    Greeter2$$say_hello(g);
    Greeter2$$set_id$Integer(g, 1);
    Greeter3$$set_id$Integer(h, 2);
    Greeter3$$set_id$Integer(i, 3);
    Greeter3$$get_id(i);
    return Bool$$or(Float$$__gt__$Float(1.5, Float$$__mul__(1.2, 1.8)), Float$$__gt__$Integer(Integer$$__div__(5, 2.0), 2));
}
