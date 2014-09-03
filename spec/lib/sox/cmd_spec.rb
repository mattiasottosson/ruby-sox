require 'spec_helper'

describe Sox::Cmd do
  let(:sox) { described_class.new }

  describe '.new' do
    it 'should initialize empty properties' do
      sox.inputs.should == []
      sox.output.should be_nil
      sox.options.should == {}
      sox.effects.should == {}
    end

    context 'options are passed' do
      it 'should set options' do
        sox = described_class.new(:combine => :mix, :guard => true)

        sox.options[:combine].should == :mix
        sox.options[:guard].should be_true
      end
    end
  end

  describe '#add_input' do
    it 'should add input file' do
      sox.add_input('a.mp3')
      sox.add_input('b.wav', :type => :wav)

      sox.should have(2).inputs
      a, b = sox.inputs

      a.should be_a Sox::File
      a.path.should    == 'a.mp3'
      a.options.should == {}

      b.should be_a Sox::File
      b.path.should    == 'b.wav'
      b.options.should == {:type => :wav}
    end

    it 'should return self' do
      sox.add_input('a.mp3').should == sox
    end
  end

  describe '#set_output' do
    it 'should set output file' do
      sox.set_output('out.raw', :bits => 16)

      output = sox.output
      output.should be_a Sox::File
      output.path.should == 'out.raw'
      output.options.should == {:bits => 16}
    end

    it 'should return self' do
      sox.set_output('out.mp3').should == sox
    end
  end

  describe '#set_effects' do
    it 'should set effects' do
      sox.set_effects(:norm => true, :channels => 1)
      sox.effects.should == {:norm => true, :channels => 1}
    end

    it 'should return self' do
      sox.set_effects({}).should == sox
    end
  end

  describe '#set_options' do
    it 'should set options' do
      sox.set_options(:combine => :concatenate)
      sox.options.should == {:combine => :concatenate}
    end

    it 'should return self' do
      sox.set_options({}).should == sox
    end
  end

  describe '#run' do
    it 'should raise if inputs are missing' do
      sox.set_output('out.mp3')
      expect { sox.run }.
        to raise_error(Sox::Error, "Inputs are missing, specify them with `add_input`")
    end

    it 'should raise if output is missing' do
      sox.add_input('in.mp3')
      expect { sox.run }.
        to raise_error(Sox::Error, "Output is missing, specify it with `set_output`")
    end

    it 'should build sox command and run it via shell' do
      sox.add_input('in.mp3')
      sox.set_output('out.mp3')
      sox.set_options(:combine => :mix)
      sox.set_effects(:norm => true)

      builder = double(:builder, :build => "sox blabla")

      Sox::CommandBuilder.should_receive(:new).
        with(sox.inputs, sox.output, sox.options, sox.effects).
        and_return(builder)

      sox.should_receive(:sh).with("sox blabla")

      sox.run
    end
  end

  describe '#to_s' do
    it 'should return string representation of the sox command to be run' do
      sox.add_input('in.mp3')
      sox.set_output('out.mp3', :bits => 16)
      sox.set_options(:combine => :mix)
      sox.set_effects(:norm => true, :rate => 16000)

      sox.to_s.should == 'sox --combine mix in.mp3 --bits 16 out.mp3 norm rate 16000'
    end
  end
end
