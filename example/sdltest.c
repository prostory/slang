typedef void Void;
typedef int Integer;
typedef double Float;
typedef void * Nil;
typedef char * String;
typedef void * Pointer;
typedef enum { False = 0, True = 1, } Bool;
typedef struct { char unused; } Class_Class;
typedef struct { char unused; } Object_Class;
typedef struct { char unused; } Integer_Class;
typedef struct { char unused; } Float_Class;
typedef struct { char unused; } Bool_Class;
typedef struct { char unused; } StringHelper_Class;
typedef struct { char unused; } String_Class;
typedef struct { char unused; } Array_Class;
typedef struct { char unused; } Pointer_Class;
typedef struct { char unused; } Rect_Class;
typedef struct { char unused; } Event_Class;
typedef struct { char unused; } Game_Class;
typedef struct { Integer x; Integer y; Integer w; Integer h; } Rect;
typedef struct { Integer type; } Event;
typedef struct { Integer width; Integer height; Bool quit; Pointer window; Pointer renderer; Rect * fill_rect; Rect * outline_rect; } Game;
static Object_Class * Main_Object;
static Class_Class * Main_Class;
static Integer_Class * Main_Integer;
static Float_Class * Main_Float;
static Bool_Class * Main_Bool;
static StringHelper_Class * Main_StringHelper;
static String_Class * Main_String;
static Array_Class * Main_Array;
static Pointer_Class * Main_Pointer;
static Rect_Class * Main_Rect;
static Event_Class * Main_Event;
static Game_Class * Main_Game;
extern Pointer calloc(Integer, Integer);
extern Class_Class * __alloc__1(Class_Class * self);
extern Void __init__2(Class_Class * self);
extern Class_Class * new3(Class_Class * self);
extern Object_Class * __alloc__4(Class_Class * self);
extern Void __init__5(Object_Class * self);
extern Object_Class * new6(Class_Class * self);
extern Integer_Class * __alloc__7(Class_Class * self);
extern Void __init__8(Integer_Class * self);
extern Integer_Class * new9(Class_Class * self);
extern Float_Class * __alloc__10(Class_Class * self);
extern Void __init__11(Float_Class * self);
extern Float_Class * new12(Class_Class * self);
extern Bool_Class * __alloc__13(Class_Class * self);
extern Void __init__14(Bool_Class * self);
extern Bool_Class * new15(Class_Class * self);
extern StringHelper_Class * __alloc__16(Class_Class * self);
extern Void __init__17(StringHelper_Class * self);
extern StringHelper_Class * new18(Class_Class * self);
extern String_Class * __alloc__19(Class_Class * self);
extern Void __init__20(String_Class * self);
extern String_Class * new21(Class_Class * self);
extern Array_Class * __alloc__22(Class_Class * self);
extern Void __init__23(Array_Class * self);
extern Array_Class * new24(Class_Class * self);
extern Pointer_Class * __alloc__25(Class_Class * self);
extern Void __init__26(Pointer_Class * self);
extern Pointer_Class * new27(Class_Class * self);
extern Rect_Class * __alloc__28(Class_Class * self);
extern Void __init__29(Rect_Class * self);
extern Rect_Class * new30(Class_Class * self);
extern Event_Class * __alloc__31(Class_Class * self);
extern Void __init__32(Event_Class * self);
extern Event_Class * new33(Class_Class * self);
extern Game_Class * __alloc__34(Class_Class * self);
extern Void __init__35(Game_Class * self);
extern Game_Class * new36(Class_Class * self);
extern Game * __alloc__37(Game_Class * self);
extern Bool __init__38(Game * self, Integer width, Integer height);
extern Game * new39(Game_Class * self, Integer var0, Integer var1);
extern Integer SDL_Init(Integer);
extern String SDL_GetError(Void);
extern Integer printf(String, ...);
extern Void exit(Integer);
extern Pointer SDL_CreateWindow(String, Integer, Integer, Integer, Integer, Integer);
extern Bool nil__mark__40(Pointer self);
extern Pointer SDL_CreateRenderer(Pointer, Integer, Integer);
extern Integer SDL_SetRenderDrawColor(Pointer, Integer, Integer, Integer, Integer);
extern Rect * __alloc__41(Rect_Class * self);
extern Integer __init__42(Rect * self, Integer x, Integer y, Integer w, Integer h);
extern Rect * new43(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3);
extern Rect * init44(Game * self);
extern Event * __alloc__45(Event_Class * self);
extern Integer __init__46(Event * self);
extern Event * new47(Event_Class * self);
extern Integer SDL_PollEvent(Event *);
extern Integer type48(Event * self);
extern Integer SDL_RenderClear(Pointer);
extern Integer SDL_RenderFillRect(Pointer, Rect *);
extern Integer SDL_RenderDrawRect(Pointer, Rect *);
extern Integer SDL_RenderDrawLine(Pointer, Integer, Integer, Integer, Integer);
extern Integer SDL_RenderDrawPoint(Pointer, Integer, Integer);
extern Void SDL_RenderPresent(Pointer);
extern Void SDL_Delay(Integer);
extern Nil render49(Game * self);
extern Void SDL_DestroyRenderer(Pointer);
extern Void SDL_DestroyWindow(Pointer);
extern Void SDL_Quit(Void);
extern Nil quit50(Game * self);
extern Nil start51(Game * self);
Class_Class * __alloc__1(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Class_Class), 1);
    return result;
}
Void __init__2(Class_Class * self)
{
    Nil result;
}
Class_Class * new3(Class_Class * self)
{
    Class_Class * result;
    Class_Class * obj;
    obj = __alloc__1(self);
    __init__2(obj);
    result = obj;
    return result;
}
Object_Class * __alloc__4(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Object_Class), 1);
    return result;
}
Void __init__5(Object_Class * self)
{
    Nil result;
}
Object_Class * new6(Class_Class * self)
{
    Object_Class * result;
    Object_Class * obj;
    obj = __alloc__4(self);
    __init__5(obj);
    result = obj;
    return result;
}
Integer_Class * __alloc__7(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Integer_Class), 1);
    return result;
}
Void __init__8(Integer_Class * self)
{
    Nil result;
}
Integer_Class * new9(Class_Class * self)
{
    Integer_Class * result;
    Integer_Class * obj;
    obj = __alloc__7(self);
    __init__8(obj);
    result = obj;
    return result;
}
Float_Class * __alloc__10(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Float_Class), 1);
    return result;
}
Void __init__11(Float_Class * self)
{
    Nil result;
}
Float_Class * new12(Class_Class * self)
{
    Float_Class * result;
    Float_Class * obj;
    obj = __alloc__10(self);
    __init__11(obj);
    result = obj;
    return result;
}
Bool_Class * __alloc__13(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Bool_Class), 1);
    return result;
}
Void __init__14(Bool_Class * self)
{
    Nil result;
}
Bool_Class * new15(Class_Class * self)
{
    Bool_Class * result;
    Bool_Class * obj;
    obj = __alloc__13(self);
    __init__14(obj);
    result = obj;
    return result;
}
StringHelper_Class * __alloc__16(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(StringHelper_Class), 1);
    return result;
}
Void __init__17(StringHelper_Class * self)
{
    Nil result;
}
StringHelper_Class * new18(Class_Class * self)
{
    StringHelper_Class * result;
    StringHelper_Class * obj;
    obj = __alloc__16(self);
    __init__17(obj);
    result = obj;
    return result;
}
String_Class * __alloc__19(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(String_Class), 1);
    return result;
}
Void __init__20(String_Class * self)
{
    Nil result;
}
String_Class * new21(Class_Class * self)
{
    String_Class * result;
    String_Class * obj;
    obj = __alloc__19(self);
    __init__20(obj);
    result = obj;
    return result;
}
Array_Class * __alloc__22(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Array_Class), 1);
    return result;
}
Void __init__23(Array_Class * self)
{
    Nil result;
}
Array_Class * new24(Class_Class * self)
{
    Array_Class * result;
    Array_Class * obj;
    obj = __alloc__22(self);
    __init__23(obj);
    result = obj;
    return result;
}
Pointer_Class * __alloc__25(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Pointer_Class), 1);
    return result;
}
Void __init__26(Pointer_Class * self)
{
    Nil result;
}
Pointer_Class * new27(Class_Class * self)
{
    Pointer_Class * result;
    Pointer_Class * obj;
    obj = __alloc__25(self);
    __init__26(obj);
    result = obj;
    return result;
}
Rect_Class * __alloc__28(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Rect_Class), 1);
    return result;
}
Void __init__29(Rect_Class * self)
{
    Nil result;
}
Rect_Class * new30(Class_Class * self)
{
    Rect_Class * result;
    Rect_Class * obj;
    obj = __alloc__28(self);
    __init__29(obj);
    result = obj;
    return result;
}
Event_Class * __alloc__31(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Event_Class), 1);
    return result;
}
Void __init__32(Event_Class * self)
{
    Nil result;
}
Event_Class * new33(Class_Class * self)
{
    Event_Class * result;
    Event_Class * obj;
    obj = __alloc__31(self);
    __init__32(obj);
    result = obj;
    return result;
}
Game_Class * __alloc__34(Class_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Game_Class), 1);
    return result;
}
Void __init__35(Game_Class * self)
{
    Nil result;
}
Game_Class * new36(Class_Class * self)
{
    Game_Class * result;
    Game_Class * obj;
    obj = __alloc__34(self);
    __init__35(obj);
    result = obj;
    return result;
}
Game * __alloc__37(Game_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Game), 1);
    return result;
}
Bool __init__38(Game * self, Integer width, Integer height)
{
    Bool result;
    self->width = width;
    self->height = height;
    self->quit = False;
    result = self->quit;
    return result;
}
Game * new39(Game_Class * self, Integer var0, Integer var1)
{
    Game * result;
    Game * obj;
    obj = __alloc__37(self);
    __init__38(obj, var0, var1);
    result = obj;
    return result;
}
Bool nil__mark__40(Pointer self)
{
    Bool result;
    result = (self == 0);
    return result;
}
Rect * __alloc__41(Rect_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Rect), 1);
    return result;
}
Integer __init__42(Rect * self, Integer x, Integer y, Integer w, Integer h)
{
    Integer result;
    self->x = x;
    self->y = y;
    self->w = w;
    self->h = h;
    result = self->h;
    return result;
}
Rect * new43(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3)
{
    Rect * result;
    Rect * obj;
    obj = __alloc__41(self);
    __init__42(obj, var0, var1, var2, var3);
    result = obj;
    return result;
}
Rect * init44(Game * self)
{
    Rect * result;
    if ((SDL_Init(32) < 0))
    {
        printf("SDL_Init failed: %s\n", SDL_GetError());
        exit(1);
    }
    self->window = SDL_CreateWindow("slang test", 0, 0, self->width, self->height, 4);
    if (nil__mark__40(self->window))
    {
        printf("SDL_CreateWindow failed: %s\n", SDL_GetError());
        exit(1);
    }
    self->renderer = SDL_CreateRenderer(self->window, -(1), 2);
    if (nil__mark__40(self->renderer))
    {
        printf("SDL_CreateRenderer failed: %s\n", SDL_GetError());
        exit(1);
    }
    SDL_SetRenderDrawColor(self->renderer, 255, 255, 255, 255);
    self->fill_rect = new43(Main_Rect, (self->width / 4), (self->height / 4), (self->width / 2), (self->height / 2));
    self->outline_rect = new43(Main_Rect, (self->width / 6), (self->height / 6), ((self->width * 2) / 3), ((self->height * 2) / 3));
    result = self->outline_rect;
    return result;
}
Event * __alloc__45(Event_Class * self)
{
    Pointer result;
    result = calloc(60, 1);
    return result;
}
Integer __init__46(Event * self)
{
    Integer result;
    self->type = 0;
    result = self->type;
    return result;
}
Event * new47(Event_Class * self)
{
    Event * result;
    Event * obj;
    obj = __alloc__45(self);
    __init__46(obj);
    result = obj;
    return result;
}
Integer type48(Event * self)
{
    Integer result;
    result = self->type;
    return result;
}
Nil render49(Game * self)
{
    Nil result;
    Integer i;
    SDL_SetRenderDrawColor(self->renderer, 255, 255, 255, 255);
    SDL_RenderClear(self->renderer);
    SDL_SetRenderDrawColor(self->renderer, 255, 0, 0, 255);
    SDL_RenderFillRect(self->renderer, self->fill_rect);
    SDL_SetRenderDrawColor(self->renderer, 0, 255, 0, 255);
    SDL_RenderDrawRect(self->renderer, self->outline_rect);
    SDL_SetRenderDrawColor(self->renderer, 0, 0, 255, 255);
    SDL_RenderDrawLine(self->renderer, 0, (self->height / 2), self->width, (self->height / 2));
    SDL_SetRenderDrawColor(self->renderer, 255, 255, 0, 255);
    i = 0;
    while ((i < self->height))
    {
        SDL_RenderDrawPoint(self->renderer, (self->width / 2), i);
        (i += 4);
    }
    SDL_RenderPresent(self->renderer);
    SDL_Delay(1);
    return result;
}
Nil quit50(Game * self)
{
    Nil result;
    if (!(nil__mark__40(self->renderer)))
    {
        SDL_DestroyRenderer(self->renderer);
    }
    if (!(nil__mark__40(self->window)))
    {
        SDL_DestroyWindow(self->window);
    }
    SDL_Quit();
    return result;
}
Nil start51(Game * self)
{
    Nil result;
    Event * e;
    init44(self);
    e = new47(Main_Event);
    while (!(self->quit))
    {
        while ((SDL_PollEvent(e) != 0))
        {
            if ((type48(e) == 256))
            {
                self->quit = True;
            }
        }
        render49(self);
    }
    result = quit50(self);
    return result;
}
Integer main(Void)
{
    Integer result;
    Main_Class = new3(Main_Class);
    Main_Object = new6(Main_Class);
    Main_Integer = new9(Main_Class);
    Main_Float = new12(Main_Class);
    Main_Bool = new15(Main_Class);
    Main_StringHelper = new18(Main_Class);
    Main_String = new21(Main_Class);
    Main_Array = new24(Main_Class);
    Main_Pointer = new27(Main_Class);
    Main_Rect = new30(Main_Class);
    Main_Event = new33(Main_Class);
    Main_Game = new36(Main_Class);
    start51(new39(Main_Game, 800, 600));
    result = 0;
    return result;
}
