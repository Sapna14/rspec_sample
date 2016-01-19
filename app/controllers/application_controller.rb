require 'net/http'
require 'json'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def hello
    require 'net/http'
    url = "https://api.github.com/users/#{params[:username]}/repos"
    result = Net::HTTP.get_response(URI.parse(url))
    resp_text = result.body  
    parsed = JSON.parse(resp_text)
    language_array = Array.new()
    if parsed.find {|key, val| val == "Not Found"}
      render text: "Username is invalid"
    else
      parsed.each do |x|
        language_array.push x["language"]
      end
      freq = language_array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
      # the following line checks for an empty array and an array with all elements nil
      # That last line demonstrates that [].all? will always return true, because if an Array is empty then by definition all of its elements (no elements) fulfill every condition.
      if freq.empty? 
        render text: "There are no public repos associated with the user"
      elsif freq.all? &:nil?
        render text: "The favourite language cannot be determined as the public repos do not have any language specification"
      else        
        freq.delete_if{|key,value| key == nil }
          final_array =  Array.new()
          freq.each do |k,v|
            if v == freq.values.max
              final_array.push k
            end
          end
          final_array = final_array.map(&:inspect).join(', ')
          render text:  " The favourite language/languages of the user : #{final_array}"
        end
      end
    end    
end
