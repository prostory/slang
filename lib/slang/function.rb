module SLang
  class Function
    attr_accessor :id
    attr_accessor :owner
    attr_accessor :instances
    attr_accessor :template
    attr_accessor :calls
    attr_accessor :variables

    def template
      if @template.nil?
        @template = FunctionTemplate.new(name)
        @template << self
      end
      @template
    end

    def <<(instance)
      @instances ||= {}
      instance.variables = variables
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

    def add_recursive_call(call)
      @recursive_calls ||= []
      @recursive_calls << call
      call.unreached = true
      call.unreachable = true
    end

    def recursive_calls
      @recursive_calls
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

    def chain
      @chain || []
    end

    def set_chain(chain)
      @chain = chain || []
      @chain << self
    end

    def closed_loop?
      chain[0..-2].find {|fun| fun == self} != nil
    end

    def calls
      @calls || []
    end

    def clear_variables
      @variables = []
    end

    def add_variable(var)
      @variables ||= []
      @variables << var
    end

    def variables
      @variables || []
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
        new_fun.template = fun.template.clone
        prototype.functions[sig] = new_fun
      end
      prototype
    end

    def to_s
      functions.map do |sig, fun|
        s = if fun.receiver then "#{fun.receiver.name}." else "" end
        s << "#{fun.name}(#{sig})"
        s
      end.join ';'
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
      list = []

      @@instances.each do |fun|
        if uniq_instances.has_key? fun.key
          old_fun = uniq_instances[fun.key]
          if old_fun.receiver == fun.receiver && old_fun.scope == fun.scope && old_fun.return_type == fun.return_type
            fun.calls.each { |call| call.target_fun = old_fun }
          else
            list << fun
          end
        else
          uniq_instances[fun.key] = fun
          list << fun
        end
      end

      @@instances = list
      @@instances
    end
  end
end