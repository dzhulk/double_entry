# encoding: utf-8
module DoubleEntry
  class Account
    class Set < Array
      def <<(account)
        if detect { |a| a.identifier == account.identifier }
          raise DuplicateAccount.new
        else
          super(account)
        end
      end
    end

    class Instance
      attr_accessor :account, :scope

      def initialize(attributes)
        attributes.each { |name, value| send("#{name}=", value) }
      end

      def method_missing(method, *args)
        if block_given?
          account.send(method, *args, &Proc.new)
        else
          account.send(method, *args)
        end
      end

      def scope_identity
        scope_identifier.call(scope).to_s if scoped?
      end

      def balance(args = {})
        DoubleEntry.balance(self, args)
      end

      include Comparable

      def ==(other)
        other.is_a?(self.class) && identifier == other.identifier && scope_identity == other.scope_identity
      end

      def eql?(other)
        self == other
      end

      def <=>(account)
        if scoped?
          [scope_identity, identifier.to_s] <=> [account.scope_identity, account.identifier.to_s]
        else
          identifier.to_s <=> account.identifier.to_s
        end
      end

      def hash
        if scoped?
          "#{scope_identity}:#{identifier}".hash
        else
          identifier.hash
        end
      end

      def to_s
        "\#{Account account: #{identifier} scope: #{scope}}"
      end

      def inspect
        to_s
      end
    end

    attr_accessor :identifier, :scope_identifier, :positive_only

    def initialize(attributes)
      attributes.each { |name, value| send("#{name}=", value) }
    end

    def scoped?
      !!scope_identifier
    end
  end
end