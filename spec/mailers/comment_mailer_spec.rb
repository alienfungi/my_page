require "spec_helper"

describe CommentMailer do
  let(:default_from) { 'commentMailer@zanewoodfin.com' }
  let(:default_to) { 'zanewoodfin@gmail.com' }
  let(:default_subject) { 'A comment from zanewoodfin.com has arrived' }
  subject { CommentMailer.comment_email(@comment) }

  describe '#comment_email' do
    before do
      @comment = FactoryGirl.build(:comment)
    end

    it 'should be sendable' do
      subject.deliver
      ActionMailer::Base.deliveries.empty?.should be_false
    end

    its(:from) { should == [default_from] }
    its(:to) { should == [default_to] }
    its(:subject) { should == default_subject }
    its(:body) { should include(@comment.message) }
  end
end
