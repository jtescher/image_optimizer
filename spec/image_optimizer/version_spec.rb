require 'spec_helper'

describe ImageOptimizer do
  it 'should have a VERSION constant' do
    ImageOptimizer::VERSION.should_not be_empty
  end
end
