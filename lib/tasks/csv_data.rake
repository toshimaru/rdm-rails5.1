 namespace :csv_data do
  desc "Create user data with posts"
  task create: :environment do
  	USER_CSV_FILE = "db/user_seed.csv"
  	POST_CSV_FILE = "db/post_seed.csv"

    puts "=== create user & post CSV ==="
    CSV.open(USER_CSV_FILE, 'w') do |user_csv|
      CSV.open(POST_CSV_FILE, 'w') do |post_csv|
        (1..100_000).each do |i|
          date = Faker::Date.between(Date.new(2014), Date.new(2018, 4))
          user_csv << ["#{i}#{Faker::Internet.email}", Faker::Name.name, rand(0..2000), date, date]
          
          rand(0..10).times do |j|
            post_date = date + j.days
            post_csv << [i, :title, :content, rand(1..100), post_date, post_date]
          end
        end
      end
    end
  end
end
