typedef struct { char unused; } Any_Class;
static Any_Class Any_class;
typedef struct { char unused; } Kernel_Class;
static Kernel_Class Kernel_class;
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
typedef void Void;
typedef struct { char unused; } Void_Class;
static Void_Class Void_class;
typedef struct { char unused; } UnionType_Class;
static UnionType_Class UnionType_class;
typedef struct { char unused; } Object_Class;
static Object_Class Object_class;
typedef struct { char unused; } StringHelper_Class;
static StringHelper_Class StringHelper_class;
typedef struct { Integer a; } A_Class;
static A_Class A_class;
typedef struct { String name; Integer id; Float a; } B;
typedef struct { Integer a; } B_Class;
static B_Class B_class;
typedef struct { char unused; } Lambda;
typedef struct { char unused; } Lambda1;
typedef struct { char unused; } Lambda2;
typedef struct { char unused; } Lambda_Class;
static Lambda_Class Lambda_class;
extern Pointer calloc(Integer, Integer);
extern Void Integer_times_Lambda(Integer self);
extern Void Integer_times_Lambda1(Integer self);
extern Void Integer_times_Lambda2(Integer self);
extern String String___lsh__(String self, String s);
extern String String_Class_new(String_Class * self, String const_str);
extern Integer B___init__(B * self, String name, Integer id);
extern B * B_Class___alloc__(B_Class * self, Integer size);
extern B * B_Class_new(B_Class * self, String var0, Integer var1);
extern Integer puts(String);
extern Integer strlen(String);
extern String strdup(String);
extern String realloc(String, Integer);
extern String strcat(String, String);
extern Integer printf(String, ...);
extern Integer B_a(B * self);
extern Integer B_a1(B * self);
extern Float B_set_id(B * self, Float n);
extern Float B_get_id(B * self);
extern Integer A_Class_b(A_Class * self);
extern Integer A_Class_b1(A_Class * self);
extern Integer B_Class_b1(B_Class * self);
extern String B_name(B * self);
extern Integer lambda0(Integer n);
extern Integer lambda1(Integer n);
extern Integer lambda2(Integer n);
Integer main(Void)
{
    Pointer b = B_Class_new(&B_class, String___lsh__(String_Class_new(&String_class, "Xiao"), String_Class_new(&String_class, " Peng")), 1);
    B_a(b);
    A_Class_b(&A_class);
    B_a1(b);
    A_Class_b1(&A_class);
    B_Class_b1(&B_class);
    B_set_id(b, 2.3);
    B_get_id(b);
    puts(B_name(b));
    puts("B");
    puts("Float");
    printf(String_Class_new(&String_class, "hello, goto %f\n"), B_get_id(b));
    Integer_times_Lambda(5);
    Integer_times_Lambda1(5);
    Integer_times_Lambda2(5);
    return (5 & (1 << 2));
}
Void Integer_times_Lambda(Integer self)
{
    Integer i = 1;
    while ((i <= self))
    {
        lambda0(i);
        i = (i + 1);
    }
}
Void Integer_times_Lambda1(Integer self)
{
    Integer i = 1;
    while ((i <= self))
    {
        lambda1(i);
        i = (i + 1);
    }
}
Void Integer_times_Lambda2(Integer self)
{
    Integer i = 1;
    while ((i <= self))
    {
        lambda2(i);
        i = (i + 1);
    }
}
String String___lsh__(String self, String s)
{
    Integer len = ((strlen(self) + strlen(s)) + 1);
    self = realloc(self, len);
    return strcat(self, s);
}
String String_Class_new(String_Class * self, String const_str)
{
    return strdup(const_str);
}
Integer B___init__(B * self, String name, Integer id)
{
    self->name = name;
    return self->id = id;
}
B * B_Class___alloc__(B_Class * self, Integer size)
{
    return calloc(size, 1);
}
B * B_Class_new(B_Class * self, String var0, Integer var1)
{
    Pointer obj = B_Class___alloc__(self, sizeof(B));
    B___init__(obj, var0, var1);
    return obj;
}
Integer B_a(B * self)
{
    return puts(String_Class_new(&String_class, "hello"));
}
Integer B_a1(B * self)
{
    return puts(String_Class_new(&String_class, "world"));
}
Float B_set_id(B * self, Float n)
{
    return self->a = n;
}
Float B_get_id(B * self)
{
    return self->a;
}
Integer A_Class_b(A_Class * self)
{
    return puts(String_Class_new(&String_class, "static hello"));
}
Integer A_Class_b1(A_Class * self)
{
    puts(String_Class_new(&String_class, "static world"));
    return self->a = 5;
}
Integer B_Class_b1(B_Class * self)
{
    puts(String_Class_new(&String_class, "static world"));
    return self->a = 5;
}
String B_name(B * self)
{
    return self->name;
}
Integer lambda0(Integer n)
{
    return puts(String_Class_new(&String_class, "Hello"));
}
Integer lambda1(Integer n)
{
    return puts(String_Class_new(&String_class, "World"));
}
Integer lambda2(Integer n)
{
    return printf(String_Class_new(&String_class, "count: %d\n"), n);
}
