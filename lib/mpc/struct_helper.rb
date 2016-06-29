
module FFI
  module StructHelper
    # Define a set of member reader
    # Ex1: `member_reader [:one, :two, :three]`
    # Ex2: `member_reader *members`
    def member_reader(*members_to_define)
      members_to_define.each do |member|
        define_method member do
          self[member]
        end
      end

    end

    # Define a set of member writer
    # Ex1: `member_reader [:one, :two, :three]`
    # Ex2: `member_reader *members`
    def member_writer(*members_to_define)
      members_to_define.each do |member|
        define_method "#{member}=".to_sym do |value|
          self[member]= value
        end
      end
    end

    # Define a set of member accessor
    # Ex1: `member_accessor [:one, :two, :three]`
    # Ex2: `member_accessor *members`
    def member_accessor(*members_to_define)
      members_to_define.each do |member|
        define_method member do
          self[member]
        end
        define_method "#{member}=".to_sym do |value|
          self[member]= value
        end
      end
    end
  end

  class Struct
    extend StructHelper
  end
end