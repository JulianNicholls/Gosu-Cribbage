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
                              
      score_box
    end

    def score_box
      box  = Point.new( SCORE_POS.x - (MARGIN + 2), 1 )
      size = Size.new( WIDTH - (SCORE_POS.x - MARGIN), SCORE_BOX_HEIGHT )

      @game.draw_rectangle( box, size, 0, SCORE_TEXT )

      @game.draw_rectangle( box.offset( 1, 1 ), size.deflate( 2, 2 ), 0, SCORE_BKGR )
    end
  end
end
