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
    Integer i;
    i = 0;
    while ((i < 10))
    {
        i = (i + 1);
    }
}
Integer main(Void)
{
    printf("fib(6) = %d\n", fib1(6));
    foo2();
}
