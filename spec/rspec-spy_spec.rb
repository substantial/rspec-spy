require 'spec_helper'
require 'rspec-spy'

class Subject
  def go(collaborator)
    collaborator.message
  end
end

describe RSpec::Spy do
  let(:collaborator) { stub.as_null_object }

  before do
    Subject.new.go(collaborator)
  end

  it "should work with should_have_received", :spy do
    collaborator.should_have_received :message
  end

  it "should work with multiple in one spy block", :spy do
    collaborator.should_have_received :message
  end

  it "should work with not", :spy do
    collaborator.should_not_have_received :other_message
  end

  specify "should work with specify", :spy do
    collaborator.should_have_received :message
  end
end

describe RSpec::Spy do
  let(:collaborator) { stub.as_null_object }

  before do
    Subject.new.go(collaborator)
  end

  context do
    it "should work in nested contexts", :spy do
      collaborator.should_have_received :message
    end
  end
end

describe RSpec::Spy, "the old way" do
  let(:collaborator) { stub.as_null_object }

  before do
    collaborator.should_have_received! :message
    collaborator.should_not_have_received! :message2
    Subject.new.go(collaborator)
  end

  it "should still work" do
  end
end

describe RSpec::Spy, "should_have_received outside of spy block" do
  let(:collaborator) { stub.as_null_object }

  it "should warn" do
    lambda { collaborator.should_have_received :message }.should raise_error
    lambda { collaborator.should_not_have_received :message }.should raise_error
  end
end

describe RSpec::Spy, "setting on context" do
  let(:collaborator) { stub.as_null_object }

  before do
    Subject.new.go(collaborator)
  end

  context "spies", :spy do
    it "should work" do
      collaborator.should_have_received :message
    end
  end
end

describe RSpec::Spy, "nil warning" do
  it "should warn me if I try to should_have_received on nil", :spy do
    lambda { @unknown.should_have_received :message }.should raise_error
    lambda { @unknown.should_not_have_received :message }.should raise_error
  end

  it "should not warn me if I allow message expectations on nil", :spy do
    RSpec::Mocks::Proxy.allow_message_expectations_on_nil
    lambda { @unknown.should_not_have_received :message }.should_not raise_error
  end
end

