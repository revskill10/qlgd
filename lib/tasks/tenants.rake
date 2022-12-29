namespace :tenants do
  namespace :db do
    desc "runs db:migrate on each tenant's private schema"
    task migrate: :environment do
      verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migration.verbose = verbose

      Tenant.all.each do |tenant|
        puts "migrating tenant #{tenant.id} (#{tenant.scheme})"
        PgTools.set_search_path tenant.scheme, false
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        ActiveRecord::Migrator.migrate("db/migrate/", version)
      end
    end
    
    task  create: :environment do
      #Tenant.where(hoc_ky: '1', nam_hoc: '2013-2014', name: 't1').first_or_create!
      Tenant.where(hoc_ky: '2', nam_hoc: '2013-2014', name: 't2').first_or_create!
      Tenant.all.each do |t|
        Apartment::Database.create(t.name)
      end
    end

    task create_tenant: :environment do 
      
      Tenant.all.each do |t|
        Apartment::Database.switch(t.name)
        Tenant.where(hoc_ky: t.hoc_ky, nam_hoc: t.nam_hoc, name: t.name).first_or_create!
      end
    end
  end
end
