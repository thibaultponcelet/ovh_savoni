class OvhSavoni::ResponseBuilder
  
  # Build a Response class
  def self.build(r,action)
    if r.is_a?(Hash) # Build the class from the hash
      const = "OvhSavoniResponse_#{action}"
      klass=nil
      if Struct.const_defined?(const) 
        klass=Struct.const_get(const) 
      else # Create a new struct if not exist already
        klass=Struct.new(const,*r.keys)
        build_class(klass,action)
      end
      ret = klass.new(*r.values) # Instanciate the class
      if ret.members.include?(:item) && [:item].is_a?(Array)
        ret.item
      else
        ret
      end
    else # Return the value in case of basic type
      r
    end
  end
  
  # Add recursive construction behavior to the class initializer
  def self.build_class(klass,action)
    klass.class_eval do 
      define_method(:initialize) do |*args|
        super(*args)
        each do |inst|
          each_pair do |k,v|
            if v.is_a?(Hash)
              self[k]=OvhSavoni::ResponseBuilder.build(v,"#{action}__#{k}")
              # replace response_info.item[] by response_info[]
              if self[k].respond_to?(:item) && self[k].item.is_a?(Array)
                self[k]=self[k].item
              end
            elsif v.is_a?(Array)
              self[k].map!{|i| OvhSavoni::ResponseBuilder.build(i,"#{action}__#{k}")}
            end
          end
        end
      end
    end
  end
end
