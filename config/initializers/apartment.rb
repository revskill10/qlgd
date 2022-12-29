Apartment.configure do |config|
  # set your options (described below) here
  config.database_names = lambda{ Tenant.pluck(:name) }
end