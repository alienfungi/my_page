require 'spec_helper'

describe ApplicationHelper do
  subject { helper }

  describe '#full_title' do
    before do
      @base_title = "Zane's Site"
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
      @default_heading = "Zane's Site"
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
end
