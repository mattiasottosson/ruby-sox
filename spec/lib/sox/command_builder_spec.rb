require 'spec_helper'

describe Sox::CommandBuilder do
  describe '#build' do
    it 'should build sox command' do
      builder = described_class.new(['in1.mp3', 'in2.ogg', 'in3.flac'], 'out.wav')
      builder.build.should == "sox in1.mp3 in2.ogg in3.flac out.wav"
    end

    it 'should escape fancy characters in file names' do
      builder = described_class.new(['in 1".mp3', 'in`2.ogg'], "out'.wav")
      builder.build.should == %q{sox in\ 1\".mp3 in\`2.ogg out\'.wav}
    end

    context 'with options' do
      it 'should add pass options to the command' do
        builder = described_class.new(['in1.mp3', 'in2.mp3'], 'out.ogg', :combine => :mix)
        builder.build.should == 'sox --combine mix in1.mp3 in2.mp3 out.ogg'
      end

      it 'should use apply "-" syntax for options' do
        opts = {:combine => :mix_power, :sox_pipe => true}
        builder = described_class.new(['in1.mp3', 'in2.mp3'], 'out.ogg', opts)

        builder.build.should ==
          'sox --combine mix-power --sox-pipe in1.mp3 in2.mp3 out.ogg'
      end
    end

    context 'with effects' do
      it 'should pass effects after output file' do
        builder = described_class.new(['in1.mp3', 'in2.mp3'], 'out.ogg', {}, :rate => '16k', :channels => 2)
        builder.build.should ==
          'sox in1.mp3 in2.mp3 out.ogg rate 16k channels 2'
      end
    end

    context 'with options and effects' do
      it 'should build command' do
        builder = described_class.new(['in'], 'out', {:combine => :mix}, :rate => 44100)
        builder.build.should ==
          'sox --combine mix in out rate 44100'
      end
    end
  end

  describe 'shellify_opt' do
    it 'should take Symbol or String and replace "_" with "-"' do
      builder = described_class.new([], '', {})

      builder.send(:shellify_opt, :sox_pipe).should == 'sox-pipe'
      builder.send(:shellify_opt, 'mix_power').should == 'mix-power'
    end
  end
end
