class Drivers < Sinatra::Base

  set(:authorized) do |role|
    condition do
      token = ::Token.find(token: request.env["HTTP_ACCESS_TOKEN"])
      return false if token.nil?
      
      if token.role == 'manager'
        (role == token.role || role == :any) && @actor = Manager.find(token: token)
        true
      elsif token.role == 'driver'
        (role == driver.role || role == :any) && @actor = Driver.find(token: token)
        true
      end
    end
  end

  post '/tasks', authorized: :manager do
    Task.create(params)
  end

  get '/tasks/available', authorized: :any do
    Task.around(params[:location])
  end

  put '/tasks/:id/assign', authorized: :driver do
    Task.find(params[:id]).assign(params[:location])
  end

  put '/tasks/:id/finish', authorized: :driver do
    Task.find(params[:location]).finish!
  end
end
