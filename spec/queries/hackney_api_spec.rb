require 'spec_helper'
require 'app/queries/hackney_api'

describe HackneyApi do
  describe '#list_properties' do
    it 'returns a list of properties' do
      results = [
        { 'property_reference' => 'def567', 'short_address' => 'Flat 8, 1 Aardvark Road, A1 1AA' },
      ]
      json_api = double(get: results)
      api = HackneyApi.new(json_api)

      expect(api.list_properties(postcode: 'A1 1AA')).to eql results
    end
  end

  describe '#get_property' do
    it 'returns an individual property' do
      results = {
        'property_reference' => 'cre045',
        'short_address' => 'Flat 45, Cheddar Row Estate, Hackney, N1 1AA',
      }
      json_api = instance_double('JsonApi')
      allow(json_api).to receive(:get).with('properties/cre045').and_return(results)
      api = HackneyApi.new(json_api)

      expect(api.get_property(property_reference: 'cre045')).to eql results
    end
  end

  describe '#create_repair' do
    it 'sends repair creation parameters' do
      json_api = instance_double('JsonApi')
      allow(json_api).to receive(:post).with('repairs', anything)

      api = HackneyApi.new(json_api)
      repair_params = {
        priority: 'U',
        problem: 'It is broken',
        property_reference: '01234567',
      }
      api.create_repair(repair_params)

      expect(json_api).to have_received(:post)
        .with(
          'repairs',
          priority: 'U',
          problem: 'It is broken',
          property_reference: '01234567',
        )
    end

    it 'returns the result from the api call' do
      json_api = instance_double('JsonApi')
      result = double('api result')
      allow(json_api).to receive(:post)
        .with('repairs', anything)
        .and_return result

      api = HackneyApi.new(json_api)
      expect(api.create_repair(double)).to eq result
    end
  end

  describe '#get_repair' do
    it 'returns an individual repair' do
      result = {
        'requestReference' => '00045678',
        'orderReference' => '00412371',
        'problem' => 'My bath is broken',
        'priority' => 'N',
        'propertyRef' => '00034713',
      }
      json_api = instance_double('JsonApi')
      allow(json_api).to receive(:get).with('repairs/00045678').and_return(result)
      api = HackneyApi.new(json_api)

      expect(api.get_repair(repair_request_reference: '00045678')).to eql result
    end
  end

  describe '#list_available_appointments' do
    it 'returns a list of available appointments for a work order' do
      result = [
        {
          'beginDate' => '2017-11-01T08:00:00Z',
          'endDate' => '2017-11-01T12:00:00Z',
          'bestSlot' => true,
        },
        {
          'beginDate' => '2017-11-01T12:00:00Z',
          'endDate' => '2017-11-01T16:15:00Z',
          'bestSlot' => false,
        },
      ]

      json_api = instance_double('JsonApi')
      allow(json_api).to receive(:get).with('work_orders/00412371/appointments').and_return(result)
      api = HackneyApi.new(json_api)

      expect(api.list_available_appointments(work_order_reference: '00412371')).to eql result
    end
  end

  describe '#book_appointment' do
    it 'books an appointment for a work order' do
      result = {
        'beginDate' => '2017-11-01T14:00:00Z',
        'endDate' => '2017-11-01T16:30:00Z',
        'status' => 'booked',
      }

      json_api = instance_double('JsonApi')
      allow(json_api)
        .to receive(:post)
        .with(
          'work_orders/00412371/appointments',
          beginDate: '2017-11-01T14:00:00Z',
          endDate: '2017-11-01T16:30:00Z'
        )
        .and_return(result)

      api = HackneyApi.new(json_api)
      expect(
        api.book_appointment(
          work_order_reference: '00412371',
          begin_date: '2017-11-01T14:00:00Z',
          end_date: '2017-11-01T16:30:00Z'
        )
      ).to eql result
    end
  end
end
