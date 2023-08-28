codeunit 50009 "SDH BC-CRM Custom Fields"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDS Setup Defaults", 'OnAfterResetCustomerAccountMapping', '', false, false)]
    local procedure SDHOnAfterResetCustomerAccountMapping(IntegrationTableMappingName: Code[20])
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
        Customer: Record Customer;
        CRMAccount: Record "CRM Account";
    begin
        // "Facebook URL" > Facebook
        IntegrationFieldMapping.CreateRecord(
          IntegrationTableMappingName,
          Customer.FieldNo("SDH Facebook URL"),
          CRMAccount.FieldNo("SDH Facebook"),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', true, false);

        // "Twitter URL" > Twitter
        IntegrationFieldMapping.CreateRecord(
          IntegrationTableMappingName,
          Customer.FieldNo("SDH Twitter URL"),
          CRMAccount.FieldNo("SDH Twitter"),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', true, false);
    end;
}
