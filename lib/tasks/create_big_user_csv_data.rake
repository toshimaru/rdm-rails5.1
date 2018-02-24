require 'csv'

desc "Creates CSV including million users"
task :create_big_user_csv_data do
  USER_CSV_FILE = "db/user_seed.csv"

  CSV.open(USER_CSV_FILE, 'w') do |csv|
    500_000.times do |i|
      date = Faker::Date.between(5.years.ago, Date.today).to_s
      csv << ["#{i}#{Faker::Internet.email}", Faker::Internet.password, date, date]
    end
  end
end
