pageextension 50003 "SDH Customer List" extends "Customer List"
{
    actions
    {
        addlast("&Customer")
        {
            action("Download Json")
            {
                ApplicationArea = All;
                Image = Export;
                Caption = 'Download Customer';
                ToolTip = 'Executes the Download Json action.';
                trigger OnAction()
                var
                    ExportJson: Codeunit "SDH Export Json";
                begin
                    ExportJson.ExportCustomerAsJson(Rec);
                end;
            }
            action("Download Jsons")
            {
                ApplicationArea = All;
                Image = Export;
                Caption = 'Download Selected Customers';
                ToolTip = 'Executes the Download Json action.';
                trigger OnAction()
                var
                    ExportJson: Codeunit "SDH Export Json";
                begin
                    ExportJson.ExportSelectedCustomersAsJson(Rec);
                end;
            }

            action(DownloadMasterData)
            {
                ApplicationArea = All;
                Image = Export;
                Caption = 'Download Master Data';
                ToolTip = 'Executes the Download Master Data action.';
                trigger OnAction()
                var
                    SDHExcelMultipleSheets: Codeunit "SDH Excel Multiple Sheets";
                begin
                    SDHExcelMultipleSheets.Run();
                end;
            }
        }
    }
}
