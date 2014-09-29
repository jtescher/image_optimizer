require 'spec_helper'

class TestShell
  include ImageOptimizer::Shell
end

describe ImageOptimizer::Shell do
  subject { TestShell.new }

  describe '#which' do
    it 'should find ruby' do
      expect(subject.which('ruby')).to_not be_nil
    end

    it 'should not find it' do
      expect(subject.which('something_that_should_not_exist_ever')).to be_nil
    end
  end

  describe '#run_command' do
    it 'run the command successfully' do
      expect(subject.run_command('ruby -v')).to_not be_nil
    end
  end
end
