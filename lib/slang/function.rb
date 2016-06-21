module SLang
  class Function
    attr_accessor :owner
    attr_accessor :instances
    attr_accessor :template
    # attr_accessor :mangled
    # attr_accessor :mangled_return_type
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
      # unless mangled
      #   if @mangled = prototype.instances.size > 0
      #     prototype.instances.each do |fun|
      #       fun.mangled = @mangled
      #     end
      #   end
      # end
      # instance.mangled = @mangled
      # fun = @instances[instance.signature]
      # if fun && fun.body.type != instance.body.type
      #   fun.mangled_return_type = true
      #   instance.mangled_return_type = true
      # end
      @instances[instance.signature] = instance
      FunctionPrototype.add_instance instance
    end

    def [](signature)
      @instances && @instances[signature]
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

  class External
    def <<(instance)
      @instances ||= {}
      if instance.has_var_list?
        @instances[:VarList] = instance
      else
        @instances[instance.signature] = instance
      end
      FunctionPrototype.add_instance instance
    end

    def [](signature)
      @instances && (@instances[signature] || @instances[:VarList])
    end
  end

  class FunctionPrototype
    attr_accessor :functions
    @@instances = []

    def initialize
      @functions = {}
    end

    def <<(fun)
      function = functions[fun.signature]
      if function.nil?
        functions[fun.signature] = fun

        functions.sort do |i, j|
          i[0] <=> j[0]
        end
      else
        function.template << fun
      end
    end

    def lookup(signature)
      function = functions.find { |sig, fun| signature.child_of? sig }
      function[1].template.latest if function
    end

    def self.add_instance(instance)
      instance.sequence = @@instances.length
      @@instances << instance
    end

    def self.instances
      @@instances
    end

    def clone
      prototype = self.class.new
      functions.each do |sig, fun|
        new_fun = fun.clone
        new_fun.prototype = prototype
        new_fun.template = fun.template
        prototype.functions[sig] = new_fun
      end
      prototype
    end

    def to_s
      functions.map{|sig, fun| "#{fun.name}(#{sig})"}.join ';'
    end
  end
end