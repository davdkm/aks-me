require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Aks Me!")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to questions index' do
      params = {
        :user => {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      }
      post '/signup', params
      expect(last_response.location).to include("/questions")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :user => {
        :username => "",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :user => {
        :username => "skittles123",
        :email => "",
        :password => "rainbows"
      }
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :user => {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => ""
      }
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:username => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
      params = {
        :user => {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      }
      post '/signup', params
      session = {}
      session[:id] = user.id

      get '/signup'
      expect(last_response.location).to include('/questions')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the questions index after login' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      session = {}
      session[:id] = user.id
      get '/login'
      expect(last_response.location).to include("/questions")
    end
  end

  describe "logout" do

    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")

    end
    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /questions if user not logged in' do
      get '/questions'
      expect(last_response.location).to include("/login")
    end

    it 'does load /questions if user is logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")


      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/questions')


    end
  end

  describe 'user show page' do
    it 'shows all a single users questions' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      question1 = Question.create(:content => "Who want's to grub?", :author_id => user.id)
      question2 = Question.create(:content => "What's for din din?", :author_id => user.id)
      get "/users/#{user.slug}"

      expect(last_response.body).to include("Who want's to grub?")
      expect(last_response.body).to include("What's for din din?")

    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the questions index if logged in' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question1 = Question.create(:content => "aksing!", :author_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        question2 = Question.create(:content => "What's the deal with airline food?", :author_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/questions"
        expect(page.body).to include(question1.content)
        expect(page.body).to include(question2.content)
      end
    end


    context 'logged out' do
      it 'does not let a user view the questions index if not logged in' do
        get '/questions'
        expect(last_response.location).to include("/login")
      end
    end

  end



  describe 'new action' do
    context 'logged in' do
      it 'lets user view new question form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/questions/new'
        expect(page.status_code).to eq(200)

      end

      it 'lets user create a question if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/questions/new'
        fill_in(:content, :with => "Question???")
        click_button 'submit'

        user = User.find_by(:username => "becky567")
        question = Question.find_by(:content => "Question???")

        expect(question).to be_instance_of(Question)
        expect(question.author_id).to eq(user.id.to_s)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user question from another user' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/questions/new'

        fill_in(:content, :with => "Question???")
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        question = Question.find_by(:content => "Question???")
        expect(question).to be_instance_of(Question)
        expect(question.author_id).to eq(user.id.to_s)
        expect(question.author_id).not_to eq(user2.id.to_s)
      end

      it 'does not let a user create a blank question' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/questions/new'

        fill_in(:content, :with => "")
        click_button 'submit'

        expect(Question.find_by(:content => "")).to eq(nil)
        expect(page.current_path).to eq("/questions/new")

      end
    end

    context 'logged out' do
      it 'does not let user view new question form if not logged in' do
        get '/questions/new'
        expect(last_response.location).to include("/login")
      end
    end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single question' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question = Question.create(:content => "i am a boss at aksing", :author_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/questions/#{question.id}"
        expect(page.status_code).to eq(200)
        expect(page.body).to include("Delete Question")
        expect(page.body).to include(question.content)
        expect(page.body).to include("Edit Question")
      end
    end

    context 'logged out' do
      it 'does not let a user view a question' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question = Question.create(:content => "i am a boss at aksing", :author_id => user.id)
        get "/questions/#{question.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end


  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view question edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question = Question.create(:content => "aksing!", :author_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/questions/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(question.content)
      end

      it 'does not let a user edit a question they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question1 = Question.create(:content => "aksing!", :author_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        question2 = Question.create(:content => "can i aks you something?", :author_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        session = {}
        session[:author_id] = user1.id
        visit "/questions/#{question2.id}/edit"
        expect(page.current_path).to include('/questions')

      end

      it 'lets a user edit their own question if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question = Question.create(:content => "aksing!", :author_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/questions/1/edit'

        fill_in(:content, :with => "i love aksing")

        click_button 'submit'
        expect(Question.find_by(:content => "i love aksing")).to be_instance_of(Question)
        expect(Question.find_by(:content => "aksing!")).to eq(nil)

        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank content' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question = Question.create(:content => "aksing!", :author_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/questions/1/edit'

        fill_in(:content, :with => "")

        click_button 'submit'
        expect(Question.find_by(:content => "i love aksing")).to be(nil)
        expect(page.current_path).to eq("/questions/1/edit")

      end
    end

    context "logged out" do
      it 'does not load let user view question edit form if not logged in' do
        get '/questions/1/edit'
        expect(last_response.location).to include("/login")
      end
    end

  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own question if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question = Question.create(:content => "aksing!", :author_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit 'questions/1'
        click_button "Delete Question"
        expect(page.status_code).to eq(200)
        expect(Question.find_by(:content => "aksing!")).to eq(nil)
      end

      it 'does not let a user delete a question they did not create' do
        user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        question1 = Question.create(:content => "aksing!", :author_id => user1.id)

        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
        question2 = Question.create(:content => "can i aks you something?", :author_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "questions/#{question2.id}"
        click_button "Delete Question"
        expect(page.status_code).to eq(200)
        expect(Question.find_by(:content => "can i aks you something?")).to be_instance_of(Question)
        expect(page.current_path).to include('/questions')
      end

    end

    context "logged out" do
      it 'does not load let user delete a question if not logged in' do
        question = Question.create(:content => "aksing!", :author_id => 1)
        visit '/questions/1'
        expect(page.current_path).to eq("/login")
      end
    end

  end


end
