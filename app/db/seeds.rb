require 'csv'
#TODO: this is super slow, see if we can speed it up. seed_dump?
# INPUTS = %w[user post comment rating]
INPUTS = %w[user post comment rating]

INPUTS.each do |input|
  puts "processing #{input}"
  klass = input.titleize.constantize
  raw = File.read(Rails.root.join('db',"#{input.pluralize}.csv"))
  parsed = CSV.parse(raw, :headers => true, :encoding => 'UTF-8', :liberal_parsing => true)  
  parsed.each do |row|
    if klass.name == 'Rating'
      row["rating"] = "5" if row["rating"].to_i > 5
      row["rating"] = "1" if row["rating"].to_i < 1
    end
    entity = klass.create! row.to_hash
    print "."
  end
  puts "\ndone"
  #seeding seems to have broken the autoincrement counts
  ActiveRecord::Base.connection.reset_pk_sequence!(input.pluralize)
end