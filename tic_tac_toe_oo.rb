class Board
  attr_accessor :squares

  def initialize
    @squares = {}
    (1..9).each { |position| self.squares[position] = ' ' }
  end
  
  def draw
    system 'clear'
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}  "
    puts "-----+-----+-----"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "-----+-----+-----"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
  end

  def empty_positions
    squares.select{|k, v| v == ' '}.keys
  end

  def all_squares_taken?
    empty_positions.count == 0
  end
end

class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

class Person < Player
  def pick_result(board)
    begin
      puts "Choose a position (from 1 to 9) :"
      position = gets.chomp.to_i
    end until board.empty_positions.include?(position)
    board.squares[position] = 'X'
  end
end

class Computer < Player
  def pick_result(board)
    position = board.empty_positions.sample
    board.squares[position] = 'O'
  end
end

class Game
  attr_reader :board, :player, :computer
  attr_accessor :winner

  def initialize
    @board = Board.new
    @player = Person.new("Tom")
    @computer = Computer.new("computer")
  end

  def check_winner(board)
    winning_positons = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    winning_positons.each do |position|
      if board.squares[position[0]] == 'X' && board.squares[position[1]] == 'X' && board.squares[position[2]] == 'X'
        return @winner = player.name
      elsif board.squares[position[0]] == 'O' && board.squares[position[1]] == 'O' && board.squares[position[2]] == 'O'
        return @winner = computer.name
      end
    end
    return @winner = nil
  end
  
  def run
    board.draw
    begin
      player.pick_result(board)
      board.draw
      break if check_winner(board)
      computer.pick_result(board)
      board.draw
      check_winner(board)
    end until winner || board.all_squares_taken?

    if winner
      puts "#{winner} won!"
    else
      puts "It's tie."
    end
  end
end

game = Game.new
game.run
