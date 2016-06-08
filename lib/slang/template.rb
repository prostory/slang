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

  class Template
    include Enumerable

    def initialize
      @instances = []
    end

    def <<(instance)
      instance.sequence = @instances.length
      @instances << instance
    end

    def each(&block)
      children.each(&block)
    end

    def empty?
      @instances.empty?
    end

    def latest
      @instances.last
    end
  end

  class FunctionTemplate < Template
  end

  class ObjectTypeTemplate < Template
  end
end