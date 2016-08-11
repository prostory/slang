typedef struct { char unused; } Any_Class;
static Any_Class Any_class;
typedef struct { char unused; } Kernel_Class;
static Kernel_Class Kernel_class;
typedef struct { char unused; } Object_Class;
static Object_Class Object_class;
typedef struct { char unused; } Class_Class;
static Class_Class Class_class;
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
typedef struct { char unused; } UnionType_Class;
static UnionType_Class UnionType_class;
typedef struct { char unused; } StringHelper_Class;
static StringHelper_Class StringHelper_class;
typedef struct { Integer a; Integer b; } A;
typedef struct { Integer f; Integer c; Integer d; } A_Class;
static A_Class A_class;
typedef struct { Integer a; Integer b; } B;
typedef struct { Integer e; } B_Class;
static B_Class B_class;
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
    A_class.c = 1;
    A_class.d = 2;
    result = A_class.d;
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
    result = A_class.c;
    return result;
}
Integer d9(A_Class * self)
{
    Integer result;
    result = A_class.d;
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
    A_class.c = 3;
    A_class.d = 4;
    B_class.e = 5;
    result = B_class.e;
    return result;
}
Integer foo14(B * self)
{
    Integer result;
    self->a = 1;
    self->b = 2;
    A_class.c = 1;
    A_class.d = 2;
    result = A_class.d;
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
    result = A_class.c;
    return result;
}
Integer d18(B_Class * self)
{
    Integer result;
    result = A_class.d;
    return result;
}
Integer e19(B_Class * self)
{
    Integer result;
    result = B_class.e;
    return result;
}
Integer f20(A_Class * self)
{
    Integer result;
    result = A_class.f;
    return result;
}
Integer main(Void)
{
    Integer result;
    A * a;
    B * b;
    A_class.f = 3;
    A_class.f = 6;
    a = new3(&A_class);
    foo4(a);
    dump6(a5(a));
    dump6(b7(a));
    dump6(c8(&A_class));
    dump6(d9(&A_class));
    b = new12(&B_class);
    bar13(b);
    dump6(c8(&A_class));
    dump6(d9(&A_class));
    foo14(b);
    dump6(a15(b));
    dump6(b16(b));
    dump6(c17(&B_class));
    dump6(d18(&B_class));
    dump6(e19(&B_class));
    dump6(f20(&A_class));
    result = 0;
    return result;
}
