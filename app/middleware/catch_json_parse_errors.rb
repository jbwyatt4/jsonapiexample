# I catch JSON Parse errors because it's processed before the 
# controller is even called
# everytime i'm changed, restart the server
# i'm added to config/application.rb
class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    begin

      @app.call(env)
    rescue JSON::ParserError => error

      error_output = "There was a problem in the JSON you submitted: #{error}"
      error_output_public = "There was a problem in the JSON you submitted."

      if Rails.env == 'development'

        return [ 400, { "Content-Type" => "application/json" },
            [ { status: 400, error: error_output }.to_json ]
            ]
      else
        return [ 400, { "Content-Type" => "application/json" },
            [ { status: 400, error: error_output_public }.to_json ]
            ]
        
      end
    end
  end
end
