require 'set'
class Graph
	
	def initialize(edge = nil, ver = nil, color = nil)
		@g = edge || Hash.new
		@v = ver || Set.new
		@color = color || Hash.new
	end
	def get_edge
		@g
	end
	def get_v
		@v
	end
	def get_colors
		@color
	end
	def add_edge(v, w)
		@g[[v, w]] = true
		@g[[w, v]] = true
		@v.add(v)
		@v.add(w)
	end
	def get_color(v)
		@color[v]
	end
	def edge?(v, w)
		return true if v == w
		return true if @g[[v, w]] == true or @g[[w, v]] == true
		return false
	end
	
	def color!
		k = 1
		mU = @v
		u1 = get_u1(mU)
		u2 = get_u2(mU)
		vi1 = max_item_degree(u2, u1)
		assign_color(vi1, k)
		@v.count.times do |t1|
			while !get_u1(mU).empty?
				al(mU, k)
			end
			k = k + 1
			mU = get_uncolored_nodes(mU)
		end
	end
	private
	def al(mU, k)
		u1 = get_u1(mU)
		u2 = get_u2(mU)
		unless u1.empty?
			vi1 = max_item_degree(u2, u1)
			assign_color(vi1, k)
		end	
	end
	def assign_color(v, k)
		@color[v] = k
	end
	def degree(mU, mv)
		@g.select {|k,v| v == true and mv == k[0] and mU.include?(k[1])}.count
	end
	def adjacent?(mU, mv)
		mU.to_a.each do |v|
			if edge?(mv, v) then return true end
		end
		return false
	end
	def max_item_degree(mU, mV)
		v_a = mV.to_a
		max_item = v_a[0]
		max_value = degree(mU, max_item)
		v_a.each do |v|
			tmp = degree(mU, v)
			if tmp > max_value
				max_item = v
				max_value = tmp
			end
		end
		max_item
	end
	def get_u1(mU)
		t = get_uncolored_nodes(mU)
		t2 = get_colored_nodes(mU)
		Set.new(t.select {|i| !adjacent?(t2, i)})
	end
	def get_u2(mU)
		t = get_uncolored_nodes(mU)
		t2 = get_colored_nodes(mU)
		Set.new(t.select {|i| adjacent?(t2, i)})
	end

	
	def get_colored_nodes(mU)
		mU.select {|v| @color[v] != nil}
	end
	def get_uncolored_nodes(mU)
		mU.select {|v| @color[v].nil? }
	end
end
	
=begin
def test
	graph = Graph.new
	graph.add_edge(1, 2)
	graph.add_edge(1, 3)
	graph.add_edge(1, 5)
	graph.add_edge(1, 6)
	graph.add_edge(2, 4)
	graph.add_edge(2, 6)
	graph.add_edge(2, 7)
	graph.add_edge(3, 4)
	graph.add_edge(3, 6)
	graph.add_edge(3, 5)
	graph.add_edge(4, 6)
	graph.add_edge(4, 7)
	graph.add_edge(5, 7)
	graph.add_edge(5, 6)
	graph.color!
	
	puts graph.get_colors.inspect
end
test
=end
