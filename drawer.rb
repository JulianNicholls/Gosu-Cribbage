module Cribbage
  # Graphic drawing
  class Drawer
    include Constants

    def initialize( game )
      @game = game
    end
    
    def background
      @game.draw_rectangle( Point.new( 0, 0 ), Size.new( WIDTH, HEIGHT ), 0, BAIZE )

      # 'Watermark' on the background
      @game.font[:watermark].draw( 'The Julio', WATERMARK_POS.x, WATERMARK_POS.y, 0,
                              1, 1, WATERMARK )      
    end
  end
end
