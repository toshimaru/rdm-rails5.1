namespace :batch do
  desc "Add 100pt to users created since 2017"
  task original: :environment do
    print_memory_usage do
      print_time_spent do
        User.all.each do |user|
          if user.created_at >= "2017-01-01"
            user.point += 100
            user.save
          end
        end
      end
    end
  end

  POINT_DATE = Date.new(2017)

  desc "improvement 1"
  task improvement1: :environment do
    print_memory_usage do
      print_time_spent do
        User.all.each do |user|
          if user.created_at >= POINT_DATE
            user.point += 100
            user.save
          end
        end
      end
    end
  end

  desc "improvement 2"
  task improvement2: :environment do
    print_memory_usage do
      print_time_spent do
        User.where("created_at >= ?", POINT_DATE).each do |user|
          user.point += 100
          user.save
        end
      end
    end
  end


  desc "improvement 3"
  task improvement3: :environment do
    print_memory_usage do
      print_time_spent do
        User.where("created_at >= ?", POINT_DATE).find_each do |user|
          user.point += 100
          user.save
        end
      end
    end
  end

  desc "improvement 4"
  task improvement4: :environment do
    print_memory_usage do
      print_time_spent do
        User.where("created_at >= ?", POINT_DATE).in_batches do |users|
          users.update_all("point = point + 100")
        end
      end
    end
  end

  desc "improvement 5"
  task improvement5: :environment do
    print_memory_usage do
      print_time_spent do
        User.where("created_at >= ?", POINT_DATE).update_all("point = point + 100")
      end
    end
  end

  desc "benchmark"
  task benchmark: :environment do
    require 'benchmark/ips'

    created_at = User.first.created_at
    Benchmark.ips do |x|
      x.report("String") {
        (created_at > "2016-01-01")
      }
      x.report("Date") {
        (created_at > Date.new(2016))
      }
      x.report("DateTime") {
        (created_at > DateTime.new(2016))
      }
      x.report("to_date") {
        (created_at > "2016-01-01".to_date)
      }

      x.compare!
    end
  end
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
