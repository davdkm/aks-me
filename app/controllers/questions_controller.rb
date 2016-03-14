class QuestionsController < ApplicationController

  get '/questions' do
    redirect_if_not_logged_in
    erb :'questions/index'
  end

  get '/questions/new' do
    redirect_if_not_logged_in
    erb :'questions/new'
  end

  post '/questions' do
    redirect_if_not_logged_in
    question = Question.new(content: params[:content])
    author = User.find_by_id(session[:id])
    if question.content.empty?
      redirect to '/questions/new'
    else
      question.author = author
      question.save
      redirect to "/questions/#{question.id}"
    end
  end

  get '/questions/:id/edit' do
    redirect_if_not_logged_in
    @question = Question.find_by_id(params[:id])
    if @question && @question.author == current_user
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
    redirect_if_not_logged_in
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
