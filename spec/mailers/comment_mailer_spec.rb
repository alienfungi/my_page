require "spec_helper"

describe ContactMessageMailer do
  let(:default_from) { 'contactMessageMailer@zanewoodfin.com' }
  let(:default_to) { 'zanewoodfin@gmail.com' }
  let(:default_subject) { 'A message from zanewoodfin.com has arrived' }
  subject { ContactMessageMailer.contact_message_email(@contact_message) }

  describe '#contact_message_email' do
    before do
      @contact_message = FactoryGirl.build(:contact_message)
    end

    it 'should be sendable' do
      subject.deliver
      ActionMailer::Base.deliveries.empty?.should be_false
    end

    its(:from) { should == [default_from] }
    its(:to) { should == [default_to] }
    its(:subject) { should == default_subject }

    it 'should contain the message in the html part' do
      subject.html_part.body.should include @contact_message.message
    end

    it 'should contain the message in the text part' do
      subject.html_part.body.should include @contact_message.message
    end
  end
end
