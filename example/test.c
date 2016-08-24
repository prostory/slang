typedef struct { char unused; } Object;
typedef void Void;
typedef int Integer;
typedef double Float;
typedef void * Nil;
typedef char * String;
typedef void * Pointer;
typedef enum { False = 0, True = 1, } Bool;
typedef union { String uString; Float uFloat; Integer uInteger; } UnionType;
typedef struct { char unused; } Class_Class;
typedef struct { char unused; } Object_Class;
typedef struct { char unused; } Integer_Class;
typedef struct { char unused; } Float_Class;
typedef struct { char unused; } Bool_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { char unused; } String_Class;
typedef struct { char unused; } Array_Class;
typedef struct { char unused; } Pointer_Class;
typedef struct { char unused; } Options_Class;
typedef struct { char unused; } A_Class;
typedef struct { UnionType a; } B_Class;
typedef struct { Pointer type; UnionType value; } Options;
static Object_Class * Main_Object;
static Class_Class * Main_Class;
static Integer_Class * Main_Integer;
static Float_Class * Main_Float;
static Bool_Class * Main_Bool;
static StringHelper_Class * Main_StringHelper;
static String_Class * Main_String;
static Array_Class * Main_Array;
static Pointer_Class * Main_Pointer;
static Options_Class * Main_Options;
static A_Class * Main_A;
static B_Class * Main_B;
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
extern Pointer_Class * __alloc__25(Class_Class * self);
extern Void __init__26(Pointer_Class * self);
extern Pointer_Class * new27(Class_Class * self);
extern Options_Class * __alloc__28(Class_Class * self);
extern Void __init__29(Options_Class * self);
extern Options_Class * new30(Class_Class * self);
extern A_Class * __alloc__31(Class_Class * self);
extern Void __init__32(A_Class * self);
extern A_Class * new33(Class_Class * self);
extern B_Class * __alloc__34(Class_Class * self);
extern Void __init__35(B_Class * self);
extern B_Class * new36(Class_Class * self);
extern Options * __alloc__37(Options_Class * self);
extern Void __init__38(Options * self);
extern Options * new39(Options_Class * self);
extern Object * __alloc__40(Object_Class * self);
extern Void __init__41(Object * self);
extern Object * new42(Object_Class * self);
extern Integer puts(String);
extern String_Class * class43(String self);
extern Pointer as44(String_Class * self, Pointer_Class * type);
extern Options * option45(Options * self, String value);
extern Float_Class * class46(Float self);
extern Pointer as47(Float_Class * self, Pointer_Class * type);
extern Options * option48(Options * self, Float value);
extern Options * foo49(Integer n);
extern Pointer type50(Options * self);
extern UnionType value51(Options * self);
extern String as52(UnionType self, String_Class * type);
extern Float as53(UnionType self, Float_Class * type);
extern Integer printf(String, ...);
extern Integer dump54(Options * self);
extern Integer a55(B_Class * self);
extern Integer b56(Void);
extern Integer a57(B_Class * self);
extern Float a__asgn__58(B_Class * self, Float n);
extern Float a59(B_Class * self);
extern Bool __eq__60(Float_Class * self, String_Class * other);
extern String a__asgn__61(B_Class * self, String n);
extern UnionType a62(B_Class * self);
extern String as63(UnionType self, String_Class * type);
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
Pointer_Class * __alloc__25(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Pointer_Class), 1);
    return result;
}
Void __init__26(Pointer_Class * self)
{
    Nil result;
}
Pointer_Class * new27(Class_Class * self)
{
    Pointer_Class * result;
    Pointer_Class * obj;
    obj = __alloc__25(self);
    __init__26(obj);
    result = obj;
    return result;
}
Options_Class * __alloc__28(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Options_Class), 1);
    return result;
}
Void __init__29(Options_Class * self)
{
    Nil result;
}
Options_Class * new30(Class_Class * self)
{
    Options_Class * result;
    Options_Class * obj;
    obj = __alloc__28(self);
    __init__29(obj);
    result = obj;
    return result;
}
A_Class * __alloc__31(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(A_Class), 1);
    return result;
}
Void __init__32(A_Class * self)
{
    Nil result;
}
A_Class * new33(Class_Class * self)
{
    A_Class * result;
    A_Class * obj;
    obj = __alloc__31(self);
    __init__32(obj);
    result = obj;
    return result;
}
B_Class * __alloc__34(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B_Class), 1);
    return result;
}
Void __init__35(B_Class * self)
{
    Nil result;
}
B_Class * new36(Class_Class * self)
{
    B_Class * result;
    B_Class * obj;
    obj = __alloc__34(self);
    __init__35(obj);
    result = obj;
    return result;
}
Options * __alloc__37(Options_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Options), 1);
    return result;
}
Void __init__38(Options * self)
{
    Nil result;
}
Options * new39(Options_Class * self)
{
    Options * result;
    Options * obj;
    obj = __alloc__37(self);
    __init__38(obj);
    result = obj;
    return result;
}
Object * __alloc__40(Object_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Object), 1);
    return result;
}
Void __init__41(Object * self)
{
    Nil result;
}
Object * new42(Object_Class * self)
{
    Object * result;
    Object * obj;
    obj = __alloc__40(self);
    __init__41(obj);
    result = obj;
    return result;
}
String_Class * class43(String self)
{
    String_Class * result;
    result = Main_String;
    return result;
}
Pointer as44(String_Class * self, Pointer_Class * type)
{
    Pointer result;
    result = (Pointer)self;
    return result;
}
Options * option45(Options * self, String value)
{
    Options * result;
    self->type = as44(class43(value), Main_Pointer);
    self->value.uString = value;
    result = self;
    return result;
}
Float_Class * class46(Float self)
{
    Float_Class * result;
    result = Main_Float;
    return result;
}
Pointer as47(Float_Class * self, Pointer_Class * type)
{
    Pointer result;
    result = (Pointer)self;
    return result;
}
Options * option48(Options * self, Float value)
{
    Options * result;
    self->type = as47(class46(value), Main_Pointer);
    self->value.uFloat = value;
    result = self;
    return result;
}
Options * foo49(Integer n)
{
    Options * result;
    String a;
    Options * a1;
    Object * b;
    Object * c;
    Bool d;
    a = 0;
    a = "Hello World";
    a1 = new39(Main_Options);
    b = new42(Main_Object);
    c = new42(Main_Object);
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
        result = option45(a1, "hello");
    }
    else
    {
        result = option48(a1, 1.5);
    }
    return result;
}
Pointer type50(Options * self)
{
    Pointer result;
    result = self->type;
    return result;
}
UnionType value51(Options * self)
{
    UnionType result;
    result = self->value;
    return result;
}
String as52(UnionType self, String_Class * type)
{
    String result;
    result = self.uString;
    return result;
}
Float as53(UnionType self, Float_Class * type)
{
    Float result;
    result = self.uFloat;
    return result;
}
Integer dump54(Options * self)
{
    Integer result;
    if ((type50(self) == Main_String))
    {
        result = puts(as52(value51(self), Main_String));
    }
    else
    {
        if ((type50(self) == Main_Float))
        {
            result = printf("%f\n", as53(value51(self), Main_Float));
        }
    }
    return result;
}
Integer a55(B_Class * self)
{
    Integer result;
    Main_B->a.uInteger = 1;
    result = puts("a");
    return result;
}
Integer b56(Void)
{
    Integer result;
    result = puts("b");
    return result;
}
Integer a57(B_Class * self)
{
    Integer result;
    result = Main_B->a.uInteger;
    return result;
}
Float a__asgn__58(B_Class * self, Float n)
{
    Float result;
    Main_B->a.uFloat = n;
    result = Main_B->a.uFloat;
    return result;
}
Float a59(B_Class * self)
{
    Float result;
    result = Main_B->a.uFloat;
    return result;
}
Bool __eq__60(Float_Class * self, String_Class * other)
{
    Bool result;
    result = (as47(self, Main_Pointer) == as44(other, Main_Pointer));
    return result;
}
String a__asgn__61(B_Class * self, String n)
{
    String result;
    Main_B->a.uString = n;
    result = Main_B->a.uString;
    return result;
}
UnionType a62(B_Class * self)
{
    UnionType result;
    result = Main_B->a;
    return result;
}
String as63(UnionType self, String_Class * type)
{
    String result;
    result = self.uString;
    return result;
}
Integer main(Void)
{
    Integer result;
    Options * a;
    Main_Class = new3(Main_Class);
    Main_Object = new6(Main_Class);
    Main_Integer = new9(Main_Class);
    Main_Float = new12(Main_Class);
    Main_Bool = new15(Main_Class);
    Main_StringHelper = new18(Main_Class);
    Main_String = new21(Main_Class);
    Main_Array = new24(Main_Class);
    Main_Pointer = new27(Main_Class);
    Main_Options = new30(Main_Class);
    Main_A = new33(Main_Class);
    Main_B = new36(Main_Class);
    a = foo49(5);
    dump54(a);
    a = foo49(-(1));
    dump54(a);
    a55(Main_B);
    b56();
    printf("%d\n", a57(Main_B));
    a__asgn__58(Main_B, 5.1);
    printf("%f\n", a59(Main_B));
    if (__eq__60(class46(a59(Main_B)), Main_String))
    {
        a__asgn__61(Main_B, "Hello");
    }
    else
    {
        a__asgn__61(Main_B, "World");
    }
    puts(as63(a62(Main_B), Main_String));
    result = 0;
    return result;
}
