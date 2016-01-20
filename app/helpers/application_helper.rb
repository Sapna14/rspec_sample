module ApplicationHelper
  def self.hello(user)
      require 'net/http'
      url = "https://api.github.com/users/#{user}/repos"
      result = Net::HTTP.get_response(URI.parse(url))
      resp_text = result.body  
      parsed = JSON.parse(resp_text)
      language_array = Array.new()
      if parsed.find {|key, val| val == "Not Found"}
        result = "Username is invalid"
        # render text: "Username is invalid"
      else
        parsed.each do |x|
          language_array.push x["language"]
        end
        freq = language_array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }      
        if freq.empty? 
          result = "There are no public repos associated with the user"
          # render text: "There are no public repos associated with the user"
        # That following line demonstrates that [].all? will always return true, because if an Array is empty then by definition all of its elements (no elements) fulfill every condition.
        elsif freq.all? &:nil?
          result = "The favourite language cannot be determined as the public repos do not have any language specification"
          # render text: "The favourite language cannot be determined as the public repos do not have any language specification"
        else        
          freq.delete_if{|key,value| key == nil }
            final_array =  Array.new()
            freq.each do |k,v|
              if v == freq.values.max
                final_array.push k
              end
            end
            final_array = final_array.map(&:inspect).join(', ')
            result =  " The favourite language/languages of the user : #{final_array}"
            # render text:  " The favourite language/languages of the user : #{final_array}"
          end
        end
       result
  end
  
  def hello(username)
    ApplicationHelper.hello(user)
  end
  # def hello
  #   require 'net/http'
  #   url = "https://api.github.com/users/#{params[:username]}/repos"
  #   result = Net::HTTP.get_response(URI.parse(url))
  #   resp_text = result.body  
  #   parsed = JSON.parse(resp_text)
  #   language_array = Array.new()
  #   if parsed.find {|key, val| val == "Not Found"}
  #     render text: "Username is invalid"
  #   else
  #     parsed.each do |x|
  #       language_array.push x["language"]
  #     end
  #     freq = language_array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }      
  #     if freq.empty? 
  #       render text: "There are no public repos associated with the user"
  #     # That following line demonstrates that [].all? will always return true, because if an Array is empty then by definition all of its elements (no elements) fulfill every condition.
  #     elsif freq.all? &:nil?
  #       render text: "The favourite language cannot be determined as the public repos do not have any language specification"
  #     else        
  #       freq.delete_if{|key,value| key == nil }
  #         final_array =  Array.new()
  #         freq.each do |k,v|
  #           if v == freq.values.max
  #             final_array.push k
  #           end
  #         end
  #         final_array = final_array.map(&:inspect).join(', ')
  #         render text:  " The favourite language/languages of the user : #{final_array}"
  #       end
  #     end
  #   end
end
