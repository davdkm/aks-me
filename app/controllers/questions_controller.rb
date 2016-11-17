require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate-bootstrap'

class QuestionsController < ApplicationController
helpers WillPaginate::Sinatra::Helpers
  get '/questions' do
    @questions = Question.paginate(:page => params[:page])
    erb :'questions/index'
  end

  get '/questions/new' do
    redirect_if_not_logged_in
    erb :'questions/new'
  end

  post '/questions' do
    redirect_if_not_logged_in
    question = current_user.authored_questions.build(content: params[:content])
    if question.content.empty?
      redirect to '/questions/new'
    else
      question.save
      redirect to "/questions/#{question.id}"
    end
  end

  get '/questions/:id/edit' do
    redirect_if_not_logged_in
    if @question = current_user.authored_questions.find_by(id: params[:id])
      erb :'questions/edit'
    else
      redirect to '/login'
    end
  end

  patch '/questions/:id' do
    question = Question.find_by_id(params[:id])
    if params[:content].empty?
      redirect to "/questions/#{question.id}/edit"
    else
      question.update(content: params[:content])
      redirect to "/questions/#{question.id}"
    end
  end

  get '/questions/:id' do
    @question = Question.find_by_id(params[:id])
    erb :'questions/show'
  end

  delete '/questions/:id/delete' do
    redirect_if_not_logged_in
    question = Question.find_by_id(params[:id])
    if question.author == current_user
      question.comments.each{|comment| comment.delete}
      question.delete
      redirect to '/questions'
    else
      redirect to "/questions/#{question.id}/edit"
    end
  end

end
