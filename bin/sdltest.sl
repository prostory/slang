# This is a SDL demo write by slang
# Author: Xiao Peng
# Date: 2016-07-21

class Integer
	operator += (Integer):Integer
	operator -= (Integer):Integer
end

class Pointer
	operator ==(Integer):Bool
	
	def nil?
		self == 0
	end
end

class Rect
	def __init__(x, y, w, h)
		@x = x
		@y = y
		@w = w
		@h = h
	end
	
	def x; @x end
	def y; @y end
	def w; @w end
	def h; @h end
end

class Event
	def self.__alloc__
		calloc(60, 1)
	end
	def __init__
		@type = 0
	end
	
	def type; @type end
end

external exit(Integer):Void

external SDL_Init(Integer):Integer
external SDL_CreateWindow(String, Integer, Integer, Integer, Integer, Integer):Pointer
external SDL_CreateRenderer(Pointer, Integer, Integer):Pointer
external SDL_SetRenderDrawColor(Pointer, Integer, Integer, Integer, Integer):Integer
external SDL_RenderClear(Pointer):Integer
external SDL_RenderFillRect(Pointer, Rect):Integer
external SDL_RenderDrawRect(Pointer, Rect):Integer
external SDL_RenderDrawLine(Pointer, Integer, Integer, Integer, Integer):Integer
external SDL_RenderDrawPoint(Pointer, Integer, Integer):Integer
external SDL_RenderPresent(Pointer):Void
external SDL_GetError():String
external SDL_Delay(Integer):Void
external SDL_PollEvent(Event):Integer
external SDL_DestroyRenderer(Pointer):Void
external SDL_DestroyWindow(Pointer):Void
external SDL_Quit():Void

class Game
	def __init__
		@width = 640
		@height = 480
		@quit = false
	end

	def __init__(width, height)
		@width = width
		@height = height
		@quit = false
	end
	
	def init
		if SDL_Init(0x00000020) < 0
			printf "SDL_Init failed: %s\n", SDL_GetError()
			exit 1
		end
		
		@window = SDL_CreateWindow("slang test", 0, 0, @width, @height, 0x00000004)
		if @window.nil?
			printf "SDL_CreateWindow failed: %s\n", SDL_GetError()
			exit 1
		end
		
		@renderer = SDL_CreateRenderer(@window, -1, 0x00000002)
		
		if @renderer.nil?
			printf "SDL_CreateRenderer failed: %s\n", SDL_GetError()
			exit 1
		end
		
		SDL_SetRenderDrawColor(@renderer, 0xFF, 0xFF, 0xFF, 0xFF)
		
		@fill_rect = Rect.new(@width/4, @height/4, @width/2, @height/2)
		@outline_rect = Rect.new(@width/6, @height/6, @width * 2 / 3, @height * 2 / 3)
	end
	
	def render
		SDL_SetRenderDrawColor(@renderer, 0xFF, 0xFF, 0xFF, 0xFF)
		SDL_RenderClear @renderer
		
		SDL_SetRenderDrawColor(@renderer, 0xFF, 0x00, 0x00, 0xFF)
		SDL_RenderFillRect(@renderer, @fill_rect)

		SDL_SetRenderDrawColor(@renderer, 0x00, 0xFF, 0x00, 0xFF)
		SDL_RenderDrawRect(@renderer, @outline_rect)

		SDL_SetRenderDrawColor(@renderer, 0x00, 0x00, 0xFF, 0xFF)
		SDL_RenderDrawLine(@renderer, 0, @height/2, @width, @height/2)
		
		SDL_SetRenderDrawColor(@renderer, 0xFF, 0xFF, 0x00, 0xFF)
		i = 0
		while i < @height do
		  SDL_RenderDrawPoint(@renderer, @width/2, i)
		  i += 4
		end
		
		SDL_RenderPresent @renderer
		SDL_Delay 1
	end
	
	def start
		init
		e = Event.new
		until @quit do
			while SDL_PollEvent(e) != 0
				case e.type
				of 0x100
					@quit = true
				end
			end
			render
		end
		quit
	end
  
	def quit
		if !@renderer.nil?
			SDL_DestroyRenderer(@renderer)
		end
		if !@window.nil?
			SDL_DestroyWindow(@window)
		end
		SDL_Quit()
	end
end

Game.new(800, 600).start
