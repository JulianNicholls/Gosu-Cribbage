module Cribbage
  # Graphic drawing
  class Drawer
    include Constants

    def initialize( game )
      @game = game
    end

    def draw
      background
      cards
      instructions unless @game.instructions.nil?
      scores
      buttons
    end

    private

    def background
      @game.draw_rectangle( Point.new( 0, 0 ), Size.new( WIDTH, HEIGHT ), 0, BAIZE )

      # 'Watermark' on the background
      @game.font[:watermark].draw(
        'The Julio', WATERMARK_POS.x, WATERMARK_POS.y, 0, 1, 1, WATERMARK )

      score_box

      draw_grid
    end

    def cards
      if [:initial_cut, :cpu_cut, :cut_complete].include? @game.phase
        return @game.pack.draw_fan( FAN_POS, CARD_GAP )
      end

      @game.player_hand.draw( orient: :face_up )
      @game.cpu_hand.draw( orient: :peep )
      @game.pack.draw

      @game.image[:back].draw( CRIB_POS.x, CRIB_POS.y, 1)
    end

    def instructions
      inst    = @game.instructions
      font    = @game.font[:instructions]
      size    = font.measure inst[:text]
      margin  = font.text_width 'X'

      left = inst[:left] || [MID_X - (size.width / 2), 3].max
      top  = inst[:top]  || INSTRUCTION_TOP

      @game.draw_rectangle( Point.new( left - margin, top ),
        Size.new( size.width + margin * 2, size.height * 2 ), 6, WATERMARK )

      font.draw(
        inst[:text], left, top + size.height / 2, 7, 1, 1, Gosu::Color::WHITE )
    end

    # TODO: Score Reason
    def scores
      player    = 'Player '
      font      = @game.font[:score]
      size      = font.measure( player )

      font.draw( 'CPU', SCORE_POS.x, SCORE_POS.y, 1, 1, 1, SCORE_TEXT )
      font.draw( @game.score[:cpu], SCORE_POS.x + size.width, SCORE_POS.y,
                 1, 1, 1, SCORE_NUM )

      font.draw( player, SCORE_POS.x, SCORE_POS.y + size.height,
                 1, 1, 1, SCORE_TEXT )

      font.draw( @game.score[:player], SCORE_POS.x + size.width,
                 SCORE_POS.y + size.height, 1, 1, 1, SCORE_NUM )
    end

    def buttons
      @game.discard_btn.draw
    end

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
