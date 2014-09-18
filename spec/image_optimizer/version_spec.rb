require 'spec_helper'

describe ImageOptimizer do
  it 'should have a VERSION constant' do
    expect(ImageOptimizer::VERSION).to_not be_empty
  end
end
