class MadHatter

	def initialize
		@ip = {"x": -1, "y": 0}
		@grid = []
		@grid_length = 0
		@stack = []
		@buffer = ""
		@commands = {
			"t"=>Proc.new{
				mult_by_10()
			},
			"T"=>Proc.new{
				mult_by_100()
			},
			"+"=>Proc.new{
				add()
			},
			"-"=>Proc.new{
				sub()
			},
			"/"=>Proc.new{
				div()
			},
			"*"=>Proc.new{
				mult()
			},
			"%"=>Proc.new{
				mod()
			},
			"^"=>Proc.new{
				pow()
			},
			"~"=>Proc.new{
				neg()
			},
			"c"=>Proc.new{
				copy()
			},
			"r"=>Proc.new{
				reverse()
			},
			"x"=>Proc.new{
				swap()
			},
			";"=>Proc.new{
				discard()
			},
			"d"=>Proc.new{
				depth()
			},
			"j"=>Proc.new{
				jump()
			},
			"&"=>Proc.new{
				repeat()
			},
			"i"=>Proc.new{
				input()
			},
			"o"=>Proc.new{
				output()
			},
			"\\"=>Proc.new{
				newline()
			},
			"|"=>Proc.new{
				noop()
			},
			"n"=>Proc.new{
				char_to_int()
			},
			"N"=>Proc.new{
				string_to_int()
			},
			"l"=>Proc.new{
				string_length()
			},
			"R"=>Proc.new{
				string_regex()
			},
			"C"=>Proc.new{
				string_chars()
			},
			"D"=>Proc.new{
				debug()
			},
			"I"=>Proc.new{
				input_string()
			},
			"S"=>Proc.new{
				string_split()
			},
			">"=>Proc.new{
				greater
			},
			"<"=>Proc.new{
				less
			},
			"="=>Proc.new{
				equal
			},
			"f"=>Proc.new{
				move_front
			},
			"e"=>Proc.new{
				move_end
			}
			
			
		}
		@queue = []
		@running = true

		setup $*[0]
		$*.clear

		run
	end

	def setup src
		code = ""
		File.open(src, "r"){|f|
			code = f.read
		}
		code.each_line{|x|
			@grid<< x.chars
		}
		
		begin
			@grid_length = @grid.max_by(&:length).length
		rescue
			puts ""
		end
		@grid.each_with_index{|x,i|
			while x.length < @grid_length
				@grid[i]<< "."
			end
		}
	end

#############
###Numbers###
#############

	def char_to_int
		a = @stack.pop|| 0
		
		@stack<< a.to_s[0].ord
	
	end
	
	
	def string_to_int
		a = @stack.pop || 0
		
		@stack<< a.to_i
	end

	def mult_by_10
		a = 10
		b = @stack.pop || 1
		@stack<<a*b
	end
	
	def mult_by_100
		a = 100
		b = @stack.pop || 1
		@stack<<a*b
	end
	
	#addition
	def add
		a = @stack.pop || 0
		b = @stack.pop || 1
		@stack<< a+b
	end

	#multiply - Technically works for strings (Lets call it a easter egg)
	def mult
		a = @stack.pop || 0
		b = @stack.pop || 1
		@stack<< a*b
	end

	#division
	def div
		a = @stack.pop || 0
		b = @stack.pop || 1
		@stack<< b/a
	end
	
	#subtraction
	def sub
		a = @stack.pop || 0
		b = @stack.pop || 1 
		@stack<< a-b
	end
	
	def mod
		a = @stack.pop || 1
		b = @stack.pop || 2
		@stack<< b%a
		
	end
	
	# Power of
	def pow
		a = @stack.pop || 0
		b = @stack.pop || 0
		@stack<< b**a
	end
	
	# Negate
	def neg
		a = @stack.pop || 1
		@stack<< a*-1
	end
	
