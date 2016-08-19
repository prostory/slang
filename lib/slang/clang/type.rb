require_relative '../type'

module SLang
  class Variable
    def type_reference
      return Type.union_type.reference if optional_type
      type.reference
    end  
  end

  class ObjectType
    def target_type
      "struct { #{display_members} }"
    end

    def define
      template.combine_same_instances

      template.map do |obj|
        "typedef #{obj.target_type} #{obj.name};\n"
      end.join ''
    end

    def display_members
      if members.empty?
        return 'char unused;'
      end

      "#{members.map{|n, v| "#{v.type_reference} #{n};"}.join ' '}"
    end

    def reference
      "#{name} *"
    end

    def base_type
      Type.pointer
    end

    def define_variable(var)
      "#{reference} #{var}"
    end

    def name
      "#{@name}#{seq}"
    end
  end

  class CBaseType < ObjectType
    def initialize(name, target_type = nil)
      super name, Type.types[:Object]
      @target_type = target_type
    end

    def define
      target_type.nil? ? '' : "typedef #{target_type} #{name};\n"
    end

    def reference
      name.to_s
    end

    def base_type
      self
    end

    def target_type
      @target_type
    end

    def name
      @name.to_s
    end

    def clone
      self.clone name, target_type
    end
  end

  class ClassType
    def name
      "#{@name}_Class".to_sym
    end

    def define
      "typedef #{target_type} #{name};\n"
    end

    def define_consts
      consts.values.map { |const| "static #{const.type} #{const.mangled_name};\n" }.join
    end
  end

  class UnionType
    def target_type
      "union { #{display_members} }"
    end

    def define
      members.empty? ? '' : "typedef #{target_type} #{name};\n"
    end

    def display_members
      members.map {|t| "#{t.base_type} #{member(t)};"}.join ' '
    end

    def reference
      name.to_s
    end

    def base_type
      self
    end

    def member(t)
      "u#{t.base_type}"
    end

    def name
      @name.to_s
    end
  end

  class EnumType
    def define
      members.empty? ? '' : "typedef #{target_type} #{name};\n"
    end

    def reference
      name.to_s
    end

    def base_type
      self
    end

    def target_type
      "enum { #{display_members} }"
    end

    def display_members
      members.map {|name, value| "#{name} = #{value},"}.join ' '
    end

    def name
      @name.to_s
    end
  end

  class VarList
    def reference
      s = ''
      members.each_with_index do |t, i|
        s << "#{t.reference} var#{i}"
        s << ', ' if i < members.length-1
      end
      s
    end

    def vars
      vars = []
      members.each_with_index do |t, i|
        vars << Variable.new("var#{i}", t)
      end
      vars
    end

    def to_s
      members.join '_'
    end
  end

  class LambdaType
    def name
      "#{@name}#{seq}"
    end
  end

  class ModuleType

  end

  class ArrayType
    def reference
      "#{elements_type} *"
    end

    def base_type
      Type.pointer
    end
  end

  class Type
    def self.init_base_types
      types[:Kernel] = ModuleType.new(:Kernel)
      types[:Any] = ObjectType.new(:Any)
      types[:Object] = ObjectType.new(:Object, types[:Any])
      types[:Object].include_module types[:Kernel]
      types[:Class] = ObjectType.new(:Class, types[:Object])
      types[:Main] = ObjectType.new(:MainTop, types[:Object])
      base(:void, :Void)
      base(:int, :Integer)
      base(:double, :Float)
      base('void *', :Nil)
      base('char *', :String)
      base('void *', :Pointer)
      enum({False: 0, True: 1}, :Bool)
      types[:UnionType] = UnionType.new
      types[:Array] = ArrayType.new
      types[:Lambda] = LambdaType.new
      union_type
    end

    def self.base(ctype, name)
      types[name] if types.has_key? name
      type = CBaseType.new(name, ctype)
      types[name] = type
      type
    end

    def self.struct(members, name)
      type = types[name] || ObjectType.new(name)
      members.each { |member| type << member }
      types[name] = type
      type
    end

    def self.union(members)
      type = types[:UnionType] || UnionType.new
      type.add_types members
      types[:UnionType] = type
      type
    end

    def self.union_type(type = nil)
      types[:UnionType] ||= UnionType.new
      return types[:UnionType] unless type
      types[:UnionType] << type
      types[:UnionType]
    end

    def self.enum(members, name)
      type = types[name] || EnumType.new(name)
      members.each { |name, value| type.push(name, value) }
      types[name] = type
      type
    end

    def self.merge(*types)
      return Type.int if types.empty?
      uniq_types = types.delete_if{|t| t.any_type? || t.nil_type? }.map{|t| t.base_type }.uniq
      return uniq_types.last if uniq_types.size == 1
      union = union_type.new_instance
      union.add_types uniq_types
      self.union(union.members)
      union
    end
  end
end
