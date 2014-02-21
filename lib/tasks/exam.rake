#encoding: utf-8
require 'graph'
require 'json'
namespace :hpu do    
  task exam:  :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    mon_hocs = Set.new
    graph = Graph.new(nil, nil, nil, nil)
    lops = Hash.new
    svs = Hash.new
    MonHoc.all.each do |mon|
      lops[mon.id] ||= Set.new
      LopMonHoc.where(ma_mon_hoc: mon.ma_mon_hoc).each do |lop|
        lops[mon.id].add(lop.enrollments.map {|en| en.sinh_vien_id})
      end            
    end        

    MonHoc.all.each_with_index do |m|
      MonHoc.all.each_with_index do |n|
        if m != n 
          if !(lops[m.id] & lops[n.id]).empty? and lops[m.id].size > 0 and lops[n.id].size > 0
            graph.add_edge(m.id, n.id)
          end
        end        
      end
    end
    File.open('E:/lops.json', 'w') {|file| file.write(lops.to_json)}
    File.open('E:/v.json', 'w') { |file| file.write(graph.get_v.to_json) }
    
    File.open('E:/edges.json','w') { |file| file.write(graph.get_edge.to_json) }
    puts graph.get_v.count
    puts graph.get_edge.count
    puts graph.get_colors.values.count
  end
  task color_exam:  :environment do 
    svs = JSON.parse(File.read('E:/lops.json')).inject({}) {|res, elem| k=elem[0].to_i;v=elem[1].flatten;res[k]=v;res}
    alledges = JSON.parse(File.read('E:/edges.json'))
    alledges2=alledges.inject({}) {|res,elem| k=elem[0];v=elem[1]; key=k[1..-2].split(",").map {|s| s.to_i};res[key]=v; res}
    allkeys = alledges2.collect {|k,v| k}.flatten.uniq
    vertice = JSON.parse(File.read('E:/v.json')).select {|k| allkeys.include?(k)}
    edges = alledges2.select {|k,v| vertice.include?(k[0]) and vertice.include?(k[1])}
    graph = Graph.new(edges, vertice, nil, svs, 28)
    File.open('E:/v1.json','w') {|file| file.write(vertice.to_json)}
    File.open('E:/edges1.json','w') {|file| file.write(edges.to_json)}
    graph.color!
    puts vertice.count
    puts edges.count
    puts graph.get_colors.values.uniq.count
    File.open('E:/result.json', 'w') {|file| file.write(graph.get_colors.to_json)}    
  end
  
end