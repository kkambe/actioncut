class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  def handle_unhandled_request
    sign_out
    super
  end
end
