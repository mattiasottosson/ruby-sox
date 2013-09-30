require 'spec_helper'

describe Sox::Shell do
  let(:target) { Object.new }
  before { target.extend(Sox::Shell) }

  describe '#sh' do
    context "command is not found" do
      it 'should raise Sox::Error' do
        expect {
          target.sh('never-command')
        }.to raise_error(Sox::Error, /Do you have `sox' installed\?/)
      end
    end

    context "command failed" do
      it 'should raise Sox::Error with error info' do
        expect {
          target.sh("sox never-file.mp3 output.ogg")
        }.to raise_error(Sox::Error, /can't open input file `never-file\.mp3'/)
      end
    end

    context "command finished successfully" do
      it "should return true" do
        target.sh("echo sweet").should be_true
      end
    end
  end


  describe '#bash' do
    it 'should run bash command in terms of sh and escape it properly' do
      target.should_receive(:sh).
        with(%q{/bin/bash -c echo\ \"11\ \'\ 12\"})
      target.bash %q{echo "11 ' 12"}
    end
  end
end
