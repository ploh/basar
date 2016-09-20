require 'fileutils'
require 'yaml'


def load_records column_names, records
  ActiveRecord::Base.connection.transaction do
    columns = column_names.map{|cn| ActiveRecord::Base.connection.columns('users').detect{|c| c.name == cn}}
    quoted_column_names = column_names.map { |column| ActiveRecord::Base.connection.quote_column_name(column) }.join(',')
    quoted_table_name = ActiveRecord::Base.connection.quote_table_name('users')
    records.each do |record|
      quoted_values = record.zip(columns).map{|c| ActiveRecord::Base.connection.quote(c.first, c.last)}.join(',')
      # ActiveRecord::Base.connection.execute("INSERT INTO #{quoted_table_name} (#{quoted_column_names}) VALUES (#{quoted_values})")
      puts "INSERT INTO #{quoted_table_name} (#{quoted_column_names}) VALUES (#{quoted_values})"
    end
  end
end


dump_dir = File.join Rails.root, 'db', 'dump'
dump_users_file = File.join dump_dir, 'users.yml'

# FileUtils.rm_r dump_dir, verbose: true
# system 'dir=dump rake db:data:dump_dir'

@dump = YAML.load_file dump_users_file

@records = @dump['users']['records']
@column_names = @dump['users']['columns']

@old_users = @records.map do |record|
  raise unless @column_names.size == record.size
  User.new @column_names.zip(record).to_h
end

ActiveRecord::Base.connection.transaction do
  new_count = 0
  old_count = 0
  @old_users.each do |old_user|
    if old_user.seller?
      corrupted_user = User.find(old_user.id)
      unless corrupted_user
        p old_user
        raise "could not find existing user"
      end
      if corrupted_user.created_at > Time.zone.local(2016, 6, 17)
        p old_user, corrupted_user
        raise "corrupted user too new, probably not corrupt"
      end

      corrupted_user.encrypted_password = old_user.encrypted_password
      corrupted_user.email = old_user.email
      corrupted_user.first_name = old_user.first_name
      corrupted_user.last_name = old_user.last_name
      corrupted_user.skip_confirmation!
      corrupted_user.skip_reconfirmation!

      new_user = User.find_by_email corrupted_user.email
      puts
      puts
      puts

      if new_user
        new_user.old_number = corrupted_user.old_number
        new_user.old_initials = corrupted_user.old_initials
        new_user.skip_confirmation!
        new_user.skip_reconfirmation!
        puts "Corrected new user: #{new_user.inspect}"
        new_user.save!
        corrupted_user.destroy
        new_count += 1
      else
        puts "Corrected old user: #{corrupted_user.inspect}"
        corrupted_user.save!
        old_count += 1
      end
    end
  end
  puts "corrected new: #{new_count}"
  puts "corrected old: #{old_count}"

  # raise "dry run"
end

# load_records @column_names, @records
