codeunit 50003 "SDH Export Json"
{
    procedure ExportSelectedCustomersAsJson(Customer: Record Customer)
    var
        CustomersJson: JsonObject;
    begin
        CustomersJson.Add('Customers', ExportCustomerAsJson(Customer, true));
        ExportJsonFile(CustomersJson, 'Selected Customers.json');
    end;

    local procedure ExportCustomerAsJson(Customer: Record Customer; Exportall: Boolean) CustomerJsonArray: JsonArray
    var
        CustomerJson: JsonObject;
    begin
        if not Exportall then exit;
        if Customer.FindSet() then
            repeat
                Clear(CustomerJson);
                Customer.SetAutoCalcFields("Balance (LCY)", "Sales (LCY)");
                CustomerJson.Add(Customer.FieldCaption("No."), Customer."No.");
                CustomerJson.Add(Customer.FieldCaption("Name"), Customer.Name);
                CustomerJson.Add(Customer.FieldCaption("Balance (LCY)"), Customer."Balance (LCY)");
                CustomerJson.Add(Customer.FieldCaption("Sales (LCY)"), Customer."Sales (LCY)");
                CustomerJson.Add('Shiptoaddress', GetShiptoAddressForCustomer(Customer."No."));
                CustomerJsonArray.Add(CustomerJson);
            until (Customer.Next() = 0);
    end;

    procedure ExportCustomerAsJson(Customer: Record Customer)
    var
        CustomerJson: JsonObject;
    begin
        Customer.SetAutoCalcFields("Balance (LCY)", "Sales (LCY)");
        CustomerJson.Add(Customer.FieldCaption("No."), Customer."No.");
        CustomerJson.Add(Customer.FieldCaption("Name"), Customer.Name);
        CustomerJson.Add(Customer.FieldCaption("Balance (LCY)"), Customer."Balance (LCY)");
        CustomerJson.Add(Customer.FieldCaption("Sales (LCY)"), Customer."Sales (LCY)");
        CustomerJson.Add('Shiptoaddress', GetShiptoAddressForCustomer(Customer."No."));
        ExportJsonFile(CustomerJson, 'Customer ' + Customer."No." + '.json');
    end;

    local procedure GetShiptoAddressForCustomer(No: Code[20]) ShipToAddressArray: JsonArray
    var
        ShipToAddress: Record "Ship-to Address";
        ShipToAddressJson: JsonObject;
    begin
        ShipToAddress.SetRange("Customer No.", No);
        if ShipToAddress.FindSet() then
            repeat
                Clear(ShipToAddressJson);
                ShipToAddressJson.Add(ShipToAddress.FieldCaption(Code), ShipToAddress.Code);
                ShipToAddressJson.Add(ShipToAddress.FieldCaption(Name), ShipToAddress.Name);
                ShipToAddressJson.Add(ShipToAddress.FieldCaption(City), ShipToAddress.City);
                ShipToAddressArray.Add(ShipToAddressJson);
            until (ShipToAddress.Next() = 0);
    end;

    local procedure ExportJsonFile(var CustomerJson: JsonObject; filename: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        CustomerOutStream: OutStream;
        CustomerInstream: InStream;
        ExportFileName: Text;
    begin
        TempBlob.CreateOutStream(CustomerOutStream);
        If CustomerJson.WriteTo(CustomerOutStream) then begin
            ExportFileName := filename;
            TempBlob.CreateInStream(CustomerInstream);
            DownloadFromStream(CustomerInstream, '', '', '', ExportFileName);
        end;
    end;

}
