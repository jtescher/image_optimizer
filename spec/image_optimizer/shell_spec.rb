require 'spec_helper'

class TestShell
  include ImageOptimizer::Shell
end

describe ImageOptimizer::Shell do
  describe '#which' do
    it 'should find ruby' do
      expect(TestShell.new.which('ruby')).to_not eql nil
    end

    it 'should not find it' do
      expect(TestShell.new.which('something_that_should_not_exist_ever')).to eql nil
    end
  end

  describe '#run_command' do
    subject { TestShell.new.run_command('ruby -v') }

    it 'run the command successfully' do
      expect(subject).to_not eql nil
    end
  end
end