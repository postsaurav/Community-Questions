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
        OpenAIMgmt: Codeunit "SDH Open AI Mgmt.";
        EmailScenrio: Enum "Email Scenario";
        Selection, DefaultSelection : Integer;
        EmailBodyTypeQst: Label 'Basic E-Mail Body,HTML E-Mail Body,Detailed HTML E-Mail Body,Word Layout Body,AI Email Body';
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
            5:
                TempEmailItem.SetBodyText(OpenAIMgmt.GeneratePurchaseOrderEmailBodyFromChatGPT(PurchaseHeader));
        end;
        AddAttachmentToPurchaseOrderEmail(TempEmailItem, PurchaseHeader);
        AddMasterAttachmentExcelToPurchaseOrderEmail(TempEmailItem);
        AddRelatedTable(TempEmailItem, PurchaseHeader);
        TempEmailItem.Send(false, EmailScenrio::"Purchase Order");
    end;

    local procedure SendPurchaseOrderWithEmailMessage(PurchaseHeader: Record "Purchase Header")
    var
        EmailMessage: Codeunit "Email Message";
        EmailSubjectBody: Codeunit "SDH Email Subject Body";
        OpenAIMgmt: Codeunit "SDH Open AI Mgmt.";
        Email: Codeunit Email;
        EmailScenrio: Enum "Email Scenario";
        Selection, DefaultSelection : Integer;
        EmailBodyTypeQst: Label 'Basic E-Mail Body,HTML E-Mail Body,Detailed HTML E-Mail Body,Word Layout Body,AI Email Body';
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
            5:
                EmailMessage.Create('postsaurav@gmail.com', EmailSubjectBody.GeneratePurchaseOrderEmailSubject(PurchaseHeader),
            OpenAIMgmt.GeneratePurchaseOrderEmailBodyFromChatGPT(PurchaseHeader), true);
        end;

        AddAttachmentToPurchaseOrderEmail(EmailMessage, PurchaseHeader);
        AddMasterAttachmentExcelToPurchaseOrderEmail(EmailMessage);
        AddRelatedTable(Email, EmailMessage, PurchaseHeader);
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

    local procedure AddMasterAttachmentExcelToPurchaseOrderEmail(var TempEmailItem: Record "Email Item" temporary)
    var
        SDHExcelMultipleSheets: Codeunit "SDH Excel Multiple Sheets";
        TempBlob: Codeunit "Temp Blob";
        ReportInStream: InStream;
        ReportOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        TempBlob.CreateInStream(ReportInStream);
        SDHExcelMultipleSheets.SaveExcelInStream(ReportOutStream);
        TempEmailItem.AddAttachment(ReportInStream, 'Master Data List.xlsx');
    end;

    local procedure AddMasterAttachmentExcelToPurchaseOrderEmail(var EmailMessage: Codeunit "Email Message")
    var
        SDHExcelMultipleSheets: Codeunit "SDH Excel Multiple Sheets";
        TempBlob: Codeunit "Temp Blob";
        ReportInStream: InStream;
        ReportOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(ReportOutStream);
        TempBlob.CreateInStream(ReportInStream);
        SDHExcelMultipleSheets.SaveExcelInStream(ReportOutStream);
        EmailMessage.AddAttachment('Master Data List.xlsx', '', ReportInStream);
    end;

    local procedure AddRelatedTable(var TempEmailItem: Record "Email Item" temporary; PurchaseHeader: Record "Purchase Header")
    var
        Vendor: Record Vendor;
        Location: Record Location;
        SourceTables: List of [Integer];
        SourceIDs: List of [Guid];
        SourceRelationTypes: List of [Integer];
    begin
        Vendor.Get(PurchaseHeader."Buy-from Vendor No.");

        SourceTables.Add(Database::"Purchase Header");
        SourceIDs.Add(PurchaseHeader.SystemId);
        SourceRelationTypes.Add(Enum::"Email Relation Type"::"Primary Source".AsInteger());

        SourceTables.Add(Database::"Vendor");
        SourceIDs.Add(Vendor.SystemId);
        SourceRelationTypes.Add(Enum::"Email Relation Type"::"Related Entity".AsInteger());

        if Location.Get(PurchaseHeader."Location Code") then begin
            SourceTables.Add(Database::"Location");
            SourceIDs.Add(Location.SystemId);
            SourceRelationTypes.Add(Enum::"Email Relation Type"::"Related Entity".AsInteger());
        end;

        TempEmailItem.SetSourceDocuments(SourceTables, SourceIDs, SourceRelationTypes);
    end;

    local procedure AddRelatedTable(var Email: Codeunit Email; EmailMessage: Codeunit "Email Message"; PurchaseHeader: Record "Purchase Header")
    var
        Vendor: Record Vendor;
        Location: Record Location;
    begin
        Vendor.Get(PurchaseHeader."Buy-from Vendor No.");
        Email.AddRelation(EmailMessage, Database::"Purchase Header", PurchaseHeader.SystemId, Enum::"Email Relation Type"::"Primary Source", Enum::"Email Relation Origin"::"Compose Context");
        Email.AddRelation(EmailMessage, Database::"Vendor", Vendor.SystemId, Enum::"Email Relation Type"::"Related Entity", Enum::"Email Relation Origin"::"Compose Context");
        if Location.Get(PurchaseHeader."Location Code") then
            Email.AddRelation(EmailMessage, Database::"Location", Location.SystemId, Enum::"Email Relation Type"::"Related Entity", Enum::"Email Relation Origin"::"Compose Context");
    end;
}
