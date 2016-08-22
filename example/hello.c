typedef void Void;
typedef int Integer;
typedef double Float;
typedef void * Nil;
typedef char * String;
typedef void * Pointer;
typedef enum { False = 0, True = 1, } Bool;
typedef struct { char unused; } Lambda;
typedef struct { char unused; } Class_Class;
typedef struct { char unused; } Object_Class;
typedef struct { char unused; } Integer_Class;
typedef struct { char unused; } Float_Class;
typedef struct { char unused; } Bool_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { char unused; } String_Class;
typedef struct { char unused; } Array_Class;
typedef struct { char unused; } Greeter_Class;
typedef struct { char unused; } Point_Class;
typedef struct { String name; } Greeter;
typedef struct { Float x; Float y; } Point;
static Object_Class * Main_Object;
static Class_Class * Main_Class;
static Integer_Class * Main_Integer;
static Float_Class * Main_Float;
static Bool_Class * Main_Bool;
static StringHelper_Class * Main_StringHelper;
static String_Class * Main_String;
static Array_Class * Main_Array;
static Greeter_Class * Main_Greeter;
static Point_Class * Main_Point;
extern Pointer calloc(Integer, Integer);
extern Class_Class * __alloc__1(Class_Class * self);
extern Void __init__2(Class_Class * self);
extern Class_Class * new3(Class_Class * self);
extern Object_Class * __alloc__4(Class_Class * self);
extern Void __init__5(Object_Class * self);
extern Object_Class * new6(Class_Class * self);
extern Integer_Class * __alloc__7(Class_Class * self);
extern Void __init__8(Integer_Class * self);
extern Integer_Class * new9(Class_Class * self);
extern Float_Class * __alloc__10(Class_Class * self);
extern Void __init__11(Float_Class * self);
extern Float_Class * new12(Class_Class * self);
extern Bool_Class * __alloc__13(Class_Class * self);
extern Void __init__14(Bool_Class * self);
extern Bool_Class * new15(Class_Class * self);
extern StringHelper_Class * __alloc__16(Class_Class * self);
extern Void __init__17(StringHelper_Class * self);
extern StringHelper_Class * new18(Class_Class * self);
extern String_Class * __alloc__19(Class_Class * self);
extern Void __init__20(String_Class * self);
extern String_Class * new21(Class_Class * self);
extern Array_Class * __alloc__22(Class_Class * self);
extern Void __init__23(Array_Class * self);
extern Array_Class * new24(Class_Class * self);
extern Integer puts(String);
extern Greeter_Class * __alloc__25(Class_Class * self);
extern Void __init__26(Greeter_Class * self);
extern Greeter_Class * new27(Class_Class * self);
extern Greeter * __alloc__28(Greeter_Class * self);
extern String __init__29(Greeter * self, String name);
extern Greeter * new30(Greeter_Class * self, String var0);
extern Integer printf(String, ...);
extern Integer say_hello31(Greeter * self);
extern Integer lambda0(Integer n);
extern Nil times32(Integer self);
extern Point_Class * __alloc__33(Class_Class * self);
extern Void __init__34(Point_Class * self);
extern Point_Class * new35(Class_Class * self);
extern Point * __alloc__36(Point_Class * self);
extern Float __init__37(Point * self, Float x, Float y);
extern Point * new38(Point_Class * self, Float var0, Float var1);
extern Float x39(Point * self);
extern Float y40(Point * self);
extern Point * __add__41(Point * self, Point * p);
extern Point * __sub__42(Point * self, Point * p);
extern Float to_f43(Float self);
extern Integer dump44(Point * self);
Class_Class * __alloc__1(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Class_Class), 1);
    return result;
}
Void __init__2(Class_Class * self)
{
    Nil result;
}
Class_Class * new3(Class_Class * self)
{
    Class_Class * result;
    Class_Class * obj;
    obj = __alloc__1(self);
    __init__2(obj);
    result = obj;
    return result;
}
Object_Class * __alloc__4(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Object_Class), 1);
    return result;
}
Void __init__5(Object_Class * self)
{
    Nil result;
}
Object_Class * new6(Class_Class * self)
{
    Object_Class * result;
    Object_Class * obj;
    obj = __alloc__4(self);
    __init__5(obj);
    result = obj;
    return result;
}
Integer_Class * __alloc__7(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Integer_Class), 1);
    return result;
}
Void __init__8(Integer_Class * self)
{
    Nil result;
}
Integer_Class * new9(Class_Class * self)
{
    Integer_Class * result;
    Integer_Class * obj;
    obj = __alloc__7(self);
    __init__8(obj);
    result = obj;
    return result;
}
Float_Class * __alloc__10(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Float_Class), 1);
    return result;
}
Void __init__11(Float_Class * self)
{
    Nil result;
}
Float_Class * new12(Class_Class * self)
{
    Float_Class * result;
    Float_Class * obj;
    obj = __alloc__10(self);
    __init__11(obj);
    result = obj;
    return result;
}
Bool_Class * __alloc__13(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Bool_Class), 1);
    return result;
}
Void __init__14(Bool_Class * self)
{
    Nil result;
}
Bool_Class * new15(Class_Class * self)
{
    Bool_Class * result;
    Bool_Class * obj;
    obj = __alloc__13(self);
    __init__14(obj);
    result = obj;
    return result;
}
StringHelper_Class * __alloc__16(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(StringHelper_Class), 1);
    return result;
}
Void __init__17(StringHelper_Class * self)
{
    Nil result;
}
StringHelper_Class * new18(Class_Class * self)
{
    StringHelper_Class * result;
    StringHelper_Class * obj;
    obj = __alloc__16(self);
    __init__17(obj);
    result = obj;
    return result;
}
String_Class * __alloc__19(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(String_Class), 1);
    return result;
}
Void __init__20(String_Class * self)
{
    Nil result;
}
String_Class * new21(Class_Class * self)
{
    String_Class * result;
    String_Class * obj;
    obj = __alloc__19(self);
    __init__20(obj);
    result = obj;
    return result;
}
Array_Class * __alloc__22(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Array_Class), 1);
    return result;
}
Void __init__23(Array_Class * self)
{
    Nil result;
}
Array_Class * new24(Class_Class * self)
{
    Array_Class * result;
    Array_Class * obj;
    obj = __alloc__22(self);
    __init__23(obj);
    result = obj;
    return result;
}
Greeter_Class * __alloc__25(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Greeter_Class), 1);
    return result;
}
Void __init__26(Greeter_Class * self)
{
    Nil result;
}
Greeter_Class * new27(Class_Class * self)
{
    Greeter_Class * result;
    Greeter_Class * obj;
    obj = __alloc__25(self);
    __init__26(obj);
    result = obj;
    return result;
}
Greeter * __alloc__28(Greeter_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Greeter), 1);
    return result;
}
String __init__29(Greeter * self, String name)
{
    String result;
    self->name = name;
    result = self->name;
    return result;
}
Greeter * new30(Greeter_Class * self, String var0)
{
    Greeter * result;
    Greeter * obj;
    obj = __alloc__28(self);
    __init__29(obj, var0);
    result = obj;
    return result;
}
Integer say_hello31(Greeter * self)
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
Nil times32(Integer self)
{
    Nil result;
    Integer i;
    i = 0;
    while ((i < self))
    {
        lambda0(i);
        i = (i + 1);
    }
    return result;
}
Point_Class * __alloc__33(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Point_Class), 1);
    return result;
}
Void __init__34(Point_Class * self)
{
    Nil result;
}
Point_Class * new35(Class_Class * self)
{
    Point_Class * result;
    Point_Class * obj;
    obj = __alloc__33(self);
    __init__34(obj);
    result = obj;
    return result;
}
Point * __alloc__36(Point_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Point), 1);
    return result;
}
Float __init__37(Point * self, Float x, Float y)
{
    Float result;
    self->x = x;
    self->y = y;
    result = self->y;
    return result;
}
Point * new38(Point_Class * self, Float var0, Float var1)
{
    Point * result;
    Point * obj;
    obj = __alloc__36(self);
    __init__37(obj, var0, var1);
    result = obj;
    return result;
}
Float x39(Point * self)
{
    Float result;
    result = self->x;
    return result;
}
Float y40(Point * self)
{
    Float result;
    result = self->y;
    return result;
}
Point * __add__41(Point * self, Point * p)
{
    Point * result;
    result = new38(Main_Point, (self->x + x39(p)), (self->y + y40(p)));
    return result;
}
Point * __sub__42(Point * self, Point * p)
{
    Point * result;
    result = new38(Main_Point, (self->x - x39(p)), (self->y - y40(p)));
    return result;
}
Float to_f43(Float self)
{
    Float result;
    result = self;
    return result;
}
Integer dump44(Point * self)
{
    Integer result;
    result = printf("(%.2f, %.2f)\n", to_f43(self->x), to_f43(self->y));
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
    Main_Class = new3(Main_Class);
    Main_Object = new6(Main_Class);
    Main_Integer = new9(Main_Class);
    Main_Float = new12(Main_Class);
    Main_Bool = new15(Main_Class);
    Main_StringHelper = new18(Main_Class);
    Main_String = new21(Main_Class);
    Main_Array = new24(Main_Class);
    puts("Hello World");
    Main_Greeter = new27(Main_Class);
    g = new30(Main_Greeter, "SLang");
    say_hello31(g);
    times32(10);
    Main_Point = new35(Main_Class);
    p1 = new38(Main_Point, 1.2, 2.3);
    p2 = new38(Main_Point, 2.2, 6.4);
    p3 = __add__41(p1, p2);
    p4 = __sub__42(p1, p2);
    dump44(p3);
    dump44(p4);
    dump44(__add__41(p3, p4));
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
    printf("3 * (5 - 4) / ((6 - 3) + 4) = %d\n", ((3 * (5 - 4)) / ((6 - 3) + 4)));
    (i += (5 - (6 * 3)));
    printf("i = %d\n", i);
    printf("i++*5 = %d\n", ((i++) * 5));
    {
        (i += 1);
        printf("i = %d\n", i);
    }
    result = 0;
    return result;
}
