module SLang
  class TypePrototype
    attr_accessor :methods
    attr_accessor :template
    attr_accessor :ancestors

    def initialize(parent = nil)
      @methods = {}
      @ancestors = [self]
      @template = ObjectTypeTemplate.new
      extend(parent) if parent
    end

    def add_method(fun)
      prototype = methods[fun.name] || FunctionPrototype.new
      prototype << fun
      fun.prototype = prototype
      methods[fun.name] = prototype
      prototype
    end

    def lookup_method(name, arg_size = 0)
      prototype = methods[name]
      prototype.lookup arg_size if prototype
    end

    def add_instance(instance)
      template << instance
      instance
    end

    def extend(parent)
      ancestors.push parent, *parent.prototype.ancestors
      ancestors.each do |type|
        type.prototype.methods.each_pair {|name, fun| methods[name] = fun unless methods[name]}
      end
    end
  end

  class ObjectType
    attr_accessor :name
    attr_accessor :parent
    attr_accessor :members
    attr_accessor :functions
    attr_accessor :prototype

    def initialize(name, parent = nil, prototype = nil)
      @name = name
      @parent = parent
      @members = {}
      @functions = []
      @prototype = prototype || TypePrototype.new(parent)
    end

    def new_instance
      prototype.add_instance clone
    end

    def add_member(var)
      members[var.name] = var
    end

    def lookup_member(name)
      members[name]
    end

    def add_function(fun)
      method = prototype.add_method(fun)
      functions << method if method
    end

    def lookup_function(fun)
      prototype.lookup_method fun
    end

    def ancestors
      prototype.ancestors
    end

    def display_members
      "#{members.map{|n, v| "#{v.type} #{n};"}.join ' '}"
    end

    def clone
      self.class.new name, parent, prototype
    end
  end
end