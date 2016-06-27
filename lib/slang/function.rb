module SLang
  class Function
    attr_accessor :id
    attr_accessor :owner
    attr_accessor :instances
    attr_accessor :template
    attr_accessor :calls

    def template
      if @template.nil?
        @template = FunctionTemplate.new(name)
        @template << self
      end
      @template
    end

    def <<(instance)
      @instances ||= {}
      @instances[instance.signature] = instance
      FunctionInstance.add_instance instance
    end

    def [](signature)
      @instances && @instances[signature]
    end

    def add_call(call)
      @calls ||= []
      @calls << call
    end

    def signature
      Signature.new(params.map(&:type))
    end

    def key
      [name, sequence, signature, body.type]
    end

    def has_var_list?
      params.any? && params.last.var_list?
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
      FunctionInstance.add_instance instance
    end

    def [](signature)
      @instances && (@instances[signature] || @instances[:VarList])
    end
  end

  class FunctionPrototype
    attr_accessor :functions

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

    def clone
      prototype = self.class.new
      functions.each do |sig, fun|
        new_fun = fun.clone
        new_fun.template = fun.template
        prototype.functions[sig] = new_fun
      end
      prototype
    end

    def to_s
      functions.map{|sig, fun| "#{fun.name}(#{sig})"}.join ';'
    end
  end

  class FunctionInstance
    @@instances = []

    def self.add_instance(instance)
      @@instances << instance
    end

    def self.instances
      id = 1
      @@instances.each do |instance|
        instance.id = id
        id += 1 unless instance.is_a?(External) || instance.is_a?(Lambda)
      end
      @@instances
    end

    def self.combine_same_instances
      uniq_instances = {}

      @@instances.each do |fun|
        if uniq_instances.has_key? fun.key
          old_fun = uniq_instances[fun.key]
          fun.calls.each { |call| call.target_fun = old_fun }
        else
          uniq_instances[fun.key] = fun
        end
      end

      @@instances = uniq_instances.values
      @@instances
    end
  end
end