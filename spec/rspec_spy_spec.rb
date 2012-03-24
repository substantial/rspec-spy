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
  end

  context do
    spy do
      it "should work in nested contexts" do
        collaborator.should_receive :message
      end
    end
  end

  spy do
    specify "should work with specify" do
      collaborator.should_receive :message
    end
  end
end
