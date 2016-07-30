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
extern Float fib2(Float n);
extern Nil foo3(Void);
extern Options bar4(Integer n);
extern String strdup(String);
extern String new5(String_Class * self, String const_str);
extern Integer strlen(String);
extern String realloc(String, Integer);
extern String strcat(String, String);
extern String __lsh__6(String self, String s);
extern Integer puts(String);
extern String to_s7(Bool self);
extern String string8(Options self);
extern Integer int9(Options self);
extern Float float10(Options self);
extern Pointer calloc(Integer, Integer);
extern Rect * __alloc__11(Rect_Class * self);
extern Integer __init__12(Rect * self, Integer x, Integer y, Integer w, Integer h);
extern Rect * new13(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3);
extern Integer x14(Rect * self);
extern Integer y15(Rect * self);
extern Integer w16(Rect * self);
extern Integer h17(Rect * self);
extern Integer dump18(Rect * self);
extern Rect * __div__19(Rect * self, Integer n);
Integer fib1(Integer n)
{
    Integer result;
    if ((n < 2))
    {
        result = n;
    }
    else
    {
        result = (fib1((n - 2)) + fib1((n - 1)));
    }
    return result;
}
Float fib2(Float n)
{
    Float result;
    if ((n < 2))
    {
        result = n;
    }
    else
    {
        result = (fib2((n - 2)) + fib2((n - 1)));
    }
    return result;
}
Nil foo3(Void)
{
    Nil result;
    Integer i;
    i = 0;
    while ((i < 10))
    {
        i = (i + 1);
    }
    return result;
}
Options bar4(Integer n)
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
String new5(String_Class * self, String const_str)
{
    String result;
    result = strdup(const_str);
    return result;
}
String __lsh__6(String self, String s)
{
    String result;
    Integer len;
    len = ((strlen(self) + strlen(s)) + 1);
    self = realloc(self, len);
    result = strcat(self, s);
    return result;
}
String to_s7(Bool self)
{
    String result;
    if (self)
    {
        result = "true";
    }
    else
    {
        result = "false";
    }
    return result;
}
String string8(Options self)
{
    String result;
    result = self.uString;
    return result;
}
Integer int9(Options self)
{
    Integer result;
    result = self.uInteger;
    return result;
}
Float float10(Options self)
{
    Float result;
    result = self.uFloat;
    return result;
}
Rect * __alloc__11(Rect_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Rect), 1);
    return result;
}
Integer __init__12(Rect * self, Integer x, Integer y, Integer w, Integer h)
{
    Integer result;
    self->x = x;
    self->y = y;
    self->w = w;
    self->h = h;
    result = self->h;
    return result;
}
Rect * new13(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3)
{
    Pointer result;
    Pointer obj;
    obj = __alloc__11(self);
    __init__12(obj, var0, var1, var2, var3);
    result = obj;
    return result;
}
Integer x14(Rect * self)
{
    Integer result;
    result = self->x;
    return result;
}
Integer y15(Rect * self)
{
    Integer result;
    result = self->y;
    return result;
}
Integer w16(Rect * self)
{
    Integer result;
    result = self->w;
    return result;
}
Integer h17(Rect * self)
{
    Integer result;
    result = self->h;
    return result;
}
Integer dump18(Rect * self)
{
    Integer result;
    result = printf("(%d, %d, %d, %d)\n", x14(self), y15(self), w16(self), h17(self));
    return result;
}
Rect * __div__19(Rect * self, Integer n)
{
    Pointer result;
    result = new13(&Rect_class, (x14(self) / n), (y15(self) / n), (w16(self) / n), (h17(self) / n));
    return result;
}
Integer main(Void)
{
    Integer result;
    Integer i;
    Float i1;
    String i2;
    Bool i3;
    Pointer r;
    printf("fib(6) = %d\n", fib1(6));
    printf("fib(6.5) = %.2f\n", fib2(6.5));
    foo3();
    bar4(10);
    i = 0;
    printf("i = %d\n", i);
    i1 = (i + 1.0);
    i1 = (1 + i1);
    printf("i = %.2f\n", i1);
    i2 = new5(&String_class, "Hello ");
    __lsh__6(i2, "World");
    puts(i2);
    i3 = True;
    puts(to_s7(i3));
    i3 = False;
    puts(to_s7(i3));
    printf("bar(0) = '%s'\n", string8(bar4(0)));
    printf("bar(-1) = %d\n", int9(bar4(-(1))));
    printf("bar(10) = %.2f\n", float10(bar4(10)));
    r = new13(&Rect_class, 10, 10, 20, 20);
    dump18(r);
    dump18(__div__19(r, 2));
    result = 0;
    return result;
}
