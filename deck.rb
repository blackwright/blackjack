class Deck
  attr_reader :cards

  SUITS = %w(spades hearts clubs diams)
  RANKS = %w(2 3 4 5 6 7 8 9 10)
  FACES = %w(J Q K)
  ACE   = "A"

  def initialize(deck = nil)
    if deck.nil?
      @cards = (RANKS + FACES + [ACE]).product(SUITS)
      shuffle
    else
      @cards = deck
    end
  end

  def deal_card
    return nil if @cards.empty?
    @cards.pop
  end

  def initial_deal
    [deal_card, deal_card]
  end

  private

    def shuffle
      @cards.shuffle!
    end
end
