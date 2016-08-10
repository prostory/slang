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
typedef void * Nil;
typedef struct { char unused; } Nil_Class;
static Nil_Class Nil_class;
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
typedef struct { char unused; } UnionType_Class;
static UnionType_Class UnionType_class;
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
extern Integer lambda0(Integer n);
extern Nil times5(Integer self);
extern Point * __alloc__6(Point_Class * self);
extern Float __init__7(Point * self, Float x, Float y);
extern Point * new8(Point_Class * self, Float var0, Float var1);
extern Float x9(Point * self);
extern Float y10(Point * self);
extern Point * __add__11(Point * self, Point * p);
extern Point * __sub__12(Point * self, Point * p);
extern Float to_f13(Float self);
extern Integer dump14(Point * self);
Greeter * __alloc__1(Greeter_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Greeter), 1);
    return result;
}
String __init__2(Greeter * self, String name)
{
    String result;
    self->name = name;
    result = self->name;
    return result;
}
Greeter * new3(Greeter_Class * self, String var0)
{
    Greeter * result;
    Greeter * obj;
    obj = __alloc__1(self);
    __init__2(obj, var0);
    result = obj;
    return result;
}
Integer say_hello4(Greeter * self)
{
    Integer result;
    result = printf("Hello, %s\n", self->name);
    return result;
}
Integer lambda0(Integer n)
{
    Integer result;
    result = printf("Say hello %d times.\n", n);
    return result;
}
Nil times5(Integer self)
{
    Nil result;
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda0(i);
        i = (i + 1);
    }
    return result;
}
Point * __alloc__6(Point_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Point), 1);
    return result;
}
Float __init__7(Point * self, Float x, Float y)
{
    Float result;
    self->x = x;
    self->y = y;
    result = self->y;
    return result;
}
Point * new8(Point_Class * self, Float var0, Float var1)
{
    Point * result;
    Point * obj;
    obj = __alloc__6(self);
    __init__7(obj, var0, var1);
    result = obj;
    return result;
}
Float x9(Point * self)
{
    Float result;
    result = self->x;
    return result;
}
Float y10(Point * self)
{
    Float result;
    result = self->y;
    return result;
}
Point * __add__11(Point * self, Point * p)
{
    Point * result;
    result = new8(&Point_class, (self->x + x9(p)), (self->y + y10(p)));
    return result;
}
Point * __sub__12(Point * self, Point * p)
{
    Point * result;
    result = new8(&Point_class, (self->x - x9(p)), (self->y - y10(p)));
    return result;
}
Float to_f13(Float self)
{
    Float result;
    result = self;
    return result;
}
Integer dump14(Point * self)
{
    Integer result;
    result = printf("(%.2f, %.2f)\n", to_f13(self->x), to_f13(self->y));
    return result;
}
Integer main(Void)
{
    Integer result;
    Greeter * g;
    Point * p1;
    Point * p2;
    Point * p3;
    Point * p4;
    Integer i;
    puts("Hello World");
    g = new3(&Greeter_class, "SLang");
    say_hello4(g);
    times5(10);
    p1 = new8(&Point_class, 1.2, 2.3);
    p2 = new8(&Point_class, 2.2, 6.4);
    p3 = __add__11(p1, p2);
    p4 = __sub__12(p1, p2);
    dump14(p3);
    dump14(p4);
    dump14(__add__11(p3, p4));
    i = 1;
    if ((i > 0))
    {
        puts("i > 0");
    }
    else
    {
        puts("i < 0");
    }
    i = 5;
    if ((i == 1))
    {
        puts("i = 1 or 2 or 3");
    }
    else
    {
        if ((i == 2))
        {
            puts("i = 1 or 2 or 3");
        }
        else
        {
            if ((i == 3))
            {
                puts("i = 1 or 2 or 3");
            }
            else
            {
                if ((i == 4))
                {
                    puts("i = 4 or 5 or 6");
                }
                else
                {
                    if ((i == 5))
                    {
                        puts("i = 4 or 5 or 6");
                    }
                    else
                    {
                        if ((i == 6))
                        {
                            puts("i = 4 or 5 or 6");
                        }
                        else
                        {
                            puts("i = other");
                        }
                    }
                }
            }
        }
    }
    while ((i < 10))
    {
        puts("Hello");
        i = (i + 1);
    }
    printf("i = %d\n", i);
    i = 0;
    do {
        puts("Hello");
        i = (i + 1);
    } while ((i < 10));
    i = 5;
    if (!((i == 5)))
    {
        do {
            puts("Hello");
            i = (i + 1);
        } while (!((i == 10)));
    }
    if ((i == 10))
    {
        puts("Hello i = 10");
    }
    printf("1 * (5 + 4) / (6 - 3) + 4 = %d\n", ((1 * ((5 + 4) / (6 - 3))) + 4));
    (i += (5 - (6 * 3)));
    printf("i++*5 = %d\n", ((i++) * 5));
    {
        (i += 1);
        printf("i = %d\n", i);
    }
    result = 0;
    return result;
}
