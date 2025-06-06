# TODO App

This is a simple TODO app that I am building to learn Ruby on Rails, and to get a better understanding of how to build a web application.

## Features

- [x] Create a new task
- [x] Edit a task
  - [x] Edit inline
- [x] Delete a task
  - [x] Confirm deletion
- [x] Search by columns
- [x] Sort by columns
- [x] Add tests
  - [x] Models
  - [x] Services
  - [x] Channels
  - [x] Controllers

## Technologies

*   Ruby on Rails 5.2.8.1
*   Ruby 2.5.9
*   PostgreSQL 12.7
*   Bootstrap 5.3.2
*   Font Awesome 4.7.0

## Installation

1. Clone the repository
2. Run `bundle install`
3. Edit the credentials file with your database credentials `EDITOR="nano" bin/rails credentials:edit`
4. Run `rails db:create`
5. Run `rails db:migrate`
6. Run `rails server`

## Usage

After completing the installation steps, you can start using the application:

1.  Open your web browser and navigate to `http://localhost:3000`.
2.  You should see the main page of the TODO app.
3.  To create a new task, click on the "New Task" button (or similar) and fill in the details.
4.  You can edit or delete tasks using the provided interface.

## Contributing

Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix (`git checkout -b feature/your-feature-name` or `git checkout -b bugfix/issue-number`).
3.  Make your changes and commit them with clear and concise messages.
4.  Ensure that all tests pass. You can run tests using `rails test`.
5.  Submit a pull request to the `main` branch of the original repository.

## Deployment

Deploying a Ruby on Rails application can be done in various ways. Here are a few common strategies:

*   **Heroku:** A popular Platform as a Service (PaaS) that simplifies deployment. You can find more information in the [Heroku Dev Center](https://devcenter.heroku.com/categories/ruby).
*   **Docker:** Containerize your application with Docker for consistent environments across development, staging, and production. You can then deploy these containers to various cloud providers or your own servers.
*   **Capistrano:** A remote server automation and deployment tool written in Ruby. It's highly configurable and widely used for deploying Rails applications. More details can be found on the [Capistrano website](https://capistranorb.com/).

Choose the deployment method that best suits your needs and infrastructure.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
