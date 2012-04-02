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

  spy do
    it "should work with should_receive" do
      collaborator.should_receive :message
    end

    it "should work with multiple in one spy block" do
      collaborator.should_receive :message
    end

    it "should work with not" do
      collaborator.should_not_receive :other_message
    end
  end

  spy do
    specify "should work with specify" do
      collaborator.should_receive :message
    end
  end
end

describe RSpec::Spy do
  let(:collaborator) { stub.as_null_object }

  before do
    Subject.new.go(collaborator)
  end

  context do
    spy do
      it "should work in nested contexts" do
        collaborator.should_receive :message
      end
    end
  end
end

describe RSpec::Spy, "the old way" do
  let(:collaborator) { stub.as_null_object }

  before do
    collaborator.should_receive! :message
    Subject.new.go(collaborator)
  end

  it "should still work" do
  end
end
