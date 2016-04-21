namespace :passenger do
  desc "Restart Passenger"
  task :restart do
    on primary roles :app do
      run "touch #{current_path}/tmp/restart.txt"
    end
  end

  desc "Stop Passenger"
  task :stop do
    on primary roles :app do
      run "touch #{current_path}/tmp/stop.txt"
    end
  end

  desc "Start (or un-stop) Passenger"
  task :start do
    on primary roles :app do
      run "rm -f #{current_path}/tmp/stop.txt"
    end
  end
end
