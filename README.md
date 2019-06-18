## ryda_app
Ryda App is a carpool application which allows an Andelan car owner to give a ride to another Andelan who does not have a car or who is not feeling like driving his/her own personal car.

#### Ruby version
  - ruby 2.6.2
  - rails 5.2.3

#### Badges
  [![Build Status](https://travis-ci.org/emekafredy/ryda_app.svg?branch=master)](https://travis-ci.org/emekafredy/ryda_app) |
  [![Coverage Status](https://coveralls.io/repos/github/emekafredy/ryda_app/badge.svg?branch=master)](https://coveralls.io/github/emekafredy/ryda_app?branch=master)


#### System dependencies
  - listed in `Gemfile`


#### Services
  - [Rails](https://rubyonrails.org/) | [Postgres](https://www.postgresql.org/) | [Google Auth](https://console.developers.google.com/apis/library)


#### App Setup instructions
  - Make sure you have Ruby, Rails(with the versions above) and PostgresQL installed in your machine.
  - Clone repo: `git clone https://github.com/emekafredy/ryda_app.git`
  - Change directory with `cd ryda_app`
  - Run `bundle install` to install dependencies
  - Run `rails db:create` and `rails db:migrate` to create the needed databases and run migrations.
  - Run `rails s` to start up the app.
  - Visit the url `http://localhost:3000` to run the app.

#### App Managament Board
  - [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/2351545)

#### Production URL
  - [Ryda-App](https://ryda-app.herokuapp.com/)

#### How to run the test suite
  - Run `rspec` in the terminal to run the application unit tests
