class MobTennis

  POINTS = {
      0 => 15,
      15 => 30,
      30 => 40,
      40 => 41,
      41 => 40
  }

  def initialize
    @players = {
      player1: 0,
      player2: 0
    }

    @deuce = false
  end

  def score(player)
    @players[player] = POINTS[@players[player]]

    unless @deuce
      @deuce = @players[:player1] == 40 && @players[:player2] == 40
    end
  end

  def current_score
    return "deuce" if deuce?

    return "advantage player 1" if advantage_player_1?

    return "advantage player 2" if advantage_player_2?

    return "player 1 has won" if win_for?(:player1)

    return "player 2 has won" if win_for?(:player2)

    "#{@players[:player1]}-#{@players[:player2]}"
  end

  private

  def win_for?(player)
    @players[player] == 41
  end

  def advantage_player_2?
    @players[:player2] == 41 && @players[:player1] == 40
  end

  def advantage_player_1?
    @players[:player1] == 41 && @players[:player2] == 40
  end

  def deuce?
    @deuce
  end

end

def expect_current_score_to_eq(expected_score)
  expect(game.current_score).to eq(expected_score)
end

describe "Mob Tennis" do
  let(:game) {MobTennis.new}

  it "should score a game where neither players has any points" do
    expect_current_score_to_eq("0-0")
  end

  it "score a game where player one has a point" do
    game.score(:player1)

    expect_current_score_to_eq("15-0")
  end

  it "score a game where both players have a point" do
    game.score(:player1)
    game.score(:player2)

    expect_current_score_to_eq("15-15")
  end

  it "score a game where player one has 2 points" do
    2.times { game.score(:player1) }

    expect_current_score_to_eq("30-0")
  end

  it "score a game where player one has 3 points" do
    3.times { game.score(:player1) }

    expect_current_score_to_eq("40-0")
  end

  it "score a game where player one has scored 4 points" do
    4.times { game.score(:player1) }

    expect(game.current_score).to eq("player 1 has won")
  end

  it "score a game where player two has scored 4 points" do
    4.times { game.score(:player2) }

    expect(game.current_score).to eq("player 2 has won")
  end

  it "score a game where player one and player two have 3 points" do
    3.times do
      game.score(:player1)
      game.score(:player2)
    end

    expect_current_score_to_eq("deuce")
  end

  it "score a game where player one has an advantage" do
    3.times do
      game.score(:player1)
      game.score(:player2)
    end
    game.score(:player1)

    expect_current_score_to_eq("advantage player 1")
  end

  it "score a game where player two has an advantage" do
    3.times do
      game.score(:player1)
      game.score(:player2)
    end
    game.score(:player2)

    expect_current_score_to_eq("advantage player 2")
  end

  xit "score a game where player two wins from advantage" do
    3.times do
      game.score(:player1)
      game.score(:player2)
    end
    2.times { game.score(:player2) }

    expect_current_score_to_eq("player 2 has won")
  end

  it "score a game where both players return to deuce" do
    4.times do
      game.score(:player1)
      game.score(:player2)
    end

    expect_current_score_to_eq("deuce")
  end
end