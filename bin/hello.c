typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef void * Pointer;
typedef enum { False, True } Bool;
typedef struct { Integer unused; } Object;
typedef struct { Integer unused; } Object_Class;
static Object_Class Object_class;
typedef struct { Integer unused; } String_Class;
static String_Class String_class;
typedef struct { Integer unused; } A;
typedef struct { Integer a; } A_Class;
static A_Class A_class;
typedef struct { String name; Integer id; Float a; } B;
typedef struct { Integer a; } B_Class;
static B_Class B_class;
extern Integer puts(String);
extern Integer strlen(String);
extern String strdup(String);
extern String realloc(String, Integer);
extern String strcat(String, String);
extern Integer printf(String, ...);
extern String String___lsh__(String self, String s);
extern B * B_Class___alloc__(B_Class * self, Integer size);
extern B * B_Class_new(B_Class * self, String var0, Integer var1);
extern String String_Class_new(String_Class * self, String const_str);
extern Integer B_a(B * self);
extern Integer B_a1(B * self);
extern Float B_set_id(B * self, Float n);
extern Float B_get_id(B * self);
extern Integer A_Class_b(A_Class * self);
extern Integer A_Class_b1(A_Class * self);
extern Integer B_Class_b1(B_Class * self);
extern Integer B___init__(B * self, String name, Integer id);
extern String B_name(B * self);
extern Pointer calloc(Integer, Integer);
String String___lsh__(String self, String s)
{
    Float len = ((strlen(self) + strlen(s)) + 1);
    self = realloc(self, len);
    return strcat(self, s);
}
B * B_Class___alloc__(B_Class * self, Integer size)
{
    return (B *)calloc(size, 1);
}
B * B_Class_new(B_Class * self, String var0, Integer var1)
{
    Pointer obj = B_Class___alloc__(self, sizeof(B));
    B___init__(obj, var0, var1);
    return obj;
}
String String_Class_new(String_Class * self, String const_str)
{
    return strdup(const_str);
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
Integer B___init__(B * self, String name, Integer id)
{
    self->name = name;
    return self->id = id;
}
String B_name(B * self)
{
    return self->name;
}
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
    return (5 & (1 << 2));
}
