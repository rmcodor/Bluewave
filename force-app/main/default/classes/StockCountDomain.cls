public with sharing class StockCountDomain {
  /**
   * updates selected stock count record count with the value difference
   * @param {Stock_Count__c} record
   * @param {Decimal} value
   * @return {Stock_Count__c}
   */
  public static Stock_Count__c UpdateStockCountValue(
    Stock_Count__c record,
    Decimal value
  ) {
    if (value != null && value >= 0 && value < record.Stock_Count_Number__c) {
      record.Stock_Count_Number__c = record.Stock_Count_Number__c - value;
    }
    return record;
  }
}
