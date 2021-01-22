@isTest
public class OpportunityProductHandlerTest {
  @testSetup
  static void setup() {
    Profile adminProfile = TestDataFactory.GetProfile(
      Constants.SYSTEM_ADMIN_PROFILE
    );
    User newUser = TestDataFactory.CreateUser(
      'miker@test.com',
      adminProfile.Id
    );
    insert newUser;
    System.runAs(newUser) {
      List<Product2> products = new List<Product2>();
      List<String> families = new List<String>{
        'Gold',
        'Silver',
        'Bronze',
        'Platinum',
        'None'
      };
      for (String family : families) {
        //add each product to be created
        products.add(
          TestDataFactory.CreateProduct(family, 'Product P - 0' + family)
        );
      }
      //Insert products with families
      insert products;

      //Instantiate the Pricebook2 record with StandardPricebookId
      Pricebook2 standardPricebook = new Pricebook2(
        Id = Test.getStandardPricebookId(),
        IsActive = true
      );

      //Execute an update DML on the Pricebook2 record, to make IsStandard to true
      update standardPricebook;

      //Query for the Pricebook2 record, to check IsStandard field
      standardPricebook = [
        SELECT Id, IsStandard
        FROM Pricebook2
        WHERE Id = :standardPricebook.Id
      ];
      //It should return true
      System.assertEquals(true, standardPricebook.IsStandard);

      List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
      for (Product2 record : products) {
        priceBookEntries.add(
          TestDataFactory.CreatePriceBookEntry(standardPricebook.Id, record.Id)
        );
      }
      //Insert Price Book Entries
      insert priceBookEntries;
      //create opportunities
      insert TestDataFactory.CreateOpportunities(5);
    }
  }
  @isTest
  public static void negativeScenarioTest() {
    Test.startTest();
    Profile adminProfile = TestDataFactory.GetProfile(
      Constants.SYSTEM_ADMIN_PROFILE
    );
    System.assert(adminProfile != null, 'Admin cannot be null');
    User newUser = TestDataFactory.CreateUser(
      'salesagent1@test.com',
      adminProfile.Id
    );
    insert newUser;
    System.runAs(newUser) {
      List<Opportunity> opps = [SELECT Id FROM Opportunity];
      System.assertEquals(5, opps.size(), '5 opportunities expected');
      List<Product2> products = [SELECT Id FROM Product2];
      System.assertEquals(5, products.size(), '5 products expected');
      List<PricebookEntry> priceBookEntries = [SELECT Id FROM PricebookEntry];
      System.assertEquals(
        5,
        priceBookEntries.size(),
        '5 PriceBookEntry expected'
      );
      List<Stock_Count__c> stocks = new List<Stock_Count__c>();
      List<OpportunityLineItem> opportunityProducts = new List<OpportunityLineItem>();
      for (Integer i = 0; i < 5; i++) {
        stocks.add(TestDataFactory.CreateStockCount(products[i].Id, i + 10));
      }
      for (Integer i = 0; i < 5; i++) {
        opportunityProducts.add(
          TestDataFactory.CreateOpportunityLineItem(
            opps[i].Id,
            priceBookEntries[i].Id,
            i + 2
          )
        );
      }
      //inserts
      insert stocks;
      insert opportunityProducts;
      //asserts
      List<Stock_Count__c> records = [
        SELECT Product_Id__c, Stock_Count_Number__c
        FROM Stock_Count__c
        ORDER BY Stock_Count_Number__c ASC
      ];
      System.assertEquals(5, records.size(), 'queriedStocks expected to be 5');
      Integer index = 0;
      for (Stock_Count__c record : records) {
        System.assertEquals(
          record.Product_Id__c,
          products[index++].Id,
          'wrong product id'
        );
      }
      //Stock count = 12, Product quantity = 4) 12 - 4 = 8
      System.assertNotEquals(
        records[1].Stock_Count_Number__c,
        7,
        'Stock count for third product not expected to be 8'
      );
    }
    Test.stopTest();
  }
  @isTest
  public static void positiveScenarioTest() {
    Test.startTest();
    Profile adminProfile = TestDataFactory.GetProfile(
      Constants.SYSTEM_ADMIN_PROFILE
    );
    System.assert(adminProfile != null, 'Admin cannot be null');
    User newUser = TestDataFactory.CreateUser(
      'salesagent1@test.com',
      adminProfile.Id
    );
    insert newUser;
    System.runAs(newUser) {
      List<Opportunity> opps = [SELECT Id FROM Opportunity];
      System.assertEquals(5, opps.size(), '5 opportunities expected');
      List<Product2> products = [SELECT Id FROM Product2];
      System.assertEquals(5, products.size(), '5 products expected');
      List<PricebookEntry> priceBookEntries = [SELECT Id FROM PricebookEntry];
      System.assertEquals(
        5,
        priceBookEntries.size(),
        '5 PriceBookEntry expected'
      );
      List<Stock_Count__c> stocks = new List<Stock_Count__c>();
      List<OpportunityLineItem> opportunityProducts = new List<OpportunityLineItem>();
      for (Integer i = 0; i < 5; i++) {
        stocks.add(TestDataFactory.CreateStockCount(products[i].Id, i + 10));
      }
      for (Integer i = 0; i < 5; i++) {
        opportunityProducts.add(
          TestDataFactory.CreateOpportunityLineItem(
            opps[i].Id,
            priceBookEntries[i].Id,
            i + 2
          )
        );
      }
      //inserts
      insert stocks;
      insert opportunityProducts;
      //asserts
      List<Stock_Count__c> records = [
        SELECT Product_Id__c, Stock_Count_Number__c
        FROM Stock_Count__c
        ORDER BY Stock_Count_Number__c ASC
      ];
      System.assertEquals(5, records.size(), 'queriedStocks expected to be 5');
      Integer index = 0;
      for (Stock_Count__c record : records) {
        System.assertEquals(
          record.Product_Id__c,
          products[index++].Id,
          'wrong product id'
        );
      }
      //Stock count = 11, Product quantity = 3) 11 - 3 = 8
      System.assertEquals(
        8,
        records[1].Stock_Count_Number__c,
        'Stock count for second opportunity expected to be 8'
      );
    }
    Test.stopTest();
  }
  @isTest
  public static void salesAgenProfileTest() {
    Test.startTest();
    Profile salesAgentProfile = TestDataFactory.GetProfile(
      Constants.SALES_AGENT_PROFILE
    );
    System.assert(salesAgentProfile != null, 'Sales Agent cannot be null');
    User newUser = TestDataFactory.CreateUser(
      'salesagent1@test.com',
      salesAgentProfile.Id
    );
    insert newUser;
    System.runAs(newUser) {
      Boolean isAccessible = Schema.sObjectType.Stock_Count__c.fields.Id.isAccessible();
      System.assertEquals(
        false,
        isAccessible,
        'Sales Agent profile should not be able to create A Stock Count Object'
      );
    }
    Test.stopTest();
  }
  @isTest
  public static void sysAdminProfileTest() {
    Test.startTest();
    Profile adminProfile = TestDataFactory.GetProfile(
      Constants.SYSTEM_ADMIN_PROFILE
    );
    System.assert(adminProfile != null, 'Admin cannot be null');
    User newUser = TestDataFactory.CreateUser(
      'salesagent2@test.com',
      adminProfile.Id
    );
    insert newUser;
    System.runAs(newUser) {
      Boolean isAccessible = Schema.sObjectType.Stock_Count__c.fields.Id.isAccessible();
      System.assertEquals(
        true,
        isAccessible,
        'System Admins profile should be able to create A Stock Count Object'
      );
    }
    Test.stopTest();
  }
  @isTest
  public static void bulkScenarioTest() {
    Test.startTest();
    Profile adminProfile = TestDataFactory.GetProfile(
      Constants.SYSTEM_ADMIN_PROFILE
    );
    System.assert(adminProfile != null, 'Sales Agent cannot be null');
    User newUser = TestDataFactory.CreateUser(
      'salesagent1@test.com',
      adminProfile.Id
    );
    insert newUser;
    System.runAs(newUser) {
      Integer count = 5;
      List<Product2> products = [SELECT Id FROM Product2];
      System.assertEquals(count, products.size(), '5 products expected');
      List<Opportunity> opps = [SELECT Id FROM Opportunity];
      System.assertEquals(count, opps.size(), '5 opportunities expected');
      List<PricebookEntry> priceBookEntries = [SELECT Id FROM PricebookEntry];
      System.assertEquals(
        count,
        priceBookEntries.size(),
        '5 PriceBookEntry expected'
      );
      List<Stock_Count__c> stocks = new List<Stock_Count__c>();
      List<OpportunityLineItem> opportunityProducts = new List<OpportunityLineItem>();
      for (Integer i = 0; i < count; i++) {
        stocks.add(TestDataFactory.CreateStockCount(products[i].Id, i));
      }
      for (Integer i = 0; i < count; i++) {
        opportunityProducts.add(
          TestDataFactory.CreateOpportunityLineItem(
            opps[i].Id,
            priceBookEntries[i].Id,
            i + 1 * 2
          )
        );
      }
      //insert stocks
      insert stocks;

      //inert opportunityLineItems
      insert opportunityProducts;

      //asserts
      List<Stock_Count__c> queriedStocks = [SELECT Id FROM Stock_Count__c];
      System.assertEquals(
        count,
        queriedStocks.size(),
        'queriedStocks expected to be 5'
      );
      List<OpportunityLineItem> opportunityLineItems = [
        SELECT Id
        FROM OpportunityLineItem
      ];
      System.assertEquals(
        count,
        opportunityLineItems.size(),
        'opportunityLineItems expected to be 5'
      );
    }
    Test.stopTest();
  }
}
