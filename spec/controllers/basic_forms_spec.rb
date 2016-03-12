require 'spec_helper'

describe "Aks Me Basics" do
  let(:user_name) { "TestUser1" }
  let(:question_content) { "What is this?" }

  before do
    @question = Question.create(content: question_content)
    @user = User.create(username: user_name)

    @question.author = @user

    @question.save
  end

  describe "index pages" do
    describe "/questions" do
      before do
        visit "/questions"
      end

      it 'responds with a 200 status code' do
        expect(page.status_code).to eq(200)
      end

      it "displays a list of questions" do
        expect(page).to have_content(question_content)
      end

      it "contains links to each question's show page" do
        expect(page).to have_css("a[href='/questions/#{@question.id}']")
      end
    end

    describe "/users" do
      before do
        visit "/users"
      end

      it 'responds with a 200 status code' do
        expect(page.status_code).to eq(200)
      end

      it "displays a list of users" do
        expect(page).to have_content(user_name)
      end

      it "contains links to each user's show page" do
        expect(page).to have_css("a[href='/users/#{@user.slug}']")
      end
    end
  end

  describe "show pages" do
    describe "/questions/:id" do
      before do
        visit "/questions/#{@question.id}"
      end

      it 'responds with a 200 status code' do
        expect(page.status_code).to eq(200)
      end

      it "displays the question's author" do
        expect(page).to have_content(user_name)
      end

      it "contains links to the user's show page" do
        expect(page).to have_css("a[href='/users/#{@user.slug}']")
      end
    end

    describe "/users/:slug" do
      before do
        visit "/users/#{@user.slug}"
      end

      it 'responds with a 200 status code' do
        expect(page.status_code).to eq(200)
      end

      it "displays the user's questions" do
        expect(page).to have_content(question_content)
      end

      it "contains links to each question's show page" do
        expect(page).to have_css("a[href='/questions/#{@question.id}']")
      end
    end

  end
end
