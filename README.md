# Drive App

## Local Environment Set Up
The `Drive Debug Localhost` scheme allows for developing locally without hitting the heroku database.

### Set Up
1. Download [backend repo](https://github.com/Drive-iOS/Drive-API)
2. Install postgres `brew install postgresql`
3. Start postgres service `brew services start postgresql`
4. Begin running postgres `psql postgres`
5. Create database user `postgres=# CREATE ROLE your_username_here WITH LOGIN PASSWORD 'your_password_here';`
6. Update database user role `postgres=# ALTER ROLE your_username_here CREATEDB;`
7. Connect to postgres `psql -d postgres -U your_username_here`
8. Create database `postgres=> CREATE DATABASE drive;`
9. Create tables by pasting entire file [build_script.sql](https://github.com/Drive-iOS/Drive-API/blob/main/postgres/release1.0.0/build_script.sql)