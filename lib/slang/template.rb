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

  class Member
    def hash
      name.hash + type.hash
    end

    def eql?(other)
      other == self
    end
  end

  class TypeTemplate < Template
    def combine_same_instances
      uniq_instances = {}

      @instances.each do |type|
        if uniq_instances.has_key? type.members
          old_type = uniq_instances[type.members]
          type.sequence = old_type.sequence
        else
          uniq_instances[type.members] = type
        end
      end

      @instances = uniq_instances.values
      @instances
    end
  end
end