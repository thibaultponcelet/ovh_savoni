class OvhSavoni::SoAPI
  # Provide class accessors
  class << self
    attr_accessor :wsdl_path, :soap
  end
  # Initialize soap connection
  @soap = Savon::Client.new{ wsdl.document = OvhSavoni::SoAPI.wsdl_path }
  # Store WDSL path and soap client as class instance variable
  @wsdl_path = File.expand_path("../../soapi-re-1.35.wsdl" , __FILE__)
  
  # Initialize the class structure on the basis of the WSDL file
  # Meta definition of one method for each action
  # Return value is the hash in return[:#{action}_response][:return]
  @soap.wsdl.soap_actions.each do |action|
    define_method(action) do |args={}|
      if !args.is_a?(Hash)
        raise OvhSavoni::Error.new("Requests args must be passed as a hash") 
      end
      begin 
        r = request(action,args)["#{action}_response".to_sym][:return]
      rescue Savon::SOAP::Fault => e
        raise OvhSavoni::Error.new(e.message)
      end
      OvhSavoni::ResponseBuilder.build(r,action)
    end
  end
  
  # Create a new instance and connect to OVH if needed
  def initialize(logins, lang=:en)
    @nichandle = logins[:nichandle]
    @password = logins[:password]
    @sms_account = logins[:sms_account]
    @sms_user = logins[:sms_user]
    @sms_password= logins[:sms_password]
    #Connect if login infos provided
    if @nichandle && @password
      @session = self.login(:nic=>@nichandle,:password=>@password,:lang=>lang.to_s)
    end
  end  
  
  private
  # Handle generic requests
  def request(method, params,second=false)
    begin
      opts = set_opts(method,params,second)
      params.each do |k, v| 
        opts[k] = v 
        if v.is_a?(Array)
          type = v.first.class.name
          opts[:attributes!] ||= {}
          opts[:attributes!][k]={"xsi:type"=>"wsdl:MyArrayOf#{type}Type","soapenc:arrayType"=>"xsd:#{type.downcase}[]" }
          opts[k]={type=>v}
        end
      end
      self.class.soap.request(:wsdl, method) do 
        soap.namespaces["xmlns:soapenc"]="http://schemas.xmlsoap.org/soap/encoding/"
        soap.body = opts
      end.body
    rescue # Monkey patch to handle SmsUser methods with differents args ordering
      if !second && sms_user_request(method)
        request(method,params,true)
      else
        raise
      end
    end
  end
  
  # Set default ops with ones defined at instanciation
  def set_opts(method,params,wrong_order=false)
    opts={}
    if params[:session].nil? && !@session.nil?
      opts[:session] = @session 
    end
    if params[:sms_account].nil? && !@sms_account.nil? && sms_request(method) 
      opts[:sms_account] = @sms_account 
    end
    if sms_user_request(method)
      if params[:login].nil? && !@sms_user.nil?
        opts[:login] = @sms_user 
      end
      if params[:password].nil? && !@sms_password.nil?
        opts[:password] = @sms_password 
      end
      # Monkey patch to handle different order of parameters in smsUser methods
      if wrong_order 
        order  = [:sms_account,:login,:password]
      else
        order  = [:login,:password,:sms_account]
      end
      opts[:order!]=order.concat(params.keys.select{|i| i!=:login && i!=:password && i!=:sms_account})
    end
    opts
  end
  
  # True if it is a sms method
  def sms_request(method)
    method.to_s.match(/sms/i) ? true : false
  end
  
  # True if it is a sms_user method
  def sms_user_request(method)
    method.to_s.match(/sms_user/i) ? true : false
  end
end
