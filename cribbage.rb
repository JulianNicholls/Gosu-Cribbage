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

    attr_reader :font, :image, :delay, :score
    attr_accessor :phase, :instructions
    attr_accessor :cpu_hand, :player_hand, :pack, :turn_card, :turn

    def initialize
      super( WIDTH, HEIGHT, false, 50 )

      self.caption = 'Gosu Cribbage 2.0'

      load_resources

      @drawer = Drawer.new( self )

      GosuCard.set_display( image[:front], image[:back], font[:card] )
      GosuPack.back = image[:back]

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
      @drawer.draw
    end

    def button_down( code )
      instance_exec( &KEY_FUNCS[code] ) if KEY_FUNCS.key? code
    end
    
    def delay=( value )
      @delay = Time.now + value
    end

    def add_to_score( player, increment, reason = nil )
      @score[player] += increment
      @score[:reason] = reason
      @score[:timeout] = Time.now + 2 if reason
    end

    private

    def update_initial_cut
      @instructions ||= { text: 'Cut Cards for Deal', top: 400 }

      return if @position.nil?

      player_cut_card
    end

    def update_initial_recut
      @instructions ||= { text: 'Draw, Cut Cards for Deal again', top: 400 }

      return if @position.nil?

      player_cut_card
    end

    def update_cpu_cut
      x     = rand( FAN_POS.x...(FAN_POS.x + 51 * CARD_GAP) )
      point = Point.new( x, PACK_POS.y + 10 )

      @cut_cards[:cpu] = @pack.card_from_fan( point, :cpu )

      self.delay = 1.5
      
      @phase = decide_dealer ? :cut_complete : :initial_recut
    end

    def update_cut_complete
      set_up_cards
      @phase = :discard
    end
    
    def update_discard
      @instructions ||= { text: 'Select Cards for Discarding' }
      
      return if @position.nil?
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
      @score = { player: 0, cpu: 0 }
    end

    def set_up_cards
      @pack         = GosuPack.new  # Fresh pack after cut
      @player_hand  = GosuHand.new @pack
      @cpu_hand     = GosuHand.new @pack

      @pack.place PACK_POS
      @player_hand.set_positions( PLAYER_HAND_POS, FANNED_GAP * 2 )
      @cpu_hand.set_positions( CPU_HAND_POS, FANNED_GAP * 2 )
    end
    
    def player_cut_card
      cut_card = @pack.card_from_fan( @position, :player )

      @position = nil

      return unless cut_card
      
      @cut_cards[:player] = cut_card
      @instructions = nil
      @phase = :cpu_cut
      self.delay = 1
    end
    
    def decide_dealer
      if @cut_cards[:player].rank < @cut_cards[:cpu].rank
        @dealer = :player
      elsif @cut_cards[:player].rank > @cut_cards[:cpu].rank
        @dealer = :cpu
      else
        return false  # Undecided, due to a draw
      end
    end
  end
end

Cribbage::Game.new.show
