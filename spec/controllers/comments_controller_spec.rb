require 'spec_helper'

describe ApplicationController do


  describe "Question Comments" do
    before do
      @user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      @question = Question.create(:content => "Who want's to grub?", :author_id => @user.id)
    end

    it 'can initialize a comment for a question' do
      comment = Comment.create(:content => "I want some grub!", :commenter => @user, :question => @question)

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get "/questions/#{@question.id}"

      expect(last_response.body).to include("I want some grub!")
    end

  it 'lets user create a question if they are logged in' do
    visit '/login'

    fill_in(:username, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'

    visit "/questions/#{@question.id}"
    fill_in(:content, :with => "My first comment!")
    click_button 'comment'

    user = User.find_by(:username => "becky567")
    comment = Comment.find_by(:content => "My first comment!")

    expect(comment).to be_instance_of(Comment)
    expect(comment.commenter.id).to eq(user.id)
    expect(page.status_code).to eq(200)
  end
end
end #end describe ApplicationController
