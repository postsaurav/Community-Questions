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

    //Sending Purchase Order Emails
    procedure SendPurchaseOrderEmail(PurchaseHeader: Record "Purchase Header")
    var
        Selection, DefaultSelection : Integer;
        EmailTypeQst: Label 'E-Mail Item,E-Mail Message';
    begin
        DefaultSelection := 1;
        Selection := StrMenu(EmailTypeQst, DefaultSelection);

        Case Selection of
            1:
                SendPurchaseOrderWithEmailItem(PurchaseHeader);
            2:
                SendPurchaseOrderWithEmailMessage(PurchaseHeader);
        end;
    end;

    local procedure SendPurchaseOrderWithEmailItem(PurchaseHeader: Record "Purchase Header")
    var
        TempEmailItem: Record "Email Item" temporary;
        EmailSubjectBody: Codeunit "SDH Email Subject Body";
        EmailScenrio: Enum "Email Scenario";
        Selection, DefaultSelection : Integer;
        EmailBodyTypeQst: Label 'Basic E-Mail Body,HTML E-Mail Body,Detailed HTML E-Mail Body,Word Layout Body';
    begin
        TempEmailItem."Send to" := 'postsaurav@gmail.com';
        TempEmailItem."Subject" := EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader);

        DefaultSelection := 1;
        Selection := StrMenu(EmailBodyTypeQst, DefaultSelection);

        Case Selection of
            1:
                TempEmailItem.SetBodyText(EmailSubjectBody.GeneratePurchaseOrderEmailBody(PurchaseHeader));
            2:
                TempEmailItem.SetBodyText(EmailSubjectBody.GeneratePurchaseOrderHtmlEmailBody(PurchaseHeader));
            3:
                TempEmailItem.SetBodyText(EmailSubjectBody.GeneratePurchaseOrderDetailedHtmlEmailBody(PurchaseHeader));
            4:
                TempEmailItem.SetBodyText(EmailSubjectBody.GeneratePurchaseOrderEmailBodyReport(PurchaseHeader));
        end;
        AddAttachmentToPurchaseOrderEmail(TempEmailItem, PurchaseHeader);
        TempEmailItem.Send(false, EmailScenrio::"Purchase Order");
    end;

    local procedure SendPurchaseOrderWithEmailMessage(PurchaseHeader: Record "Purchase Header")
    var
        EmailMessage: Codeunit "Email Message";
        EmailSubjectBody: Codeunit "SDH Email Subject Body";
        Email: Codeunit Email;
        EmailScenrio: Enum "Email Scenario";
        Selection, DefaultSelection : Integer;
        EmailBodyTypeQst: Label 'Basic E-Mail Body,HTML E-Mail Body,Detailed HTML E-Mail Body,Word Layout Body';
    begin
        DefaultSelection := 1;
        Selection := StrMenu(EmailBodyTypeQst, DefaultSelection);

        Case Selection of
            1:
                EmailMessage.Create('postsaurav@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
        EmailSubjectBody.GeneratePurchaseOrderEmailBody(PurchaseHeader), true);
            2:
                EmailMessage.Create('postsaurav@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
        EmailSubjectBody.GeneratePurchaseOrderHtmlEmailBody(PurchaseHeader), true);
            3:
                EmailMessage.Create('postsaurav@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
        EmailSubjectBody.GeneratePurchaseOrderDetailedHtmlEmailBody(PurchaseHeader), true);
            4:
                EmailMessage.Create('postsaurav@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
        EmailSubjectBody.GeneratePurchaseOrderEmailBodyReport(PurchaseHeader), true);
        end;

        AddAttachmentToPurchaseOrderEmail(EmailMessage, PurchaseHeader);
        Email.OpenInEditor(EmailMessage, EmailScenrio::Default);
    end;

    local procedure AddAttachmentToPurchaseOrderEmail(var TempEmailItem: Record "Email Item" temporary; PurchaseHeader: Record "Purchase Header")
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        SDHEmailSubjectBody: Codeunit "SDH Email Subject Body";
        PurchaseHeaderRecordRef: RecordRef;
        ReportInStream: InStream;
        ReportOutStream: OutStream;
        LayoutCode: Code[20];
        ReportId: Integer;
        AttachmentFileNameLbl: Label 'Purchase Order %1.pdf', Comment = '%1 Purchase Order No.';
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        PurchaseHeaderRecordRef := SDHEmailSubjectBody.SetPurchaseRecordRef(PurchaseHeader);
        ReportLayoutSelection := SDHEmailSubjectBody.GetPurchOrderReportandLayoutCode(ReportId, LayoutCode, true);

        if LayoutCode <> '' then begin
            ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, PurchaseHeaderRecordRef);
            ReportLayoutSelection.SetTempLayoutSelected('');
        end else
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, PurchaseHeaderRecordRef);

        TempBlob.CreateInStream(ReportInStream);
        TempEmailItem.AddAttachment(ReportInStream, StrSubstNo(AttachmentFileNameLbl, PurchaseHeader."No."));
    end;

    local procedure AddAttachmentToPurchaseOrderEmail(var EmailMessage: Codeunit "Email Message"; PurchaseHeader: Record "Purchase Header")
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        TempBlob: Codeunit "Temp Blob";
        SDHEmailSubjectBody: Codeunit "SDH Email Subject Body";
        PurchaseHeaderRecordRef: RecordRef;
        ReportInStream: InStream;
        ReportOutStream: OutStream;
        LayoutCode: Code[20];
        ReportId: Integer;
        AttachmentFileNameLbl: Label 'Purchase Order %1.pdf', Comment = '%1 Purchase Order No.';
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        PurchaseHeaderRecordRef := SDHEmailSubjectBody.SetPurchaseRecordRef(PurchaseHeader);
        ReportLayoutSelection := SDHEmailSubjectBody.GetPurchOrderReportandLayoutCode(ReportId, LayoutCode, true);

        if LayoutCode <> '' then begin
            ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, PurchaseHeaderRecordRef);
            ReportLayoutSelection.SetTempLayoutSelected('');
        end else
            Report.SaveAs(ReportId, '', ReportFormat::Pdf, ReportOutStream, PurchaseHeaderRecordRef);

        TempBlob.CreateInStream(ReportInStream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, PurchaseHeader."No."), '', ReportInStream);
    end;
}
