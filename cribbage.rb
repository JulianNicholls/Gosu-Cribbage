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

    attr_reader :font, :image
    attr_reader :cpu_hand, :player_hand
    
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
      
    end
    
    def draw
      @drawer.background
      @drawer.cards
    end
  
    def button_down( code )
      instance_exec( &KEY_FUNCS[code] ) if KEY_FUNCS.key? code
    end
    
    private
  
    def load_resources
      @loader = ResourceLoader.new( self )
    
      @image = @loader.images
      @font  = @loader.fonts
    end
    
    def reset
      set_up_cards
    end
    
    def set_up_cards
      @pack         = GosuPack.new
      @player_hand  = GosuHand.new( @pack )
      @cpu_hand     = GosuHand.new( @pack )
      
      @pack.set_position( PACK_POS )
      @player_hand.set_positions( PLAYER_HAND_POS, FANNED_GAP * 2 )
      @cpu_hand.set_positions( CPU_HAND_POS, FANNED_GAP * 2 )
    end
  end
end

Cribbage::Game.new.show
