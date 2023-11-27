# Ticket Management API

This Rails application provides an API for managing tickets with associated tags and a webhook sender. It's designed to demonstrate basic API functionalities including creating records, handling associations, and triggering external actions (webhooks).

## Features

- **Create Tickets**: API endpoint to create tickets with a user ID, title, and associated tags.
- **Tag Management**: Automatically manages tags, storing them with a count of their occurrences.
- **Webhook Notification**: Sends a webhook request to a predefined URL with the tag that has the highest count.
- **Validation**: Ensures that each ticket has a user ID, a title, and no more than five tags.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- Ruby 3.2.2
- Rails 7.1.2
- SQLite3 (as the database for Active Record)

### Key Gems Used

- **HTTParty**: Simplifies making HTTP requests, used for the webhook functionality.
- **RSpec-Rails**: Testing framework for Rails.
- **FactoryBotRails**: A fixtures replacement tool for setting up test data in Rails.

### Installation

Clone the repository and install the dependencies:

```
git clone [repository-url]
cd [project-directory]
bundle install
```

Create your database and run your migrations:

```
rails db:create
rails db:migrate
```

### Running the Application

Start the Rails server:

```
rails server
```

## API Endpoints

### POST /tickets
Create a new ticket with user ID, title, and tags.

```
{
  "user_id": 1234,
  "title": "Sample Ticket",
  "tags": ["tag1", "tag2"]
}
```

## Testing

Run the test suite to ensure that everything is working correctly:

```
bundle exec rspec
```


