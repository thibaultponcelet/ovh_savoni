require "../lib/ovh_savoni"

savoni = OvhSavoni::SoAPI.new(:nichandle=>"******",:password=>"******")
result = savoni.domain_info("example.com")
puts result.members
