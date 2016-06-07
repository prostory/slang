module SLang
  class FunctionPrototype
    attr_accessor :templates
    attr_accessor :instances

    def initialize
      @templates = {}
      @instances = []
    end

    def <<(fun)
      if fun.has_var_list?
        template = templates[:varlist] || FunctionTemplate.new
        template << fun
        templates[:varlist] = template
      else
        template = templates[fun.params.size] || FunctionTemplate.new
        template << fun
        templates[fun.params.size] = template
      end
    end

    def lookup(args_size)
      template = templates[args_size] || templates[:varlist]
      template && template.latest
    end

    def add_instance(instance)
      @instances << instance
    end
  end

  class FunctionTemplate
    def initialize
      @functions = []
    end

    def <<(fun)
      fun.sequence = @functions.length
      @functions << fun
    end

    def empty?
      @functions.empty?
    end

    def latest
      @functions.last
    end
  end
end