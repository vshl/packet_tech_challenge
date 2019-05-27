# frozen_string_literal: true

require 'packethost'

class Device
  PROJECT_ID = 'ca73364c-6023-4935-9137-2132e73c20b4'

  def initialize
    @client = Packet::Client.new('NLxG4o3xNjyKyddT7g9WX1rHyPYfHeBZ')
  end

  def create_new_device
    return unless my_device.nil?

    client.create_device(new_device)
  end

  def tear_down_device
    return if my_device.nil?

    client.delete_device(my_device) unless my_device.provisioning?
  rescue Packet::Error => e
    puts e
  end

  def new_device
    @new_device ||=
      Packet::Device.new(
        project_id: PROJECT_ID,
        hostname: 'vishaltest.packethost.net',
        operating_system: os.to_hash,
        facility: facility.to_hash,
        plan: plan.to_hash
      )
  rescue Packet::Error => e
    puts e
  end

  def boot
    return false if my_device.nil? || my_device&.active? || my_device&.provisioning?

    client.power_on_device(my_device)
  end

  def powerdown
    return false if my_device.nil? || my_device&.inactive? || my_device&.provisioning?

    client.power_off_device(my_device)
  end

  def number_of_devices
    client.list_devices(PROJECT_ID).count
  end

  def my_device
    client.list_devices(PROJECT_ID).find { |device| device.hostname == 'vishaltest.packethost.net' }
  end

  attr_reader :client

  private

  def os
    @os ||= client.list_operating_systems.find { |os| os.slug == 'freebsd_10_3' }
  end

  def facility
    @facility ||= client.list_facilities.find { |facility| facility.code == 'ewr1' }
  end

  def plan
    @plan ||= client.list_devices(PROJECT_ID)[0].plan
  end
end
