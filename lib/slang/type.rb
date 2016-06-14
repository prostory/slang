module SLang
  class Type
    @@types = {}

    def self.types
      @@types
    end

    def self.object(name, parent = nil)
      types[name] ||= ObjectType.new(name, parent)
    end

    def self.lookup(name)
      types[name]
    end

    def self.lookup_class(name)
      type = types[name]
      type && type.class_type
    end

    def self.include?(name)
      types.has_key? name
    end
  end

  class TypePrototype
    attr_accessor :functions
    attr_accessor :template
    attr_accessor :ancestors
    attr_accessor :class_type

    def initialize(obj, parent = nil)
      @functions = {}
      @ancestors = [obj]
      @template = ObjectTypeTemplate.new
      extend(parent)
    end

    def class_type
      unless @class_type
        obj = ancestors.first
        parent = ancestors[1]
        @class_type = ClassType.new(obj.name, parent && parent.class_type)
        @class_type.object_type = obj
      end
      @class_type
    end

    def add_function(fun)
      prototype = functions[fun.name]
      if prototype.nil?
        prototype = fun.new_prototype
        functions[fun.name] = prototype
        return prototype
      end
      prototype << fun
      fun.prototype = prototype
      nil
    end

    def lookup_function(name, args)
      prototype = functions[name]
      prototype.lookup args if prototype
    end

    def add_instance(instance)
      template << instance
      instance
    end

    def extend(parent)
      if parent.nil?
        Type.main.ancestors.each do |type|
          type.prototype.functions.each do |name, prototype|
            functions[name] = prototype unless functions.has_key? name
          end
        end if Type.main
        return
      end

      ancestors.push parent, *parent.ancestors
      parent.ancestors.each do |type|
        type.prototype.functions.each do |name, prototype|
          functions[name] = prototype unless functions.has_key? name
        end
      end
    end
  end

  class BaseType
    attr_accessor :name
    attr_accessor :parent
    attr_accessor :functions
    attr_accessor :prototype
    attr_accessor :sequence

    def initialize(name, parent = nil, prototype = nil)
      @name = name
      @parent = parent
      @functions = []
      @prototype = prototype || TypePrototype.new(self, parent)
      @sequence = 0
    end

    def new_instance
      prototype.add_instance clone
    end

    def class_type
      prototype.class_type
    end

    def template
      prototype.template
    end

    def add_function(fun)
      if fun.is_a? ClassFun
        function = class_type.prototype.add_function(fun)
        class_type.functions << function if function
      else
        function = prototype.add_function(fun)
        functions << function if function
      end
    end

    def lookup_function(name, args)
      prototype.lookup_function name, args
    end

    def ancestors
      prototype.ancestors
    end

    def target_type

    end

    def seq
      sequence > 0 ? sequence.to_s : ''
    end

    def clone
      self.class.new @name, parent, prototype
    end

    def to_s
      name.to_s
    end
  end

  class ObjectType < BaseType
    attr_accessor :members

    def initialize(name, parent = nil, prototype = nil)
      super name, parent, prototype
      @members = {}
    end

    def <<(var)
      members[var.name] = var
    end

    def include?(name)
      members.has_key? name
    end

    def [](name)
      members[name]
    end
  end

  class ClassType < ObjectType
    attr_accessor :object_type
    attr_accessor :class_vars

    def initialize(name, parent = nil, prototype = nil)
      super name, parent, prototype
      @class_vars = {}
      ancestors.each do |type|
        type.members.each {|name, var| class_vars[name] = var unless class_vars[name]}
      end
    end

    def <<(var)
      members[var.name] = var
      class_vars[var.name] = var
    end

    def [](name)
      class_vars[name]
    end
  end

  class UnionType < BaseType
    attr_accessor :members

    def initialize(name, parent = nil, prototype = nil)
      super name, parent, prototype
      @members = []
    end

    def <<(type)
      members << type unless has_type? type
    end

    def add_types(types)
      types.each {|type| self << type}
    end

    def has_type?(type)
      members.any?{|t| t == type}
    end

    def include?(types)
      return has_type? type unless types.is_a? Array
      types.any? {|type| !has_type?(type)}
    end

    def eql?(other)
      (self == other) || (include? other)
    end
  end

  class EnumType < BaseType
    attr_accessor :members

    def initialize(name, parent = nil, prototype = nil)
      super name, parent, prototype
      @members = {}
    end

    def push(name, value = nil)
      value = if members.empty?
        value || 0
      else
        value || members.last + 1
      end
      members[name] = value
    end

    def include?(name)
      members.has_key?(name)
    end
  end

  class VarList < BaseType
    include Enumerable

    attr_accessor :members

    def initialize(parent = nil, prototype = nil)
      super :VarList, parent, prototype
      @members = []
    end

    def size
      members.size
    end

    def empty?
      members.empty?
    end

    def each(&block)
      members.each(&block)
    end

    def [](index)
      members[index]
    end

    def []=(index, type)
      members[index] = type
    end

    def <<(type)
      members << type
    end

    def ==(other)
      other.class == self.class && other.members == members
    end

    def clone
      self.class.new parent, prototype
    end
  end

  class LambdaType < BaseType
    def initialize(parent = nil, prototype = nil)
      super :Lambda, parent, prototype
    end

    def lookup_function(args)
      prototype.lookup_function :lambda, args
    end

    def clone
      self.class.new parent, prototype
    end
  end
end