# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# CSV has to be saved in RAILS_ROOT/data with ';' as field delimiter and without any text delimiter
def load_initial_sellers(csv_file)
  csv_line_regexp = /^\s*([[:alpha:]]/
  lines = File.readlines(File.join(Rails.root, 'data', csv_file))

  lines.shift unless build_seller_from_line(line)
  sellers = []
  lines.each_with_index do |line|
    seller = build_seller_from_line(line)
    if seller
      sellers << seller
    else
      raise "Not a valid description of a seller: #{line}"
    end
  end
  Seller.transaction do
    sellers.each {|seller| seller.save!}
  end
end

def build_seller_from_line(line)
  fields = line.split(";")
  code, name, rate_category = fields[0], fields[1].strip, fields[3].strip.upcase
  result = Seller.new
  pair = split_code(code)
  if pair
    seller.initials = pair[0]
    seller.number = pair[1]
  end
  seller.name = name
  seller.rate_in_percent = case rate_category
    when "C"
      10
    when "B"
      15
    else
      20
    end
  result = nil unless result.valid?
  result
end

load_initial_sellers 'initial_sellers.csv'
