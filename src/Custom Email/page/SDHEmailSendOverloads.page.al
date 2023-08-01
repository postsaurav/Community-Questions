page 50002 "SDH Email Send Overloads"
{
    ApplicationArea = All;
    Caption = 'Email Send Overloads';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Send1Lbl; Send1Lbl)
                {
                    Editable = false;
                    ShowCaption = false;
                    trigger OnDrillDown()
                    begin
                        GenerateEmailMessage(1);
                        SendEmailMessage(1);
                    end;
                }
                field(Send2Lbl; Send2Lbl)
                {
                    Editable = false;
                    ShowCaption = false;
                    trigger OnDrillDown()
                    begin
                        GenerateEmailMessage(2);
                        SendEmailMessage(2);
                    end;
                }
                field(Send3Lbl; Send3Lbl)
                {
                    Editable = false;
                    ShowCaption = false;
                    trigger OnDrillDown()
                    begin
                        GenerateEmailMessage(3);
                        SendEmailMessage(3);
                    end;
                }
                field(Send4Lbl; Send4Lbl)
                {
                    Editable = false;
                    ShowCaption = false;
                    trigger OnDrillDown()
                    begin
                        GenerateEmailMessage(4);
                        SendEmailMessage(4);
                    end;
                }
            }
        }
    }

    local procedure GenerateEmailMessage(EmailType: Integer)
    begin
        Case EmailType of
            1:
                EmailMessage.Create('postsaurav@gmail.com', 'Test Email - 1', 'This is a Test Email From Business Central');
            2:
                EmailMessage.Create('postsaurav@gmail.com', 'Test Email - 2', 'This is a Test Email From Business Central');
            3:
                EmailMessage.Create('postsaurav@gmail.com', 'Test Email - 3', 'This is a Test Email From Business Central');
            4:
                EmailMessage.Create('postsaurav@gmail.com', 'Test Email - 4', 'This is a Test Email From Business Central');
        End;
    end;

    local procedure SendEmailMessage(EmailType: Integer)
    var
        TempEmailAccount: Record "Email Account" temporary;
        EmailAccount: Codeunit "Email Account";
    begin
        Case EmailType of
            1:
                Email.Send(EmailMessage);
            2:
                Email.Send(EmailMessage, Enum::"Email Scenario"::"Purchase Order");
            3:
                begin
                    EmailAccount.GetAllAccounts(true, TempEmailAccount);
                    TempEmailAccount.SetRange(Name, 'Purchase Demo');
                    if TempEmailAccount.FindFirst() then
                        Email.Send(EmailMessage, TempEmailAccount);
                end;
            4:
                begin
                    EmailAccount.GetAllAccounts(true, TempEmailAccount);
                    TempEmailAccount.SetRange(Name, 'Sales Demo');
                    if TempEmailAccount.FindFirst() then
                        Email.Send(EmailMessage, TempEmailAccount."Account Id", TempEmailAccount.Connector);
                end;
        end;
    end;

    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Send1Lbl: Label 'Send With Email Message.';
        Send2Lbl: Label 'Send With Email Message and Email Scenario.';
        Send3Lbl: Label 'Send With Email Message and Email Account Id.';
        Send4Lbl: Label 'Send With Email Message, Email Account Id and Email Connector.';
}
