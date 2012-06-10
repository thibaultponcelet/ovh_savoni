require "../lib/ovh_savoni"

# One time login
savoni = OvhSavoni::SoAPI.new :sms_user=>"******",:sms_password=>"******",:sms_account=>"******"

puts savoni.telephony_sms_user_credit_left
puts savoni.telephony_sms_user_multi_send("+32*****",["+32******","+32******"],"SMS content")


# Login at each request
savoni2 = OvhSavoni::SoAPI.new
puts savoni.telephony_sms_user_credit_left("******","******","******")
