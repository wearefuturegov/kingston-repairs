class Repair
  def initialize(repair_data)
    @repair_data = repair_data
  end

  def request_reference
    @repair_data.fetch('repairRequestReference')
  end

  def work_order_reference
    return nil unless @repair_data.key?('workOrders')

    @repair_data.fetch('workOrders')&.first&.fetch('workOrderReference')
  end

  def sor_code
    return nil unless @repair_data.key?('workOrders')

    @repair_data.fetch('workOrders')&.first&.fetch('sorCode')
  end

  def supplier_reference
    return nil unless @repair_data.key?('workOrders')

    @repair_data.fetch('workOrders')&.first&.fetch('supplierReference')
  end

  def priority
    @repair_data.fetch('priority')
  end
end
