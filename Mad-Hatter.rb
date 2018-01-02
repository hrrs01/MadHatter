class MadHatter

	def initialize src
		@ip = {"x": 0, "y": 0}
		@grid = []
		@grid_length = 0
		@stack = []
		@sp = 0
		@commands = {

		}
		@running = false

		setup src

		run
	end

	def setup src
		code = File.open().read
		code.each_line{|x|
			@grid<< x
		}
		@grid_length = @grid.max_by(&:length).length
		@grid.each_with_index{|x,i|
			while x.length < longest
				@grid[i]<< "."
			end
		}
	end

#############
###Numbers###
#############

	# Easier numbers
	def chars_to_ord
		a=1
		a=@stack.pop if @stack[-1] =~ /[[:digit:]]/
		chars = []
		a.times{|x|
			chars<< @stack.pop.ord
		}
	end

	def string_to_num
		@stack<< @stack.pop.to_i if @stack[-1] =~ /[[:digit:]]+/
	end

	#addition
	def add
		a = @stack.pop
		b = @stack.pop || 1
		@stack<< a+b
	end

	#multiply - Technically works for strings (Lets call it a easter egg)
	def mult
		a = @stack.pop
		b = @stack.pop || 2
		@stack<< a*b
	end

	#division
	def div
		a = @stack.pop
		b = @stack.pop || 2
		@stack<< a/b
	end
#############
###Strings###
#############

#############
####Stack####
#############

#############
####Logic####
#############

##################
###Input/Output###
##################

#############
###Running###
#############
	def run
		while @running

			# Modifying ip for main loop here
			@ip["x"] += 1
			if @ip["x"] > @grid_length-1
				@ip["y"] += 1 if @stack[@sp] > 0
				@ip["y"] -= 1 if @stack[@sp] <= 0
				@ip["x"] = 0
				@running = false if @ip["y"] > @grid.length-1 ||  @ip["y"]<0
			end

			if @commands.key? @grid[@ip["y"]][@ip["x"]]
				@commands[@grid[@ip["y"]][@ip["x"]]].call()
			end
		end
	end

end
