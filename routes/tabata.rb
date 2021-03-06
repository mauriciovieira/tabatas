class Tabatas < Sinatra::Base
  before '/tabatas*' do
    halt 401, 'Access denied :(' unless params[:key] == ApiKey.first.key
  end

  get '/tabatas' do
    return 'No tabatas!' if Tabata.count == 0
    Tabata.all.map { |tabata| "#{tabata.done ? 'X' : ' '} #{tabata.name}" }.join "\n"
  end

  post '/tabatas/add' do
    tabata = Tabata.new(name: params[:name])
    return tabata.errors.messages.to_s if !tabata.save
    "'#{tabata.name}' saved successfully"
  end

  post '/tabatas/do' do
    return 'No tabatas!' if Tabata.count == 0
    message = ''
    if Tabata.where(done: false).count == 0
      message = "All tabatas done! Resetting...\n"
      Tabata.reset_all
    end
    tabata = Tabata.random
    message << "You should do #{tabata.name}!"
  end

  post '/tabatas/mark' do
    tabata = Tabata.where(name: params[:name]).first
    tabata.done = true
    tabata.save!
    "'#{tabata.name}' marked done"
  end

  post '/tabatas/unmark' do
    tabata = Tabata.where(name: params[:name]).first
    tabata.done = false
    tabata.save!
    "'#{tabata.name}' marked not done"
  end

  delete '/tabatas' do
    tabata = Tabata.where(name: params[:name]).first
    message = "'#{tabata.name}' deleted successfully"
    tabata.delete
    message
  end

end
