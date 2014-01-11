require 'spec_helper'

require 'pipeline/plugin'

describe Pipeline::Plugin do
  describe '#new(root)' do
    it "takes one argument which is the root directory" do
      expect { described_class.new(Dir.pwd) }.not_to raise_error
    end
  end

  describe '#root' do
    subject { described_class.new(File.join(Dir.pwd, 'spec', 'data', 'app')) }

    it "returns path to the root directory" do
      subject.root.should be_kind_of(Pathname)
      subject.root.to_s.should match('pipeline.rb/spec/data/app')
    end
  end

  describe '#config' do
    subject { described_class.new(File.join(Dir.pwd, 'spec', 'data', 'app')) }

    let(:config) { subject.config('smtp') }

    it 'contains the global settings' do
      config[:address].should eql('smtp.gmail.com')
    end

    it 'contains the global settings' do
      config[:password].should eql('password.local')
    end

    it 'overrides the global settings by the local settings' do
      config[:user_name].should eql('user.local')
    end
  end
end
