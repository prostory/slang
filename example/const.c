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
typedef struct { char unused; } A_Class;
typedef struct { char unused; } C_Class;
typedef struct { char unused; } F_Class;
static Object_Class * Main_Object;
static Class_Class * Main_Class;
static Integer_Class * Main_Integer;
static Float_Class * Main_Float;
static Bool_Class * Main_Bool;
static StringHelper_Class * Main_StringHelper;
static String_Class * Main_String;
static Array_Class * Main_Array;
static Integer Main_B;
static A_Class * Main_A;
static F_Class * Main_F;
static Integer Main_A_B;
static C_Class * Main_A_C;
static Integer Main_A_E;
static Integer Main_A_C_D;
static Integer Main_F_B;
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
extern Integer printf(String, ...);
extern C_Class * __alloc__28(Class_Class * self);
extern Void __init__29(C_Class * self);
extern C_Class * new30(Class_Class * self);
extern F_Class * __alloc__31(Class_Class * self);
extern Void __init__32(F_Class * self);
extern F_Class * new33(Class_Class * self);
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
C_Class * __alloc__28(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(C_Class), 1);
    return result;
}
Void __init__29(C_Class * self)
{
    Nil result;
}
C_Class * new30(Class_Class * self)
{
    C_Class * result;
    C_Class * obj;
    obj = __alloc__28(self);
    __init__29(obj);
    result = obj;
    return result;
}
F_Class * __alloc__31(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(F_Class), 1);
    return result;
}
Void __init__32(F_Class * self)
{
    Nil result;
}
F_Class * new33(Class_Class * self)
{
    F_Class * result;
    F_Class * obj;
    obj = __alloc__31(self);
    __init__32(obj);
    result = obj;
    return result;
}
Integer main(Void)
{
    Integer result;
    Main_Class = new3(Main_Class);
    Main_Object = new6(Main_Class);
    Main_Integer = new9(Main_Class);
    Main_Float = new12(Main_Class);
    Main_Bool = new15(Main_Class);
    Main_StringHelper = new18(Main_Class);
    Main_String = new21(Main_Class);
    Main_Array = new24(Main_Class);
    Main_B = 2;
    Main_A = new27(Main_Class);
    Main_A_B = 3;
    printf("%d\n", Main_A_B);
    printf("%d\n", Main_B);
    Main_A_C = new30(Main_Class);
    Main_A_C_D = 4;
    Main_A_E = 22083;
    Main_F = new33(Main_Class);
    printf("%d\n", Main_A_C_D);
    printf("0x%x\n", Main_A_E);
    printf("F::B = %d\n", Main_A_B);
    Main_F_B = 5;
    printf("F::B = %d\n", Main_F_B);
    result = 0;
    return result;
}
