RSpec.describe Spire do
  it 'has a version number' do
    expect(Spire::VERSION).not_to be nil
  end

  describe 'logger' do
    it 'returns a logger' do
      expect(Spire.logger.class.name).to eq 'Logger'
    end
  end

  describe 'logger=' do
    it 'assigns @logger' do
      logger = Logger.new(STDOUT)
      Spire.logger = logger
      expect(Spire.logger).to eq logger
    end
  end

  describe 'configure' do
    it 'calls client.configure' do
      allow_any_instance_of(Spire::Client).to receive(:configure)

      Spire.configure do |config|
        config.company = 'Some Company'
        config.username = 'username'
        config.password = 'password'
        config.host = 'www.example.com'
        config.port = 3000
      end

      expect(Spire.client).to have_received(:configure)
    end

    it 'calls reset!' do
      allow(Spire).to receive(:reset!)

      Spire.configure do |config|
        config.company = 'Some Company'
        config.username = 'username'
        config.password = 'password'
        config.host = 'www.example.com'
        config.port = 3000
      end

      expect(Spire).to have_received(:reset!)
    end
  end

  describe 'reset!' do
    it 'sets resets the client' do
      client = Spire.client
      Spire.reset!
      expect(client).to_not eq Spire.client
    end
  end

  describe 'auth_policy' do
    it 'returns the client auth_policy' do
      Spire.configure do |config|
        config.company = 'Some Company'
        config.username = 'username'
        config.password = 'password'
        config.host = 'www.example.com'
        config.port = 3000
      end

      expect(Spire.auth_policy).to eq Spire.client.auth_policy
    end
  end

  describe 'configuration' do
    it 'returns the client configuration' do
      Spire.configure do |config|
        config.company = 'Some Company'
        config.username = 'username'
        config.password = 'password'
        config.host = 'www.example.com'
        config.port = 3000
      end

      expect(Spire.configuration).to eq Spire.client.configuration
    end
  end
end
