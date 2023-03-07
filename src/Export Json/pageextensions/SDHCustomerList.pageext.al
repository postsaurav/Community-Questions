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
                ToolTip = 'Executes the Download Json action.';
                trigger OnAction()
                var
                    ExportJson: Codeunit "SDH Export Json";
                begin
                    ExportJson.ExportCustomerAsJson(Rec);
                end;
            }
        }
    }
}
