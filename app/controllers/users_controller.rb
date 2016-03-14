class UsersController < ApplicationController

  get '/signup' do
    redirect to '/questions' unless !logged_in?
    erb :'users/signup'
  end

  post '/signup' do
    if params[:user].values.include?('')
      redirect to '/signup'
    else
      user = User.new(params[:user])
      if user.save
        session[:id] = user.id
        redirect to '/questions'
      end
    end
    redirect to '/failure'
  end

  get '/login' do
    redirect to '/questions' unless !logged_in?
    erb :'users/login'
  end

  post '/login' do
    if params.values.include?('')
      redirect to '/login'
    end
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect to '/questions'
    else
      erb :'users/login'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

end
