# README

## Odds and Ends

* Ruby version `2.0.0`

* Rails version `4.2.0`

* Access to a unix shell is assumed

## Getting the Application Running Locally

1. (OS X only) Download and install Homebrew

1. Install MySQL `brew install mysql`

1. Check out the repository: `git clone git@github.com:caramcc/char-dir-warehouse.git`

Also, make sure you're developing on a new branch rather than on `develop` or `master`. Branch naming convention should be `{feature or defect}/{username}/{description}`, e.g., `feature/caramcc/build-json-api`

1. Start your MySQL server: `mysql.server start`

1. Migrate and seed the databases: `rake db:migrate && rake db:seed`

1. Start the application server: `rails s`

1. Navigate to http://localhost:3000/ to access the app.


## Deploying

* Deploys to Heroku automatically when commits are made to `master `

* Can be manually pushed up to Heroku from the command line: `git push heroku master`


## TODO

* Validations for Character model

* Testing the controllers

* ~~Build out a JSON API~~

* Census and Reaping and stats

* ~~more useful 'look at dis info' pages~~

* ~~populate front page with anything~~

* ~~implement search (see: nav bar)~~

* ~~make nav bar not suck also (although rn it sucks less)~~