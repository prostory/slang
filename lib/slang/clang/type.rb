module SLang
  module CLang
    class BaseType
      attr_accessor :name
      attr_accessor :type

      def initialize(name, type)
        @name = name
        @type = type
      end

      def define
        "typedef #{type} #{name};"
      end

      def to_s
        name.to_s
      end

      def ==(other)
        other.class == self.class && other.name == name &&
          other.type.to_s == type.to_s
      end
    end

    class CStruct < BaseType
      attr_accessor :members

      def initialize(members, name)
        @name = name
        @members = members
      end

      def type
        "struct { #{display_members} }"
      end

      def define
        name.nil? ? "" : super
      end

      def display_members
        members.map {|n, t| "#{t} #{n};"}.join ' '
      end
    end

    class CUnion < CStruct
      def type
        "union { #{display_members} }"
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

      def define_types
        types.each do |_, type|
          stream << type.define.to_s
          stream << "\n"
        end
      end

      def base(ctype, name)
        @types[name] if @types.has_key? name
        type = BaseType.new(name, ctype)
        @types[name] = type
        type
      end

      def struct(members, name = nil)
        key = name.nil? ? members : name
        @types[key] if @types.has_key? key
        type = CStruct.new(members, name)
        @types[key] = type
        type
      end

      def union(members, name = nil)
        types = members
        if members.is_a? Array
          types = {}
          members.each_with_index { |mem, i| types["t#{i}"] = mem }
        end
        key = name.nil? ? types : name
        @types[key] if @types.has_key? key
        type = CUnion.new(types, name)
        @types[key] = type
        type
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