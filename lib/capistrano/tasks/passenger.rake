namespace :passenger do
  desc "Stop Passenger"
  task :stop do
    on roles :app do
      within release_path do
        execute :touch, release_path.join('public/stop/stop.txt')
        put release_path.join('public/stop/stop.js') <<JAVA_SCRIPT
document.write('\\
  #{ENV["STOP_TEXT"] || "<p>Bitte versuchen Sie es später wieder</p>"}\\
');
JAVA_SCRIPT
      end
    end
  end

  desc "Start (or un-stop) Passenger"
  task :start do
    on roles :app do
      within release_path do
        execute :rm, release_path.join('public/stop/stop.txt')
      end
    end
  end
end
