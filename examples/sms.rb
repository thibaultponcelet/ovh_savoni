require "../lib/ovh_savoni"

savoni = OvhSavoni::SoAPI.new :sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****" 

puts savoni.telephony_sms_user_credit_left
ids = savoni.telephony_sms_user_multi_send(
  :number_from=>"+320000000",
  :number_to=>["+321111111","+32111111"],
  :message=>"SMS CONTENT"
)
puts ids

puts savoni.telephony_sms_user_credit_left





