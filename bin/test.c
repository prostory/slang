typedef struct { char unused; } Any_Class;
typedef struct { char unused; } Kernel_Class;
typedef struct { char unused; } Object;
typedef struct { char unused; } Object_Class;
typedef struct { char unused; } Class_Class;
typedef void Void;
typedef struct { char unused; } Void_Class;
typedef int Integer;
typedef struct { char unused; } Integer_Class;
typedef double Float;
typedef struct { char unused; } Float_Class;
typedef void * Nil;
typedef struct { char unused; } Nil_Class;
typedef char * String;
typedef struct { char unused; } String_Class;
typedef void * Pointer;
typedef struct { char unused; } Pointer_Class;
typedef enum { False = 0, True = 1, } Bool;
typedef struct { char unused; } Bool_Class;
typedef struct { char unused; } Array_Class;
typedef union { String uString; Float uFloat; Integer uInteger; } UnionType;
typedef struct { char unused; } UnionType_Class;
typedef struct { char unused; } MainTop_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { Integer type; UnionType value; } Options;
typedef struct { char unused; } Options_Class;
typedef struct { char unused; } A_Class;
typedef struct { UnionType a; } B_Class;
static Object_Class Main_Object;
static Integer_Class Main_Integer;
static Float_Class Main_Float;
static Bool_Class Main_Bool;
static StringHelper_Class Main_StringHelper;
static String_Class Main_String;
static Array_Class Main_Array;
static Options_Class Main_Options;
static A_Class Main_A;
static B_Class Main_B;
extern Pointer calloc(Integer, Integer);
extern Options * __alloc__1(Options_Class * self);
extern Void __init__2(Options * self);
extern Options * new3(Options_Class * self);
extern Object * __alloc__4(Object_Class * self);
extern Void __init__5(Object * self);
extern Object * new6(Object_Class * self);
extern Integer puts(String);
extern String_Class * class7(String self);
extern Integer type_id8(String_Class * self);
extern Options * option9(Options * self, String value);
extern Float_Class * class10(Float self);
extern Integer type_id11(Float_Class * self);
extern Options * option12(Options * self, Float value);
extern Options * foo13(Integer n);
extern Integer type14(Options * self);
extern String string15(Options * self);
extern Float float16(Options * self);
extern Integer printf(String, ...);
extern Integer dump17(Options * self);
extern Integer a18(B_Class * self);
extern Integer b19(Void);
extern Integer a20(B_Class * self);
extern Float a__asgn__21(B_Class * self, Float n);
extern Float a22(B_Class * self);
extern String a__asgn__23(B_Class * self, String n);
extern UnionType a24(B_Class * self);
Options * __alloc__1(Options_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Options), 1);
    return result;
}
Void __init__2(Options * self)
{
    Nil result;
}
Options * new3(Options_Class * self)
{
    Options * result;
    Options * obj;
    obj = __alloc__1(self);
    __init__2(obj);
    result = obj;
    return result;
}
Object * __alloc__4(Object_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Object), 1);
    return result;
}
Void __init__5(Object * self)
{
    Nil result;
}
Object * new6(Object_Class * self)
{
    Object * result;
    Object * obj;
    obj = __alloc__4(self);
    __init__5(obj);
    result = obj;
    return result;
}
String_Class * class7(String self)
{
    String_Class * result;
    result = &Main_String;
    return result;
}
Integer type_id8(String_Class * self)
{
    Integer result;
    result = 8;
    return result;
}
Options * option9(Options * self, String value)
{
    Options * result;
    self->type = type_id8(class7(value));
    self->value.uString = value;
    result = self;
    return result;
}
Float_Class * class10(Float self)
{
    Float_Class * result;
    result = &Main_Float;
    return result;
}
Integer type_id11(Float_Class * self)
{
    Integer result;
    result = 6;
    return result;
}
Options * option12(Options * self, Float value)
{
    Options * result;
    self->type = type_id11(class10(value));
    self->value.uFloat = value;
    result = self;
    return result;
}
Options * foo13(Integer n)
{
    Options * result;
    String a;
    Options * a1;
    Object * b;
    Object * c;
    Bool d;
    a = 0;
    a = "Hello World";
    a1 = new3(&Main_Options);
    b = new6(&Main_Object);
    c = new6(&Main_Object);
    d = (b == c);
    if (d)
    {
        puts("true");
    }
    else
    {
        puts("false");
    }
    if ((n > 0))
    {
        result = option9(a1, "hello");
    }
    else
    {
        result = option12(a1, 1.5);
    }
    return result;
}
Integer type14(Options * self)
{
    Integer result;
    result = self->type;
    return result;
}
String string15(Options * self)
{
    String result;
    result = self->value.uString;
    return result;
}
Float float16(Options * self)
{
    Float result;
    result = self->value.uFloat;
    return result;
}
Integer dump17(Options * self)
{
    Integer result;
    if ((type14(self) == type_id8(&Main_String)))
    {
        result = puts(string15(self));
    }
    else
    {
        if ((type14(self) == type_id11(&Main_Float)))
        {
            result = printf("%f\n", float16(self));
        }
    }
    return result;
}
Integer a18(B_Class * self)
{
    Integer result;
    Main_B.a.uInteger = 1;
    result = puts("a");
    return result;
}
Integer b19(Void)
{
    Integer result;
    result = puts("b");
    return result;
}
Integer a20(B_Class * self)
{
    Integer result;
    result = Main_B.a.uInteger;
    return result;
}
Float a__asgn__21(B_Class * self, Float n)
{
    Float result;
    Main_B.a.uFloat = n;
    result = Main_B.a.uFloat;
    return result;
}
Float a22(B_Class * self)
{
    Float result;
    result = Main_B.a.uFloat;
    return result;
}
String a__asgn__23(B_Class * self, String n)
{
    String result;
    Main_B.a.uString = n;
    result = Main_B.a.uString;
    return result;
}
UnionType a24(B_Class * self)
{
    UnionType result;
    result = Main_B.a;
    return result;
}
Integer main(Void)
{
    Integer result;
    Options * a;
    Options * a1;
    a = foo13(5);
    dump17(a);
    a1 = foo13(-(1));
    dump17(a1);
    a18(&Main_B);
    b19();
    printf("%d\n", a20(&Main_B));
    a__asgn__21(&Main_B, 5.1);
    printf("%f\n", a22(&Main_B));
    if ((type_id11(class10(a22(&Main_B))) == type_id8(&Main_String)))
    {
        a__asgn__23(&Main_B, "Hello");
    }
    else
    {
        a__asgn__23(&Main_B, "World");
    }
    puts(a24(&Main_B).uString);
    result = 0;
    return result;
}
