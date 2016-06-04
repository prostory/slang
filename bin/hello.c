typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef void * Pointer;
typedef enum { False, True } Bool;
typedef union { Integer UInteger; Float UFloat; } UnionType;
typedef struct { String id; } Greeter1;
typedef struct { String name; Integer id; } Greeter2;
typedef struct { Integer id; } Greeter3;
typedef struct { UnionType id; } Greeter4;
typedef struct { Integer a; } A;
static struct { Integer a; } A$class;
typedef struct { Float a; } B;
static struct { Float a; } B$class;
typedef struct {  } C;
static struct { String a; } C$class;
extern Float Integer$$to_f(Integer self);
extern Integer Float$$to_i(Float self);
extern Integer puts(String);
extern Integer strlen(String);
extern String strdup(String);
extern String realloc(String, Integer);
extern String strcat(String, String);
extern String String$$__lsh__(String self, String s);
extern String Greeter2$$set_name(Greeter2 * self, String name);
extern Integer Greeter2$$say_hello(Greeter2 * self);
extern String Greeter1$$set_id$String(Greeter1 * self, String id);
extern Integer Greeter2$$set_id$Integer(Greeter2 * self, Integer id);
extern Integer Greeter3$$set_id$Integer(Greeter3 * self, Integer id);
extern Integer Greeter4$$set_id$Integer(Greeter4 * self, Integer id);
extern Float Greeter4$$set_id$Float(Greeter4 * self, Float id);
extern String Greeter1$$get_id(Greeter1 * self);
extern Integer Greeter4$$get_id$$Integer(Greeter4 * self);
extern Float Greeter4$$get_id$$Float(Greeter4 * self);
extern Integer A$$foo(A * self);
extern Integer A$$bar(A * self);
extern Float B$$foo(B * self);
extern Float B$$bar(B * self);
extern Float C$$foo$$Float(C * self);
extern String C$$foo$$String(C * self);
extern String C$$bar(C * self);
extern Integer C$class$$hello(Void);
Float Integer$$to_f(Integer self)
{
    return (Float)self;
}
Integer Float$$to_i(Float self)
{
    return (Integer)self;
}
String String$$__lsh__(String self, String s)
{
    Float len = ((strlen(self) + strlen(s)) + 1);
    self = realloc(self, len);
    return strcat(self, s);
}
String Greeter2$$set_name(Greeter2 * self, String name)
{
    return self->name = name;
}
Integer Greeter2$$say_hello(Greeter2 * self)
{
    return puts(String$$__lsh__(strdup("hello, "), self->name));
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
Integer Greeter4$$set_id$Integer(Greeter4 * self, Integer id)
{
    return self->id.UInteger = id;
}
Float Greeter4$$set_id$Float(Greeter4 * self, Float id)
{
    return self->id.UFloat = id;
}
String Greeter1$$get_id(Greeter1 * self)
{
    return self->id;
}
Integer Greeter4$$get_id$$Integer(Greeter4 * self)
{
    return self->id.UInteger;
}
Float Greeter4$$get_id$$Float(Greeter4 * self)
{
    return self->id.UFloat;
}
Integer A$$foo(A * self)
{
    puts("A:foo");
    return self->a = 1;
}
Integer A$$bar(A * self)
{
    puts("A:bar");
    return A$class.a;
}
Float B$$foo(B * self)
{
    return self->a = 2.3;
}
Float B$$bar(B * self)
{
    puts("B:bar");
    return B$class.a;
}
Float C$$foo$$Float(C * self)
{
    return B$class.a;
}
String C$$foo$$String(C * self)
{
    return C$class.a;
}
String C$$bar(C * self)
{
    return C$class.a = "hello";
}
Integer C$class$$hello(Void)
{
    return puts(C$class.a);
}
Integer main(Void)
{
    A$class.a = 2;
    B$class.a = 2.3;
    puts(String$$__lsh__(strdup("Hello"), " World"));
    Pointer f = calloc(sizeof(Greeter1), 1);
    Pointer g = calloc(sizeof(Greeter2), 1);
    Pointer h = calloc(sizeof(Greeter3), 1);
    Pointer i = calloc(sizeof(Greeter4), 1);
    Greeter1$$set_id$String(f, "01");
    Greeter1$$get_id(f);
    Greeter2$$set_name(g, "Prostory");
    Greeter2$$say_hello(g);
    Greeter2$$set_id$Integer(g, 1);
    Greeter3$$set_id$Integer(h, 2);
    Greeter4$$set_id$Integer(i, 3);
    Greeter4$$get_id$$Integer(i);
    Greeter4$$set_id$Float(i, 3.3);
    Greeter4$$get_id$$Float(i);
    UnionType a;
    a.UFloat = 5.5;
    UnionType b;
    b.UInteger = Float$$to_i(a.UFloat);
    a.UInteger = 5;
    b.UFloat = Integer$$to_f(a.UInteger);
    Pointer d = calloc(sizeof(A), 1);
    Pointer e = calloc(sizeof(B), 1);
    A$$foo(d);
    B$$foo(e);
    A$$bar(d);
    B$$bar(e);
    f = calloc(sizeof(C), 1);
    C$$foo$$Float(f);
    C$$bar(f);
    C$$foo$$String(f);
    C$class$$hello();
    return (5 & (1 << 2));
}
