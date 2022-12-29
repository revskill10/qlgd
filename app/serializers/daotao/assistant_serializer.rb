class Daotao::AssistantSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :username, :hovaten, :code, :trogiang

  def username
    "" unless object.user
    object.user.username if object.user
  end

  def hovaten
    object.giang_vien.hovaten
  end

  def code
    object.giang_vien.code
  end
end