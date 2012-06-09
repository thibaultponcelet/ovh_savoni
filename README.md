ovh_savoni
===========
OVH SoAPI wrapper.
Provide super easy access to the OVH Soap API for Ruby >1.9 on top of savon.

Please refer to http://www.ovh.com/soapi/en/ for API definition.

This gem gives you access to the whole OVH SOAP API with extra support for SMS handling.

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

Example: SMS sending
------------

    require "ovh_savoni"
    savoni = OvhSavoni::SoAPI.new :sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****"

    puts savoni.telephony_sms_user_credit_left
    puts savoni.telephony_sms_user_multi_send(
      :number_from=>"+320000000",
      :number_to=>["+321111111","+32111111"],
      :message=>"SMS CONTENT"
    )

This will display the credit left, send a SMS to two recipient using a sms user from OVH and display the ids of the sended SMS.

Example: Domain info
-------

    require "ovh_savoni"

    savoni = OvhSavoni::SoAPI.new(:nichandle=>"nichandle",:password=>"password")
    result = savoni.domain_info(:domain=>"example.com")

'result' is now a Struct with accessors for all response elements defined by OVH. In this case:
  - dns
  - nicbilling
  - nicadmin
  - domain
  - modification
  - expiration
  - nicowner
  - authinfo
  - creation

Usage
-----

**Connection establishment**

  For actions with authentications:

    savoni = OvhSavoni::SoAPI.new(:nickhandle=>"nichandle",:password=>"password")

  For SMS user:

    savoni = OvhSavoni::SoAPI.new(:sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****")

  Both can be specified if needed to have always full access:

    savoni = OvhSavoni::SoAPI.new(:nickhandle=>"nichandle",:password=>"password", :sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****")

**API access**

  OvhSavoni::SoAPI instances have one method for each SOAP action defined by OVH
  parameters have to be passed has one hash argument:
  - savoni.action_name(:param1=>"val1", :param2=>"val2",...)
  N.B. The actions are to be in snake case in order to follow Ruby convention.

  Results are sub-classes of Struct mapped on the returned XML for comppound values and basic values for simple return values such as String, Dates,...

**Change the WSDL**

The WSDL included in the gem is the most recent one but if you want to
use an other (older) WSDL file you can do it simply by putting:
  - OvhSavoni::SoAPI.wsdl_path="wsdl_path"
in your configuration file.

Copyright
---------
Copyright 2011-2012 Thibault Poncelet - See LICENCE for details.