#############
###Strings###
#############

	# Most useful here probably
	def string_length
		a = @stack.pop
		@stack<< a.to_s.length
	end
	
	# Hacky
	def string_regex
		a = @stack.pop.to_s
		b = @stack.pop.to_s
		#p a, b
		#arr = a.scan(/#{b}/)
		#p arr
		@stack<< b.scan(/#{a}/)[0]
	end
	
	# Very useful for fake arrays
	def string_chars
		a = @stack.pop.to_s
		a.chars.each{|x|
	
	
			@stack<< x
		}
	
	end
	
	# Also very useful
	def string_split
		a = @stack.pop.to_s || "\s"
		b = @stack.pop.to_s 
		b.split(/#{a}/).each{|x|
			@stack<< x
		}
		
		
		
	end
	
#############
####Stack####
#############

	def copy
		a = @stack.pop || 0
		@stack<< a
		@stack<< a
	end
	
	def reverse
		@stack = @stack.reverse
	end
	
	def swap
		a = @stack.pop || 1
		b = @stack.pop || 0
		
		@stack<< a
		@stack<< b
	end
	
	def discard
		@stack.pop
	end
	
	def depth
		@stack<< @stack.size
	end
	
	def move_end
		@stack<< @stack.shift
	end
	
	def move_front
		@stack.unshift(@stack.pop)
	end

#############
####Logic####
#############

	def jump
		a = @stack.pop || -1
		b = @stack.pop || 0
		#puts a, b
		@ip[:x] = a
		@ip[:y] = b
	end
	
	#do next if
	
	def greater
		a = @stack.pop || 0
		b = @stack.pop || 0
		
		move() if not b>a
	
	end
	
	def less
		a = @stack.pop || 0
		b = @stack.pop || 0
		
		move() if not b>a
	end
	
	def equal
	
		a = @stack.pop || 0
		b = @stack.pop || 1
		
		move() if not a==b
	end
	
	
	#repeat x times
	
	def repeat
		move()
		a = @stack.pop || 0
		a.times{|x|
			#p x
			@commands[@grid[@ip[:y]][@ip[:x]]].call()
		}
	
	end

##################
###Input/Output###
##################

	def input
		
		x = gets.chomp
		#p x
		
		begin
			@stack<< x.to_i
		rescue
			@stack<< x
		end
	end
	
	def input_string
		x = gets.chomp
		@stack<< x
	end
	
	def output
		$><< @stack.pop
	end
	
	def newline
		$><< "\r\n"
	end
	
	

#############
###Running###
#############
	
	def debug
		print @stack,$/, @grid,$/, @ip
	
	end
	
	def move
			
			
			@ip[:x] += 1
			#@stack<< 0 if @stack.length<1
			#puts @stack
			if @ip[:x] > @grid_length-1
				value = 0
				begin
					value = @stack[-1].to_i
				rescue
					value = @stack[-1].length
				end
				
				@ip[:y] += 1 if @stack[-1]==nil || value > 0
				@ip[:y] -= 1 if @stack[-1] && value <= 0
				@ip[:x] = 0
				
			
			end
			@running = false if @ip[:y] > @grid.length-1 ||  @ip[:y]<0
			#print @ip
			
	end

	def run
		while @running

			# Modifying ip for main loop here
			
			move()
			break if @running == false
			break if @grid == nil
			if @commands.key? @grid[@ip[:y]][@ip[:x]]
				@commands[@grid[@ip[:y]][@ip[:x]]].call()
				
			# Number handeling
			elsif @grid[@ip[:y]][@ip[:x]] =~ /[[:digit:]]/
				@stack<< @grid[@ip[:y]][@ip[:x]].to_i
			# String handeling
			elsif @grid[@ip[:y]][@ip[:x]] == "'"
				@buffer = ""
				move()
				while @grid[@ip[:y]][@ip[:x]] != "'"
					
					@buffer<< @grid[@ip[:y]][@ip[:x]]
					move()
					
				end
				@stack<< @buffer
			elsif @grid[@ip[:y]][@ip[:x]] == '"'
				@buffer = ""
				move()
				while @grid[@ip[:y]][@ip[:x]] != '"'
					
					@buffer<< @grid[@ip[:y]][@ip[:x]]
					move()
					
				end
				@stack<< @buffer
			end
		end
	end

end

mad = MadHatter.new
