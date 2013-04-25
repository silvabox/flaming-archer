require 'spec_helper'

describe "participants/edit" do
  before(:each) do
    @participant = assign(:participant, stub_model(Participant,
      :name => "MyString",
      :email => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders the edit participant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", participant_path(@participant), "post" do
      assert_select "input#participant_name[name=?]", "participant[name]"
      assert_select "input#participant_email[name=?]", "participant[email]"
      assert_select "input#participant_phone[name=?]", "participant[phone]"
    end
  end
end
