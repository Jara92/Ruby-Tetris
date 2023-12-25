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

  def check_board(board, expected_occupied)
    (0..board.height - 1).each do |row_index|
      (0..board.width - 1).each do |column_index|
        if expected_occupied.include?(Vector.new(column_index, row_index))
          # must not be 0
          expect(board.get_cell(column_index, row_index)).not_to eq(0)
        else
          # must be 0 because it is not occupied
          expect(board.get_cell(column_index, row_index)).to eq(0)
        end
      end
    end
  end

  describe "get_cell" do
    it "returns the cell value" do
      occupied = [
        Vector.new(0, 0),
        Vector.new(1, 0),
        Vector.new(5, 2),
        Vector.new(15, 7),
      ]

      # Init the board
      board = Board.new(20, 25, occupied)

      # Check the board
      (0..board.height - 1).each do |row_index|
        (0..board.width - 1).each do |column_index|
          if occupied.include?(Vector.new(column_index, row_index))
            # must not be 0
            expect(board.get_cell(column_index, row_index)).not_to eq(0)
          else
            # must be 0 because it is not occupied
            expect(board.get_cell(column_index, row_index)).to eq(0)
          end
        end
      end
    end

    it "invalid coord" do
      occupied = [
        Vector.new(0, 0),
        Vector.new(1, 0),
        Vector.new(5, 2),
        Vector.new(15, 7),
      ]

      # Init the board
      board = Board.new(20, 25, occupied)

      expect { board.get_cell(:jedna, :dva) }.to raise_error(TypeError)

      expect { board.get_cell(-1, 0) }.to raise_error(IndexError)
      expect { board.get_cell(-1, -1) }.to raise_error(IndexError)
      expect { board.get_cell(20, 0) }.to raise_error(IndexError)
      expect { board.get_cell(0, 25) }.to raise_error(IndexError)
    end
  end

  describe "cell_occupied?" do
    it "returns the cell value" do
      occupied = [
        Vector.new(0, 0),
        Vector.new(1, 0),
        Vector.new(5, 2),
        Vector.new(15, 7),
      ]

      # Init the board
      board = Board.new(20, 25, occupied)

      # Check the board
      (0..board.height - 1).each do |row_index|
        (0..board.width - 1).each do |column_index|
          if occupied.include?(Vector.new(column_index, row_index))
            # must not be 0
            expect(board.cell_occupied?(column_index, row_index)).to eq(true)
          else
            # must be 0 because it is not occupied
            expect(board.cell_occupied?(column_index, row_index)).to eq(false)
          end
        end
      end
    end

    it "invalid coord" do
      occupied = [
        Vector.new(0, 0),
        Vector.new(1, 0),
        Vector.new(5, 2),
        Vector.new(15, 7),
      ]

      # Init the board
      board = Board.new(20, 25, occupied)

      expect { board.cell_occupied?(:jedna, :dva) }.to raise_error(TypeError)

      expect { board.cell_occupied?(-1, 0) }.to raise_error(IndexError)
      expect { board.cell_occupied?(-1, -1) }.to raise_error(IndexError)
      expect { board.cell_occupied?(20, 0) }.to raise_error(IndexError)
      expect { board.cell_occupied?(0, 25) }.to raise_error(IndexError)
    end
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

  describe 'add_shape' do
    it 'adds the shape to the board' do
      # Init the board
      board = Board.new(20, 25, [])

      # Shape layout for this test
      shape_layout = [[1, 1, 1, 1]]
      shape = Shape.new(Vector.new(5, 0), shape_layout)

      # Add the shape to the board
      board.add_shape(shape)

      expected_occupied_cells = [
        Vector.new(5, 0),
        Vector.new(6, 0),
        Vector.new(7, 0),
        Vector.new(8, 0)
      ]

      check_board(board, expected_occupied_cells)
    end

    it 'adds the shape to the board' do
      # Init the board
      board = Board.new(20, 25, [])

      # Shape layout for this test
      shape_layout = [[1, 1, 1], [1, 0, 0]]
      shape = Shape.new(Vector.new(7, 4), shape_layout)

      # Add the shape to the board
      board.add_shape(shape)

      expected_occupied_cells = [
        Vector.new(7, 4),
        Vector.new(8, 4),
        Vector.new(9, 4),
        Vector.new(7, 5)
      ]

      check_board(board, expected_occupied_cells)

    end
  end

  describe 'row_full?' do
    it 'check full rows' do
      # Init the board with some full rows
      board = Board.new(2, 5, [
        # full row 0
        Vector.new(0, 0),
        Vector.new(1, 0),

        # full row 2
        Vector.new(0, 2),
        Vector.new(1, 2),

        # half full row 3
        Vector.new(0, 3),

        # half full row 4
        Vector.new(1, 4),
      ])

      # Check if the rows are full
      expect(board.row_full?(0)).to eq(true)
      expect(board.row_full?(1)).to eq(false)
      expect(board.row_full?(2)).to eq(true)
      expect(board.row_full?(3)).to eq(false)
      expect(board.row_full?(4)).to eq(false)

    end
  end

  describe 'squash row' do
    it 'squash row' do
      # Init the board with some full rows
      board = Board.new(2, 3, [
        # full row 0
        # Vector.new(0, 0),
        Vector.new(1, 0),

        # full row 2
        Vector.new(0, 2),
        Vector.new(1, 2),
      ])

      # Squash the last row
      board.squash_row(2)

      # Check rows content
      expect(board.get_row(0)).to eq([0, 0])
      expect(board.get_row(1)).to eq([0, 1])
      expect(board.get_row(2)).to eq([0, 0])

      # Squash again second row
      board.squash_row(1)

      # Check rows content
      expect(board.get_row(0)).to eq([0, 0])
      expect(board.get_row(1)).to eq([0, 0])
      expect(board.get_row(2)).to eq([0, 0])

    end

    it 'invalid row' do
      # Init the board with some full rows
      board = Board.new(2, 3, [
        # full row 0
        # Vector.new(0, 0),
        Vector.new(1, 0),

        # full row 2
        Vector.new(0, 2),
        Vector.new(1, 2),
      ])

      # try to squash invalid row
      expect { board.squash_row(:first) }.to raise_error(TypeError)
      expect { board.squash_row(-1) }.to raise_error(IndexError)
      expect { board.squash_row(3) }.to raise_error(IndexError)

    end
  end
end
