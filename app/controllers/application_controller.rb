require 'net/http'
require 'json'
# helper ApplicationHelper
include ApplicationHelper
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def action
    @variable = ApplicationHelper.hello(params[:username])
    render text: @variable  
  end
end
