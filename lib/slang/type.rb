module SLang
  class Type
    @@types = {}

    def self.types
      @@types
    end

    def self.object_type(name, parent = nil)
      types[name] ||= ObjectType.new(name, parent)
    end

    def self.module_type(name)
      types[name] ||= ModuleType.new(name)
    end

    def self.varlist
      VarList.new
    end
    
    def self.main
      types[:Main]
    end

    def self.lambda
      types[:Lambda]
    end

    def self.kernel
      types[:Kernel]
    end

    def self.any
      types[:Any]
    end

    def self.void
      types[:Void]
    end

    def self.int
      types[:Integer]
    end

    def self.float
      types[:Float]
    end

    def self.bool
      types[:Bool]
    end

    def self.nil
      types[:Nil]
    end

    def self.string
      types[:String]
    end

    def self.pointer
      types[:Pointer]
    end

    def self.array_type(elements = [])
      types[:Array].new_array(elements)
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
    attr_accessor :parent
    attr_accessor :type_id

    @@sequence = 0

    def initialize(obj, parent = nil)
      @functions = {}
      @ancestors = [obj]
      @template = TypeTemplate.new(obj.name)
      @parent = parent
      extend_parent(parent) if parent
      @type_id = @@sequence
      @@sequence += 1
    end

    def class_type(target)
      unless @class_type
        obj = ancestors.first
        @class_type = ClassType.new(obj.name)
        if parent
          @class_type.extend_parent(parent.class_type)
        else
          @class_type.extend_parent(Type.types[:Object])
        end
        @class_type.object_type = obj
        @class_type.target = target || Const.new(:Main)
      end
      @class_type
    end

    def add_function(fun)
      functions[fun.name] = FunctionPrototype.new unless functions.has_key? fun.name
      functions[fun.name] << fun
    end

    def lookup_function(name, signature)
      type = ancestors.find {|type| type.functions.has_key? name }
      type.functions[name].lookup signature if type
    end

    def add_instance(instance)
      template << instance
      instance
    end

    def extend_parent(parent)
      ancestors.push *parent.ancestors
    end

    def include_module(mod)
      ancestors.push mod
    end
  end

  class BaseType
    attr_accessor :name
    attr_accessor :parent
    attr_accessor :prototype
    attr_accessor :sequence

    def initialize(name, parent = nil, prototype = nil)
      @name = name
      @parent = parent
      @functions = []
      @sequence = 0
      @prototype = prototype || TypePrototype.new(self, parent)
    end

    def type_id
      prototype.type_id
    end

    def extend_parent(type)
      prototype.extend_parent(type)
    end

    def new_instance
      prototype.add_instance clone
    end

    def class_type(target = nil)
      prototype.class_type(target)
    end

    def template
      prototype.template
    end

    def include_module(mod)
      prototype.include_module mod
    end

    def add_function(fun)
      if fun.class_fun?
        class_type.prototype.add_function(fun)
      else
        prototype.add_function(fun)
      end
    end

    def lookup_function(name, signature)
      prototype.lookup_function name, signature
    end

    def functions
      prototype.functions
    end

    def ancestors
      prototype.ancestors
    end

    def target_type

    end

    def child_of?(type)
      ancestors.include? type
    end

    def cast_of?(type)
      return true if child_of?(type)
    end

    def union_type?
      self.kind_of? UnionType
    end

    def any_type?
      self == Type.any
    end

    def nil_type?
      self == Type.nil
    end

    def seq
      sequence > 0 ? sequence.to_s : ''
    end

    def hash
      name.hash
    end

    def eql?(other)
      other.class.eql?(self.class) && other.name == name
    end

    def ==(other)
      eql?(other)
    end

    def clone
      self.class.new template.name, parent, prototype
    end

    def to_s
      name.to_s
    end
  end

  class ObjectType < BaseType
    attr_accessor :members
    attr_accessor :consts

    def initialize(name, parent = nil, prototype = nil)
      super name, parent, prototype
      @members = {}
      @consts = {}
    end

    def <<(var)
      case var
      when Member
        define_instance_var(var)
      when ClassVar
        define_class_var(var)
      end
    end

    def define_instance_var(var)
      members[var.name] = var
    end

    def define_class_var(var)
      class_type << var
    end
    
    def define_const(const)
      class_type.define_const const
    end
    
    def define_class(const)
      class_type.define_class const
    end
    
    def lookup_const(name)
      class_type.lookup_const name
    end

    def include?(name)
      members.has_key? name
    end

    def lookup_instance_var(name)
      members[name]
    end

    def lookup_class_var(name)
      class_type.lookup_class_var name
    end

    def target
      Const.new(:Main)
    end

    def hash
      name.hash ^ members.hash
    end

    def eql?(other)
      super && other.members == members
    end

    def latest
      template.latest
    end

    def despect
      "<#{template.name}: #{members.map {|n, v| "#{v.type} #{n}"}.join ';'}>"
    end
  end

  class ContainerType < ObjectType
    include Enumerable

    def initialize(name, members = [], parent = nil, prototype = nil)
      super name, parent, prototype
      @members = members
    end

    def size
      members.size
    end

    def empty?
      members.empty?
    end

    def each(&block)
      items.each(&block)
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
  end

  class ClassType < ObjectType
    attr_accessor :object_type
    attr_accessor :target

    def initialize(name, parent = nil, prototype = nil)
      super name, parent, prototype
      ancestors.each do |type|
        type.consts.each {|name, const| consts[name] ||= const }
      end
      @target = Const.new(:Main)
    end

    def <<(var)
      members[var.name] = var
      var.target = target
    end
    
    def define_const(const)
      old_const = consts[const.name]
      raise "Redefined const '#{const.name}' in #{@name}" if old_const && old_const.target == target
      consts[const.name] = const
      const.target = target if const.target.nil?
    end
    
    def define_class(const)
      old_const = consts[const.name]
      raise "#{const.name} is not a class" if old_const && old_const.target == target && !old_const.type.is_a?(ClassType)
      consts[const.name] = const
      const.target = target if const.target.nil?
    end

    def lookup_instance_var(name)
      raise "Can't lookup instance var in Class"
    end

    def lookup_class_var(name)
      type = ancestors.find {|type| type.members.has_key? name }
      type.members[name] if type
    end
    
    def lookup_const(name)
      type = ancestors.find {|type| type.consts.has_key? name }
      type.consts[name] if type
    end
  end

  class ModuleType < ObjectType
    def initialize(name, prototype = nil)
      super name, Type.types[:Object], prototype
    end

    def clone
      self.class.new @name, prototype
    end
  end

  class UnionType < ObjectType
    attr_accessor :optional_type

    def initialize(parent = nil, prototype = nil)
      super :UnionType, Type.types[:Object], prototype
      @members = []
    end

    def <<(type)
      if type.union_type?
        type.members.each { |t| self << t }
      else
        members << type unless has_type? type
      end
    end

    def cast_of?(type)
      return true if super(type)
      return true if has_type?(type)
    end

    def add_types(types)
      types.each {|type| self << type}
    end

    def has_type?(type)
      members.any?{|t| t == type}
    end

    def include?(types)
      return has_type? types unless types.is_a? Array
      types.any? {|type| !has_type?(type)}
    end

    def despect
      "#{name}(#{members.join '|'})"
    end

    def clone
      self.class.new parent, prototype
    end
  end

  class EnumType < ObjectType
    def initialize(name, parent = nil, prototype = nil)
      super name, Type.types[:Object], prototype
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

  class VarList < ContainerType
    include Enumerable

    def initialize(parent = nil, prototype = nil)
      super :VarList, [], Type.types[:Object], prototype
    end

    def clone
      self.class.new parent, prototype
    end
  end

  class LambdaType < ObjectType
    def initialize(parent = nil, prototype = nil)
      super :Lambda, Type.types[:Object], prototype
    end

    def lookup_function(signature)
      prototype.lookup_function :lambda, signature
    end

    def clone
      self.class.new parent, prototype
    end
  end

  class ArrayType < ContainerType
    attr_accessor :size

    def initialize(elements = [], parent = nil, prototype = nil)
      super :Array, elements, Type.types[:Object], prototype
    end

    def new_array(elements)
      self.class.new elements, parent, prototype
    end

    def elements_type
      Type.merge(*members)
    end

    def clone
      self.class.new members, parent, prototype
    end
  end
end
