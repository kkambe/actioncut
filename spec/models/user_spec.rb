# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Test user", email: "test@test.com", 
                            password: "testpass", password_confirmation: "testpass")}
  
  subject { @user }
  
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate)}
  
  it {should be_valid}
  
  describe "When name is not present" do
    before {@user.name = " "}
    
    it {should_not be_valid}
  end
  
  describe "When email is not present" do 
    before {@user.email = " "}
    it {should_not be_valid}
  end
  
  describe "When the length of name is too long" do
    before {@user.name = "a"*51}
    it {should_not be_valid}
  end
  
  describe "When the email in not valid" do 
    it "should be invalid" do
      addresses = %w[ffo@bar,com f foo@foo foo@bar+cup.com foo@bar_cup.com]
      addresses.each do |invalid_addr| 
        @user.email=invalid_addr
        @user.should_not be_valid
      end
    end
  end
  
  describe "When the email is valid" do
    it "should be valid" do
      addresses = %w[foo@bar.com FOO@BAR.COM foo_bar@BAR.com f00123@bar.co.in foo+bar@bar.com]
      addresses.each do |valid_addr|
        @user.email=valid_addr
        @user.should be_valid
      end
    end
  end
  
  describe "When the email is already existing" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = user_with_same_email.email.upcase
      user_with_same_email.save
    end
    
    it {should_not be_valid} 
  end
  
  describe "When password is empty" do
    before {@user.password = @user.password_confirmation = " "}
    
    it {should_not be_valid}
  end
  
  describe "When password and confirmation don't match" do
    before {@user.password_confirmation = "mismatch"}
    
    it {should_not be_valid}
  end
  
  describe "When password is nil" do 
    before {@user.password_confirmation = nil}
    it {should_not be_valid}
  end
  
  describe "When the password is too short" do
    before {@user.password = @user.password_confirmation = "a"*5}
    it {should_not be_valid}
  end
  
  describe "return value of authenticate method" do
    before {@user.save}
    let(:found_user) {User.find_by_email(@user.email)}
    
    describe "Password is valid" do
      it {should == found_user.authenticate(@user.password)}
    end
    
    describe "Password is invalid" do
      let(:user_with_invalid_password) {found_user.authenticate("invalid")}
      
      it {should_not == user_with_invalid_password}
      specify {user_with_invalid_password.should be_false}
    end
    
  end
  
  describe "remember token" do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end
  
end
