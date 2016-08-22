typedef void Void;
typedef int Integer;
typedef double Float;
typedef void * Nil;
typedef char * String;
typedef void * Pointer;
typedef enum { False = 0, True = 1, } Bool;
typedef union { Integer uInteger; String uString; Float uFloat; } UnionType;
typedef struct { char unused; } Class_Class;
typedef struct { char unused; } Object_Class;
typedef struct { char unused; } Integer_Class;
typedef struct { char unused; } Float_Class;
typedef struct { char unused; } Bool_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { char unused; } String_Class;
typedef struct { char unused; } Array_Class;
typedef struct { char unused; } UnionType_Class;
typedef struct { char unused; } Rect_Class;
typedef struct { Integer x; Integer y; Integer w; Integer h; } Rect;
static Object_Class * Main_Object;
static Class_Class * Main_Class;
static Integer_Class * Main_Integer;
static Float_Class * Main_Float;
static Bool_Class * Main_Bool;
static StringHelper_Class * Main_StringHelper;
static String_Class * Main_String;
static Array_Class * Main_Array;
static UnionType_Class * Main_UnionType;
static Rect_Class * Main_Rect;
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
extern Integer fib25(Integer n);
extern Integer printf(String, ...);
extern Float fib26(Float n);
extern Nil foo27(Void);
extern UnionType bar28(Integer n);
extern String strdup(String);
extern String new29(String_Class * self, String const_str);
extern Integer strlen(String);
extern String realloc(String, Integer);
extern String strcat(String, String);
extern String __lsh__30(String self, String s);
extern Integer puts(String);
extern UnionType_Class * __alloc__31(Class_Class * self);
extern Void __init__32(UnionType_Class * self);
extern UnionType_Class * new33(Class_Class * self);
extern String to_s34(Bool self);
extern String string35(UnionType self);
extern Integer int36(UnionType self);
extern Float float37(UnionType self);
extern Rect_Class * __alloc__38(Class_Class * self);
extern Void __init__39(Rect_Class * self);
extern Rect_Class * new40(Class_Class * self);
extern Rect * __alloc__41(Rect_Class * self);
extern Integer __init__42(Rect * self, Integer x, Integer y, Integer w, Integer h);
extern Rect * new43(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3);
extern Integer x44(Rect * self);
extern Integer y45(Rect * self);
extern Integer w46(Rect * self);
extern Integer h47(Rect * self);
extern Integer dump48(Rect * self);
extern Rect * __div__49(Rect * self, Integer n);
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
Integer fib25(Integer n)
{
    Integer result;
    if ((n < 2))
    {
        result = n;
    }
    else
    {
        result = (fib25((n - 2)) + fib25((n - 1)));
    }
    return result;
}
Float fib26(Float n)
{
    Float result;
    if ((n < 2))
    {
        result = n;
    }
    else
    {
        result = (fib26((n - 2)) + fib26((n - 1)));
    }
    return result;
}
Nil foo27(Void)
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
UnionType bar28(Integer n)
{
    UnionType result;
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
String new29(String_Class * self, String const_str)
{
    String result;
    result = strdup(const_str);
    return result;
}
String __lsh__30(String self, String s)
{
    String result;
    Integer len;
    len = ((strlen(self) + strlen(s)) + 1);
    self = realloc(self, len);
    result = strcat(self, s);
    return result;
}
UnionType_Class * __alloc__31(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(UnionType_Class), 1);
    return result;
}
Void __init__32(UnionType_Class * self)
{
    Nil result;
}
UnionType_Class * new33(Class_Class * self)
{
    UnionType_Class * result;
    UnionType_Class * obj;
    obj = __alloc__31(self);
    __init__32(obj);
    result = obj;
    return result;
}
String to_s34(Bool self)
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
String string35(UnionType self)
{
    String result;
    result = self.uString;
    return result;
}
Integer int36(UnionType self)
{
    Integer result;
    result = self.uInteger;
    return result;
}
Float float37(UnionType self)
{
    Float result;
    result = self.uFloat;
    return result;
}
Rect_Class * __alloc__38(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Rect_Class), 1);
    return result;
}
Void __init__39(Rect_Class * self)
{
    Nil result;
}
Rect_Class * new40(Class_Class * self)
{
    Rect_Class * result;
    Rect_Class * obj;
    obj = __alloc__38(self);
    __init__39(obj);
    result = obj;
    return result;
}
Rect * __alloc__41(Rect_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Rect), 1);
    return result;
}
Integer __init__42(Rect * self, Integer x, Integer y, Integer w, Integer h)
{
    Integer result;
    self->x = x;
    self->y = y;
    self->w = w;
    self->h = h;
    result = self->h;
    return result;
}
Rect * new43(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3)
{
    Rect * result;
    Rect * obj;
    obj = __alloc__41(self);
    __init__42(obj, var0, var1, var2, var3);
    result = obj;
    return result;
}
Integer x44(Rect * self)
{
    Integer result;
    result = self->x;
    return result;
}
Integer y45(Rect * self)
{
    Integer result;
    result = self->y;
    return result;
}
Integer w46(Rect * self)
{
    Integer result;
    result = self->w;
    return result;
}
Integer h47(Rect * self)
{
    Integer result;
    result = self->h;
    return result;
}
Integer dump48(Rect * self)
{
    Integer result;
    result = printf("(%d, %d, %d, %d)\n", x44(self), y45(self), w46(self), h47(self));
    return result;
}
Rect * __div__49(Rect * self, Integer n)
{
    Rect * result;
    result = new43(Main_Rect, (x44(self) / n), (y45(self) / n), (w46(self) / n), (h47(self) / n));
    return result;
}
Integer main(Void)
{
    Integer result;
    Integer i;
    Float i1;
    String i2;
    Bool i3;
    Rect * r;
    Main_Class = new3(Main_Class);
    Main_Object = new6(Main_Class);
    Main_Integer = new9(Main_Class);
    Main_Float = new12(Main_Class);
    Main_Bool = new15(Main_Class);
    Main_StringHelper = new18(Main_Class);
    Main_String = new21(Main_Class);
    Main_Array = new24(Main_Class);
    printf("fib(6) = %d\n", fib25(6));
    printf("fib(6.5) = %.2f\n", fib26(6.5));
    foo27();
    bar28(10);
    i = 0;
    printf("i = %d\n", i);
    i1 = (i + 1.0);
    i1 = (1 + i1);
    printf("i = %.2f\n", i1);
    i2 = new29(Main_String, "Hello ");
    __lsh__30(i2, "World");
    puts(i2);
    i3 = True;
    Main_UnionType = new33(Main_Class);
    puts(to_s34(i3));
    i3 = False;
    puts(to_s34(i3));
    printf("bar(0) = '%s'\n", string35(bar28(0)));
    printf("bar(-1) = %d\n", int36(bar28(-(1))));
    printf("bar(10) = %.2f\n", float37(bar28(10)));
    Main_Rect = new40(Main_Class);
    r = new43(Main_Rect, 10, 10, 20, 20);
    dump48(r);
    dump48(__div__49(r, 2));
    result = 0;
    return result;
}
