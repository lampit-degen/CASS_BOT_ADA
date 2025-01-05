class FraudService
  # Rules
  # - Mint transaction needs to be 20 seconds apart from next transaction, weight: 30
  # - next 4 transactions need to be 10 seconds each apart, weight: 10 each
  # - next 4-10 transactions need to be 10 seconds each apart, weight: 5 each
  def initialize(transactions)
    @transactions = transactions.sort_by { |t| [t['block_time'], t['tx_index']] }.map { |t| t['block_time'] }
  end

  def call
    @score = 0
    @score += 30 if TimestampService.new(@transactions[0], @transactions[1]).call
    @score += 10 if TimestampService.new(*@transactions.slice(1..3)).call
    @score += 20 if TimestampService.new(*@transactions.slice(1..4)).call
    @score += 30 if TimestampService.new(*@transactions.slice(1..5)).call
    @score += 40 if TimestampService.new(*@transactions.slice(1..6)).call
    @score += 50 if TimestampService.new(*@transactions.slice(1..7)).call
    @score += 50 if TimestampService.new(*@transactions.slice(1..8)).call
    @score += 50 if TimestampService.new(*@transactions.slice(1..9)).call
    @score += 50 if TimestampService.new(*@transactions.slice(1..10)).call
    @score
  end
end
