# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create an admin user
User.create(email: "admin@donate.app", password: "123456", password_confirmation: "123456", admin: true)
