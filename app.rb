require "sinatra"
require "sinatra/reloader"
require "http"
require "dotenv"

Dotenv.load

get("/") do
  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)
  @currencies = @parsed_response.fetch("currencies")
  erb(:homepage)
end

get("/:first_symbol") do
  @symbol = params.fetch("first_symbol")

  @raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)
  @currencies = @parsed_response.fetch("currencies")

erb(:step_one)
end

get("/:first_symbol/:second_symbol") do
  @first_symbol = params.fetch("first_symbol")
  @second_symbol = params.fetch("second_symbol")

  @raw_response = HTTP.get("https://api.exchangerate.host/convert?from=#{@first_symbol}&to=#{@second_symbol}&amount=1&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")
  @string_response = @raw_response.to_s
  @parsed_response = JSON.parse(@string_response)
  @value1 = @parsed_response.fetch("info")
  @value2 = @value1.fetch("quote")
  erb(:step_two)
end
