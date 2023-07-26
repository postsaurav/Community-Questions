pageextension 50006 "SDH Purchase Order" extends "Purchase Order"
{
    actions
    {
        addlast(Processing)
        {
            action(SDHSimpleEmail)
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Email';
                ToolTip = 'Executes the Sample Email action.';
                Image = Email;
                trigger OnAction()
                var
                    SDHCustomEmail: Codeunit "SDH Custom Emails";
                begin
                    SDHCustomEmail.SendPurchaseOrderEmail(Rec);
                end;
            }
        }
    }
}
