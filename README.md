# README

## Odds and Ends

* Ruby version `2.2.1`

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


## API

####route: `/api/find/character`

*Returns:* JSON array of characters that match the given params

*Primary Use:* advanced search for characters

*Accepted URL Parameters:* 

`created_before` unix timestamp

`created_after` unix timestamp

`last_edit_before` unix timestamp

`last_edit_after` unix timestamp

`first` character's first name (string)

`last` character's last name (string)

`area` one of (1..13) or Capitol or Wanderer

`fc_first` character's FC's first name

`fc_last` character's FC's last name

`approved` boolean (is the character approved?)

`fc_approved` boolean (is the character's fc approved?)

`gender` one of 'Male', 'Female', 'Other'

`age_lt` integer (characters where character_age < given_age)

`age_gt` integer (characters where character_age > given_age)

`age_lte` integer (characters where character_age <= given_age)

`age_gte` integer (characters where character_age >= given_age)

`age` integer (characters where character_age == given_age)

`special` one of Peacekeeper', 'Victor', 'Gamemaker', 'Avox', ''

`special_not` !(one of 'Peacekeeper', 'Victor', 'Gamemaker', 'Avox', '')

`user` int, user's warehouse id

`ao` one of 'or' or 'and' - used to compare the fields together. Default is 'and'. (e.g `?first=Arbor&last=Halt&ao=or` would return any character whose first name matches "Arbor" || whose last name matches "Halt" — so "Arbor Smith" and "Cedar Halt" would also appear in the results)

#### route: `/api/characters`

*Returns:* a list of all active characters that match the given params.

*Primary Use:* displaying lists of characters by district.

`area` (1..13) or Capitol or Wanderer, accepts list of multiple params (e.g. `?area=1,3,Capitol` will return a list of characters belonging to district 1, district 3, or the Capitol)



## TODO

* Validations for Character model

* Engine Integreations (Hero)

* Testing the controllers

* ~~Build out a JSON API~~

* Census and Reaping and stats

* ~~more useful 'look at dis info' pages~~

* ~~populate front page with anything~~

* ~~implement search (see: nav bar)~~

* ~~make nav bar not suck also (although rn it sucks less)~~