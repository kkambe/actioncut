require 'spec_helper'

describe "UserPages" do
  subject {page}
  
  describe "Signup page" do
    before {visit signup_path}
    puts "Full title: " + full_title('Sign up')
    it { should have_selector('h1', text: 'Sign up')}
    it { should have_selector('title', text: full_title('Sign up'))}
  end
end
