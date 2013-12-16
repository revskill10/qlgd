class Tenant < ActiveRecord::Base
  attr_accessible :hoc_ky, :nam_hoc, :name, :ngay_bat_dau, :ngay_ket_thuc
  after_create :prepare_tenant
  
  private

  def prepare_tenant
    create_schema
    load_tables
  end

  def create_schema
    PgTools.create_schema name unless PgTools.schemas.include? name
  end

  def load_tables    
    PgTools.set_search_path name, false
    load "#{Rails.root}/db/schema.rb"    
    PgTools.restore_default_search_path
  end
end
