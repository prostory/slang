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
typedef struct { char unused; } Bool_Class;
static Bool_Class Bool_class;
typedef union { Float uFloat; Integer uInteger; } UnionType;
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
typedef struct { Integer a; } B_Class;
static B_Class B_class;
typedef struct { char unused; } Lambda;
typedef struct { char unused; } Lambda1;
typedef struct { char unused; } Lambda2;
typedef struct { char unused; } Lambda_Class;
static Lambda_Class Lambda_class;
extern Pointer calloc(Integer, Integer);
extern B * __alloc__1(B_Class * self, Integer size);
extern Integer __init__2(B * self, Integer id);
extern B * new3(B_Class * self, Integer var0);
extern String strdup(String);
extern String new5(String_Class * self, String const_str);
extern B1 * __alloc__6(B_Class * self, Integer size);
extern String __init__7(B1 * self, String name);
extern B1 * new8(B_Class * self, String var0);
extern B2 * __alloc__9(B_Class * self, Integer size);
extern Integer __init__10(B2 * self, String name, Integer id);
extern B2 * new11(B_Class * self, String var0, Integer var1);
extern Integer puts(String);
extern Integer a13(B2 * self);
extern Integer b14(A_Class * self);
extern Integer a15(B2 * self);
extern Integer b16(A_Class * self);
extern Integer b17(B_Class * self);
extern Float set_id18(B2 * self, Float n);
extern Float get_id19(B2 * self);
extern Integer set_id20(B2 * self, Integer n);
extern Integer get_id21(B2 * self);
extern String name22(B2 * self);
extern Integer printf(String, ...);
extern Integer lambda25(Integer n);
extern Void times27(Integer self);
extern Integer lambda28(Integer n);
extern Void times29(Integer self);
extern Integer lambda30(Integer n);
extern Void times31(Integer self);
B * __alloc__1(B_Class * self, Integer size)
{
    return calloc(size, 1);
}
Integer __init__2(B * self, Integer id)
{
    return self->id = id;
}
B * new3(B_Class * self, Integer var0)
{
    Pointer obj;
    obj = __alloc__1(self, sizeof(B));
    __init__2(obj, var0);
    return obj;
}
String new5(String_Class * self, String const_str)
{
    return strdup(const_str);
}
B1 * __alloc__6(B_Class * self, Integer size)
{
    return calloc(size, 1);
}
String __init__7(B1 * self, String name)
{
    return self->name = name;
}
B1 * new8(B_Class * self, String var0)
{
    Pointer obj;
    obj = __alloc__6(self, sizeof(B));
    __init__7(obj, var0);
    return obj;
}
B2 * __alloc__9(B_Class * self, Integer size)
{
    return calloc(size, 1);
}
Integer __init__10(B2 * self, String name, Integer id)
{
    self->name = name;
    return self->id = id;
}
B2 * new11(B_Class * self, String var0, Integer var1)
{
    Pointer obj;
    obj = __alloc__9(self, sizeof(B));
    __init__10(obj, var0, var1);
    return obj;
}
Integer a13(B2 * self)
{
    return puts(new5(&String_class, "hello"));
}
Integer b14(A_Class * self)
{
    return puts(new5(&String_class, "static hello"));
}
Integer a15(B2 * self)
{
    return puts(new5(&String_class, "world"));
}
Integer b16(A_Class * self)
{
    puts(new5(&String_class, "static world"));
    return self->a = 5;
}
Integer b17(B_Class * self)
{
    puts(new5(&String_class, "static world"));
    return self->a = 5;
}
Float set_id18(B2 * self, Float n)
{
    return self->a.uFloat = n;
}
Float get_id19(B2 * self)
{
    return self->a.uFloat;
}
Integer set_id20(B2 * self, Integer n)
{
    return self->a.uInteger = n;
}
Integer get_id21(B2 * self)
{
    return self->a.uInteger;
}
String name22(B2 * self)
{
    return self->name;
}
Integer lambda25(Integer n)
{
    return puts(new5(&String_class, "Hello"));
}
Void times27(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda25(i);
        i = (i + 1);
    }
}
Integer lambda28(Integer n)
{
    return puts(new5(&String_class, "World"));
}
Void times29(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda28(i);
        i = (i + 1);
    }
}
Integer lambda30(Integer n)
{
    return printf(new5(&String_class, "count: %d\n"), n);
}
Void times31(Integer self)
{
    Integer i;
    i = 1;
    while ((i <= self))
    {
        lambda30(i);
        i = (i + 1);
    }
}
Integer main(Void)
{
    Pointer b;
    b = new3(&B_class, 2);
    b = new8(&B_class, new5(&String_class, "Xiao Peng"));
    b = new11(&B_class, new5(&String_class, "Xiao Peng"), 1);
    a13(b);
    b14(&A_class);
    a15(b);
    b16(&A_class);
    b17(&B_class);
    set_id18(b, 2.3);
    puts("Float");
    set_id20(b, 1);
    puts("Integer");
    puts(name22(b));
    puts("B");
    printf(new5(&String_class, "hello, goto %d\n"), get_id21(b));
    times27(5);
    times29(5);
    times31(5);
    return (5 & (1 << 2));
}
