Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3000'  # Ensure this matches the port of your Next.js app

    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :delete, :options],
             credentials: false  # If your frontend needs to support cookies/session
  end
end
