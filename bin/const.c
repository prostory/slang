typedef struct { char unused; } Any_Class;
typedef struct { char unused; } Kernel_Class;
typedef struct { char unused; } Object_Class;
typedef struct { char unused; } Class_Class;
typedef void Void;
typedef struct { char unused; } Void_Class;
typedef int Integer;
typedef struct { char unused; } Integer_Class;
typedef double Float;
typedef struct { char unused; } Float_Class;
typedef void * Nil;
typedef struct { char unused; } Nil_Class;
typedef char * String;
typedef struct { char unused; } String_Class;
typedef void * Pointer;
typedef struct { char unused; } Pointer_Class;
typedef enum { False = 0, True = 1, } Bool;
typedef struct { char unused; } Bool_Class;
typedef struct { char unused; } Array_Class;
typedef struct { char unused; } UnionType_Class;
typedef struct { char unused; } MainTop_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { char unused; } A_Class;
typedef struct { char unused; } C_Class;
static Object_Class Main_Object;
static Integer_Class Main_Integer;
static Float_Class Main_Float;
static Bool_Class Main_Bool;
static StringHelper_Class Main_StringHelper;
static String_Class Main_String;
static Array_Class Main_Array;
static Integer Main_B;
static A_Class Main_A;
static Integer Main_A_B;
static C_Class Main_A_C;
static Integer Main_A_C_D;
extern Integer printf(String, ...);
Integer main(Void)
{
    Integer result;
    Main_B = 2;
    Main_A_B = 3;
    printf("%d\n", Main_A_B);
    printf("%d\n", Main_B);
    Main_A_C_D = 4;
    printf("%d\n", Main_A_C_D);
    result = 0;
    return result;
}
