require 'constants'

module Cribbage
  # Represent a pack of cards as a 1..52 array and deal cards from it.
  class Pack
    def initialize
      reset
    end

    def reset
      @cards      = Array.new( 52, 1 )
      @cards_left = 52
    end

    def deal( klass = Card )
      return nil if empty?    # Should we punish emptyness with an exception

      card = rand 52

      card = rand( 52 ) while @cards[card] == 0

      @cards[card] = 0
      @cards_left -= 1
      klass.new( (card / 4) + 1, (card % 4) + 1 )
    end

    def empty?
      @cards_left == 0
    end

    # I can't think of another way to cut a card at the moment

    def cut( klass = Card )
      deal klass
    end

    protected

    attr_reader :cards_left
  end

  # A pack that can display itself on a Gosu window
  class GosuPack < Pack
    include Constants

    def self.set_back_image( back )
      @back = back
    end

    class << self
      attr_reader :back
    end
    
    def initialize
      super

      @fan, @fan_cards = nil, {}
    end

    def reset
      super
      @fan, @fan_cards = nil, {}
    end

    def deal
      super( GosuCard )
    end

    alias_method :cut, :deal

    def set_position( pos )
      @pos = Region.new( pos, CARD_SIZE )
    end

    def draw
      back_image.draw( @pos.left, @pos.top, 1 )
    end

    def draw_fan( point, gap, options = {} )
      @fan ||= generate_fan( point, gap )

      @fan.each { |c| c.draw( options ) }
      @fan_cards.keys.each { |k| @fan_cards[k].draw( orient: :face_up ) }
    end

    def generate_fan( point, gap )
      cards = []
      pos   = point.dup

      until empty?
        card = deal
        card.place( pos )
        cards << card

        pos.move_by!( gap, 0 )
      end
      
      cards
    end

    def card_from_fan( point, turn = :player )
      # Must traverse from the right, because cards overlap each other

      @fan.reverse_each do |card|
        if card.contains?( point )
          @fan_cards[turn] = card
          delta = CARD_SIZE.height + CARD_GAP
          card.move_by!( 0, turn == :player ? delta : -delta )

          return card
        end
      end

      nil   # Nothing chosen
    end
    
    private
    
    def back_image
      self.class.back
    end
  end
end
