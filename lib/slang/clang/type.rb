module SLang
  module CLang
    class CBaseType
      attr_accessor :name
      attr_accessor :type
      attr_accessor :reference_type

      def initialize(name, type, reference_type = nil)
        @name = name
        @type = type
        @reference_type = reference_type || type
      end

      def define
        raise "Base type #{type.name} can't has any members<#{type.display_members}>." unless members.empty?
        "typedef #{name} #{type.name};\n"
      end

      def reference
        type.name
      end

      def to_s
        name
      end
    end

    class CObjectType < CBaseType
      def initialize(type, reference_type)
        @type = type
        @reference_type = reference_type
      end

      def name
        "struct { #{display_members} }"
      end

      def display_members
        if type.members.empty?
          return "#{context.int.reference_type} unused;"
        end

        type.display_members
      end

      def define
        "typedef #{name} #{type.name};\n"
      end

      def reference
        "#{type.name} *"
      end
    end

    class CClassType < CObjectType
      attr_accessor :class_name
      attr_accessor :object_type

      def initialize(context, name, super_type)
        super context, "#{name}_Class".to_sym, super_type
        @class_type = self
        @class_name = "#{name}_class"
      end

      def define
        "typedef #{type} #{name};\nstatic #{name} #{class_name};\n"
      end

      def display_members
        if members.empty?
          return "#{context.int.ref} unused;"
        end
        members.map {|name, var| "#{var.optional ? context.union_type : var.type.ref} #{name};"}.join ' '
      end
    end

    # class ObjectType < CStruct
    #   attr_accessor :instances
    #
    #   def initialize(context, name, super_type)
    #     super context, {}, name
    #     @base_type = context.pointer
    #     @super_type = super_type
    #   end
    #
    #   def define
    #     return super unless instances
    #
    #     unless instances.size > 1
    #       return instances.map {|obj| obj.define}.join "\n"
    #     end
    #
    #     list = {}
    #     instances.map do |obj|
    #       unless list[obj.members]
    #         list[obj.members] = obj
    #       else
    #         list[obj.members].methods.each do |f1|
    #           obj.methods.each do |f2|
    #             f2.params.first.type = f1.params.first.type
    #             f2.owner = f1.owner
    #             if f2.name == f1.name && f2.params.map(&:type) == f1.params.map(&:type)
    #               f2.redefined = true
    #             end
    #           end
    #         end
    #       end
    #       obj.name = "#{name}#{list.length}"
    #       obj
    #     end
    #     @instances = list.values
    #     instances.map do |obj|
    #       "typedef #{obj.type} #{obj.name};\n"
    #     end.join ''
    #   end
    #
    #   def display_members
    #     if members.empty?
    #       return "#{context.int.ref} unused;"
    #     end
    #     members.map {|name, var| "#{var.optional ? context.union_type : var.type.ref} #{name};"}.join ' '
    #   end
    #
    #   def despect
    #     "#{name}<#{members.map {|name, var| "#{name}:#{var.type}"}.join ', '}>"
    #   end
    #
    #   def clone
    #     obj = ObjectType.new context, name, super_type
    #     obj.template = self
    #     obj.class_type = class_type
    #     @instances ||= []
    #     @instances << obj
    #     obj
    #   end
    # end



    class CUnion < CStruct
      def type
        "union { #{display_members} }"
      end

      def ref
        base_type
      end

      def ==(other)
        other.class == self.class && name == other.name
      end
    end

    class UnionType < CUnion
      def initialize(context)
        super context, {}, :UnionType
      end

      def <<(type)
        members[type] = "U#{type}" unless members[type]
      end

      def define
        members.empty? ? "" : super
      end

      def add_types(types)
        types.each {|type| self << type}
      end

      def display_members
        members.map {|t, n| "#{t.base_type} #{n};"}.join ' '
      end

      def despect
        "#{name}<#{members.keys.join ', '}>"
      end

      def has_type?(type)
        members.has_key? type
      end

      def include?(types)
        return has_type? type unless types.is_a? Array
        types.any? {|type| !members.has_key?(type)}
      end

      def eql?(other)
        (self == other) || (include? other)
      end
    end

    class CEnum < CStruct
      def type
        "enum { #{display_members} }"
      end

      def ref
        base_type
      end

      def display_members
        members.join ', '
      end

      def despect
        "#{name}<#{members.join ', '}>"
      end
    end


    class VarList < BaseType
      include Enumerable

      attr_accessor :list

      def initialize(context)
        super context, :VarList, :Pointer
        @list = []
      end

      def ref
        s = ''
        @list.each_with_index do |t, i|
          s << "#{t.ref} var#{i}"
          s << ', ' if i < @list.length-1
        end
        s
      end

      def vars
        vars = []
        @list.each_with_index do |t, i|
          vars << Variable.new("var#{i}", t)
        end
        vars
      end

      def size
        @list.size
      end

      def empty?
        @list.empty?
      end

      def each(&block)
        @list.each(&block)
      end

      def [](index)
        @list[index]
      end

      def []=(index, type)
        @list[index] = type
      end

      def <<(type)
        @list << type
      end

      def to_s
        @list.join '_'
      end

      def ==(other)
        other.class == self.class && other.list == list
      end
    end

    class CType
      attr_accessor :context
      attr_accessor :types

      def initialize(context)
        @context = context
        @types = {}
      end

      def [](name)
        return context.void if name == :unknown
        types[name]
      end

      def []=(name, type)
        types[name] = type
      end

      def define_types
        types.values.each { |type| stream << "#{type.define}" }
      end

      def declare_functions
        types.values.each { |type| type.cfunc.declare_functions }
      end

      def define_functions
        types.values.each { |type| type.cfunc.define_functions }
      end

      def base(ctype, name)
        @types[name] if @types.has_key? name
        type = BaseType.new(context, name, ctype)
        @types[name] = type
        type
      end

      def struct(members, name = nil)
        key = name.nil? ? members : name
        return @types[key] if @types.has_key? key
        type = CStruct.new(context, members, name)
        @types[key] = type
        type
      end

      def union(members, name = nil)
        key = name.nil? ? members : name
        return @types[key] if @types.has_key? key
        type = CUnion.new(context, members, name)
        @types[key] = type
        type
      end

      def enum(members, name = nil)
        key = name.nil? ? members : name
        return @types[key] if @types.has_key? key
        type = CEnum.new(context, members, name)
        @types[key] = type
        key
      end

      def merge(t1, t2)
        if t1 == t2
          t1
        else
          union [t1, t2].flatten.uniq
        end
      end

      private
      def stream
        context.codegen.stream
      end
    end
  end
end
