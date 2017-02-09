require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate-bootstrap'

class UsersController < ApplicationController
  helpers WillPaginate::Sinatra::Helpers

  get '/signup' do
    redirect to '/questions' unless !logged_in?
    erb :'users/signup'
  end

  post '/signup' do
    if params[:user].values.include?('') || User.find_by_slug(params[:user][:username]) || User.find_by(email: params[:user][:username])
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
    @questions = @user.authored_questions.order('created_at DESC').paginate(:page => params[:questions_page])
    @comments = @user.comments.order('created_at DESC').paginate(:page => params[:comments_page])
    erb :'users/show'
  end

end
