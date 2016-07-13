typedef struct { char unused; } Any_Class;
static Any_Class Any_class;
typedef struct { char unused; } Kernel_Class;
static Kernel_Class Kernel_class;
typedef void Void;
typedef struct { char unused; } Void_Class;
static Void_Class Void_class;
typedef int Integer;
typedef struct { char unused; } Integer_Class;
static Integer_Class Integer_class;
typedef double Float;
typedef struct { char unused; } Float_Class;
static Float_Class Float_class;
typedef char * String;
typedef struct { char unused; } String_Class;
static String_Class String_class;
typedef void * Pointer;
typedef struct { char unused; } Pointer_Class;
static Pointer_Class Pointer_class;
typedef enum { False = 0, True = 1, } Bool;
typedef struct { char unused; } Bool_Class;
static Bool_Class Bool_class;
typedef struct { char unused; } Array_Class;
static Array_Class Array_class;
typedef struct { char unused; } Options_Class;
static Options_Class Options_class;
typedef struct { char unused; } Object_Class;
static Object_Class Object_class;
typedef struct { char unused; } StringHelper_Class;
static StringHelper_Class StringHelper_class;
typedef struct { String name; } Greeter;
typedef struct { char unused; } Greeter_Class;
static Greeter_Class Greeter_class;
typedef struct { char unused; } Lambda_Class;
static Lambda_Class Lambda_class;
typedef struct { Float x; Float y; } Point;
typedef struct { char unused; } Point_Class;
static Point_Class Point_class;
extern Integer puts(String);
extern Pointer calloc(Integer, Integer);
extern Greeter * __alloc__1(Greeter_Class * self);
extern String __init__2(Greeter * self, String name);
extern Greeter * new3(Greeter_Class * self, String var0);
extern Integer printf(String, ...);
extern Integer say_hello4(Greeter * self);
extern Integer foo5(Greeter * self);
extern Integer lambda0(Integer n);
extern Void times6(Integer self);
extern Point * __alloc__7(Point_Class * self);
extern Float __init__8(Point * self, Float x, Float y);
extern Point * new9(Point_Class * self, Float var0, Float var1);
extern Float x10(Point * self);
extern Float y11(Point * self);
extern Point * __add__12(Point * self, Point * p);
extern Float to_f13(Float self);
extern Integer display14(Point * self);
extern Point * __sub__15(Point * self, Point * p);
extern Point * __mul__16(Point * self, Integer n);
extern Float __sub_asgn__17(Point * self, Point * p);
Greeter * __alloc__1(Greeter_Class * self)
{
    return calloc(sizeof(Greeter), 1);
}
String __init__2(Greeter * self, String name)
{
    return self->name = name;
}
Greeter * new3(Greeter_Class * self, String var0)
{
    Pointer obj;
    obj = __alloc__1(self);
    __init__2(obj, var0);
    return obj;
}
Integer say_hello4(Greeter * self)
{
    return printf("Hello, %s\n", self->name);
}
Integer foo5(Greeter * self)
{
    return puts("a");
}
Integer lambda0(Integer n)
{
    return printf("Say hello %d times\n", n);
}
Void times6(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda0(i);
        i = (i + 1);
    }
}
Point * __alloc__7(Point_Class * self)
{
    return calloc(sizeof(Point), 1);
}
Float __init__8(Point * self, Float x, Float y)
{
    self->x = x;
    return self->y = y;
}
Point * new9(Point_Class * self, Float var0, Float var1)
{
    Pointer obj;
    obj = __alloc__7(self);
    __init__8(obj, var0, var1);
    return obj;
}
Float x10(Point * self)
{
    return self->x;
}
Float y11(Point * self)
{
    return self->y;
}
Point * __add__12(Point * self, Point * p)
{
    return new9(&Point_class, (self->x + x10(p)), (self->y + y11(p)));
}
Float to_f13(Float self)
{
    return self;
}
Integer display14(Point * self)
{
    return printf("(%.2f, %.2f)\n", to_f13(self->x), to_f13(self->y));
}
Point * __sub__15(Point * self, Point * p)
{
    return new9(&Point_class, (self->x - x10(p)), (self->y - y11(p)));
}
Point * __mul__16(Point * self, Integer n)
{
    return new9(&Point_class, (self->x * n), (self->y * n));
}
Float __sub_asgn__17(Point * self, Point * p)
{
    (self->x -= x10(p));
    return (self->y -= y11(p));
}
Integer main(Void)
{
    puts("Hello World");
    Pointer a;
    a = new3(&Greeter_class, "SLang");
    say_hello4(a);
    foo5(a);
    times6(10);
    lambda0(100);
    Pointer p1;
    p1 = new9(&Point_class, 1.1, 2.3);
    Pointer p2;
    p2 = new9(&Point_class, 2.2, 3.5);
    Pointer p3;
    p3 = __add__12(p1, p2);
    display14(p3);
    Pointer p4;
    p4 = __sub__15(p1, p2);
    display14(p4);
    Pointer p5;
    p5 = __mul__16(p1, 3);
    display14(p5);
    __sub_asgn__17(p5, p4);
    display14(p5);
}
