# README

## Create User CSV Data

```
$ bundle exec rails create_big_user_csv_data
```

## Load CSV Data

```
$ mysql -u root --local-infile -e "LOAD DATA LOCAL INFILE './db/user_seed.csv' INTO TABLE rdm_development.users FIELDS TERMINATED BY ',' (email, name, point, created_at, updated_at)"
```

## Reset User DATA

```
$ bundle exec rails db:migrate:reset
```
