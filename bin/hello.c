typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef void * Pointer;
typedef enum { False, True } Bool;
typedef struct { Integer unused; } Object;
typedef struct { Integer unused; } Object_Class;
static Object_Class Object_class;
typedef struct { Integer unused; } A;
typedef struct { Integer a; } A_Class;
static A_Class A_class;
typedef struct { String name; Integer id; Float a; } B;
typedef struct { Integer a; } B_Class;
static B_Class B_class;
extern Integer puts(String);
extern Integer printf(String, ...);
extern B * B_Class___alloc__(B_Class * self);
extern B * B_Class_new(B_Class * self, String var0, Integer var1);
extern Integer B_a(B * self);
extern Integer B_a1(B * self);
extern Float B_set_id(B * self, Float n);
extern Float B_get_id(B * self);
extern Integer A_Class_b(A_Class * self);
extern Integer A_Class_b1(A_Class * self);
extern Integer B_Class_b1(B_Class * self);
extern Integer B___init__1(B * self, String name, Integer id);
extern String B_name(B * self);
extern Pointer calloc(Integer, Integer);
B * B_Class___alloc__(B_Class * self)
{
    return (B *)calloc(sizeof(B), 1);
}
B * B_Class_new(B_Class * self, String var0, Integer var1)
{
    Pointer obj = B_Class___alloc__(self);
    B___init__1(obj, var0, var1);
    return obj;
}
Integer B_a(B * self)
{
    return puts("hello");
}
Integer B_a1(B * self)
{
    return puts("world");
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
    return puts("static hello");
}
Integer A_Class_b1(A_Class * self)
{
    puts("static world");
    return self->a = 5;
}
Integer B_Class_b1(B_Class * self)
{
    puts("static world");
    return self->a = 5;
}
Integer B___init__1(B * self, String name, Integer id)
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
    Pointer b = B_Class_new(&B_class, "Xiao Peng", 1);
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
    printf("hello, goto %f\n", B_get_id(b));
    return (5 & (1 << 2));
}

