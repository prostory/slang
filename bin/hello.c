typedef void Void;
typedef int Integer;
typedef double Float;
typedef char * String;
typedef enum { False, True } Bool;
extern Float Integer$$__div__(Integer self, Float n);
extern Float Float$$__mul__(Float self, Float n);
extern Bool Float$$__gt__$Float_Float(Float self, Float n);
extern Bool Float$$__gt__$Float_Integer(Float self, Integer n);
extern Bool Bool$$or(Bool self, Bool n);
Float Integer$$__div__(Integer self, Float n)
{
    return (self / n);
}
Float Float$$__mul__(Float self, Float n)
{
    return (self * n);
}
Bool Float$$__gt__$Float_Float(Float self, Float n)
{
    return (self > n);
}
Bool Float$$__gt__$Float_Integer(Float self, Integer n)
{
    return (self > n);
}
Bool Bool$$or(Bool self, Bool n)
{
    return (self || n);
}
Integer main(Void)
{
    return Bool$$or(Float$$__gt__$Float_Float(1.5, Float$$__mul__(1.2, 1.8)), Float$$__gt__$Float_Integer(Integer$$__div__(5, 2.0), 2));
}
