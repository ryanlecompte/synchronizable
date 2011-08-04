require 'monitor'
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
      original_method = obj.method(m)
      next if IGNORABLE_METHOD_OWNERS.include?(original_method.owner)

      obj.define_singleton_method(m) do |*args, &block|
        __lock.synchronize do
          original_method.call(*args, &block)
        end
      end
    end

    # define synchronize method that executes a block
    # protected with the internal instance lock
    obj.define_singleton_method(:synchronize) do |&block|
      __lock.synchronize(&block)
    end
  end

  private

  def __lock
    # Monitor is used instead of Mutex in order to support
    # re-entrant locking
    @__lock ||= Monitor.new
  end
end
