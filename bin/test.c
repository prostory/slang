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
typedef union { String uString; Float uFloat; } UnionType;
typedef struct { char unused; } UnionType_Class;
static UnionType_Class UnionType_class;
typedef struct { char unused; } Object;
typedef struct { char unused; } Object_Class;
static Object_Class Object_class;
typedef struct { char unused; } StringHelper_Class;
static StringHelper_Class StringHelper_class;
typedef struct { Integer type; UnionType value; } Options;
typedef struct { char unused; } Options_Class;
static Options_Class Options_class;
typedef struct { char unused; } A_Class;
static A_Class A_class;
typedef struct { Integer a; } B_Class;
static B_Class B_class;
extern Pointer calloc(Integer, Integer);
extern Options * __alloc__1(Options_Class * self);
extern Void __init__2(Options * self);
extern Options * new3(Options_Class * self);
extern Object * __alloc__4(Object_Class * self);
extern Void __init__5(Object * self);
extern Object * new6(Object_Class * self);
extern Integer puts(String);
extern String_Class * class7(String self);
extern Integer type_id8(String_Class * self);
extern Options * option9(Options * self, String value);
extern Float_Class * class10(Float self);
extern Integer type_id11(Float_Class * self);
extern Options * option12(Options * self, Float value);
extern Options * foo13(Integer n);
extern Integer type14(Options * self);
extern String string15(Options * self);
extern Float float16(Options * self);
extern Integer printf(String, ...);
extern Integer dump17(Options * self);
extern Integer a18(B_Class * self);
extern Integer b19(Void);
extern Integer a20(B_Class * self);
Options * __alloc__1(Options_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Options), 1);
    return result;
}
Void __init__2(Options * self)
{
    Nil result;
}
Options * new3(Options_Class * self)
{
    Options * result;
    Options * obj;
    obj = __alloc__1(self);
    __init__2(obj);
    result = obj;
    return result;
}
Object * __alloc__4(Object_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Object), 1);
    return result;
}
Void __init__5(Object * self)
{
    Nil result;
}
Object * new6(Object_Class * self)
{
    Object * result;
    Object * obj;
    obj = __alloc__4(self);
    __init__5(obj);
    result = obj;
    return result;
}
String_Class * class7(String self)
{
    String_Class * result;
    result = &String_class;
    return result;
}
Integer type_id8(String_Class * self)
{
    Integer result;
    result = 6;
    return result;
}
Options * option9(Options * self, String value)
{
    Options * result;
    self->type = type_id8(class7(value));
    self->value.uString = value;
    result = self;
    return result;
}
Float_Class * class10(Float self)
{
    Float_Class * result;
    result = &Float_class;
    return result;
}
Integer type_id11(Float_Class * self)
{
    Integer result;
    result = 4;
    return result;
}
Options * option12(Options * self, Float value)
{
    Options * result;
    self->type = type_id11(class10(value));
    self->value.uFloat = value;
    result = self;
    return result;
}
Options * foo13(Integer n)
{
    Options * result;
    String a;
    Options * a1;
    Object * b;
    Object * c;
    Bool d;
    a = 0;
    a = "Hello World";
    a1 = new3(&Options_class);
    b = new6(&Object_class);
    c = new6(&Object_class);
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
        result = option9(a1, "hello");
    }
    else
    {
        result = option12(a1, 1.5);
    }
    return result;
}
Integer type14(Options * self)
{
    Integer result;
    result = self->type;
    return result;
}
String string15(Options * self)
{
    String result;
    result = self->value.uString;
    return result;
}
Float float16(Options * self)
{
    Float result;
    result = self->value.uFloat;
    return result;
}
Integer dump17(Options * self)
{
    Integer result;
    if ((type14(self) == type_id8(&String_class)))
    {
        result = puts(string15(self));
    }
    else
    {
        if ((type14(self) == type_id11(&Float_class)))
        {
            result = printf("%f\n", float16(self));
        }
    }
    return result;
}
Integer a18(B_Class * self)
{
    Integer result;
    self->a = 1;
    result = puts("a");
    return result;
}
Integer b19(Void)
{
    Integer result;
    result = puts("b");
    return result;
}
Integer a20(B_Class * self)
{
    Integer result;
    result = self->a;
    return result;
}
Integer main(Void)
{
    Integer result;
    Options * a;
    Options * a1;
    a = foo13(5);
    dump17(a);
    a1 = foo13(-(1));
    dump17(a1);
    a18(&B_class);
    b19();
    printf("%d\n", a20(&B_class));
    result = 0;
    return result;
}
