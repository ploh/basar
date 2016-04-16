# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# CSV has to be saved in RAILS_ROOT/data with ';' as field delimiter and without any text delimiter
def load_initial_sellers(csv_file)
  lines = File.readlines(File.join(Rails.root, 'data', csv_file)).map {|line| line.chomp}

  lines.shift unless build_seller_from_line(lines.first).valid?
  sellers_with_lines = []
  lines.each_with_index do |line|
    sellers_with_lines << [ build_seller_from_line(line), line ]
  end
  Seller.transaction do
    sellers_with_lines.each do |seller, line|
      if seller.valid?
        seller.save!
        Rails.logger.info "Saved seller: #{seller}"
        p "Saved seller: #{seller}"
      else
        raise "Seller #{seller} from line '#{line.chomp}' not valid! #{seller.errors.full_messages.join("; ")}"
      end
    end
  end
end

def build_seller_from_line(line)
  fields = line.split(";", -1)
  code, name, rate_category = fields[0], fields[1].strip, fields[2].strip.upcase
  seller = Seller.new
  pair = Seller.split_code(code)
  if pair
    seller.initials = pair[0]
    seller.number = pair[1]
  end
  seller.name = name
  seller.rate_in_percent = case rate_category
    when "D"
      10
    when "C"
      10
    when "B"
      15
    else
      20
    end
  seller
end

# load_initial_sellers 'initial_sellers.csv'

user = User.new(email: "admin@admin", first_name: "admin", last_name: "admin", password: "testpasswort", role: :admin)
user.skip_confirmation!
user.save!
