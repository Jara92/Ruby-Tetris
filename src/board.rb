class Board
  attr_reader :width, :height

  def initialize(width, height, occupied_cells = [])
    @width = width
    @height = height

    # Create the board
    @board = Array.new(height) { Array.new(width, 0) }

    # Must be an array of vectors
    raise TypeError if not occupied_cells.is_a?(Array)
    raise TypeError if not occupied_cells.all? { |cell| cell.is_a?(Vector) }

    # Set the occupied cells
    occupied_cells.each do |cell|
      set_cell(cell.x, cell.y, 1)
    end

  end

  def can_rotate?(shape)
    # Simulate the rotation
    rotated_shape = shape.rotate

    # Check if the rotated shape is not colliding with the board
    !is_out_off_board(shape) && !is_colliding?(rotated_shape)
  end

  def can_move?(shape, direction)
    # Simulate the movement
    moved_shape = shape.move(direction)

    # Check if the moved shape is not out of the board or colliding with the board cells.
    !is_out_off_board(moved_shape) && !is_colliding?(moved_shape)
  end

  def is_colliding?(shape)
    shape.layout.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        # check if the cell is occupied
        if cell == 1
          # Get the absolute position of the cell in the board
          x = shape.position.x + column_index
          y = shape.position.y + row_index

          # Return true if the cell exists and is occupied
          cell_collision = (check_cell(x, y) and @board[y][x] == 1)

          # Check ground collision - collision with the bottom of the board is also considered as collision
          ground_collision = (y >= @height)

          return true if cell_collision or ground_collision
        end
      end
    end

    # Return false if no cells of the shape are colliding with occupied cells in the board
    false
  end

  def is_out_off_board(shape)
    # Check each cell of the shape
    shape.layout.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        # check if the cell is occupied
        if cell != 0
          # Get the absolute position of the cell in the board
          x = shape.position.x + column_index
          y = shape.position.y + row_index

          # Return true if the cell is outside of the board
          return true if x < 0 || x >= @width || y < 0 || y >= @height
        end
      end
    end

    # Return false if the shape is inside the board
    false
  end

  def add_shape(shape)
    shape.layout.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        # check if the cell is occupied
        if cell != 0
          # Get the absolute position of the cell in the board
          x = shape.position.x + column_index
          y = shape.position.y + row_index

          # Set the cell to occupied
          set_cell(x, y, 1)
        end
      end
    end
  end

  def get_cell(x, y)
    check_cell!(x, y)

    @board[y][x]
  end

  def cell_occupied?(x, y)
    check_cell!(x, y)

    @board[y][x] != 0
  end

  def check_cell(x, y)
    # Check the type of the arguments
    raise TypeError if not x.is_a?(Integer) or not y.is_a?(Integer)

    # return true if the cell is inside the board
    not (x < 0 or x >= @width or y < 0 or y >= @height)
  end

  def check_cell!(x, y)
    # Raise IndexError if the cell is outside of the board
    raise IndexError if not check_cell(x, y)


  end

  private

  def set_cell(x, y, value)
    check_cell!(x, y)

    @board[y][x] = value
  end
end