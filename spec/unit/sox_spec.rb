require 'spec_helper'

describe Sox do
  let(:sox) { described_class.new }

  describe '.new' do
    context 'nothing is passed' do
      it 'should keep input files and options empty' do
        sox = described_class.new
        sox.input_files.should == []
        sox.options.should == {}
      end
    end

    context 'input files are passed' do
      it 'should set input files' do
        sox = described_class.new('a.mp3', 'b.mp3')
        sox.input_files.should == ['a.mp3', 'b.mp3']
      end
    end

    context 'options are passed' do
      it 'should set options' do
        sox = described_class.new(:combine => :concatenate)
        sox.options.should == {:combine => :concatenate}
      end
    end

    context 'input files and options are passed' do
      it 'should set input files and options' do
        sox = described_class.new('a.mp3', 'b.mp3', :guard => true, :combine => :mix)
        sox.input_files.should == ['a.mp3', 'b.mp3']
        sox.options.should == {:guard => true, :combine => :mix}
      end
    end
  end

  describe '#add_input_files' do
    it 'should add input_files' do
      sox.add_input_files 'a.mp3', 'b.mp3'
      sox.add_input_files ['c.mp3']
      sox.input_files.should == ['a.mp3', 'b.mp3', 'c.mp3']
    end

    it "should have alias <<" do
      sox << "a.ogg"
      sox << ["b.ogg", "c.ogg"]
      sox.input_files.should == ['a.ogg', 'b.ogg', 'c.ogg']
    end
  end

  describe '#run_command' do
    context "command is not found" do
      it 'should raise Sox::Error' do
        expect {
          sox.send(:run_command, 'never-command')
        }.to raise_error(Sox::Error, /Do you have `sox' installed\?/)
      end
    end

    context "command failed" do
      it 'should raise Sox::Error with error info' do
        expect {
          sox.send(:run_command, "sox never-file.mp3 output.ogg")
        }.to raise_error(Sox::Error, /can't open input file `never-file\.mp3'/)
      end
    end

    context "command finished successfully" do
      it "should return true" do
        sox.send(:run_command, "echo sweet").should be_true
      end
    end
  end

  describe '#write' do
    it 'should build command with CommandBuilder and run it' do
      sox = described_class.new('a.mp3', :combine => :mix)

      command_builder = stub(:command_builder, :build => "shell_command")

      Sox::CommandBuilder.should_receive(:new).
        with(['a.mp3'], 'out.mp3', :combine => :mix).
        and_return(command_builder)

      sox.should_receive(:run_command).with("shell_command")

      sox.write('out.mp3')
    end
  end
end
