require 'csv'

desc "Creates CSV including million users"
task :create_big_user_csv_data do
  CSV.open("db/user_seed.csv", 'w') do |csv|
    500_000.times do |i|
      date = Faker::Date.between(5.years.ago, Date.today).to_s
      csv << [Faker::Internet.email, Faker::Internet.password, date, date]
    end
  end
end
