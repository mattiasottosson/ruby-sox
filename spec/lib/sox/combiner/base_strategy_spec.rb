require 'spec_helper'

describe Sox::Combiner::BaseStrategy do
  describe '#write' do
    it 'should raise NotImplementedError' do
      strategy = described_class.new([], {})
      expect { strategy.write('out.mp3') }.
        to raise_error(NotImplementedError)
    end
  end
end
