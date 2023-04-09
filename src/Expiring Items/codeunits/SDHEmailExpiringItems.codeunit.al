codeunit 50005 "SDH Email Expiring Items"
{
    // trigger onRUn()
    // begin
    //     EmailExpiringItems();
    // end;

    procedure EmailExpiringItems()
    var
        TempEmailItem: Record "Email Item" temporary;
    begin
        TempEmailItem."Send to" := 'postsaurav@gmail.com';
        TempEmailItem.Subject := 'Expiring Items';
        TempEmailItem."Plaintext Formatted" := true;
        TempEmailItem.SetBodyText('Hi Team, <br> Please find attached Items Expiring.');
        AddReportPDF(TempEmailItem);
        TempEmailItem.Send(true, Enum::"Email Scenario"::Default);
    end;

    local procedure AddReportPDF(var TempEmailItem: Record "Email Item" temporary)
    var
        SDHExpiringItems: Report "SDH Expiring Items";
        TempBlob: Codeunit "Temp Blob";
        NewDateForumla: DateFormula;
        reportinstream: InStream;
        reportoutstream: OutStream;
    begin
        Evaluate(NewDateForumla, '1W');
        SDHExpiringItems.SetParameters(NewDateForumla);
        TempBlob.CreateOutStream(reportoutstream);
        TempBlob.CreateInStream(reportinstream);
        SDHExpiringItems.SaveAs('', ReportFormat::Pdf, reportoutstream);
        TempEmailItem.AddAttachment(reportinstream, 'ExpiringItems.pdf');
    end;
}
