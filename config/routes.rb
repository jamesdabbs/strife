Rails.application.routes.draw do
  post '/echo' => 'echo#respond'

  root to: 'echo#status'
end
