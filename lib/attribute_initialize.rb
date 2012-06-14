module AttributeInitialize
  def initialize (attrs={})
    attrs.each_pair do |k, v|
      symbol = ((k.to_s) + "=").to_sym
      if respond_to?(symbol)
        send symbol, v
      else
        raise "Does not respond to, or no setter found for :#{k}"
      end
    end
  end
end
