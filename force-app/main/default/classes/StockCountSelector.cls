public with sharing class StockCountSelector {
  /**
   * queries stock counts for specific product records
   * @param {Set<Id>}productIds
   * @return {List<Stock_Count__c>}
   */
  public static List<Stock_Count__c> GetRecords(Set<Id> productIds) {
    return [
      SELECT Id, Stock_Count_Number__c, Product_Id__c
      FROM Stock_Count__c
      WHERE Product_Id__c IN :productIds
      WITH SECURITY_ENFORCED
      FOR UPDATE
    ];
  }
}
