class Drivers < Sinatra::Base
  before do
    request.body.rewind
    data = request.body.read
    @payload = ActiveSupport::JSON.decode(data) if data.size > 0
  end


  set(:authorized) do |role|
    condition do
      token = ::Token.where(token: request.env["HTTP_ACCESS_TOKEN"]).first
      
      result = case token.try(:tokenized_type)
        when 'Manager'
          (role == :manager || role == :any) && (@actor = token.tokenized)
        when 'Driver'
          (role == :driver || role == :any) && (@actor = token.tokenized)
      end

      unless result
        redirect '/unauthorized', 401
      end
    end
  end

  post '/tasks', authorized: :manager do
    task = Task.new(@payload)
    if task.save
      json task
    else
      json task.errors, status: 400
    end
  end

  post '/tasks/available', authorized: :any do
    if @payload["location"]
      json Task.around(@payload["location"])
    else    
      status 400
      json "No location received"
    end
  end

  put '/tasks/:id/assign', authorized: :driver do
    json Task.find(params[:id]).tap { |task| task.assign! }
  end

  put '/tasks/:id/finish', authorized: :driver do
    json Task.find(params[:id]).tap { |task| task.finalize! }
  end

  get '/unauthorized' do
    body 'Not authorized'
    status 403
  end
end
