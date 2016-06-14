module SLang
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

  class TypeTemplate < Template
  end
end