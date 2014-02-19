#encoding: utf-8
require 'graph'
require 'json'
namespace :hpu do    
  task exam:  :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    mon_hocs = Set.new
    graph = Graph.new
    lops = Hash.new
    MonHoc.all.each do |mon|
      lops[mon.id] ||= Set.new
      LopMonHoc.where(ma_mon_hoc: mon.ma_mon_hoc).each do |lop|
        lops[mon.id].add(lop.enrollments.map {|en| en.sinh_vien_id})
      end            
    end        

    MonHoc.all.each_with_index do |m|
      MonHoc.all.each_with_index do |n|
        if m != n 
          if !(lops[m.id] & lops[n.id]).empty?
            graph.add_edge(m.id, n.id)
          end
        end        
      end
    end
    File.open('E:/v.json', 'w') { |file| file.write(graph.get_v.to_json) }
    
    File.open('E:/edges.json','w') { |file| file.write(graph.get_edge.to_json) }
    puts graph.get_v.count
    puts graph.get_edge.count
    puts graph.get_colors.values.count
  end
  task color_exam:  :environment do 
    vertice = JSON.parse(File.read('E:/v.json'))
    edges = JSON.parse(File.read('E:/edges.json'))
    graph = Graph.new(vertice, edges, nil)
    graph.color!
    File.open('E:/result.json', 'w') {|file| file.write(graph.get_colors.to_json)}
  end
  
end