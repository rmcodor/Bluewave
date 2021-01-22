public class TestDataFactory {
  public static List<Opportunity> CreateOpportunities(Integer count) {
    List<Opportunity> records = new List<Opportunity>();
    for (Integer i = 0; i < count; i++) {
      Opportunity c = new Opportunity();
      c.Name = (i + 1) + ' opp';
      c.CloseDate = Date.today().addDays(i);
      c.StageName = 'Closed Won';
      records.add(c);
    }
    return records;
  }
  public static User CreateUser(String uniqueUserName, Id profileId) {
    User record = new User(
      Alias = 'standt',
      Email = 'blueuser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      FirstName = 'Blue',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = profileId,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = uniqueUserName
    );
    return record;
  }
  public static Product2 CreateProduct(String family, String name) {
    Product2 record = new Product2(Name = name, Family = family);
    return record;
  }
  public static OpportunityLineItem CreateOpportunityLineItem(
    Id OpportunityId,
    Id PricebookEntryId,
    Decimal Quantity
  ) {
    OpportunityLineItem record = new OpportunityLineItem();
    record.OpportunityId = OpportunityId;
    record.Quantity = Quantity;
    record.TotalPrice = 500000.00;
    record.PricebookEntryId = PricebookEntryId;
    return record;
  }
  public static PricebookEntry CreatePriceBookEntry(
    Id pricebookId,
    Id productId
  ) {
    PricebookEntry record = new PricebookEntry(
      Pricebook2Id = pricebookId,
      Product2Id = productId,
      UnitPrice = 1020,
      IsActive = true
    );
    return record;
  }

  public static Profile GetProfile(String name) {
    return [SELECT Id FROM Profile WHERE Name = :name];
  }
  public static Stock_Count__c CreateStockCount(Id productId, Decimal count) {
    Stock_Count__c record = new Stock_Count__c(
      Product_Id__c = productId,
      Stock_Count_Number__c = count
    );
    return record;
  }
}
