class OvhSavoni::SoAPI
  # Init Class
  class << self
    attr_reader :soap
  end
  # Initialize soap connection
  @soap = Savon::Client.new do
    wsdl.document =File.expand_path("../../soapi-dlw-1.59.wsdl" , __FILE__)
  end
  # Initialize the class structure on the basis of the WSDL file
  # Meta definition of one method for each action
  # Return value is the values in return[:#{action}_response][:return]
  @soap.wsdl.soap_actions.each do |action|
    arg_names = @soap.wsdl.type_namespaces.find_all do |i|
      i[0][0]==@soap.wsdl.soap_input(action)
    end.map{|j| j[0][1]}.compact

    define_method(action) do |*arg_values|
      begin
        r = request(action,arg_names,arg_values)["#{action}_response".to_sym][:return]
      rescue Savon::SOAP::Fault => e
        raise OvhSavoni::Error.new(e.message)
      end
      OvhSavoni::ResponseBuilder.build(r,action)
    end
  end

  # Create a new instance and connect to OVH if nic and pwd provided
  def initialize(logins={}, lang=:en)
    @nichandle = logins[:nichandle]
    @password = logins[:password]
    @sms_account = logins[:sms_account]
    @sms_user = logins[:sms_user]
    @sms_password= logins[:sms_password]
    #Connect if login infos provided
    if @nichandle && @password
      @session = self.login(@nichandle,@password,lang.to_s)
    end
    @session
  end

  private
  # Handle generic requests
  def request(method, arg_names, arg_values)
    structured_args = set_default_args(method,arg_names)
    preset_args = structured_args.keys
    custom_args = arg_names[preset_args.size-1..-1]
    custom_args.each_index do |i|
      key = custom_args[i].snakecase.to_sym
      structured_args[key] = arg_values[i]
      if structured_args[key].is_a?(Array)
        set_array_arg(structured_args,key,custom_args[i],arg_values[i])
      end
    end
    self.class.soap.request(method) do
      soap.namespaces["xmlns:soapenc"]="http://schemas.xmlsoap.org/soap/encoding/"
      http.headers["SOAPAction"] = ""
      soap.body = structured_args
    end.body
  end

  # Add xml attributes for array arguments
  def set_array_arg(structured_args,key,original_key,value)
    structured_args[:attributes!] ||= {}
    # ins0 to workaround savon bug
    structured_args[:attributes!]["ins0:#{original_key}"]=
      { "soapenc:arrayType"=>"xsd:#{structured_args[key].first.class.name.downcase}[]" }
    structured_args[key]={:item=>value}
  end

  # Set default args with ones defined at initialization
  def set_default_args(method,arg_names)
    default_args={}
    if arg_names.include?("session") && !@session.nil?
      default_args[:session] = @session
    end
    if arg_names.include?("smsAccount") && !@sms_account.nil?
      default_args[:smsAccount] = @sms_account
    end
    if method.to_s.match(/sms_user/i)
      if arg_names.include?("login") && !@sms_user.nil?
        default_args[:login] = @sms_user
      end
      if arg_names.include?("password") && !@sms_password.nil?
        default_args[:password] = @sms_password
      end
    end
    default_args[:order!]=arg_names.dup # Dup to avoid savon changing args
    default_args
  end
end
