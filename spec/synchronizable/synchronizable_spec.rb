require 'spec_helper'

describe Synchronizable do
  context "when extended by an object" do
    let(:object) { String.new }

    it "creates an instance-level lock" do
      object.instance_variables.should_not include(:@__lock)
      object.extend(Synchronizable)
      object.instance_variables.should include(:@__lock)
    end

    it "creates a locked version of each original method" do
      class TestLock
        attr_reader :sync_invoked

        def initialize
          @sync_invoked = false
        end

        def synchronize(&block)
          @sync_invoked = true
        end
      end

      lock = TestLock.new
      object.extend(Synchronizable)
      object.instance_variable_set(:@__lock, lock)

      # methods from Object not wrapped
      object.object_id
      lock.sync_invoked.should == false

      # class-defined methods should be wrapped
      object.size
      lock.sync_invoked.should == true
    end

    it "allows re-entrant methods" do
      class Test
        def m1
          10
        end

        def m2
          m1
        end
      end

      t = Test.new
      t.extend(Synchronizable)
      t.m2.should == 10
    end
  end

  it "protects a block via #synchronize" do
    s = ""
    s.methods.should_not include(:synchronize)
    s.extend(Synchronizable)
    s.methods.should include(:synchronize)
    s.synchronize do
      s.split
    end
  end
end