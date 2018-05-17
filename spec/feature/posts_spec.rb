require 'rails_helper'

RSpec.feature "Post", type: :feature do
  describe "index" do
    before do
      @post = Post.create(title: "Hello", content: "world")
    end
    
    it "should returns all posts" do
      visit '/'
      expect(page).to have_content 'Posts'
      expect(Post.count).to eq 1
      expect(page).to have_content @post.title
    end
  end

  describe "new" do
    context "with valid information" do
      it "should returns a new post" do
        visit '/'
        click_link('New Post')
        within("form") do
          fill_in 'Title', with: 'Second post'
          fill_in 'Content', with: 'SiliconJungles'
        end
        click_button("Create Post")
        expect(Post.count).to eq 1
        expect(page).to have_content "Post was successfully created."
      end
    end

    context "with invalid information" do
      it "should returns error" do
        visit '/'
        click_link('New Post')
        within("form") do
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
        end
        click_button("Create Post")
        expect(Post.count).to eq 0
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Content can't be blank"
      end
    end
  end

  describe "update" do
    before do
      @post = Post.create(title: "Hello", content: "world")
    end

    context "with valid input" do
      it "should update a post" do
        visit '/'
        click_link("Edit")
        within("form") do
          fill_in 'Title', with: 'He'
          fill_in 'Content', with: 'wo'
        end
        click_button("Update Post")
        expect(Post.count).to eq 1
        expect(page).to have_content "Post was successfully updated."
        expect(page).to have_content "He"
        expect(page).to have_content "wo"
      end
    end

    context "with invalid input" do
      it "should returns error" do
        visit '/'
        click_link("Edit")
        within("form") do
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
        end
        click_button("Update Post")
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Content can't be blank"
      end
    end
  end

  describe "delete" do
    before do
      Post.create(title: "Hello", content: "world")
      Post.create(title: "Hi", content: "world")
    end

    it "should delete the post", js: true do
      visit '/'
      first('a[data-method="delete"]').click
      page.accept_alert
      expect(page).to have_content "Post was successfully destroyed."
      expect(Post.count).to eq 1
    end
  end
end