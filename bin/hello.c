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
typedef union { Integer uInteger; Float uFloat; String uString; } Options;
typedef struct { char unused; } Options_Class;
static Options_Class Options_class;
typedef struct { char unused; } Object_Class;
static Object_Class Object_class;
typedef struct { char unused; } StringHelper_Class;
static StringHelper_Class StringHelper_class;
typedef struct { Integer a; } A_Class;
static A_Class A_class;
typedef struct { Integer id; } B;
typedef struct { String name; } B1;
typedef struct { String name; Integer id; Options a; } B2;
typedef struct { Integer a; } B_Class;
static B_Class B_class;
typedef struct { char unused; } Lambda_Class;
static Lambda_Class Lambda_class;
extern Pointer calloc(Integer, Integer);
extern B * __alloc__1(B_Class * self);
extern Integer __init__2(B * self, Integer id);
extern B * new3(B_Class * self, Integer var0);
extern String strdup(String);
extern String new4(String_Class * self, String const_str);
extern B1 * __alloc__5(B_Class * self);
extern String __init__6(B1 * self, String name);
extern B1 * new7(B_Class * self, String var0);
extern B2 * __alloc__8(B_Class * self);
extern Integer __init__9(B2 * self, String name, Integer id);
extern B2 * new10(B_Class * self, String var0, Integer var1);
extern Integer id11(B2 * self);
extern Bool __eq__12(B * self, B2 * other);
extern Integer id13(B * self);
extern Integer printf(String, ...);
extern Integer puts(String);
extern Integer a14(B2 * self);
extern Integer b15(A_Class * self);
extern Integer a16(B2 * self);
extern Integer b17(A_Class * self);
extern Integer b18(B_Class * self);
extern Float set_id19(B2 * self, Float n);
extern Float get_id20(B2 * self);
extern Integer set_id21(B2 * self, Integer n);
extern Integer get_id22(B2 * self);
extern String name23(B2 * self);
extern Integer lambda0(Integer n);
extern Void times24(Integer self);
extern Integer lambda1(Integer n);
extern Void times25(Integer self);
extern Integer lambda2(Integer n);
extern Void times26(Integer self);
extern Options * new27(Array_Class * self, Integer size);
extern Float __set__28(Options * self, Integer index, Float value);
extern Integer __set__29(Options * self, Integer index, Integer value);
extern String __set__30(Options * self, Integer index, String value);
extern Options __get__31(Options * self, Integer index);
B * __alloc__1(B_Class * self)
{
    return calloc(sizeof(B), 1);
}
Integer __init__2(B * self, Integer id)
{
    return self->id = id;
}
B * new3(B_Class * self, Integer var0)
{
    Pointer obj;
    obj = __alloc__1(self);
    __init__2(obj, var0);
    return obj;
}
String new4(String_Class * self, String const_str)
{
    return strdup(const_str);
}
B1 * __alloc__5(B_Class * self)
{
    return calloc(sizeof(B1), 1);
}
String __init__6(B1 * self, String name)
{
    return self->name = name;
}
B1 * new7(B_Class * self, String var0)
{
    Pointer obj;
    obj = __alloc__5(self);
    __init__6(obj, var0);
    return obj;
}
B2 * __alloc__8(B_Class * self)
{
    return calloc(sizeof(B2), 1);
}
Integer __init__9(B2 * self, String name, Integer id)
{
    self->name = name;
    return self->id = id;
}
B2 * new10(B_Class * self, String var0, Integer var1)
{
    Pointer obj;
    obj = __alloc__8(self);
    __init__9(obj, var0, var1);
    return obj;
}
Integer id11(B2 * self)
{
    return self->id;
}
Bool __eq__12(B * self, B2 * other)
{
    return (id11(other) == self->id);
}
Integer id13(B * self)
{
    return self->id;
}
Integer a14(B2 * self)
{
    return puts(new4(&String_class, "hello"));
}
Integer b15(A_Class * self)
{
    return puts(new4(&String_class, "static hello"));
}
Integer a16(B2 * self)
{
    return puts(new4(&String_class, "world"));
}
Integer b17(A_Class * self)
{
    puts(new4(&String_class, "static world"));
    return self->a = 5;
}
Integer b18(B_Class * self)
{
    puts(new4(&String_class, "static world"));
    return self->a = 5;
}
Float set_id19(B2 * self, Float n)
{
    return self->a.uFloat = n;
}
Float get_id20(B2 * self)
{
    return self->a.uFloat;
}
Integer set_id21(B2 * self, Integer n)
{
    return self->a.uInteger = n;
}
Integer get_id22(B2 * self)
{
    return self->a.uInteger;
}
String name23(B2 * self)
{
    return self->name;
}
Integer lambda0(Integer n)
{
    return puts(new4(&String_class, "Hello"));
}
Void times24(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda0(i);
        i = (i + 1);
    }
}
Integer lambda1(Integer n)
{
    return puts(new4(&String_class, "World"));
}
Void times25(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda1(i);
        i = (i + 1);
    }
}
Integer lambda2(Integer n)
{
    return printf(new4(&String_class, "count: %d\n"), n);
}
Void times26(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda2(i);
        i = (i + 1);
    }
}
Options * new27(Array_Class * self, Integer size)
{
    return calloc(sizeof(Options), size);
}
Float __set__28(Options * self, Integer index, Float value)
{
    return ((Options *)self)[index].uFloat = value;
}
Integer __set__29(Options * self, Integer index, Integer value)
{
    return ((Options *)self)[index].uInteger = value;
}
String __set__30(Options * self, Integer index, String value)
{
    return ((Options *)self)[index].uString = value;
}
Options __get__31(Options * self, Integer index)
{
    return ((Options *)self)[index];
}
Integer main(Void)
{
    Pointer b;
    b = new3(&B_class, 2);
    sizeof(B);
    b = new7(&B_class, new4(&String_class, "Xiao Peng"));
    sizeof(B1);
    b = new10(&B_class, new4(&String_class, "Xiao Peng"), 1);
    sizeof(B2);
    Pointer c;
    c = new3(&B_class, 2);
    if (__eq__12(c, b))
    {
        printf(new4(&String_class, "c[%d] == b[%d]\n"), id13(c), id11(b));
    }
    else
    {
        printf(new4(&String_class, "c[%d] != b[%d]\n"), id13(c), id11(b));
    }
    a14(b);
    b15(&A_class);
    a16(b);
    b17(&A_class);
    b18(&B_class);
    set_id19(b, 2.3);
    puts("Float");
    set_id21(b, 1);
    puts("Integer");
    puts(name23(b));
    puts("B");
    printf(new4(&String_class, "hello, goto %d\n"), get_id22(b));
    times24(5);
    times25(5);
    times26(5);
    Pointer ary;
    ary = calloc(sizeof(Integer), 5);
    ((Integer *)ary)[2] = 1;
    ((Integer *)ary)[1] = 2;
    ((Integer *)ary)[0] = 5;
    printf(new4(&String_class, "value: %d, %d\n"), ((Integer *)ary)[0], ((Integer *)ary)[1]);
    ary = new27(&Array_class, 5);
    __set__28(ary, 0, 0.234);
    __set__28(ary, 1, 0.456);
    __set__29(ary, 2, 2);
    __set__30(ary, 3, new4(&String_class, "Hello"));
    printf(new4(&String_class, "value: %f, %d\n"), __get__31(ary, 0).uFloat, __get__31(ary, 2).uInteger);
    puts(__get__31(ary, 3).uString);
    return (5 & (1 << 2));
}
