typedef void Void;
typedef int Integer;
typedef double Float;
typedef void * Nil;
typedef char * String;
typedef void * Pointer;
typedef enum { False = 0, True = 1, } Bool;
typedef struct { char unused; } Class_Class;
typedef struct { char unused; } Object_Class;
typedef struct { char unused; } Integer_Class;
typedef struct { char unused; } Float_Class;
typedef struct { char unused; } Bool_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { char unused; } String_Class;
typedef struct { char unused; } Array_Class;
typedef struct { Integer f; Integer c; Integer d; } A_Class;
typedef struct { Integer e; } B_Class;
typedef struct { Integer a; Integer b; } A;
typedef struct { Integer a; Integer b; } B;
static Object_Class * Main_Object;
static Class_Class * Main_Class;
static Integer_Class * Main_Integer;
static Float_Class * Main_Float;
static Bool_Class * Main_Bool;
static StringHelper_Class * Main_StringHelper;
static String_Class * Main_String;
static Array_Class * Main_Array;
static A_Class * Main_A;
static B_Class * Main_B;
static Integer Main_A_C;
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
extern A_Class * __alloc__25(Class_Class * self);
extern Void __init__26(A_Class * self);
extern A_Class * new27(Class_Class * self);
extern B_Class * __alloc__28(Class_Class * self);
extern Void __init__29(B_Class * self);
extern B_Class * new30(Class_Class * self);
extern A * __alloc__31(A_Class * self);
extern Void __init__32(A * self);
extern A * new33(A_Class * self);
extern Integer foo34(A * self);
extern Integer a35(A * self);
extern Integer printf(String, ...);
extern Integer dump36(Integer self);
extern Integer b37(A * self);
extern Integer c38(A_Class * self);
extern Integer d39(A_Class * self);
extern B * __alloc__40(B_Class * self);
extern Void __init__41(B * self);
extern B * new42(B_Class * self);
extern Integer bar43(B * self);
extern Integer foo44(B * self);
extern Integer a45(B * self);
extern Integer b46(B * self);
extern Integer c47(B_Class * self);
extern Integer d48(B_Class * self);
extern Integer e49(B_Class * self);
extern Integer f50(A_Class * self);
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
A_Class * __alloc__25(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(A_Class), 1);
    return result;
}
Void __init__26(A_Class * self)
{
    Nil result;
}
A_Class * new27(Class_Class * self)
{
    A_Class * result;
    A_Class * obj;
    obj = __alloc__25(self);
    __init__26(obj);
    result = obj;
    return result;
}
B_Class * __alloc__28(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B_Class), 1);
    return result;
}
Void __init__29(B_Class * self)
{
    Nil result;
}
B_Class * new30(Class_Class * self)
{
    B_Class * result;
    B_Class * obj;
    obj = __alloc__28(self);
    __init__29(obj);
    result = obj;
    return result;
}
A * __alloc__31(A_Class * self)
{
    Pointer result;
    result = calloc(sizeof(A), 1);
    return result;
}
Void __init__32(A * self)
{
    Nil result;
}
A * new33(A_Class * self)
{
    A * result;
    A * obj;
    obj = __alloc__31(self);
    __init__32(obj);
    result = obj;
    return result;
}
Integer foo34(A * self)
{
    Integer result;
    self->a = 1;
    self->b = 2;
    Main_A->c = 1;
    Main_A->d = 2;
    result = Main_A->d;
    return result;
}
Integer a35(A * self)
{
    Integer result;
    result = self->a;
    return result;
}
Integer dump36(Integer self)
{
    Integer result;
    result = printf("%d\n", self);
    return result;
}
Integer b37(A * self)
{
    Integer result;
    result = self->b;
    return result;
}
Integer c38(A_Class * self)
{
    Integer result;
    result = Main_A->c;
    return result;
}
Integer d39(A_Class * self)
{
    Integer result;
    result = Main_A->d;
    return result;
}
B * __alloc__40(B_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B), 1);
    return result;
}
Void __init__41(B * self)
{
    Nil result;
}
B * new42(B_Class * self)
{
    B * result;
    B * obj;
    obj = __alloc__40(self);
    __init__41(obj);
    result = obj;
    return result;
}
Integer bar43(B * self)
{
    Integer result;
    Main_A->c = 3;
    Main_A->d = 4;
    Main_B->e = 5;
    result = Main_B->e;
    return result;
}
Integer foo44(B * self)
{
    Integer result;
    self->a = 1;
    self->b = 2;
    Main_A->c = 1;
    Main_A->d = 2;
    result = Main_A->d;
    return result;
}
Integer a45(B * self)
{
    Integer result;
    result = self->a;
    return result;
}
Integer b46(B * self)
{
    Integer result;
    result = self->b;
    return result;
}
Integer c47(B_Class * self)
{
    Integer result;
    result = Main_A->c;
    return result;
}
Integer d48(B_Class * self)
{
    Integer result;
    result = Main_A->d;
    return result;
}
Integer e49(B_Class * self)
{
    Integer result;
    result = Main_B->e;
    return result;
}
Integer f50(A_Class * self)
{
    Integer result;
    result = Main_A->f;
    return result;
}
Integer main(Void)
{
    Integer result;
    A * a;
    B * b;
    Main_Class = new3(Main_Class);
    Main_Object = new6(Main_Class);
    Main_Integer = new9(Main_Class);
    Main_Float = new12(Main_Class);
    Main_Bool = new15(Main_Class);
    Main_StringHelper = new18(Main_Class);
    Main_String = new21(Main_Class);
    Main_Array = new24(Main_Class);
    Main_A = new27(Main_Class);
    Main_A->f = 3;
    Main_A_C = 1;
    Main_B = new30(Main_Class);
    Main_A->f = 6;
    a = new33(Main_A);
    foo34(a);
    dump36(a35(a));
    dump36(b37(a));
    dump36(c38(Main_A));
    dump36(d39(Main_A));
    b = new42(Main_B);
    bar43(b);
    dump36(c38(Main_A));
    dump36(d39(Main_A));
    foo44(b);
    dump36(a45(b));
    dump36(b46(b));
    dump36(c47(Main_B));
    dump36(d48(Main_B));
    dump36(e49(Main_B));
    dump36(f50(Main_A));
    result = 0;
    return result;
}
