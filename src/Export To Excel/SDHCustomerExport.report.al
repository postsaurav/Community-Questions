report 50004 "SDH Customer Export"
{
    ApplicationArea = All;
    Caption = 'Customer Export';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            trigger OnPreDataItem()
            begin
                CreateExcelHeader();
                Customer.SetAutoCalcFields("Balance (LCY)");
            end;

            trigger OnAfterGetRecord()
            begin
                CreateExcelBody();
            end;
        }

    }

    trigger OnInitReport()
    begin
        TempExcelBuffer.Deleteall();
    end;

    trigger OnPostReport()
    begin
        CreateExcelBook();
    end;

    local procedure CreateExcelHeader()
    begin
        TempExcelBuffer.AddColumn(Customer.FieldCaption("No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer.FieldCaption("Name"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer.FieldCaption("Location Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Balance$', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelBody()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Customer."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer."Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Customer."Balance (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelBook()
    begin
        TempExcelBuffer.CreateNewBook('Demo Excel');
        TempExcelBuffer.WriteSheet('Demo Excel', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Customer List');
        TempExcelBuffer.OpenExcel();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
}