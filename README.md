# Aika

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## API

You can create timesheet entries by sending a `POST` request to `/api/entries/<date>`:

```
> curl -H "Content-Type: application/json" \
    -X POST \
    -d '{
          "user_id": "<your user_id>",
          "api_token": "<your api_token>",
          "entry": {
            "description": "test description",
            "time": "1.25"}}' \
   'http://localhost:4000/api/entries/2017-11-09'

"{\"id\":18,\"duration\":75,\"description\":\"test description\",\"date\":\"2017-11-09\"}"%
```
