ovh_savoni
===
OVH SoAPI wrapper.

Super easy access to the OVH Soap API for Ruby >1.9, with extra support for SMS handling.

Please refer to http://www.ovh.com/soapi/en/ for the API definition.

##Install

Install it on your system:

        gem install ovh_savoni

Or add it to your Gemfile:

        gem 'ovh_savoni', 'x.x.x'


### Version


Be carefull that methods will change with versions to follow the updates done by OVH in their WSDL file.
Version number of this gem match the WSDL version of OVH (see the changelog here: http://www.ovh.com/soapi/fr/changelog.xml).
An additional version number will be added if required by the gem.

## Example


### SMS sending


        require "ovh_savoni"
        savoni = OvhSavoni::SoAPI.new :sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****"

        puts savoni.telephony_sms_user_credit_left
        puts savoni.telephony_sms_user_multi_send("+320000000",["+321111111","+32111111"],"SMS content")

This will display the credit left, send a SMS to two recipients using a sms user from OVH and display the returned ids.

### Domain info


        require "ovh_savoni"

        savoni = OvhSavoni::SoAPI.new(:nichandle=>"******",:password=>"******")
        result = savoni.domain_info("example.com")

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

## Usage

### Connection establishment


  For actions with authentications:

        savoni = OvhSavoni::SoAPI.new(:nickhandle=>"******",:password=>"******")

  For SMS user:

        savoni = OvhSavoni::SoAPI.new(:sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****")

  Both can be specified if needed to have always full access:

        savoni = OvhSavoni::SoAPI.new(:nickhandle=>"******",:password=>"password", :sms_user=>"*****",:sms_password=>"*****",:sms_account=>"*****")

  In case you do not want the gem to handle the authentification for you just create a new instance without parameters:
  (This mean that you will have to perfom a login call explicitely and pass the result with each action that requires authentication.)

        savoni = OvhSavoni::SoAPI.new


### API access


  OvhSavoni::SoAPI instances define one method for each SOAP action defined by OVH
  parameters have to be passed in the same order than the one defined at http://www.ovh.com/soapi/en/ (optional parameters can be omited)
        savoni.action_name(arg1,arg2,arg3)

  The *session* parameter must be skipped when the SoAPI instance has been initialized with the *nichandle* and *passowrd* parameters

  The *sms_account*, *sms_user*, *sms_password* parameters for sms users methods must also be skipped when setted at initialization.

  N.B. The actions are to be in snake case in order to follow Ruby conventions.

  Results are sub-classes of Struct mapped on the returned XML for comppound values and basic values for simple return values such as String, Dates,etc

## Contributions

If you want to contribute, please open an issue or:

  * Fork the project.
  * Make your feature addition or bug fix.
  * Send a pull request on Github with a clear description.

## TODO

  * Tests
  * Check methods arity

## Copyright

Copyright 2011-2012 Thibault Poncelet - See LICENCE for details.
