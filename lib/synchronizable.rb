require 'thread'
require 'synchronizable/version'

# Synchronizable is intended to be injected into objects via Object#extend.
# After Object#extend(Synchronizable) is performed, the object's original
# methods will become synchronized via a per-instance lock.
module Synchronizable
  IGNORABLE_METHOD_OWNERS = [Object, Kernel, BasicObject]

  def self.extended(obj)
    # immediately create object-level lock
    obj.send(:__lock)

    # redefine all user-defined methods to utilize lock
    obj.methods.each do |m|
      next if IGNORABLE_METHOD_OWNERS.include?(obj.method(m).owner)
      obj.define_singleton_method(m) do |*args, &block|
        __lock.synchronize do
          super(*args, &block)
        end
      end
    end
  end

  private

  def __lock
    @__lock ||= Mutex.new
  end
end
