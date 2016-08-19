module SLang
  class Enviroment
    attr_accessor :types

    def initialize
      @types = {}

      types[:Main] = ObjectType.new(:MainTop)
      types[:Kernel] = ModuleType.new(:Kernel)
      types[:Any] = BaseObjectType.new(:Any)
      types[:Any].include_module types[:Kernel]
      types[:Object] = ObjectType.new(:Object, types[:Any])
      types[:Class] = ObjectType.new(:Class, types[:Object])
      types[:UnionType] = UnionType.new
      types[:Array] = ArrayType.new

      base(:void, :Void)
      base(:int, :Integer)
      base(:double, :Float)
      base('void *', :Nil)
      base('char *', :String)
      base('void *', :Pointer)
      enum({False: 0, True: 1}, :Bool)
    end

    def object_type(name, parent = nil)
      types[name] ||= ObjectType.new(name, parent)
    end

    def module_type(name)
      types[name] ||= ModuleType.new(name)
    end

    def varlist
      VarList.new
    end

    def main
      types[:Main]
    end

    def lambda
      types[:Lambda] ||= LambdaType.new
    end

    def kernel
      types[:Kernel]
    end

    def any
      types[:Any]
    end

    def void
      types[:Void]
    end

    def int
      types[:Integer]
    end

    def float
      types[:Float]
    end

    def bool
      types[:Bool]
    end

    def nil
      types[:Nil]
    end

    def string
      types[:String]
    end

    def pointer
      types[:Pointer]
    end

    def base(ctype, name)
      types[name] if types.has_key? name
      type = CBaseType.new(name, ctype, any)
      types[name] = type
      type
    end

    def struct(members, name)
      type = types[name] || ObjectType.new(name)
      members.each { |member| type << member }
      types[name] = type
      type
    end

    def union(members)
      type = types[:UnionType]
      type.add_types members
      types[:UnionType] = type
      type
    end

    def union_type(type = nil)
      types[:UnionType]
      return types[:UnionType] unless type
      types[:UnionType] << type
      types[:UnionType]
    end

    def enum(members, name)
      type = types[name] || EnumType.new(name)
      members.each { |name, value| type.push(name, value) }
      types[name] = type
      type
    end

    def merge(*types)
      return Type.int if types.empty?
      uniq_types = types.delete_if{|t| t.any_type? || t.nil_type? }.map{|t| t.base_type }.uniq
      return uniq_types.last if uniq_types.size == 1
      union = union_type.new_instance
      union.add_types uniq_types
      union(union.members)
      union
    end

    def array_type(elements = [])
      types[:Array].new_array(elements)
    end

    def lookup(name)
      types[name]
    end

    def lookup_class(name)
      type = types[name]
      type && type.class_type
    end

    def include?(name)
      types.has_key? name
    end
  end
end