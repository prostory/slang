module SLang
  class Template
    include Enumerable

    attr_accessor :name

    def initialize(name)
      @name = name
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

    def to_s
      name.to_s
    end
  end

  class FunctionTemplate < Template
  end

  class TypeTemplate < Template
  end
end