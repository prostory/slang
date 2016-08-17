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
typedef union { Integer uInteger; Float uFloat; } UnionType;
typedef struct { char unused; } UnionType_Class;
typedef struct { char unused; } MainTop_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { UnionType a; } A;
typedef struct { char unused; } A1;
typedef struct { char unused; } A_Class;
typedef struct { Float a; } B;
typedef struct { char unused; } B1;
typedef struct { char unused; } B_Class;
static Object_Class Main_Object;
static Integer_Class Main_Integer;
static Float_Class Main_Float;
static Bool_Class Main_Bool;
static StringHelper_Class Main_StringHelper;
static String_Class Main_String;
static Array_Class Main_Array;
static A_Class Main_A;
static B_Class Main_B;
extern Pointer calloc(Integer, Integer);
extern A * __alloc__1(A_Class * self);
extern Void __init__2(A * self);
extern A * new3(A_Class * self);
extern Integer a__asgn__4(A * self, Integer n);
extern Integer a5(A * self);
extern Integer printf(String, ...);
extern Float a__asgn__6(A * self, Float n);
extern Float a7(A * self);
extern B * __alloc__8(B_Class * self);
extern Void __init__9(B * self);
extern B * new10(B_Class * self);
extern Float a__asgn__11(B * self, Float n);
extern Float a12(B * self);
extern A1 * __alloc__13(A_Class * self);
extern Void __init__14(A1 * self);
extern A1 * new15(A_Class * self);
extern B1 * __alloc__16(B_Class * self);
extern Void __init__17(B1 * self);
extern B1 * new18(B_Class * self);
extern Integer a19(A1 * self);
extern Integer a20(B1 * self);
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
Integer a__asgn__4(A * self, Integer n)
{
    Integer result;
    self->a.uInteger = n;
    result = self->a.uInteger;
    return result;
}
Integer a5(A * self)
{
    Integer result;
    result = self->a.uInteger;
    return result;
}
Float a__asgn__6(A * self, Float n)
{
    Float result;
    self->a.uFloat = (n - 1);
    result = self->a.uFloat;
    return result;
}
Float a7(A * self)
{
    Float result;
    result = self->a.uFloat;
    return result;
}
B * __alloc__8(B_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B), 1);
    return result;
}
Void __init__9(B * self)
{
    Nil result;
}
B * new10(B_Class * self)
{
    B * result;
    B * obj;
    obj = __alloc__8(self);
    __init__9(obj);
    result = obj;
    return result;
}
Float a__asgn__11(B * self, Float n)
{
    Float result;
    self->a = (n - 1);
    result = self->a;
    return result;
}
Float a12(B * self)
{
    Float result;
    result = self->a;
    return result;
}
A1 * __alloc__13(A_Class * self)
{
    Pointer result;
    result = calloc(sizeof(A1), 1);
    return result;
}
Void __init__14(A1 * self)
{
    Nil result;
}
A1 * new15(A_Class * self)
{
    A1 * result;
    A1 * obj;
    obj = __alloc__13(self);
    __init__14(obj);
    result = obj;
    return result;
}
B1 * __alloc__16(B_Class * self)
{
    Pointer result;
    result = calloc(sizeof(B1), 1);
    return result;
}
Void __init__17(B1 * self)
{
    Nil result;
}
B1 * new18(B_Class * self)
{
    B1 * result;
    B1 * obj;
    obj = __alloc__16(self);
    __init__17(obj);
    result = obj;
    return result;
}
Integer a19(A1 * self)
{
    Integer result;
    result = 1;
    return result;
}
Integer a20(B1 * self)
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
    a = new3(&Main_A);
    a__asgn__4(a, 5);
    printf("%d\n", a5(a));
    a__asgn__6(a, 3.5);
    printf("%f\n", a7(a));
    b = new10(&Main_B);
    a__asgn__11(b, 5.5);
    printf("%.1f\n", a12(b));
    a1 = new15(&Main_A);
    b1 = new18(&Main_B);
    printf("%d\n", a19(a1));
    printf("%d\n", a20(b1));
    result = 0;
    return result;
}
