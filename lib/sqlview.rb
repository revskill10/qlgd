=begin

select hovaten, code, ma_lop_hanh_chinh, enrollment_id, encoded_position,
	sum(case when tuan=23 then stv else 0 end) as "Tuan 23"	
from (
select sum(so_tiet_vang) as stv, enrollment_id, encoded_position, tuan, hovaten, code, ma_lop_hanh_chinh
from (
SELECT regexp_replace(sv.ho || ' ' || sv.dem || ' ' || sv.ten, '  ',' ') as hovaten, sv.code, sv.ma_lop_hanh_chinh, at.so_tiet_vang, lp.id as lop_mon_hoc_id, en.id as enrollment_id, sv.encoded_position as encoded_position, lt.tuan
  FROM t2.attendances at
  inner join t2.lich_trinh_giang_days lt on at.lich_trinh_giang_day_id=lt.id
  inner join t2.lop_mon_hocs lp on lp.id = lt.lop_mon_hoc_id
  inner join t2.sinh_viens sv on at.sinh_vien_id=sv.id
  inner join t2.enrollments en on en.sinh_vien_id=sv.id and en.lop_mon_hoc_id=lp.id
  where lp.id=126 and at.so_tiet_vang > 0
  order by lt.tuan) at
  group by tuan, lop_mon_hoc_id, enrollment_id, encoded_position, hovaten, code, ma_lop_hanh_chinh
  order by tuan) at2
  group by enrollment_id, encoded_position, hovaten, code, ma_lop_hanh_chinh
  

union all

  select regexp_replace(sv.ho || ' ' || sv.dem || ' ' || sv.ten, '  ',' ') as hovaten, sv.code, sv.ma_lop_hanh_chinh, en.id as enrollment_id, sv.encoded_position, 0 as "Tuan23"
  from t2.enrollments en
  inner join t2.sinh_viens sv on sv.id= en.sinh_vien_id
  where en.lop_mon_hoc_id=126

order by encoded_position
  

=end