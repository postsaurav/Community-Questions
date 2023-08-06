codeunit 50008 "SDH Excel Multiple Sheets"
{
    trigger OnRun()
    begin
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();

        ExportCustomerData();
        CreateExcelSheet('Customer', true);

        ExportVendorData();
        CreateExcelSheet('Vendor', false);

        ExportItemData();
        CreateExcelSheet('Item', false);

        CreateExcelBook();
    end;

    procedure SaveExcelInStream(var ResultStream: OutStream)
    begin
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();

        ExportCustomerData();
        CreateExcelSheet('Customer', true);

        ExportVendorData();
        CreateExcelSheet('Vendor', false);

        ExportItemData();
        CreateExcelSheet('Item', false);

        SaveToStream(ResultStream);
    end;

    local procedure ExportCustomerData()
    var
        Customer: Record Customer;
    begin
        Customer.SetAutoCalcFields("Balance (LCY)");
        if Customer.FindSet() then begin
            CreateExcelHeader(Customer);
            repeat
                CreateExcelBody(Customer);
            until Customer.Next() = 0;
        end;
    end;

    local procedure ExportVendorData()
    var
        Vendor: Record Vendor;
    begin
        Vendor.SetAutoCalcFields("Balance (LCY)");
        if Vendor.FindSet() then begin
            CreateExcelHeader(Vendor);
            repeat
                CreateExcelBody(Vendor);
            until Vendor.Next() = 0;
        end;
    end;

    local procedure ExportItemData()
    var
        Item: Record Item;
    begin
        Item.SetAutoCalcFields(Inventory);
        if Item.FindSet() then begin
            CreateExcelHeader(Item);
            repeat
                CreateExcelBody(Item);
            until Item.Next() = 0;
        end;
    end;

    local procedure CreateExcelHeader(Customer: Record Customer)
    begin
        TempExcelBuffer.AddColumn(Customer.FieldCaption("No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer.FieldCaption("Name"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer.FieldCaption("Location Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Balance$', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelHeader(Vendor: Record Vendor)
    begin
        TempExcelBuffer.AddColumn(Vendor.FieldCaption("No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Vendor.FieldCaption("Name"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Vendor.FieldCaption("Location Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Balance$', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelHeader(Item: Record Item)
    begin
        TempExcelBuffer.AddColumn(Item.FieldCaption("No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item.FieldCaption("Description"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item.FieldCaption("Inventory Posting Group"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Inventory', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelBody(Customer: Record Customer)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Customer."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer."Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer."Balance (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelBody(Vendor: Record Vendor)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Vendor."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Vendor."Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Vendor."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Vendor."Balance (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelBody(Item: Record Item)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item."Description", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item."Inventory Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Item."Inventory", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelSheet(SheetName: Text[250]; NewBook: Boolean)
    begin
        if NewBook then
            TempExcelBuffer.CreateNewBook(SheetName)
        else
            TempExcelBuffer.SelectOrAddSheet(SheetName);
        TempExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
    end;

    local procedure CreateExcelBook()
    begin
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Master Data List');
        TempExcelBuffer.OpenExcel();
    end;

    local procedure SaveToStream(var ResultStream: OutStream)
    begin
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Master Data List');
        TempExcelBuffer.SaveToStream(ResultStream, true);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
}
