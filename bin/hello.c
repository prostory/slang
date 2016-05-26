typedef void Void;
typedef int Integer;
typedef char * String;
extern Integer Integer$$__add__(Integer self, Integer n);
extern Integer Integer$$__mul__(Integer self, Integer n);
Integer Integer$$__add__(Integer self, Integer n)
{
    return (self + n);
}
Integer Integer$$__mul__(Integer self, Integer n)
{
    return (self * n);
}
Integer main(Void)
{
    
    return Integer$$__mul__(1, Integer$$__add__(2, 3));
}
