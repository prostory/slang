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
typedef void * Nil;
typedef struct { char unused; } Nil_Class;
static Nil_Class Nil_class;
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
typedef struct { Integer x; Integer y; Integer w; Integer h; } Rect;
typedef struct { char unused; } Rect_Class;
static Rect_Class Rect_class;
typedef struct { Integer type; } Event;
typedef struct { char unused; } Event_Class;
static Event_Class Event_class;
typedef struct { Integer width; Integer height; Bool quit; Pointer window; Pointer renderer; Rect * fill_rect; Rect * outline_rect; } Game;
typedef struct { char unused; } Game_Class;
static Game_Class Game_class;
extern Pointer calloc(Integer, Integer);
extern Game * __alloc__1(Game_Class * self);
extern Bool __init__2(Game * self, Integer width, Integer height);
extern Game * new3(Game_Class * self, Integer var0, Integer var1);
extern Integer SDL_Init(Integer);
extern String SDL_GetError(Void);
extern Integer printf(String, ...);
extern Void exit(Integer);
extern Pointer SDL_CreateWindow(String, Integer, Integer, Integer, Integer, Integer);
extern Bool nil__mark__4(Pointer self);
extern Pointer SDL_CreateRenderer(Pointer, Integer, Integer);
extern Integer SDL_SetRenderDrawColor(Pointer, Integer, Integer, Integer, Integer);
extern Rect * __alloc__5(Rect_Class * self);
extern Integer __init__6(Rect * self, Integer x, Integer y, Integer w, Integer h);
extern Rect * new7(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3);
extern Rect * init8(Game * self);
extern Event * __alloc__9(Event_Class * self);
extern Integer __init__10(Event * self);
extern Event * new11(Event_Class * self);
extern Integer SDL_PollEvent(Event *);
extern Integer type12(Event * self);
extern Integer SDL_RenderClear(Pointer);
extern Integer SDL_RenderFillRect(Pointer, Rect *);
extern Integer SDL_RenderDrawRect(Pointer, Rect *);
extern Integer SDL_RenderDrawLine(Pointer, Integer, Integer, Integer, Integer);
extern Integer SDL_RenderDrawPoint(Pointer, Integer, Integer);
extern Void SDL_RenderPresent(Pointer);
extern Void SDL_Delay(Integer);
extern Nil render13(Game * self);
extern Void SDL_DestroyWindow(Pointer);
extern Void SDL_Quit(Void);
extern Nil quit14(Game * self);
extern Nil start15(Game * self);
Game * __alloc__1(Game_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Game), 1);
    return result;
}
Bool __init__2(Game * self, Integer width, Integer height)
{
    Bool result;
    self->width = width;
    self->height = height;
    self->quit = False;
    result = self->quit;
    return result;
}
Game * new3(Game_Class * self, Integer var0, Integer var1)
{
    Pointer result;
    Pointer obj;
    obj = __alloc__1(self);
    __init__2(obj, var0, var1);
    result = obj;
    return result;
}
Bool nil__mark__4(Pointer self)
{
    Bool result;
    result = (self == 0);
    return result;
}
Rect * __alloc__5(Rect_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Rect), 1);
    return result;
}
Integer __init__6(Rect * self, Integer x, Integer y, Integer w, Integer h)
{
    Integer result;
    self->x = x;
    self->y = y;
    self->w = w;
    self->h = h;
    result = self->h;
    return result;
}
Rect * new7(Rect_Class * self, Integer var0, Integer var1, Integer var2, Integer var3)
{
    Pointer result;
    Pointer obj;
    obj = __alloc__5(self);
    __init__6(obj, var0, var1, var2, var3);
    result = obj;
    return result;
}
Rect * init8(Game * self)
{
    Pointer result;
    if ((SDL_Init(32) < 0))
    {
        printf("SDL_Init failed: %s\n", SDL_GetError());
        exit(1);
    }
    self->window = SDL_CreateWindow("slang test", 0, 0, self->width, self->height, 4);
    if (nil__mark__4(self->window))
    {
        printf("SDL_CreateWindow failed: %s\n", SDL_GetError());
        exit(1);
    }
    self->renderer = SDL_CreateRenderer(self->window, -(1), 2);
    if (nil__mark__4(self->renderer))
    {
        printf("SDL_CreateRenderer failed: %s\n", SDL_GetError());
        exit(1);
    }
    SDL_SetRenderDrawColor(self->renderer, 255, 255, 255, 255);
    self->fill_rect = new7(&Rect_class, (self->width / 4), (self->height / 4), (self->width / 2), (self->height / 2));
    self->outline_rect = new7(&Rect_class, (self->width / 6), (self->height / 6), (self->width * (2 / 3)), (self->height * (2 / 3)));
    result = self->outline_rect;
    return result;
}
Event * __alloc__9(Event_Class * self)
{
    Pointer result;
    result = calloc(sizeof(Event), 1);
    return result;
}
Integer __init__10(Event * self)
{
    Integer result;
    self->type = 0;
    result = self->type;
    return result;
}
Event * new11(Event_Class * self)
{
    Pointer result;
    Pointer obj;
    obj = __alloc__9(self);
    __init__10(obj);
    result = obj;
    return result;
}
Integer type12(Event * self)
{
    Integer result;
    result = self->type;
    return result;
}
Nil render13(Game * self)
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
Nil quit14(Game * self)
{
    Nil result;
    if (!(nil__mark__4(self->window)))
    {
        SDL_DestroyWindow(self->window);
    }
    SDL_Quit();
    return result;
}
Nil start15(Game * self)
{
    Nil result;
    Pointer e;
    init8(self);
    e = new11(&Event_class);
    while (!(self->quit))
    {
        while ((SDL_PollEvent(e) != 0))
        {
            if ((type12(e) == 256))
            {
                self->quit = True;
            }
        }
        render13(self);
    }
    result = quit14(self);
    return result;
}
Integer main(Void)
{
    Integer result;
    start15(new3(&Game_class, 800, 600));
    result = 0;
    return result;
}
