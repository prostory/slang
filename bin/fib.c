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
typedef union { Integer uInteger; String uString; Float uFloat; } Options;
typedef struct { char unused; } Options_Class;
static Options_Class Options_class;
typedef struct { char unused; } Object_Class;
static Object_Class Object_class;
typedef struct { char unused; } StringHelper_Class;
static StringHelper_Class StringHelper_class;
typedef struct { Integer x; Integer y; Integer w; Integer h; } Rect;
typedef struct { char unused; } Rect_Class;
static Rect_Class Rect_class;
extern Integer fib1(Integer n);
extern Integer printf(String, ...);
extern Void foo2(Void);
extern Options bar3(Integer n);
extern String strdup(String);
extern String new4(String_Class * self, String const_str);
extern Integer strlen(String);
extern String realloc(String, Integer);
extern String strcat(String, String);
extern String __lsh__5(String self, String s);
extern Integer puts(String);
extern String to_s6(Bool self);
extern String string7(Options self);
extern Integer int8(Options self);
extern Float float9(Options self);
extern Pointer calloc(Integer, Integer);
extern Rect * __alloc__10(Rect_Class * self);
extern Integer __init__11(Rect * self, Integer x, Integer y, Integer w, Integer h);
extern Rect * new12(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3);
extern Integer x13(Rect * self);
extern Integer y14(Rect * self);
extern Integer w15(Rect * self);
extern Integer h16(Rect * self);
extern Integer dump17(Rect * self);
extern Rect * __div__18(Rect * self, Integer n);
Integer fib1(Integer n)
{
    if ((n < 2))
    {
        return n;
    }
    else
    {
        return (fib1((n - 2)) + fib1((n - 1)));
    }
}
Void foo2(Void)
{
    Integer i;
    i = 0;
    while ((i < 10))
    {
        i = (i + 1);
    }
}
Options bar3(Integer n)
{
    Options result;
    if ((n < 0))
    {
        result.uInteger = -(n);
    }
    else
    {
        if ((n == 0))
        {
            result.uString = "result is 0";
        }
        else
        {
            result.uFloat = (n + 1.25);
        }
    }
    return result;
}
String new4(String_Class * self, String const_str)
{
    return strdup(const_str);
}
String __lsh__5(String self, String s)
{
    Integer len;
    len = ((strlen(self) + strlen(s)) + 1);
    self = realloc(self, len);
    return strcat(self, s);
}
String to_s6(Bool self)
{
    if (self)
    {
        return "true";
    }
    else
    {
        return "false";
    }
}
String string7(Options self)
{
    return self.uString;
}
Integer int8(Options self)
{
    return self.uInteger;
}
Float float9(Options self)
{
    return self.uFloat;
}
Rect * __alloc__10(Rect_Class * self)
{
    return calloc(sizeof(Rect), 1);
}
Integer __init__11(Rect * self, Integer x, Integer y, Integer w, Integer h)
{
    self->x = x;
    self->y = y;
    self->w = w;
    return self->h = h;
}
Rect * new12(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3)
{
    Pointer obj;
    obj = __alloc__10(self);
    __init__11(obj, var0, var1, var2, var3);
    return obj;
}
Integer x13(Rect * self)
{
    return self->x;
}
Integer y14(Rect * self)
{
    return self->y;
}
Integer w15(Rect * self)
{
    return self->w;
}
Integer h16(Rect * self)
{
    return self->h;
}
Integer dump17(Rect * self)
{
    return printf("(%d, %d, %d, %d)\n", x13(self), y14(self), w15(self), h16(self));
}
Rect * __div__18(Rect * self, Integer n)
{
    return new12(&Rect_class, (x13(self) / n), (y14(self) / n), (w15(self) / n), (h16(self) / n));
}
Integer main(Void)
{
    Integer i;
    Float i1;
    String i2;
    Bool i3;
    Pointer r;
    printf("fib(6) = %d\n", fib1(6));
    foo2();
    bar3(10);
    i = 0;
    printf("i = %d\n", i);
    i1 = (i + 1.0);
    i1 = (1 + i1);
    printf("i = %.2f\n", i1);
    i2 = new4(&String_class, "Hello ");
    __lsh__5(i2, "World");
    puts(i2);
    i3 = True;
    puts(to_s6(i3));
    i3 = False;
    puts(to_s6(i3));
    printf("bar(0) = '%s'\n", string7(bar3(0)));
    printf("bar(-1) = %d\n", int8(bar3(-(1))));
    printf("bar(10) = %.2f\n", float9(bar3(10)));
    r = new12(&Rect_class, 10, 10, 20, 20);
    dump17(r);
    dump17(__div__18(r, 2));
    return 0;
}
