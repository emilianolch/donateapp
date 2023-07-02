# DonateApp

This is a simple Ruby on Rails application to manage donations for a non-profit organization, using MercadoPago as payment gateway.

## Setup development environment

In order to setup the development environment, you need to have installed PostgreSQL, Ruby 3.2.1, NodeJS and ngrok.

Install the gems and npm packages:

```
bundle install
npm install
```

Create the database and load the schema:

```
rails db:create
rails db:schema:load
```

Seed the database with the default admin user:

```
rails db:seed
```

This will create an admin user with email `admin@donate.app` and password `123456`.

Configure the MercadoPago credentials in the `.env` and `.env.test` files:

```
MP_ACCESS_TOKEN=YOUR_ACCESS_TOKEN
MP_INTEGRATOR_ID=YOUR_INTEGRATOR_ID
```

Run the tests:

```
bundle exec rspec
```

Start the server:

```
./bin/dev
```

### ngrok

The MercadoPago API requires a public URL to send notifications. You can use [ngrok](https://ngrok.com/) to expose your local server to the internet.

Start ngrok:

```
ngrok http 3000
```

Once ngrok is running, you will see a public URL in the console. Open that URL in your bowser to access the app. Don't access the app using `localhost:3000` because MercadoPago won't be able to send notifications to your local server.

## Live demo

The main branch is automatically deployed to Heroku. You can access the app at https://donate.emiliano.cloudns.nz/
You can use the default admin user to access the admin panel.

## TODO

- Setup a mailer addon in Heroku to send emails in production.
