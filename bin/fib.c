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
typedef struct { char unused; } Options_Class;
static Options_Class Options_class;
typedef struct { char unused; } Object_Class;
static Object_Class Object_class;
typedef struct { char unused; } StringHelper_Class;
static StringHelper_Class StringHelper_class;
extern Integer fib1(Integer n);
extern Integer printf(String, ...);
extern Void foo2(Void);
extern String strdup(String);
extern String new3(String_Class * self, String const_str);
extern Integer strlen(String);
extern String realloc(String, Integer);
extern String strcat(String, String);
extern String __lsh__4(String self, String s);
extern Integer puts(String);
extern String to_s5(Bool self);
Integer fib1(Integer n)
{
    if ((n < 2))
    {
        return n;
    }
    else
    {
        return (fib1((n - 2)) + fib1((n - 1)));
    }
}
Void foo2(Void)
{
    Integer i0;
    i0 = 0;
    while ((i0 < 10))
    {
        i0 = (i0 + 1);
    }
}
String new3(String_Class * self, String const_str)
{
    return strdup(const_str);
}
String __lsh__4(String self, String s)
{
    Integer len0;
    len0 = ((strlen(self) + strlen(s)) + 1);
    self = realloc(self, len0);
    return strcat(self, s);
}
String to_s5(Bool self)
{
    if (self)
    {
        return "true";
    }
    else
    {
        return "false";
    }
}
Integer main(Void)
{
    Integer i0;
    Float i1;
    String i2;
    Bool i3;
    printf("fib(6) = %d\n", fib1(6));
    foo2();
    i0 = 0;
    printf("i = %d\n", i0);
    i1 = (i0 + 1.0);
    i1 = (1 + i1);
    printf("i = %.2f\n", i1);
    i2 = new3(&String_class, "Hello ");
    i2 = __lsh__4(i2, "World");
    puts(i2);
    i3 = True;
    puts(to_s5(i3));
    i3 = False;
    puts(to_s5(i3));
    return 0;
}
