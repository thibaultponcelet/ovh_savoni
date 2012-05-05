# Load the gem files in the system
require "savon"

# Configure savon
HTTPI.log = false
Nori.parser = :nokogiri
Savon.configure do |config|
  config.log = false
end

module OvhSavoni end
  
require_relative "./ovh_savoni/error.rb"
require_relative "./ovh_savoni/response_builder.rb"
require_relative "./ovh_savoni/soapi.rb"
