module SLang
  class BaseObjectType < BaseType
    def target_type
      "struct { #{display_members} }"
    end

    def define
      template.map do |obj|
        "typedef #{obj.target_type} #{obj.name};\n"
      end.join ''
    end

    def display_members
      if members.empty?
        return 'char unused;'
      end

      "#{members.map{|n, v| "#{v.optional ? Type.union_type : v.type.reference} #{n};"}.join ' '}"
    end

    def reference
      "#{name} *"
    end

    def base_type
      Type.pointer
    end

    def define_variable(var)
      "#{base_type} #{var}"
    end
  end

  class CBaseType < AnyType
    def initialize(name, target_type = nil)
      super name
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

    def clone
      self.clone name, target_type
    end
  end

  class ArrayType < SequenceType
    def reference
      "#{items_type} []"
    end

    def base_type
      self
    end

    def define_variable(var)
      "#{items_type} #{var}[#{size}]"
    end
  end

  class ObjectType < AnyType
    def name
      "#{@name}#{seq}"
    end
  end

  class ClassType < ObjectType
    def name
      "#{@name}_Class".to_sym
    end

    def instance_name
      "#{@name}_class".to_sym
    end

    def define
      "typedef #{target_type} #{name};\nstatic #{name} #{instance_name};\n"
    end
  end

  class UnionType < AnyType
    def target_type
      "union { #{display_members} }"
    end

    def define
      members.empty? ? '' : "typedef #{target_type} #{name};\n"
    end

    def display_members
      members.map {|t| "#{t.base_type} #{member(t)};"}.join ' '
    end

    def member(t)
      "u#{t.base_type}"
    end
  end

  class EnumType < AnyType
    def target_type
      "enum { #{display_members} }"
    end

    def display_members
      members.map {|name, value| "#{name} = #{value},"}.join ' '
    end
  end

  class VarList < SequenceType
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

  class LambdaType < AnyType
    def name
      "#{@name}#{seq}"
    end
  end

  class ModuleType < BaseObjectType

  end

  class Type
    def self.init_base_types
      base(:void, :Void)
      base(:int, :Integer)
      base(:double, :Float)
      base('char *', :String)
      base('void *', :Pointer)
      enum({False: 0, True: 1}, :Bool)
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
      members.each_key { |member| type << member }
      types[name] = type
      type
    end

    def self.union(members)
      type = types[:UnionType] || UnionType.new(:UnionType)
      members.each { |member| type << member }
      types[:UnionType] = type
      type
    end

    def self.union_type(type = nil)
      types[:UnionType] ||= UnionType.new(:UnionType)
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
      uniq_types = types.uniq
      return uniq_types.last if uniq_types.size == 1
      self.union uniq_types
    end
  end
end
