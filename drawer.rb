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
      
      draw_grid
    end
    
    def cards
      @game.player_hand.draw( orient: :face_up )
      @game.cpu_hand.draw
    end
    
    private

    def score_box
      box  = Point.new( SCORE_POS.x - (MARGIN + 2), 1 )
      size = Size.new( WIDTH - (SCORE_POS.x - MARGIN), SCORE_BOX_HEIGHT )

      @game.draw_rectangle( box, size, 0, SCORE_TEXT )

      @game.draw_rectangle( box.offset( 1, 1 ), size.deflate( 2, 2 ), 0, SCORE_BKGR )
    end
    
    def draw_grid
      vert  = Size.new( 1, HEIGHT )
      horiz = Size.new( WIDTH, 1 )

      0.step( WIDTH - 50, 50 ).each do |l|
        @game.draw_rectangle( Point.new( l, 0 ), vert, 0, WATERMARK )
      end

      0.step( HEIGHT - 50, 50 ).each do |t|
        @game.draw_rectangle( Point.new( 0, t ), horiz, 0, WATERMARK )
      end
    end
  end
end
