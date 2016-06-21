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
typedef union { Integer uInteger; Float uFloat; } UnionType;
typedef struct { char unused; } UnionType_Class;
static UnionType_Class UnionType_class;
typedef struct { char unused; } Object_Class;
static Object_Class Object_class;
typedef struct { char unused; } StringHelper_Class;
static StringHelper_Class StringHelper_class;
typedef struct { Integer a; } A_Class;
static A_Class A_class;
typedef struct { Integer id; } B;
typedef struct { String name; } B1;
typedef struct { String name; Integer id; UnionType a; } B2;
typedef struct { Integer id; } B3;
typedef struct { Integer a; } B_Class;
static B_Class B_class;
typedef struct { char unused; } Lambda_Class;
static Lambda_Class Lambda_class;
extern Pointer calloc(Integer, Integer);
extern B * __alloc__1(B_Class * self);
extern Integer __init__2(B * self, Integer id);
extern B * new3(B_Class * self, Integer var0);
extern String strdup(String);
extern String new5(String_Class * self, String const_str);
extern B1 * __alloc__6(B_Class * self);
extern String __init__7(B1 * self, String name);
extern B1 * new8(B_Class * self, String var0);
extern B2 * __alloc__9(B_Class * self);
extern Integer __init__10(B2 * self, String name, Integer id);
extern B2 * new11(B_Class * self, String var0, Integer var1);
extern B3 * __alloc__12(B_Class * self);
extern Integer __init__13(B3 * self, Integer id);
extern B3 * new14(B_Class * self, Integer var0);
extern Integer id15(B2 * self);
extern Bool __eq__17(B3 * self, B2 * other);
extern Integer id18(B3 * self);
extern Integer printf(String, ...);
extern Integer printf(String, ...);
extern Integer puts(String);
extern Integer a22(B2 * self);
extern Integer b23(A_Class * self);
extern Integer a24(B2 * self);
extern Integer b25(A_Class * self);
extern Integer b26(B_Class * self);
extern Float set_id27(B2 * self, Float n);
extern Float get_id28(B2 * self);
extern Integer set_id29(B2 * self, Integer n);
extern Integer get_id30(B2 * self);
extern String name31(B2 * self);
extern Integer printf(String, ...);
extern Integer lambda34(Integer n);
extern Void times36(Integer self);
extern Integer lambda37(Integer n);
extern Void times38(Integer self);
extern Integer printf(String, ...);
extern Integer printf(String, ...);
extern Integer lambda41(Integer n);
extern Void times42(Integer self);
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
String new5(String_Class * self, String const_str)
{
    return strdup(const_str);
}
B1 * __alloc__6(B_Class * self)
{
    return calloc(sizeof(B1), 1);
}
String __init__7(B1 * self, String name)
{
    return self->name = name;
}
B1 * new8(B_Class * self, String var0)
{
    Pointer obj;
    obj = __alloc__6(self);
    __init__7(obj, var0);
    return obj;
}
B2 * __alloc__9(B_Class * self)
{
    return calloc(sizeof(B2), 1);
}
Integer __init__10(B2 * self, String name, Integer id)
{
    self->name = name;
    return self->id = id;
}
B2 * new11(B_Class * self, String var0, Integer var1)
{
    Pointer obj;
    obj = __alloc__9(self);
    __init__10(obj, var0, var1);
    return obj;
}
B3 * __alloc__12(B_Class * self)
{
    return calloc(sizeof(B3), 1);
}
Integer __init__13(B3 * self, Integer id)
{
    return self->id = id;
}
B3 * new14(B_Class * self, Integer var0)
{
    Pointer obj;
    obj = __alloc__12(self);
    __init__13(obj, var0);
    return obj;
}
Integer id15(B2 * self)
{
    return self->id;
}
Bool __eq__17(B3 * self, B2 * other)
{
    return (id15(other) == self->id);
}
Integer id18(B3 * self)
{
    return self->id;
}
Integer a22(B2 * self)
{
    return puts(new5(&String_class, "hello"));
}
Integer b23(A_Class * self)
{
    return puts(new5(&String_class, "static hello"));
}
Integer a24(B2 * self)
{
    return puts(new5(&String_class, "world"));
}
Integer b25(A_Class * self)
{
    puts(new5(&String_class, "static world"));
    return self->a = 5;
}
Integer b26(B_Class * self)
{
    puts(new5(&String_class, "static world"));
    return self->a = 5;
}
Float set_id27(B2 * self, Float n)
{
    return self->a.uFloat = n;
}
Float get_id28(B2 * self)
{
    return self->a.uFloat;
}
Integer set_id29(B2 * self, Integer n)
{
    return self->a.uInteger = n;
}
Integer get_id30(B2 * self)
{
    return self->a.uInteger;
}
String name31(B2 * self)
{
    return self->name;
}
Integer lambda34(Integer n)
{
    return puts(new5(&String_class, "Hello"));
}
Void times36(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda34(i);
        i = (i + 1);
    }
}
Integer lambda37(Integer n)
{
    return puts(new5(&String_class, "World"));
}
Void times38(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda37(i);
        i = (i + 1);
    }
}
Integer lambda41(Integer n)
{
    return printf(new5(&String_class, "count: %d\n"), n);
}
Void times42(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda41(i);
        i = (i + 1);
    }
}
Integer main(Void)
{
    Pointer b;
    b = new3(&B_class, 2);
    sizeof(B);
    b = new8(&B_class, new5(&String_class, "Xiao Peng"));
    sizeof(B1);
    b = new11(&B_class, new5(&String_class, "Xiao Peng"), 1);
    sizeof(B2);
    Pointer c;
    c = new14(&B_class, 2);
    if (__eq__17(c, b))
    {
        printf(new5(&String_class, "c[%d] == b[%d]\n"), id18(c), id15(b));
    }
    else
    {
        printf(new5(&String_class, "c[%d] != b[%d]\n"), id18(c), id15(b));
    }
    a22(b);
    b23(&A_class);
    a24(b);
    b25(&A_class);
    b26(&B_class);
    set_id27(b, 2.3);
    puts("Float");
    set_id29(b, 1);
    puts("Integer");
    puts(name31(b));
    puts("B");
    printf(new5(&String_class, "hello, goto %d\n"), get_id30(b));
    times36(5);
    times38(5);
    times42(5);
    return (5 & (1 << 2));
}
