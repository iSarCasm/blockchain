require_relative '../blockchain'

describe Blockchain do
  let!(:blockchain) { Blockchain.new }

  describe '#add_data' do
    describe 'adds any string data to internal data' do
      it 'one record' do
        blockchain.add_data '12345'

        expect(blockchain.data).to eq ['12345']
      end

      it 'multiple records' do
        blockchain.add_data '12345'
        blockchain.add_data '123'

        expect(blockchain.data).to eq ['12345', '123']
      end
    end

    context 'when reaches 5 data records' do
      before do
        5.times { blockchain.add_data '12345' }

        @payload = {
          previous_block_hash: 0,
          rows: ['12345', '12345', '12345', '12345', '12345'],
          timestamp: Time.now.to_i
        }
        @hash = Digest::SHA256.new.hexdigest(@payload.to_s)
        @block = @payload.merge(block_hash: @hash)
      end

      it 'resets internal data' do
        expect(blockchain.data).to eq []
      end

      describe 'adds new block to blocks' do
        it 'increases amount of blocks' do
          expect(blockchain.blocks.size).to eq 1
        end

        it 'creates valid block' do
          expect(blockchain.blocks[@hash]).to eq @block
        end
      end
    end
  end

  describe '#get_blocks' do
    before do
      @block1 = {
        previous_block_hash: 0,
        rows: [1, 2, 3, 4, 5],
        timestamp: 30,
        block_hash: 'hash1'
      }
      @block2 = {
        previous_block_hash: 'hash1',
        rows: [1, 2, 3, 4, 5],
        timestamp: 10,
        block_hash: 'hash2'
      }
      @block3 = {
        previous_block_hash: 'hash2',
        rows: [1, 2, 3, 4, 5],
        timestamp: 0,
        block_hash: 'hash3'
      }
      @blocks = {
        'hash3' => @block3,
        'hash1' => @block1,
        'hash2' => @block2,
      }
      blockchain.instance_variable_set(:@blocks, @blocks)
      blockchain.instance_variable_set(:@previous_block_hash, 'hash3')
    end

    it 'returns blocks in correct order even if time is messed up' do
      expect(blockchain.get_blocks(3)).to eq [@block1, @block2, @block3]
    end

    it 'returns all blocks if amount is higher than blocks size' do
      expect(blockchain.get_blocks(10)).to eq [@block1, @block2, @block3]
    end

    it 'returns empty array if amount is below 1' do
      expect(blockchain.get_blocks(-1)).to eq []
    end

    it 'returns last blocks' do
      expect(blockchain.get_blocks(2)).to eq [@block2, @block3]
    end
  end
end
