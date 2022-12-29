#encoding: utf-8
class LopEnrollmentDecorator < Draper::Decorator
  delegate_all
  def initialize(lop)
  	@object = lop
  end
  
end