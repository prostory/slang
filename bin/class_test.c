typedef struct { char unused; } Any_Class;
typedef struct { char unused; } Kernel_Class;
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
typedef struct { char unused; } UnionType_Class;
typedef struct { char unused; } MainTop_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { Integer a; Integer b; } A;
typedef struct { Integer f; Integer c; Integer d; } A_Class;
typedef struct { Integer a; Integer b; } B;
typedef struct { Integer e; } B_Class;
static Object_Class Main_Object;
static Integer_Class Main_Integer;
static Float_Class Main_Float;
static Bool_Class Main_Bool;
static StringHelper_Class Main_StringHelper;
static String_Class Main_String;
static Array_Class Main_Array;
static A_Class Main_A;
static B_Class Main_B;
static Integer Main_A_C;
extern Pointer calloc(Integer, Integer);
extern A * __alloc__1(A_Class * self);
extern Void __init__2(A * self);
extern A * new3(A_Class * self);
extern Integer foo4(A * self);
extern Integer a5(A * self);
extern Integer printf(String, ...);
extern Integer dump6(Integer self);
extern Integer b7(A * self);
extern Integer c8(A_Class * self);
extern Integer d9(A_Class * self);
extern B * __alloc__10(B_Class * self);
extern Void __init__11(B * self);
extern B * new12(B_Class * self);
extern Integer bar13(B * self);
extern Integer foo14(B * self);
extern Integer a15(B * self);
extern Integer b16(B * self);
extern Integer c17(B_Class * self);
extern Integer d18(B_Class * self);
extern Integer e19(B_Class * self);
extern Integer f20(A_Class * self);
A * __alloc__1(A_Class * self)
{
    Pointer result;
    result = calloc(sizeof(A), 1);
    return result;
}
Void __init__2(A * self)
{
    Nil result;
}
A * new3(A_Class * self)
{
    A * result;
    A * obj;
    obj = __alloc__1(self);
    __init__2(obj);
    result = obj;
    return result;
}
Integer foo4(A * self)
{
    Integer result;
    self->a = 1;
    self->b = 2;
    Main_A.c = 1;
    Main_A.d = 2;
    result = Main_A.d;
    return result;
}
Integer a5(A * self)
{
    Integer result;
    result = self->a;
    return result;
}
Integer dump6(Integer self)
{
    Integer result;
    result = printf("%d\n", self);
    return result;
}
Integer b7(A * self)
{
    Integer result;
    result = self->b;
    return result;
}
Integer c8(A_Class * self)
{
    Integer result;
    result = Main_A.c;
    return result;
}
Integer d9(A_Class * self)
{
    Integer result;
    result = Main_A.d;
    return result;
}
B * __alloc__10(B_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B), 1);
    return result;
}
Void __init__11(B * self)
{
    Nil result;
}
B * new12(B_Class * self)
{
    B * result;
    B * obj;
    obj = __alloc__10(self);
    __init__11(obj);
    result = obj;
    return result;
}
Integer bar13(B * self)
{
    Integer result;
    Main_A.c = 3;
    Main_A.d = 4;
    Main_B.e = 5;
    result = Main_B.e;
    return result;
}
Integer foo14(B * self)
{
    Integer result;
    self->a = 1;
    self->b = 2;
    Main_A.c = 1;
    Main_A.d = 2;
    result = Main_A.d;
    return result;
}
Integer a15(B * self)
{
    Integer result;
    result = self->a;
    return result;
}
Integer b16(B * self)
{
    Integer result;
    result = self->b;
    return result;
}
Integer c17(B_Class * self)
{
    Integer result;
    result = Main_A.c;
    return result;
}
Integer d18(B_Class * self)
{
    Integer result;
    result = Main_A.d;
    return result;
}
Integer e19(B_Class * self)
{
    Integer result;
    result = Main_B.e;
    return result;
}
Integer f20(A_Class * self)
{
    Integer result;
    result = Main_A.f;
    return result;
}
Integer main(Void)
{
    Integer result;
    A * a;
    B * b;
    Main_A.f = 3;
    Main_A_C = 1;
    Main_A.f = 6;
    a = new3(&Main_A);
    foo4(a);
    dump6(a5(a));
    dump6(b7(a));
    dump6(c8(&Main_A));
    dump6(d9(&Main_A));
    b = new12(&Main_B);
    bar13(b);
    dump6(c8(&Main_A));
    dump6(d9(&Main_A));
    foo14(b);
    dump6(a15(b));
    dump6(b16(b));
    dump6(c17(&Main_B));
    dump6(d18(&Main_B));
    dump6(e19(&Main_B));
    dump6(f20(&Main_A));
    result = 0;
    return result;
}
