class MadHatter

	def initialize
		@ip = {"x": -1, "y": 0}
		@grid = []
		@grid_length = 0
		@stack = [[]]
		@stack_index = 0
		
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
			"L"=>Proc.new{
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
			},
			"E"=>Proc.new{
				string_empty
			},
			"{"=>Proc.new{
				stack_left
			},
			"}"=>Proc.new{
				stack_right
			},
			"p"=>Proc.new{
				push_right
			},
			"q"=>Proc.new{
				push_left
			},
			"Z"=>Proc.new{
				string_reverse
			},
			"X"=>Proc.new{
				string_from_int
			},
			"A"=>Proc.new{
				ip_up
			},
			"V"=>Proc.new{
				ip_down
			},
			","=>Proc.new{
				wait
			},
			"J"=>Proc.new{
				string_join
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
		a = @stack[@stack_index].pop|| 0
		
		@stack[@stack_index]<< a.to_s[0].to_i
	
	end
	
	def string_to_int
		a = @stack[@stack_index].pop || 0
		
		@stack[@stack_index]<< a.to_i
	end

	def mult_by_10
		a = 10
		b = @stack[@stack_index].pop || 1
		@stack[@stack_index]<<a*b
	end
	
	def mult_by_100
		a = 100
		b = @stack[@stack_index].pop || 1
		@stack[@stack_index]<<a*b
	end
	
	#addition
	def add
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 1
		@stack[@stack_index]<< b+a
	end

	#multiply - Technically works for strings (Lets call it a easter egg)
	def mult
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 1
		@stack[@stack_index]<< a*b
	end

	#division
	def div
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 1
		@stack[@stack_index]<< b/a
	end
	
	#subtraction
	def sub
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 1 
		@stack[@stack_index]<< a-b
	end
	
	def mod
		a = @stack[@stack_index].pop || 1
		b = @stack[@stack_index].pop || 2
		@stack[@stack_index]<< b%a
		
	end
	
	# Power of
	def pow
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 0
		@stack[@stack_index]<< b**a
	end
	
	# Negate
	def neg
		a = @stack[@stack_index].pop || 1
		@stack[@stack_index]<< a*-1
	end
	
#############
###Strings###
#############

	# Most useful here probably
	def string_length
		a = @stack[@stack_index].pop
		@stack[@stack_index]<< a.to_s.length
	end
	
	def string_from_int
		a = @stack[@stack_index].pop.to_s
		@stack[@stack_index]<< a
	end
	
	# Hacky
	def string_regex
		a = @stack[@stack_index].pop.to_s
		b = @stack[@stack_index].pop.to_s
		#p a, b
		#arr = a.scan(/#{b}/)
		#p arr
		@stack[@stack_index]<< b.scan(/#{a}/)[0]
	end
	
	# Very useful for fake arrays
	def string_chars
		a = @stack[@stack_index].pop.to_s
		a.chars.each{|x|
	
			
			@stack[@stack_index]<< x
		}
	
	end
	
	# Reverse string
	def string_reverse
		a = @stack[@stack_index].pop.to_s
		@stack[@stack_index]<< a.reverse
	end
	
	# Also very useful
	def string_split
		a = @stack[@stack_index].pop.to_s 
		b = @stack[@stack_index].pop.to_s
		
		#p b
		b.split(/#{a}/).each{|x|
			@stack[@stack_index]<< x
		}
		
		
		
	end
	
	# Godlike, acctually
	def string_join
		a = @stack[@stack_index].pop.to_s
		b = @stack[@stack_index].pop.to_i || 2
		c = @stack[@stack_index][-b, b].join(a)
		@stack[@stack_index].pop(b)
		@stack[@stack_index]<< c
	end
	
	def string_empty
		@stack[@stack_index]<< ""
	
	end
	
#############
####Stack####
#############

	def stack_right
		@stack_index += 1
		@stack<< [] if @stack_index>@stack.length-1
	end
	
	def stack_left
		@stack_index -= 1
		if @stack_index<0
			@stack.unshift([]) 
			@stack_index = 0
		end
	end
	
	def push_right
		a = @stack[@stack_index].pop
		@stack_index += 1
		@stack<< [] if @stack_index>@stack.length-1
		@stack[@stack_index]<< a
	end
	
	def push_left
		a = @stack[@stack_index].pop
		@stack_index -= 1
		if @stack_index<0
			@stack.unshift([]) 
			@stack_index = 0
		end
		@stack[@stack_index]<< a
	end
	
	def copy
		a = @stack[@stack_index].pop || 0
		@stack[@stack_index]<< a
		@stack[@stack_index]<< a
	end
	
	def reverse
		@stack[@stack_index] = @stack[@stack_index].reverse
	end
	
	def swap
		a = @stack[@stack_index].pop || 1
		b = @stack[@stack_index].pop || 0
		
		@stack[@stack_index]<< a
		@stack[@stack_index]<< b
	end
	
	def discard
		@stack[@stack_index].pop
	end
	
	def depth
		@stack[@stack_index]<< @stack[@stack_index].size
	end
	
	def move_end
		@stack[@stack_index]<< @stack[@stack_index].shift
	end
	
	def move_front
		@stack[@stack_index].unshift(@stack[@stack_index].pop)
	end

#############
####Logic####
#############

	def jump
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 0
		#puts a, b
		@ip[:x] = b-1
		@ip[:y] = a
	end
	
	#do next if, with error handling, in case we want to compare strings and digits
	
	def greater
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 0
		begin
			move() if not b>a
		rescue
			move()
		end
	
	end
	
	def less
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 0
		begin
			move() if not b>a
		rescue
			move()
		end
	end
	
	def equal
	
		a = @stack[@stack_index].pop || 0
		b = @stack[@stack_index].pop || 1
		begin
			move() if not a==b
		rescue
			move()
		end
	end
	
	
	#repeat x times
	
	def repeat
		move()
		a = @stack[@stack_index].pop || 0
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
			@stack[@stack_index]<< x.to_i
		rescue
			@stack[@stack_index]<< x
		end
	end
	
	def input_string
		x = gets.chomp
		@stack[@stack_index]<< x
	end
	
	def output
		$><< @stack[@stack_index].pop
	end
	
	def newline
		$><< "\r\n"
	end
	
	

#############
###Running###
#############
	
	def wait
		a = @stack[@stack_index].pop.to_i
		sleep(a)
	
	end
	
	def ip_up
		@ip[:y] -= 1
		@ip[:y] = @grid.length-1 if @ip[:y]<0
		@ip[:x] = -1
	end
	
	def ip_down
		@ip[:y] += 1
		@ip[:y] = 0 if @ip[:y] > @grid.length-1
		@ip[:x] = -1
	end
	
	def debug
		print @stack,$/, @grid,$/, @ip,$/
	
	end
	
	def move
			
			
			@ip[:x] += 1
			#@stack[@stack_index]<< 0 if @stack[@stack_index].length<1
			#puts @stack[@stack_index]
			if @ip[:x] > @grid_length-1
				value = 0
				begin
					value = @stack[@stack_index][-1].to_i
				rescue
					value = @stack[@stack_index][-1].length
				end
				
				@ip[:y] += 1 if @stack[@stack_index][-1]==nil || value > 0
				@ip[:y] -= 1 if @stack[@stack_index][-1] && value <= 0
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
				@stack[@stack_index]<< @grid[@ip[:y]][@ip[:x]].to_i
			# String handeling
			elsif @grid[@ip[:y]][@ip[:x]] == "'"
				@buffer = ""
				move()
				while @grid[@ip[:y]][@ip[:x]] != "'"
					
					@buffer<< @grid[@ip[:y]][@ip[:x]]
					move()
					
				end
				@stack[@stack_index]<< @buffer
			elsif @grid[@ip[:y]][@ip[:x]] == '"'
				@buffer = ""
				move()
				while @grid[@ip[:y]][@ip[:x]] != '"'
					
					@buffer<< @grid[@ip[:y]][@ip[:x]]
					move()
					
				end
				@stack[@stack_index]<< @buffer
			end
		end
	end

end

mad = MadHatter.new
