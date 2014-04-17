class AddInfoToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :host, :string
    add_column :tenants, :adapter, :string
    add_column :tenants, :database, :string
    add_column :tenants, :username, :string
    add_column :tenants, :password, :string
    add_column :tenants, :port, :string
  end
end
