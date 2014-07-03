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

       Gosu::MsLeft   =>  -> { @position = Point.new( mouse_x, mouse_y ) }
    }

    attr_reader :font, :image
    
    def initialize
      super( WIDTH, HEIGHT, false, 50 )
      
      self.caption = 'Gosu Cribbage 2.0'
      
      load_resources
      @drawer = Drawer.new( self )
    end
    
    def need_cursor?
      true
    end
    
    def update
      
    end
    
    def draw
      @drawer.background
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
  end
end

Cribbage::Game.new.show
