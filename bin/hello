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
extern Integer lambda0(Integer n);
extern Void times5(Integer self);
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
Integer lambda0(Integer n)
{
    return printf("Say hello %d times.\n", n);
}
Void times5(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda0(i);
        i = (i + 1);
    }
}
Point * __alloc__6(Point_Class * self)
{
    return calloc(sizeof(Point), 1);
}
Float __init__7(Point * self, Float x, Float y)
{
    self->x = x;
    return self->y = y;
}
Point * new8(Point_Class * self, Float var0, Float var1)
{
    Pointer obj;
    obj = __alloc__6(self);
    __init__7(obj, var0, var1);
    return obj;
}
Float x9(Point * self)
{
    return self->x;
}
Float y10(Point * self)
{
    return self->y;
}
Point * __add__11(Point * self, Point * p)
{
    return new8(&Point_class, (self->x + x9(p)), (self->y + y10(p)));
}
Point * __sub__12(Point * self, Point * p)
{
    return new8(&Point_class, (self->x - x9(p)), (self->y - y10(p)));
}
Float to_f13(Float self)
{
    return self;
}
Integer dump14(Point * self)
{
    return printf("(%.2f, %.2f)\n", to_f13(self->x), to_f13(self->y));
}
Integer main(Void)
{
    puts("Hello World");
    Pointer g;
    g = new3(&Greeter_class, "SLang");
    say_hello4(g);
    times5(10);
    Pointer p1;
    p1 = new8(&Point_class, 1.2, 2.3);
    Pointer p2;
    p2 = new8(&Point_class, 2.2, 6.4);
    Pointer p3;
    p3 = __add__11(p1, p2);
    Pointer p4;
    p4 = __sub__12(p1, p2);
    dump14(p3);
    dump14(p4);
    dump14(__add__11(p3, p4));
    Integer i;
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
}
