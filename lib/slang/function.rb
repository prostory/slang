module SLang
  class Function
    attr_accessor :owner
    attr_accessor :instances
    attr_accessor :mangled
    attr_accessor :mangled_return_type
    attr_accessor :prototype

    def template
      if @template.nil?
        @template = FunctionTemplate.new(name)
        @template << self
      end
      @template
    end

    def <<(instance)
      @instances ||= {}
      unless mangled
        if @mangled = prototype.instances.size > 0
          prototype.instances.each do |fun|
            fun.mangled = @mangled
          end
        end
      end
      instance.mangled = @mangled
      fun = @instances[instance.signature]
      if fun && fun.body.type != instance.body.type
        fun.mangled_return_type = true
        instance.mangled_return_type = true
      end
      if instance.has_var_list?
        @instances[:VarList] = instance
      else
        @instances[instance.signature] = instance
      end
      prototype.add_instance instance
    end

    def [](signature)
      @instances && (@instances[signature]||@instances[:VarList])
    end

    def signature
      @signature ||= Signature.new(params.map(&:type))
    end

    def has_var_list?
      params.any? && params.last.var_list?
    end

    def new_prototype
      @prototype ||= FunctionPrototype.new
      @prototype << self
      @prototype
    end
  end

  class FunctionPrototype
    attr_accessor :functions
    attr_accessor :instances

    def initialize
      @functions = {}
      @instances = []
    end

    def <<(fun)
      if fun.has_var_list?
        if functions[VarListSignature.new]
          functions[VarListSignature.new].template << fun
        else
          functions[VarListSignature.new] = fun
        end
        return
      end

      function = functions[fun.signature]
      if function.nil?
        functions[fun.signature] = fun

        functions.sort do |i, j|
          i[0] <=> j[0]
        end
      else
        function.template << fun
        return
      end
    end

    def lookup(sig)
      function = functions.select { |signature, function| sig.child_of? signature }.to_a.flatten[1] || functions[:VarList]
      function.template.latest if function
    end

    def add_instance(instance)
      @instances << instance
    end

    def clone
      prototype = self.class.new
      functions.each do |sig, fun|
        new_fun = fun.clone
        new_fun.prototype = prototype
        prototype.functions[sig] = new_fun
      end
      prototype
    end
  end
end