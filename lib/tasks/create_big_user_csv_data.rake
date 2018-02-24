require 'csv'

desc "Creates CSV including million users"
task :create_big_user_csv_data do
  USER_CSV_FILE = "db/user_seed.csv"

  CSV.open(USER_CSV_FILE, 'w') do |csv|
    500_000.times do |i|
      date = Faker::Date.between(Date.new(2014), Date.new(2018, 4)).to_s
      csv << ["#{i}#{Faker::Internet.email}", Faker::Internet.password, date, date, rand(1..2000)]
    end
  end
end
