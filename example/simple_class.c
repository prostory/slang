typedef void Void;
typedef int Integer;
typedef double Float;
typedef void * Nil;
typedef char * String;
typedef void * Pointer;
typedef enum { False = 0, True = 1, } Bool;
typedef union { Integer uInteger; Float uFloat; } UnionType;
typedef struct { char unused; } Class_Class;
typedef struct { char unused; } Object_Class;
typedef struct { char unused; } Integer_Class;
typedef struct { char unused; } Float_Class;
typedef struct { char unused; } Bool_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { char unused; } String_Class;
typedef struct { char unused; } Array_Class;
typedef struct { char unused; } A_Class;
typedef struct { char unused; } B_Class;
typedef struct { UnionType a; } A;
typedef struct { char unused; } A1;
typedef struct { Float a; } B;
typedef struct { char unused; } B1;
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
extern A * __alloc__28(A_Class * self);
extern Void __init__29(A * self);
extern A * new30(A_Class * self);
extern Integer a__asgn__31(A * self, Integer n);
extern Integer a32(A * self);
extern Integer printf(String, ...);
extern Float a__asgn__33(A * self, Float n);
extern Float a34(A * self);
extern B_Class * __alloc__35(Class_Class * self);
extern Void __init__36(B_Class * self);
extern B_Class * new37(Class_Class * self);
extern B * __alloc__38(B_Class * self);
extern Void __init__39(B * self);
extern B * new40(B_Class * self);
extern Float a__asgn__41(B * self, Float n);
extern Float a42(B * self);
extern A1 * __alloc__43(A_Class * self);
extern Void __init__44(A1 * self);
extern A1 * new45(A_Class * self);
extern B1 * __alloc__46(B_Class * self);
extern Void __init__47(B1 * self);
extern B1 * new48(B_Class * self);
extern Integer a49(A1 * self);
extern Integer a50(B1 * self);
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
A * __alloc__28(A_Class * self)
{
    Pointer result;
    result = calloc(sizeof(A), 1);
    return result;
}
Void __init__29(A * self)
{
    Nil result;
}
A * new30(A_Class * self)
{
    A * result;
    A * obj;
    obj = __alloc__28(self);
    __init__29(obj);
    result = obj;
    return result;
}
Integer a__asgn__31(A * self, Integer n)
{
    Integer result;
    self->a.uInteger = n;
    result = self->a.uInteger;
    return result;
}
Integer a32(A * self)
{
    Integer result;
    result = self->a.uInteger;
    return result;
}
Float a__asgn__33(A * self, Float n)
{
    Float result;
    self->a.uFloat = (n - 1);
    result = self->a.uFloat;
    return result;
}
Float a34(A * self)
{
    Float result;
    result = self->a.uFloat;
    return result;
}
B_Class * __alloc__35(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B_Class), 1);
    return result;
}
Void __init__36(B_Class * self)
{
    Nil result;
}
B_Class * new37(Class_Class * self)
{
    B_Class * result;
    B_Class * obj;
    obj = __alloc__35(self);
    __init__36(obj);
    result = obj;
    return result;
}
B * __alloc__38(B_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B), 1);
    return result;
}
Void __init__39(B * self)
{
    Nil result;
}
B * new40(B_Class * self)
{
    B * result;
    B * obj;
    obj = __alloc__38(self);
    __init__39(obj);
    result = obj;
    return result;
}
Float a__asgn__41(B * self, Float n)
{
    Float result;
    self->a = (n - 1);
    result = self->a;
    return result;
}
Float a42(B * self)
{
    Float result;
    result = self->a;
    return result;
}
A1 * __alloc__43(A_Class * self)
{
    Pointer result;
    result = calloc(sizeof(A1), 1);
    return result;
}
Void __init__44(A1 * self)
{
    Nil result;
}
A1 * new45(A_Class * self)
{
    A1 * result;
    A1 * obj;
    obj = __alloc__43(self);
    __init__44(obj);
    result = obj;
    return result;
}
B1 * __alloc__46(B_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B1), 1);
    return result;
}
Void __init__47(B1 * self)
{
    Nil result;
}
B1 * new48(B_Class * self)
{
    B1 * result;
    B1 * obj;
    obj = __alloc__46(self);
    __init__47(obj);
    result = obj;
    return result;
}
Integer a49(A1 * self)
{
    Integer result;
    result = 1;
    return result;
}
Integer a50(B1 * self)
{
    Integer result;
    result = 1;
    return result;
}
Integer main(Void)
{
    Integer result;
    A * a;
    B * b;
    A1 * a1;
    B1 * b1;
    Main_Class = new3(Main_Class);
    Main_Object = new6(Main_Class);
    Main_Integer = new9(Main_Class);
    Main_Float = new12(Main_Class);
    Main_Bool = new15(Main_Class);
    Main_StringHelper = new18(Main_Class);
    Main_String = new21(Main_Class);
    Main_Array = new24(Main_Class);
    Main_A = new27(Main_Class);
    a = new30(Main_A);
    a__asgn__31(a, 5);
    printf("%d\n", a32(a));
    a__asgn__33(a, 3.5);
    printf("%f\n", a34(a));
    Main_B = new37(Main_Class);
    b = new40(Main_B);
    a__asgn__41(b, 5.5);
    printf("%.1f\n", a42(b));
    a1 = new45(Main_A);
    b1 = new48(Main_B);
    printf("%d\n", a49(a1));
    printf("%d\n", a50(b1));
    result = 0;
    return result;
}
