namespace :passenger do
  desc "Stop Passenger"
  task :stop do
    on roles :app do
      within release_path do
        execute :mkdir, '-p', release_path.join('tmp')
        execute :touch, release_path.join('tmp/stop.txt')
      end
    end
  end

  desc "Start (or un-stop) Passenger"
  task :start do
    on roles :app do
      within release_path do
        execute :rm, release_path.join('tmp/stop.txt')
      end
    end
  end
end
