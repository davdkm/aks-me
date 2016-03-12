class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  set :session_secret, "let_me_aks_you_a_question"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/' do
    erb :index
  end

  helpers do
    def redirect_if_not_logged_in
      if !logged_in?
        redirect "/login"
      end
    end

    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find_by_id(session[:id])
    end
  end

end
