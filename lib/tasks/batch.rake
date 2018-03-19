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

  desc "original1 improvement 1"
  task original1_improved1: :environment do
    print_memory_usage do
      print_time_spent do
        User.where("created_at >= ?", Date.new(2017))
            .find_each do |user|
          user.point += 100
          user.save
        end
      end
    end
  end

  desc "original1 improvement 2"
  task original1_improved2: :environment do
    print_memory_usage do
      print_time_spent do
        User.where("created_at >= ?", Date.new(2017))
            .update_all("point = point + 100")
      end
    end
  end

  desc "Ruby Aggregation Code"
  task original2: :environment do
    print_memory_usage do
      print_time_spent do
        user_like_counts = []
        User.all.each do |user|
          user_like_counts << { 
            name: user.name,
            total_like_count: user.posts.sum(&:like_count)
          }
        end
        user_like_counts
          .sort_by! { |u| u[:total_like_count] }
          .reverse!
          .take(100).each do |u|
            puts "#{u[:name]}(#{u[:total_like_count]})"
          end
      end
    end
  end

  desc "original2 improvement 1"
  task original2_improved1: :environment do
    print_memory_usage do
      print_time_spent do
        Post.group(:user_id)
            .select("user_id, SUM(like_count) AS like_count")
            .order("like_count DESC")
            .limit(100).each do |post|
          puts "#{post.user.name}(#{post.like_count})"
        end
      end
    end
  end

  desc "original2 improvement 2"
  task original2_improved2: :environment do
    print_memory_usage do
      print_time_spent do
        Post.includes(:user)
            .group(:user_id)
            .select("user_id, SUM(like_count) AS like_count")
            .order("like_count DESC")
            .limit(100).each do |post|
          puts "#{post.user.name}(#{post.like_count})"
        end
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
end
