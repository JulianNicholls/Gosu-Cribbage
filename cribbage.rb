#!/usr/bin/env ruby -I.

require 'gosu_enhanced'

require 'constants'

require 'pack'
require 'hand'

require 'resources'
require 'drawer'

module Cribbage
  # Game Class
  class Game < Gosu::Window
    include Constants

    KEY_FUNCS = {
       Gosu::KbEscape =>  -> { close },
       Gosu::KbR      =>  -> { reset },

       Gosu::MsLeft   =>  -> { @position = Point.new( mouse_x, mouse_y ) }
    }

    attr_reader :font, :image, :delay
    attr_accessor :phase, :instructions
    attr_accessor :cpu_hand, :player_hand, :pack, :turn_card

    def initialize
      super( WIDTH, HEIGHT, false, 50 )

      self.caption = 'Gosu Cribbage 2.0'

      load_resources

      @drawer = Drawer.new( self )

      GosuCard.set_display( image[:front], image[:back], font[:card] )
      GosuPack.set_back_image( image[:back] )

      reset
    end

    def needs_cursor?
      true
    end

    def update
      return if delay != 0 && Time.now < delay

      update_proc = "update_#{phase}"
      return send( update_proc ) if respond_to?( update_proc, true )

      puts "Update: #{update_proc} not implemented"   #
    end

    def draw
      @drawer.background
      @drawer.cards
      @drawer.instructions
    end

    def button_down( code )
      instance_exec( &KEY_FUNCS[code] ) if KEY_FUNCS.key? code
    end

    private

    def update_initial_cut
      @instructions = { text: 'Cut card for Deal', top: 400 }

      return if @position.nil?

      cut_card = @pack.card_from_fan( @position, :player )

      if cut_card
        @cut_cards[:player] = cut_card
        @instructions = nil
        @phase = :cpu_cut
        self.delay = 1
      end

      @position = nil
    end

    def update_cpu_cut
      point = Point.new( rand( FAN_POS.x..(FAN_POS.x + 51 * CARD_GAP) ),
              PACK_POS.y + 10 )

      @cut_cards[:cpu] = @pack.card_from_fan( point, :cpu )

      self.delay = 1.5
      @phase = :cut_complete
    end

    def update_cut_complete
      set_up_cards
      @phase = :discard
    end

    def delay=( value )
      @delay = Time.now + value
    end

    def load_resources
      @loader = ResourceLoader.new( self )

      @image = @loader.images
      @font  = @loader.fonts
    end

    def reset
      @pack  = GosuPack.new
      @phase = :initial_cut

      @cut_cards = {}

      @delay = 0
    end

    def set_up_cards
      @pack         = GosuPack.new  # Fresh pack after cut
      @player_hand  = GosuHand.new( @pack )
      @cpu_hand     = GosuHand.new( @pack )

      @pack.set_position( PACK_POS )
      @player_hand.set_positions( PLAYER_HAND_POS, FANNED_GAP * 2 )
      @cpu_hand.set_positions( CPU_HAND_POS, FANNED_GAP * 2 )
    end
  end
end

Cribbage::Game.new.show
