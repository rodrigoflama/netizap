json.extract! message, :id, :text, :result, :protocol, :response, :recipient, :sender, :url, :token, :appname, :created_at, :updated_at
json.url message_url(message, format: :json)
