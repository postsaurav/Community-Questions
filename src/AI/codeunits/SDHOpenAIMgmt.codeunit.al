codeunit 50011 "SDH Open AI Mgmt."
{
    procedure GetResponseFromChatGPT(Input: Text; var Response: Text)
    var
        OpenAISetup: Record "SDH Open AI Setup";
        ChatGPTBody: JsonObject;
        Clinet: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        RequestMsg: HttpRequestMessage;
        ResponseMsg: HttpResponseMessage;
        ContentText: Text;
        OutputString: Text;
    begin
        OpenAISetup.Get();

        Content.Clear();

        ChatGPTBody.Add('model', Format(OpenAISetup."Model (Legacy)"));
        ChatGPTBody.Add('prompt', Input);
        ChatGPTBody.Add('max_tokens', OpenAISetup."Max Tokens");
        ChatGPTBody.Add('temperature', OpenAISetup.Temperature);
        ChatGPTBody.WriteTo(ContentText);

        Content.WriteFrom(ContentText);

        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');
        RequestMsg.GetHeaders(Headers);
        Headers.Add('Authorization', 'Bearer ' + OpenAISetup."Secret Key");

        RequestMsg.Content(Content);
        RequestMsg.SetRequestUri('https://api.openai.com/v1/completions');
        RequestMsg.Method := 'POST';

        if not Clinet.Send(RequestMsg, ResponseMsg) then
            Error('Error Sending Request %1', ResponseMsg.HttpStatusCode);

        ResponseMsg.Content.ReadAs(OutputString);

        if ResponseMsg.IsSuccessStatusCode then
            Response := ParseResponseText(OutputString);
    end;

    local procedure ParseResponseText(OutputString: Text): Text
    var
        JsonObjectResponse, JsonObjectChoice : JsonObject;
        JsonTokenResponse, JsonTokenChoice, ResponseToken : JsonToken;
        JsonArrayResponse: JsonArray;
    begin
        JsonObjectResponse.ReadFrom(OutputString);
        if JsonObjectResponse.Get('choices', JsonTokenResponse) then begin
            JsonArrayResponse := JsonTokenResponse.AsArray();
            JsonArrayResponse.Get(0, JsonTokenChoice);
            JsonObjectChoice := JsonTokenChoice.AsObject();
            JsonObjectChoice.Get('text', ResponseToken);
            exit(ResponseToken.AsValue().AsText());
        end;
    end;
}
