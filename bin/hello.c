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
typedef struct { String name; } B;
typedef struct { String name; Integer id; UnionType a; } B1;
typedef struct { char unused; } B_Class;
static B_Class B_class;
typedef struct { char unused; } Lambda;
typedef struct { char unused; } Lambda1;
typedef struct { char unused; } Lambda2;
typedef struct { char unused; } Lambda_Class;
static Lambda_Class Lambda_class;
extern Void Integer_times_Lambda(Integer self);
extern Void Integer_times_Lambda1(Integer self);
extern Void Integer_times_Lambda2(Integer self);
extern Integer puts(String);
extern String strdup(String);
extern Integer printf(String, ...);
extern String String_Class_new(String_Class * self, String const_str);
extern Pointer calloc(Integer, Integer);
extern Pointer Pointer_Class_new(Pointer_Class * self, Integer size, Integer nitems);
extern Integer A_Class_b(A_Class * self);
extern Integer A_Class_b1(A_Class * self);
extern String B___init___String(B * self, String name);
extern Integer B1___init___String_Integer(B1 * self, String name, Integer id);
extern Integer B1_a(B1 * self);
extern Float B1_set_id_Float(B1 * self, Float n);
extern Integer B1_set_id_Integer(B1 * self, Integer n);
extern Float B1_get_id__Float(B1 * self);
extern Integer B1_get_id__Integer(B1 * self);
extern String B1_name(B1 * self);
extern Pointer calloc(Integer, Integer);
extern B * B_Class___alloc___Integer_B(B_Class * self, Integer size);
extern B1 * B_Class___alloc___Integer_B1(B_Class * self, Integer size);
extern B * B_Class_new_String(B_Class * self, String var0);
extern B1 * B_Class_new_String_Integer(B_Class * self, String var0, Integer var1);
extern Integer B_Class_b(B_Class * self);
extern Integer lambda0(Integer n);
extern Integer lambda1(Integer n);
extern Integer lambda2(Integer n);
Integer main(Void)
{
    Pointer b = B_Class_new_String(&B_class, String_Class_new(&String_class, "Xiao Peng"));
    b = B_Class_new_String_Integer(&B_class, String_Class_new(&String_class, "Xiao Peng"), 1);
    B1_a(b);
    A_Class_b(&A_class);
    B1_a(b);
    A_Class_b1(&A_class);
    B_Class_b(&B_class);
    B1_set_id_Float(b, 2.3);
    puts("Float");
    B1_set_id_Integer(b, 1);
    puts("Integer");
    puts(B1_name(b));
    puts("B");
    printf(String_Class_new(&String_class, "hello, goto %d\n"), B1_get_id__Integer(b));
    Integer_times_Lambda(5);
    Integer_times_Lambda1(5);
    Integer_times_Lambda2(5);
    Integer a[4] = { 1, 2, 3, 4 };
    Pointer p = Pointer_Class_new(&Pointer_class, sizeof(Integer), 4);
    (p []= 0 []= 5);
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
String String_Class_new(String_Class * self, String const_str)
{
    return strdup(const_str);
}
Pointer Pointer_Class_new(Pointer_Class * self, Integer size, Integer nitems)
{
    return calloc(size, nitems);
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
String B___init___String(B * self, String name)
{
    return self->name = name;
}
Integer B1___init___String_Integer(B1 * self, String name, Integer id)
{
    self->name = name;
    return self->id = id;
}
Integer B1_a(B1 * self)
{
    return puts(String_Class_new(&String_class, "hello"));
}
Float B1_set_id_Float(B1 * self, Float n)
{
    return self->a.uFloat = n;
}
Integer B1_set_id_Integer(B1 * self, Integer n)
{
    return self->a.uInteger = n;
}
Float B1_get_id__Float(B1 * self)
{
    return self->a.uFloat;
}
Integer B1_get_id__Integer(B1 * self)
{
    return self->a.uInteger;
}
String B1_name(B1 * self)
{
    return self->name;
}
B * B_Class___alloc___Integer_B(B_Class * self, Integer size)
{
    return calloc(size, 1);
}
B1 * B_Class___alloc___Integer_B1(B_Class * self, Integer size)
{
    return calloc(size, 1);
}
B * B_Class_new_String(B_Class * self, String var0)
{
    Pointer obj = B_Class___alloc___Integer_B(self, sizeof(B));
    B___init___String(obj, var0);
    return obj;
}
B1 * B_Class_new_String_Integer(B_Class * self, String var0, Integer var1)
{
    Pointer obj = B_Class___alloc___Integer_B1(self, sizeof(B));
    B1___init___String_Integer(obj, var0, var1);
    return obj;
}
Integer B_Class_b(B_Class * self)
{
    return puts(String_Class_new(&String_class, "static hello"));
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
