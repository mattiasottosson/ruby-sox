require 'spec_helper'

describe Sox::CommandBuilder do
  describe '#build' do
    it 'should build sox command' do
      in1 = Sox::File.new('in1.mp3', :type => :mp3)
      in2 = Sox::File.new('in2.raw', :type => :raw, :bits => 16, :encoding => :signed)
      out = Sox::File.new('out.raw', :encoding => :signed, :bits => 32)
      builder = described_class.new([in1, in2], out, {:combine => :mix}, :rate => 22050)

      builder.build.should ==
        'sox --combine mix --type mp3 in1.mp3 --type raw --bits 16 --encoding signed in2.raw ' \
        '--encoding signed --bits 32 out.raw rate 22050'
    end

    it 'should escape fancy characters in file names' do
      in1 = Sox::File.new('in 1".mp3')
      out = Sox::File.new("out'.wav")
      builder = described_class.new([in1], out)

      builder.build.should == %q{sox in\ 1\".mp3 out\'.wav}
    end


    it 'should use apply "-" syntax for options' do
      in1 = Sox::File.new('in1.mp3')
      out = Sox::File.new("out.wav")
      builder = described_class.new([in1], out, :combine => :mix_power)

      builder.build.should == 'sox --combine mix-power in1.mp3 out.wav'
    end
  end

  describe '#shellify_opt' do
    it 'should take Symbol or String and replace "_" with "-"' do
      builder = described_class.new([], '', {})

      builder.send(:shellify_opt, :sox_pipe).should == 'sox-pipe'
      builder.send(:shellify_opt, 'mix_power').should == 'mix-power'
    end
  end
end
