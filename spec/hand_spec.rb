require 'hand'

require 'spec_helper'

module Cribbage
  # Test version that allows access to the held cards
  class Hand
    attr_accessor :cards
  end
end

describe Cribbage::Hand do
  before :each do
    pack  = Cribbage::Pack.new
    @hand = Cribbage::Hand.new pack
  end

  describe '#initialize' do
    it 'should deal 6 cards' do
      expect( @hand.cards.size ).to eq 6
    end

    it 'should store cards in ascending rank/value order' do
      5.times { |c| expect( @hand.cards[c].value <= @hand.cards[c + 1].value ) }
      5.times { |c| expect( @hand.cards[c].rank  <= @hand.cards[c + 1].rank ) }
    end
  end

  describe '#discard' do
    it 'should allow discarding of two cards' do
      updated_hand = @hand.cards.dup
      updated_hand.slice!( 1, 2 )   # 1 for 2
      @hand.discard( *[1, 2] )      # 1 and 2
      expect( @hand.cards.size ).to eq 4
      expect( @hand.cards ).to eq updated_hand

      updated_hand.slice!( 1, 2 )   # 1 for 2
      @hand.discard( 2, 1 )         # 1 and 2
      expect( @hand.cards.size ).to eq 2
      expect( @hand.cards ).to eq updated_hand
    end

    it 'should disallow discarding of more or less than two cards' do
      expect { @hand.discard [1] }.to raise_error Exception
      expect { @hand.discard [1, 2, 3] }.to raise_error Exception
    end
  end

  describe '#to_s' do
    it 'should render the hand as text' do
      @hand.cards = [FullPack::HA, FullPack::H5, FullPack::S5,
                     FullPack::CJ, FullPack::HQ, FullPack::HK]

      expect( @hand.to_s ).to eq 'AH 5H 5S JC QH KH'
    end
  end
end
