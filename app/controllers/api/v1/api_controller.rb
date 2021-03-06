class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session

  # Debug variables in case we forget to set them
  @status = -1
  @success = false
  @data = "no_data_debug"

  # Simple plain text render test
  def text
    render :text => 'Hello', :content_type => 'text/plain'
  end

  # Returns JSON input
  def mirror
    @json = ActiveSupport::JSON.decode(request.body.read)
    json_output(200, true, @json) and return
  end

  # User is user and password is pass
  def auth
    @json = ActiveSupport::JSON.decode(request.body.read)
    user = @json['username']
    pass = @json['password']
    if (user == 'user' && pass == 'pass')
      render :status => 200,
       :json => { :success => true,
         :info => "You are now signed in!"
       } and return
    else
      render :status => 300,
       :json => { :success => false,
         :info => [:user => user, :pass => pass]
       } and return
    end
  end

  # Just a simple list to test
  def list
    json_output(@status = 200, @success = true, @data = [ 'Apple', 'Banana', 'Coconut']) and return
  end

  private
    # All instances of json_output must be used with the return keyword
    # or you get mutiple render issues while developing
    def json_output(status, success, data) 
      return render :status => status,
       :json => { :success => success,
         :info => data
       }
    end
end
