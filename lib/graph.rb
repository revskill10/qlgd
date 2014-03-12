require 'set'
class Node
	# id: id trong database		
	attr_accessor :id, :svs, :hinh_thuc, :so_tin_chi
	def initialize(id, svs, stc, ht = nil)
		self.id = id
		self.so_tin_chi = stc
		self.svs = svs || Set.new
		self.hinh_thuc = ht
	end
	def he_so
		if hinh_thuc == 'van_dap'
			svs.count / 16
		else
			svs.count / 28
		end
	end
	def eql?(obj)
		self.id == obj.id
	end
	def hash
		self.id
	end
end

class Graph
	# heso: so sinh vien / 28 doi voi mon tu luan, so sinh vien / 16 do voi mon van dap
	# max_phong: so phong toi da cho 1 ca thi
	# edge: lien ket mon
	# ver: mon hoc
	# color: slot thi
	def initialize(ver = nil, slot, so_mon)
		@slot = slot
		#@max_mon = 20
		@g = Hash.new
		@v = ver || Set.new
		@v2 = Set.new(@v)
		@color = Hash.new
		process_edge!
		@tmp = Hash.new # danh sach sinh vien da thi tai mau k
		@tmp2 = Hash.new
	end
	def clear!
		#@color = Hash.new
		@tmp = Hash.new
		@tmp2 = Hash.new
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
	def add_ver(v)
		@v.each do |v2|
			if !(v.svs & v2.svs).empty?
				add_edge(v, v2)
			end
		end
	end	
	def get_color(v)
		@color[v.id]
	end
	def edge?(v, w)
		return true if v.id == w.id
		return true if @g[[v.id, w.id]] > 0 or @g[[w.id, v.id]] > 0
		return false
	end
	def colored?
		@color.keys.count == @v.count
	end
	def color!		
		al(@v, 1)				
	end
	def so_sinh_vien(k)
		ids = []
		tmp = @color.each do |k2, v|
			if v == k 
				ids << k2
			end
		end		
		v = @v.select {|v1| ids.include?(v1.id)}
		Set.new(v.inject([]) {|res, elem| res + elem.svs.to_a}).to_a.count
	end
	def al(mU, k)		
		return true if colored?					
		u1 = get_u1(mU, k)
		u2 = get_u2(mU, k)		
		if !u1.empty? 
			vi1 = max_item_degree(u2, u1)
			assign_color(vi1, k)
			al(mU, k)
		else			
			if (k+1) % 3 == 0
				mU = mU - get_colored_nodes(@v)
			end
			al(get_uncolored_nodes(mU, k+1), k+1)
		end		
	end
	def assign_color(v, k)
		@color[v.id] = k
		@tmp[k] ||= Set.new
		@tmp[k] += Set.new(v.svs)		
		@tmp2[k] ||= 0	
		@tmp2[k] += 1	
	end
	def can_assign?(v, k)		
		(k..k).each do |t|
			@tmp[t] ||= Set.new
			return false if !(v.svs & @tmp[t]).empty?
		end
		@tmp2[k] ||= 0
		#return false if @tmp2[k] > @max_mon
		return true
	end
	def get_degree(v)
		degree(@v, v)
	end		
	def get_weight(i, j)
		return @g[[i, j]] || 0
	end
	def degree(mU, mv)
		temp = 0
		if !mU.empty?
			temp = mU.inject(0) {|res, elem| res + get_weight(mv.id, elem.id)}		
		else
			temp = degree(@v, mv)
		end
		return temp
	end
	def get_temp(k)
		if @tmp[k]
			return @tmp[k]
		else
			@tmp[k] = Set.new
			return @tmp[k]
		end
	end
	def add_edge(v, w, weight)
		@g[[v.id, w.id]] = weight
		@g[[w.id, v.id]] = weight
		@v.add(v)
		@v.add(w)
	end
	def process_edge!
		@v.each do |v|
			@v.each do |v2|				
				if v.id == v2.id 
					add_edge(v, v2, 0)
				else
					weight = (v.svs & v2.svs).count
					add_edge(v, v2, weight)				
				end
			end
		end
	end			
	def adjacent?(mU, mv)
		mU.to_a.each do |v|
			if get_weight(v.id, mv.id) > 0 then return true end
		end
		return false
	end
	def max_item_degree(mU, mV)
		mV.max {|a, b| degree(mU, a) <=> degree(mU, b)}
	end
	def get_u1(mU, k)
		t = get_uncolored_nodes(mU, k)
		t2 = get_colored_nodes(mU)
		Set.new(t.select {|i| !adjacent?(t2, i)}.select {|m| can_assign?(m, k)})
	end
	def get_u2(mU, k)
		t = get_uncolored_nodes(mU, k)
		t2 = get_colored_nodes(mU)
		Set.new(t.select {|i| adjacent?(t2, i)})
	end	
	def get_colored_nodes(mU)
		Set.new(mU.select {|v| @color[v.id] != nil})
	end
	def get_uncolored_nodes(mU, k)
		Set.new(mU.select {|v| @color[v.id].nil?})
	end
	
end

	
=begin
def test	
	n1 = Node.new(1, Set.new([1,2,3]))
	n2 = Node.new(2, Set.new([1,9,10]))
	n3 = Node.new(3, Set.new([2,5,6, 11]))
	n4 = Node.new(4, Set.new([1,7,8, 11]))	
	graph = Graph.new(Set.new([n1, n2, n3, n4]))	
	graph.color!
	puts graph.get_colors.inspect	
end
test
=end

