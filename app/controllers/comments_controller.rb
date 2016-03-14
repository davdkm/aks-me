class CommentsController < ApplicationController

  get '/comments/:id/edit' do
    @comment = Comment.find_by_id(params[:id])
    erb :'/comments/edit'
  end

  get '/comments/:id' do
    @comment = Comment.find_by_id(params[:id])
    erb :'/comments/show'
  end

  patch '/comments/:id' do
    redirect_if_not_logged_in
    comment = Comment.find_by_id(params[:id])
    question = comment.question
    comment.update(content: params[:content])
    redirect to "/questions/#{question.id}"
  end

  post '/questions/comments/:id' do
    redirect_if_not_logged_in
    question = Question.find_by_id(params[:id])
    comment = Comment.new(content: params[:content], commenter: current_user, question: question)
    comment.save
    redirect to "/questions/#{question.id}"
  end

  delete '/comments/:id/delete' do
    redirect_if_not_logged_in
    comment = Comment.find_by_id(params[:id])
    question = comment.question
    comment.delete
    redirect to "/questions/#{question.id}"
  end

end
