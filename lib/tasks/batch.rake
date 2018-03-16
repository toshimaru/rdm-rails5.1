namespace :batch do
  desc "Add 100pt to users created since 2017"
  task original1: :environment do
    print_memory_usage do
      print_time_spent do
        User.all.each do |user|
          if user.created_at >= Date.new(2017)
            user.point += 100
            user.save
          end
        end
      end
    end
  end

  desc "Aggregate"
  task original2: :environment do
  end

  def print_memory_usage
    memory_before = `ps -o rss= -p #{Process.pid}`.to_i
    yield
    memory_after = `ps -o rss= -p #{Process.pid}`.to_i

    puts "Memory: #{((memory_after - memory_before) / 1024.0).round(2)} MB"
  end

  def print_time_spent
    time = Benchmark.realtime do
      yield
    end

    puts "Time: #{time.round(2)} secs"
  end
end
