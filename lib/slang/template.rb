module SLang
  class Template
    include Enumerable

    attr_accessor :name

    def initialize(name, instances = [])
      @name = name
      @instances = instances || []
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

    def clone
      self.class.new name, @instances.clone
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
        if uniq_instances.has_key?(type)
          old_type = uniq_instances[type]
          type.sequence = old_type.sequence
        else
          uniq_instances[type] = type
        end
      end

      @instances = uniq_instances.values
      @instances
    end
  end
end