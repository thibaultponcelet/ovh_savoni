ovh_savoni
===========
OVH SoAPI wrapper. 
Provide easy access to the OVH Soap API for Ruby >1.9 on top of savon

Please refer to http://www.ovh.com/soapi/en/ for API definition

This gem gives you access to the whole OVH SOAP API with extra support for SMS handling

Install
-------
Add it to your Gemfile (dev version):

    gem "ovh_savoni", :git => "git://github.com/thibaultponcelet/ovh_savoni.git"

Comming soon:

  Install it on your system:
  
      gem install ovh_savoni

  Or add it to your Gemfile:
  
      gem 'ovh_savoni', 'x.x.x' 

  
**Version**
Be carefull that methods will change with versions to follow the updates done by OVH in their WSDL file.
Version number of this gem match the WSDL version of OVH (see the changelog here: http://www.ovh.com/soapi/fr/changelog.xml).
An additional version number will be added if required by the gem.


Usage
-----

**Connection establishment**
  For actions with authentications: 
  
    savoni = OvhSavoni::SoAPI.new(:nickhandle=>"nichandle",:password=>"password")
    
  For SMS user: 
  
    savoni = OvhSavoni::SoAPI.new(:sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****")
    
  Both can be specified to have always full access:
  
    savoni = OvhSavoni::SoAPI.new(:nickhandle=>"nichandle",:password=>"password", :sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****")
  
**API access**
  OvhSavoni::SoAPI instances have one method for each SOAP action defined by OVH
  parameters have to be passed has one hash argument:
  - savoni.action_name(:param1=>"val1", :param2=>"val2",...)
  N.B. The actions are to be in snake case.

  Results are Struct mapped on the returned XML for comppound values and basic values for simple return values such as String, Dates,...
  
**Change the WSDL**
The WSDL included in the gem should be the most recent one but if you want to 
use an other (older/newer) WSDL file you can do it simply by putting:
  - OvhSavoni::SoAPI.wsdl_path="wsdl_path" 
in your configuration file.
  
Example: Domain info
-------

    require "ovh_savoni"

    savoni = OvhSavoni::SoAPI.new(:nichandle=>"nichandle",:password=>"password")
    result = savoni.domain_info(:domain=>"example.com")

'result' is now a Struct with accessors for all response elements defined by ovh. In this case: 
  - dns
  - nicbilling
  - nicadmin
  - domain
  - modification
  - expiration
  - nicowner
  - authinfo
  - creation

Example: SMS sending:
------------

    require "ovh_savoni"
    savoni = OvhSavoni::SoAPI.new :sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****" 

    puts savoni.telephony_sms_user_credit_left
    ids = savoni.telephony_sms_user_multi_send(
      :number_from=>"+320000000",
      :number_to=>["+321111111","+32111111"],
      :message=>"SMS CONTENT"
    )
    puts ids

    puts savoni.telephony_sms_user_credit_left
    
This will send a SMS to two recipient using a sms user from OVH and display credit left before and after sending and the ids of the sended SMS.


