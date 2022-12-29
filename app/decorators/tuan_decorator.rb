#encoding: utf-8
class TuanDecorator < Draper::Decorator
	delegate_all

	def tu_ngay2
		object.tu_ngay.strftime("%d/%m/%Y")
	end

	def den_ngay2
		object.den_ngay.strftime("%d/%m/%Y")
	end
end