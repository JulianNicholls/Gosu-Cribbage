module Cribbage
  # Resource Loader
  class ResourceLoader
    def initialize( game )
      @game = game
    end

    def fonts
      {
        watermark:    Gosu::Font.new( @game, 'Brush Script Std', 130 ),
        score:        Gosu::Font.new( @game, Gosu.default_font_name, 18 ),
        instructions: Gosu::Font.new( @game, Gosu.default_font_name, 28 ),
        card:         Gosu::Font.new( @game, Gosu.default_font_name, 24 ),
        button:       Gosu::Font.new( @game, Gosu.default_font_name, 24 )
      }
    end

    def images
      {
        back:  Gosu::Image.new( @game, 'media/CardBack.png', true ),
        front: Gosu::Image.new( @game, 'media/CardFront.png', true )
      }
    end
  end
end
