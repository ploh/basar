namespace :passenger do
  desc "Stop Passenger"
  task :stop do
    on roles :app do
      within release_path do
        maintenance_text = ENV["STOP_TEXT"] || "Bitte versuchen Sie es später wieder"
        html_content = File.read(release_path.join('app/views/stop/503.html')).sub('MAINTENANCE_TEXT', maintenance_text)
        upload! StringIO.new(html_content), release_path.join('public/stop/503.html')
        execute :touch, release_path.join('public/stop/stop.txt')
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
