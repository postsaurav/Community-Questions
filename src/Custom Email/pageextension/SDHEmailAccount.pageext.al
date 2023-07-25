pageextension 50005 "SDH Email Account" extends "Email Accounts"
{
    actions
    {
        addlast(Processing)
        {
            action(SDHSimpleEmail)
            {
                ApplicationArea = All;
                Caption = 'Sample Email';
                ToolTip = 'Executes the Sample Email action.';
                trigger OnAction()
                var
                    SDHCustomEmail: Codeunit "SDH Custom Emails";
                begin
                    SDHCustomEmail.SendSimpleEmail();
                end;
            }
        }
    }
}
