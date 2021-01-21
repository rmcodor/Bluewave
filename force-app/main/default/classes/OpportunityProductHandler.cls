public with sharing class OpportunityProductHandler {
  public static final String TAG = 'OpportunityProductHandler';
  /**
   * updates the stock count value, with the difference between the related product quantity and stock count
   * @param {List<Opportunity>} newRecords
   * @return {void}
   */
  public static void UpdateStockCountPerProductQuantity(
    List<OpportunityLineItem> newRecords
  ) {
    Map<Id, Decimal> mappedOppProducts = new Map<Id, Decimal>();
    Map<Id, Stock_Count__c> stockCountsToUpdate = new Map<Id, Stock_Count__c>();
    for (OpportunityLineItem record : newRecords) {
      if (Memory.opportunityProducts.contains(record.Id)) {
        continue; //skip, already processed
      }
      mappedOppProducts.put(record.Product2Id, record.Quantity);
    }
    for (
      Stock_Count__c record : StockCountSelector.GetRecords(
        mappedOppProducts.keySet()
      )
    ) {
      record = StockCountDomain.UpdateStockCountValue(
        record,
        mappedOppProducts.get(record.Product_Id__c)
      );
      stockCountsToUpdate.put(record.Id, record);
    }
    if (stockCountsToUpdate.size() > 0) {
      try {
        update stockCountsToUpdate.values();
      } catch (Exception e) {
        System.debug(Logginglevel.ERROR, TAG + ' ' + e.getMessage());
      }
    }
  }
}
