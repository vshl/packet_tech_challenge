# frozen_string_literal: true

require_relative 'packet'

describe Device do
  device = Device.new

  describe 'create_new_device' do
    it 'creates new device' do
      if device.my_device.nil?
        expect { device.create_new_device }.to change { device.number_of_devices }.by(1)
      else
        expect { device.create_new_device }.to change { device.number_of_devices }.by(0)
      end
    end
  end

  describe 'tear_down_device' do
    it 'tears down device' do
      unless device&.my_device&.provisioning?
        expect { device.tear_down_device }.to change { device.number_of_devices }.by(-1)
      end
    end
  end

  describe 'boot' do
    it 'does not power up a device when provisioning' do
      expect(device.boot).to eq false if device&.my_device&.provisioning?
    end

    it 'does power up a device' do
      unless device.my_device.nil?
        expect(device.boot).to eq true unless device&.my_device&.provisioning?
      end
    end
  end

  describe 'powerdown' do
    it 'does not power down a device when provisioning' do
      expect(device.powerdown).to eq false if device&.my_device&.provisioning?
    end

    it 'does power down a device' do
      unless device.my_device.nil?
        expect(device.powerdown).to eq true unless device&.my_device&.provisioning?
      end
    end
  end
end
