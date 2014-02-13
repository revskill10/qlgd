#encoding: utf-8
class SearchLopMonHocDecorator < Draper::Decorator
  delegate_all
  def giang_viens
  	object.giang_viens.inject("") {|res, elem| res + "  " + elem.hovaten}
  end
  def siso
  	object.enrollments.count
  end
end
