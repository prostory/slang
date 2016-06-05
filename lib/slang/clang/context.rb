module SLang
  module CLang
    class Context
      attr_accessor :scopes
      attr_accessor :type
      attr_accessor :codegen

      def initialize
        @ctype = CType.new(self)
        @cfunc = CFunction.new(self)
        @scopes = [Scope.new(main, nil)]
        @type = TypeVisitor.new(self)
        @codegen = CodeGenVisitor.new(self)

        base_type(:void, :Void)
        base_type(:int, :Integer)
        base_type(:double, :Float)
        base_type('char *', :String)
        base_type('void *', :Pointer)
        enum([:False, :True], :Bool)
        union_type
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

      def string
        types[:String]
      end

      def pointer
        types[:Pointer]
      end

      def base_type(type, name)
        @ctype.base(type, name)
      end

      def struct(members, name = nil)
        @ctype.struct members, name
      end

      def union(members, name = nil)
        @ctype.union members, name
      end

      def enum(members, name = nil)
        @ctype.enum members, name
      end

      def object_type(name, super_type = nil)
        types[name] ||= ObjectType.new(self, name, super_type)
      end

      def union_type(type = nil)
        types[:UnionType] ||= UnionType.new(self)
        return types[:UnionType] unless type
        types[:UnionType] << type
        types[:UnionType]
      end

      def merge(t1, t2)
        @ctype.merge t1, t2
      end

      def types
        @ctype.types
      end

      def main
        nil
      end

      def type_inference(node)
        node.accept type
        self
      end

      def gen_code(node)
        type_inference node

        @ctype.define_types

        @ctype.declear_functions
        @cfunc.declear_functions

        @ctype.define_functions
        @cfunc.define_functions

        codegen.to_s
      end

      def add_function(fun)
        if class_def = fun.receiver
          if fun.is_a? ClassFun
            @ctype.types[class_def.name].class_type.cfunc << fun
          else
            @ctype.types[class_def.name].cfunc << fun
          end
        else
          @cfunc << fun
        end
        fun
      end

      def lookup_function(name, obj = nil)
        if obj
          type = obj.type
          while type
            template = type.cfunc[name]
            return template.function if template
            type = type.template.super_type
          end
        end
        @cfunc[name] && @cfunc[name].function
      end

      def define_variable(var)
        scope << var
      end

      def lookup_variable(name)
        scope.lookup_variable name
      end

      def lookup_member(name)
        scope.lookup_member name
      end

      def lookup_class_var(name)
        scope.lookup_class_var(name)
      end


      def new_scope(obj, type)
        @scopes.push(Scope.new obj, type)
        yield
        @scopes.pop
      end

      def scope
        @scopes.last
      end
    end
  end
end