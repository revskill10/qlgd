#encoding: utf-8
require 'graph'
require 'json'
require 'csv'
namespace :hpu do    
  task mon_exam:  :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    mon_hocs = Set.new
    
    lops = Hash.new
    svs = Hash.new
    nodes = Set.new
    MonHoc.all.each do |mon|
      lops[mon.id] ||= Set.new
      LopMonHoc.where(ma_mon_hoc: mon.ma_mon_hoc).each do |lop|
        lop.enrollments.each do |en|
          lops[mon.id].add(en.sinh_vien_id)
        end
      end            
      m = mon.ma_mon_hoc[-2].to_i
      node = Node.new(mon.id, lops[mon.id], m)
      nodes.add(node)
    end        
    File.open('E:/mon.json', 'w') {|file| file.write(nodes.to_json)} 
  end    

  task exam:  :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    mon_hocs = Set.new
    
    lops = Hash.new
    svs = Hash.new
    nodes = Set.new

    n2 = Set.new
    nodes = JSON.parse(File.read('E:/mon.json'))
    ns2 = nodes.select {|n| n["svs"].count > 0}
    ns2.each do |n3|
      n = Node.new(n3["id"], Set.new(n3["svs"]), n3["so_tin_chi"].to_i)
      n2.add(n)
    end
    graph = Graph.new(n2, 3, 15)    
    graph.color!
    File.open('E:/result.json', 'w') {|file| file.write(graph.get_colors.to_json)}
    #puts graph.is_adjacent?(graph.get_v, 2194)    

  end
  task test_exam:  :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    mon_hocs = Set.new
    
    lops = Hash.new
    svs = Hash.new
    nodes = Set.new

    n2 = Set.new
    nodes = JSON.parse(File.read('E:/mon.json'))
    ns2 = nodes.select {|n| n["svs"].count > 0}
    ns2.each do |n3|
      n = Node.new(n3["id"], Set.new(n3["svs"]), n3["so_tin_chi"].to_i)
      n2.add(n)
    end        
    CSV.open("E:/test_graph.csv", "wb") do |csv|
      csv << ["Slot", "Số môn / Ca", "Số lượt", "Số ca"]
      (1..5).each do |slot|
        (7..21).each do |sm|
          graph = Graph.new(n2, slot, sm)    
          graph.color!
          csv << [slot, sm, graph.get_colors.values.uniq.count, graph.get_colors.values.max]            
        end
      end
    end
  end

  task sort_mon: :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    n2 = Set.new
    nodes = JSON.parse(File.read('E:/mon.json'))
    ns2 = nodes.select {|n| n["svs"].count > 0}
    ns2.each do |n3|
      n = Node.new(n3["id"], Set.new(n3["svs"]), n3["so_tin_chi"].to_i)
      n2.add(n)
    end
    graph = Graph.new(n2)    
    CSV.open("E:/sort_mon.csv", "wb") do |csv|
      csv << ["id","Tên môn", "Mã môn học","Degree", "SSV"]
      graph.get_v.each do |v|
        degree = graph.degree(graph.get_v, v)
        mon = MonHoc.find(v.id)      
        if v.id == 327 
          puts v.svs.inspect
          puts v.svs.count
        end        
        tmp = v.svs.count
        csv << [v.id, mon.ten_mon_hoc, mon.ma_mon_hoc, degree, tmp.to_s]
      end  
    end
  end
  task report_exam: :environment do 
    nodes = JSON.parse(File.read('E:/mon.json'))
    ns2 = nodes.select {|n| n["svs"].count > 0}
    exam = JSON.parse(File.read('E:/result.json'))
    e2 = exam.group_by {|k,v| v}.sort_by {|k,v| k}
    CSV.open("E:/report.csv", "wb") do |csv|
      csv << ["Ca thi", "Số môn", "Số sinh viên"]
      e2.each do |k,v|
        tmp = []
        v.each do |v1|
          tmp << v1[0].to_i
        end
        c = Set.new(ns2.select {|s| tmp.include?(s["id"])}.inject([]) {|res, elem| res + elem["svs"]}).count
        csv << [k, v.count, c]
      end
    end
  end

  task report_exam2: :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    nodes = JSON.parse(File.read('E:/mon.json'))
    ns2 = nodes.select {|n| n["svs"].count > 0}
    exam = JSON.parse(File.read('E:/result.json'))
    e2 = exam.group_by {|k,v| v}.sort_by {|k,v| k}
    tmp = []
    CSV.open("E:/report2.csv", "wb") do |csv|
      (1..100).each do |t|
        tmp << "Ca #{t}"
      end
      csv << ["Tên môn", "Mã môn học"] + tmp
      
      
      exam.each do |k,v|
        res = []
        mon = MonHoc.find(k)
        res << mon.ten_mon_hoc 
        res << mon.ma_mon_hoc
        (1..100).each do |t|
          if v == t 
            res << ns2.select {|k2| k2["id"] == k.to_i}.first["svs"].count 
          else
            res << ""
          end          
        end
        csv << res
      end      
    end
  end

  task report_sv: :environment do 
    Apartment::Database.switch('public')
    tenant = Tenant.last
    Apartment::Database.switch(tenant.name)
    
    nodes = JSON.parse(File.read('E:/mon.json'))
    ns2 = nodes.select {|n| n["svs"].count > 0}
    exam = JSON.parse(File.read('E:/result.json'))
    
    svs = SinhVien.order('ma_lop_hanh_chinh')
    CSV.open("E:/exam/all_report.csv", "wb") do |csv|          
      csv << ["Mã sinh viên", "Tên sinh viên", "Ngày sinh", "Mã lớp hành chính"]  + (1..200).to_a
      svs.each do |sv|
        mons = nodes.select {|n| n["svs"].include?(sv.id)}
        tmp = {}
        (1..200).each do |t|
          tmp[t] = ""
        end
        mons.each do |m|
          m2 = MonHoc.find(m["id"])
          tmp[exam[m["id"].to_s]] = m2.ten_mon_hoc + "(#{m2.ma_mon_hoc})"
        end          
        csv << [sv.code, sv.hovaten, sv.ngay_sinh.localtime.strftime("%d/%m/%Y"), sv.ma_lop_hanh_chinh] + tmp.values
      end
    end
    
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