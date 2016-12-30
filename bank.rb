class Bank
  attr_reader :funds

  STARTING_FUNDS = 1000

  def initialize(amount)
    @funds = amount.nil? ? STARTING_FUNDS : amount
  end

  def transfer(amount)
    @funds += amount
  end
end
