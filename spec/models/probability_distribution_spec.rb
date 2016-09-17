require 'rails_helper'

RSpec.describe ProbabilityDistribution do
  before(:each) do
    @fake_weighted_contents = {a: 1, b: 2, c: 3, d: 4, e: 5}
  end

  describe '#new' do
    it 'creates a new ProbabilityDistribution with the given objects and weightings' do
      pd = ProbabilityDistribution.new @fake_weighted_contents
      expect(pd.size).to eq 5
    end
  end

  describe '#draw' do
    it 'randomly draws an object according to the weightings' do
      count = 10000
      tolerance = 0.3

      frequencies = Hash.new {|h,k| h[k] = 0}
      count.times do
        pd = ProbabilityDistribution.new @fake_weighted_contents
        frequencies[pd.draw] += 1
      end
      freq_a = count/15
      expect(frequencies[:a]).to be_between (1-tolerance) * freq_a, (1+tolerance) * freq_a
      expect(frequencies[:b]).to be_between (2-tolerance) * freq_a, (2+tolerance) * freq_a
      expect(frequencies[:c]).to be_between (3-tolerance) * freq_a, (3+tolerance) * freq_a
      expect(frequencies[:d]).to be_between (4-tolerance) * freq_a, (4+tolerance) * freq_a
      expect(frequencies[:e]).to be_between (5-tolerance) * freq_a, (5+tolerance) * freq_a
    end

    it 'does not draw the same object twice' do
      drawns = []
      pd = ProbabilityDistribution.new @fake_weighted_contents
      5.times do
        drawns << pd.draw
      end
      expect(drawns.sort).to eq [:a, :b, :c, :d, :e]
    end

    it 'draws nil if nothing is left to draw' do
      pd = ProbabilityDistribution.new @fake_weighted_contents
      5.times { pd.draw }

      expect(pd.draw).to be_nil
    end

    it 'draws arbitrary if all weightings are zero' do
      pd = ProbabilityDistribution.new a: 0, b: 0, c: 0, d: 0, e: 0
      expect(pd.draw).to_not be_nil
    end
  end
end
