# Ukio's coding test

Welcome! First of all, thanks for your interest in being part of [Ukio's mission](https://ukio.com/about-us)! Here you'll find all the instructions to set up the environment and the requirements for the exercise.

# Preamble

At Ukio we embrace AI and we believe the best engineers today should know how to use it effectively to their advantage. As such, we do welcome you to take this exercise with a co-pilot and really go the extra mile with the project making it production ready. 
In the interview session following the coding round, we will want to make sure you understand the code, why you make some decisions in your solution, and also get to know you better as an Engineer. As such, we do advice not to just blindly ask the AI to do everything for you in one go. :)


## Elixir

If you're using `asdf`, you should be ready as we've defined the required version in the `.tool-versions` file. If it's not your case, you need Elixir >=v1.16; you can find [here](https://elixir-lang.org/install.html) instructions to install it.

Once installed, you need to run the following commands.

1. > docker-compose up -d
2. > mix setup

You should already have the project up and running. You could run the tests to check if everything is working as expected

> mix test

To test manually, you can:

> mix phx.server

This will start the Phoenix endpoint. You can check it at [`localhost:4000`](http://localhost:4000) from your browser. 


## Coding test
After putting our first API MVP online, we're ready to face a second iteration, and here is where we need your help. Right now our API is capable of handling simple bookings, but we're expanding, and we want to be able to rent our apartments in more cities. Let's go into detail to our models, API, and requirements for those new markets

### Models
1. Apartments:
    * ID
    * Name
    * Address
    * Zip code
    * Monthly price
    * Square meters


2. Bookings
    * ID
    * Check-in
    * Check-out
    * Apartment_id
    * Monthly rent

### API
1. GET /api/apartments
  > Return the lists of apartments with all the fields we have in the model
2. POST /api/bookings
  > Create a new booking. For its creation, we need the following body
  ```JSON
    {
      check_in: date
      check_out: date
      apartment_id: integer
    }
  ```
  Returns a `201` when the booking has been created. The response body looks like follows:
  ```JSON
    {
      check_in: date
      check_out: date
      apartment_id: integer
      monthly_rent: integer
      deposit: integer
      utilities: integer
    }
  ```

### Requirements
We have two different tasks here:
1. On one hand, we realized we're not checking availability before booking, so we need to update our API to return a `401` in case the apartment is unavailable for the selected dates.
2. Furthermore, as we're expanding, we've discovered that not all markets work in the same way. Our next market, "Mars", has different deposit and utilities conditions:
    * The deposit is a full monthly rent
    * Utilities are not a fixed amount and are linked to the apartments' square meters.

### What we look for
We've tried to create a simple test but, also, something that lets us know more about you. Some points that could help you:
* Feel free to change anything you think must/can be changed: variable names, code structure, etc.
* Add as many tests as you need/want. We're not looking for 100% test coverage.
* From now on, this is your project! You can change/refactor/delete whatever you think is needed. Just let us see how you like your production code

### Time to complete
We expect a solution within 3 days after sending you the test. Let us know if you need more time for some reason.

### How to submit
Please push your project to a private GitHub repository and add @engineering-at-ukio as a collaborator so we can review your work.



## Learn more
  * Elixir language website: https://elixir-lang.org/
  * Elixir official documentation: https://hexdocs.pm/elixir/Kernel.html
  * Official Phoenix website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
