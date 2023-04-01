codeunit 50004 "SDH Customize Email Subject"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeGetEmailSubject', '', false, false)]
    local procedure SDHCustomEmailSubject(var EmailSubject: Text[250]; PostedDocNo: Code[20]; ReportUsage: Integer; var IsHandled: Boolean)
    var
        ReportUsageEnum: Enum "Report Selection Usage";
    begin
        ReportUsageEnum := "Report Selection Usage".FromInteger(ReportUsage);

        if ReportUsageEnum <> ReportUsageEnum::"S.Order" then
            exit;

        EmailSubject := 'Demo Subject For Document No ' + PostedDocNo;
        IsHandled := true;
    end;
}
