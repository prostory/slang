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

    def lookup(args)
      template = templates[args.size] || templates[:varlist]
      template.latest if template
    end

    def add_instance(instance)
      @instances << instance
    end
  end

  class ExternalPrototype
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
        signature = Function.signature(fun)
        template = templates[signature] || FunctionTemplate.new
        template << fun
        templates[signature] = template
      end
    end

    def lookup(args)
      template = templates[args.map(&:type)] || templates[:varlist]
      template.latest if template
    end

    def add_instance(instance)
      @instances.pop
      @instances.push instance
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
      @instances.each(&block)
    end

    def empty?
      @instances.empty?
    end

    def size
      @instances.size
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