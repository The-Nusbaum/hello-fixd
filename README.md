# Requirements
- Docker
- Docker Compose
- open ports 3000 and 5432 on localhost

# Setup
Run the following to initialize the project, hydrate the database, and generate API docs

`docker compose run --rm app /bin/bash -c "gem install rails bundler; bundle install; bundle exec rake db:create db:migrate db:seed; RAILS_ENV=test bundle exec rails rswag"`

This will take a moment

# Tests
`docker compose run --rm app bin/bash -c "RAILS_ENV=test bundle exec rspec"`

# Usage

1. Run the following and wait for the ready message from Puma
`docker compose up`
2. navigate to http://localhost:3000/api-docs/index.html
3. click authorize, enter
    username: lucile@example.org
    passwd: temp_dev_passwd
4. Execute POST /api-keys
5. Copy bearer token froim response, enter into second field in authorization
6. Check out the other end points
7. ???
8. Profit!

# Notes
1. I left the secrets in the repo because in this case I am not concerned with keeping them secret
2. I could not get the Request Spec POST requests to work, it does not seem to be sending the data in the body with :formData or :body. I know I have tested POST endpoints in the past but could not get these to behave. Worked around it by passing parameters in the query, they work properly in postman