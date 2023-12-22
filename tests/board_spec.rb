# my_class_spec.rb
require 'rspec'
require_relative '../src/shape'
require_relative '../src/board'

describe Board do

  def create_board1
    Board.new(20, 25, [
      Vector.new(0, 0),
      Vector.new(1, 0),
      Vector.new(0, 1),

      Vector.new(18, 0),
      Vector.new(19, 0),
      Vector.new(19, 1),

      Vector.new(5, 4),
      Vector.new(4, 5),
      Vector.new(5, 5),
      Vector.new(6, 5),
      Vector.new(5, 6)
    ])
  end

  describe '#is_colliding?' do
    it 'returns true if the shape is colliding with occupied cells in the board' do
      # Init the board
      board = create_board1

      # Shape layout for this test
      shape_layout = [[1, 1, 1, 1]]
      shape = Shape.new(Vector.new(0, 0), shape_layout)

      # The shape is not colliding with the board
      expect(board.colliding?(shape)).to eq(true)

      # Move the shape to the right 2times
      shape = Shape.new(Vector.new(2, 0), shape_layout)
      expect(board.colliding?(shape)).to eq(false)

      # Move the shape
      shape = Shape.new(Vector.new(3, 4), shape_layout)
      expect(board.colliding?(shape)).to eq(true)

      # Move the shape
      shape = Shape.new(Vector.new(0, 1), shape_layout)
      expect(board.colliding?(shape)).to eq(true)

      # The shape may be outside of the board but the collision must be false and no error should be raised
      shape = Shape.new(Vector.new(-5, -6), shape_layout)
      expect(board.colliding?(shape)).to eq(false)

      # The shape may be outside of the board but the collision must be false and no error should be raised
      shape = Shape.new(Vector.new(30, 10), shape_layout)
      expect(board.colliding?(shape)).to eq(false)

      # Shape above the ground - no collision
      shape = Shape.new(Vector.new(0, 24), shape_layout)
      expect(board.colliding?(shape)).to eq(false)

      # Ground collision detection - shape colliding or under the board is considered as collision
      shape = Shape.new(Vector.new(0, 25), shape_layout)
      expect(board.colliding?(shape)).to eq(true)
    end

    # TODO: test when roration is involved
  end

  describe '#is_out_off_board?' do
    it 'returns true if the shape is out of the board' do
      # Init the board
      board = create_board1

      # Shape layout for this test
      shape_layout = [[1, 1, 1, 1]]
      shape = Shape.new(Vector.new(0, 0), shape_layout)

      # The shape is not out of the board
      expect(board.out_off_board?(shape)).to eq(false)

      # Move the shape to the right 2times
      shape = Shape.new(Vector.new(2, 0), shape_layout)
      expect(board.out_off_board?(shape)).to eq(false)

      # Move the shape
      shape = Shape.new(Vector.new(16, 0), shape_layout)
      expect(board.out_off_board?(shape)).to eq(false)

      # Move the shape to index 17 - the shape is out of the board partially
      shape = Shape.new(Vector.new(17, 0), shape_layout)
      expect(board.out_off_board?(shape)).to eq(true)
    end

    it 'returns true if the shape is out of the board' do
      # Init the board
      board = create_board1

      # Shape layout for this test
      shape_layout = [[1], [1], [1], [1]]
      shape = Shape.new(Vector.new(0, 0), shape_layout)

      # The shape is not out of the board
      expect(board.out_off_board?(shape)).to eq(false)

      # Move the shape to the bottom 2times
      shape = Shape.new(Vector.new(0, 2), shape_layout)
      expect(board.out_off_board?(shape)).to eq(false)

      # Move the shape
      shape = Shape.new(Vector.new(0, 21), shape_layout)
      expect(board.out_off_board?(shape)).to eq(false)

      # Move the shape to index 22 - the shape is out of the board partially
      shape = Shape.new(Vector.new(0, 22), shape_layout)
      expect(board.out_off_board?(shape)).to eq(true)
    end
  end
end
