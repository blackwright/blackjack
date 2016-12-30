require "./deck"

class Hand
  attr_reader :cards

  def initialize(cards = [])
    @cards = cards
  end

  def blackjack?
    score == 21
  end

  def bust?
    score > 21
  end

  def has_seventeen?
    score > 16
  end

  def score
    points = 0
    @cards.each do |card|
      rank = card[0]
      if rank =~ /[2-9]|10/
        points += rank.to_i
      elsif Deck::FACES.include?(rank)
        points += 10
      else
        points += 1
      end
    end
    @cards.each do |card|
      points += 10 if eleven_point_ace?(card, points)
    end
    points
  end

  private

    def eleven_point_ace?(card, points)
      card[0] == Deck::ACE && points < 12
    end
end
