trigger OpportunityProductTriiger on OpportunityLineItem(after insert) {
  if (Trigger.isInsert) {
    if (Trigger.isAfter) {
      OpportunityProductHandler.UpdateStockCountPerProductQuantity(Trigger.new);
    }
  }
}
