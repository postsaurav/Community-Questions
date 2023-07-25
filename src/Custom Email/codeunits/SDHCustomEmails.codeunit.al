codeunit 50006 "SDH Custom Emails"
{
    procedure SendSimpleEmail()
    begin
        if Confirm('Do you want to send email with Old Style?') then
            SendSimpleEmailOldStyle()
        else
            SendSimpleEmailNewStyle();
    end;

    local procedure SendSimpleEmailOldStyle()
    var
        TempEmailItem: Record "Email Item" temporary;
        EmailScenrio: Enum "Email Scenario";
    begin
        TempEmailItem."Send to" := 'postsaurav@gmail.com';
        TempEmailItem."Subject" := 'Test Email';
        TempEmailItem.SetBodyText('This is a test email.');
        TempEmailItem.Send(false, EmailScenrio::"Purchase Order");
    end;

    local procedure SendSimpleEmailNewStyle()
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailScenrio: Enum "Email Scenario";
    begin
        EmailMessage.Create('postsaurav@gmail.com', 'Test Email', 'This is a test email.');
        Email.OpenInEditor(EmailMessage, EmailScenrio::Default);
        //Email.Send(EmailMessage, EmailScenrio::Default);
    end;
}
