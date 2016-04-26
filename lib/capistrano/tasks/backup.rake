def with_verbosity level
  old_level = SSHKit.config.output_verbosity
  begin
    SSHKit.config.output_verbosity = level
    yield
  ensure
    SSHKit.config.output_verbosity = old_level
  end
end

def backup_path
  release_path.join "../backup"
end


namespace :backup do
  desc "Create new yml backup"
  task :create do
    on roles :db do
      within release_path do
        with rails_env: :production do
          rake "db:data:dump"
          execute :cp, "db/data.yml", backup_path.join("#{Time.now.utc.strftime("%Y%m%d_%H%M%S")}.data.yml")
        end
      end
    end
  end

  desc "Download latest yml backup"
  task :download do
    on roles :db do
      backup_files = with_verbosity Logger::INFO do
        capture :ls, backup_path
      end
      latest_yml_backup = backup_files.split("\n").find_all {|filename| filename.end_with? "data.yml"}.last

      download! backup_path.join(latest_yml_backup), "db/data.yml"
    end
  end
end
