#!/usr/bin/env bash
# exit on error
set -o errexit

RAILS_ENV=production bundle install
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

# RAILS_ENV=production bundle exec rails db:migrate
