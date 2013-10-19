require 'spec_helper'

describe ApplicationHelper do
  subject { helper }

  describe '#full_title' do
    before do
      @base_title = "The Network"
    end

    context 'with provided page_title' do
      before do
        @page_title = "teh page title"
      end

      it "should return 'base_title | page_title'" do
        helper.full_title(@page_title).should == "#{@base_title} | #{@page_title}"
      end
    end

    context 'with no provided page_title' do
      its(:full_title) { should == @base_title }
    end
  end

  describe '#heading' do
    before do
      @default_heading = "The Network"
      @title = "Title"
      @heading = "Heading"
    end

    it "should return heading, title, or default in that priority" do
      helper.heading().should == @default_heading
      helper.heading('', @title).should == @title
      helper.heading(@heading, @title).should == @heading
    end
  end

  describe '#flash_class' do
    before do
      @base_alert = "alert alert-"
    end

    it "should return the appropriate classes for each alert type" do
      helper.flash_class(:success).should == "#{@base_alert}success"
      helper.flash_class(:notice).should == "#{@base_alert}info"
      helper.flash_class(:alert).should == "#{@base_alert}warning"
      helper.flash_class(:error).should == "#{@base_alert}danger"
    end
  end

  describe '#header_links' do
    before do
      @user = FactoryGirl.create(:user)
      helper.stub(:current_user).and_return(@user)
      @hash = { home: "Home", profile: "My Profile", activities: "Activity", users: "Users" }
    end

    context "with no new messages or friend requests" do
      before do
        @hash.merge!({ messages: "Messages", friends: "Friends" })
      end

      it "should return the correct links with no badges" do
        @hash.keys.each do |key|
          helper.header_links[key][:text].should == @hash[key]
        end
      end
    end

    context "with a new message and 2 friend requests" do
      before do
        @user1 = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        @friendship1 = FactoryGirl.create(:friendship, user_id: @user1.id, friend_id: @user.id)
        @friendship2 = FactoryGirl.create(:friendship, user_id: @user2.id, friend_id: @user.id)
        @message = FactoryGirl.create(:message, recipient_id: @user.id)
        @hash.merge!({ messages: "Messages <span class='badge'>1</span>", friends: "Friends <span class='badge'>2</span>" })
      end

      it "should return links with a 1 badge next to messages and a 2 badge next to friends" do
        @hash.keys.each do |key|
          helper.header_links[key][:text].should == @hash[key]
        end
      end
    end
  end
end
