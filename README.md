# Hi
---
#### Here is the challenge for HomeTime

# To start
1. Install all gem `bundle`
2. Setup database `rails db:create && rails db:migrate`
3. Run the server `rails s`, voila

# Test
We are using rspec and rswag for nice documentation
You can visit the documentation by heading to `/api-docs`
To run the test just run `rspec`

## Known issues
1. We have a database cleaner issues. Rspec didnt truncate the database after test suites. It cause the test to failed when ran again.
2. The test suite can be refactored. But I dont have the time for that


> Hoping to hear back soon. =)
