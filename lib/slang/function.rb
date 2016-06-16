module SLang
  class FunctionPrototype
    attr_accessor :functions
    attr_accessor :instances
    attr_accessor :specific_function

    def initialize
      @functions = {}
      @instances = []
    end

    def set_specific_function(fun)
      if @specific_function
        @specific_function.template << fun
      else
        @specific_function = fun
      end
    end

    def <<(fun)
      if fun.has_var_list?
        set_specific_function fun
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
      function = functions.select { |signature, function| sig.child_of? signature }.to_a.flatten[1] || specific_function
      function.template.latest if function
    end

    def add_instance(instance)
      @instances << instance
    end
  end
end