require 'digest'

class Blockchain
  attr_reader :data, :blocks, :previous_block_hash

  def initialize
    @previous_block_hash  = 0
    @data   = Array.new
    @blocks = Hash.new
    @sha256 = Digest::SHA256.new
  end

  def add_data(data)
    @data << data
    if @data.size == 5
      block = create_new_block
      @blocks[block[:block_hash]] = block
      @previous_block_hash = block[:block_hash]
      @data.clear
    end
  end

  def get_blocks(amount)
    hash = @previous_block_hash
    [amount, @blocks.size].min.times.with_object([]) do |_, blockchain|
      blockchain << @blocks[hash]
      hash = blockchain.last[:previous_block_hash]
    end.reverse
  end

  private

  def create_new_block
    payload = {
      previous_block_hash: @previous_block_hash,
      rows: @data.dup,
      timestamp: Time.now.to_i
    }
    {
      block_hash: hash(payload)
    }.merge(payload)
  end

  def hash(block)
    @sha256.hexdigest block.to_s
  end
end
