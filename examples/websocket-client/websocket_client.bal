import ballerina/io;
import ballerina/lang.'string;
import ballerina/log;
import ballerina/websocket;

public function main() returns websocket:Error? {
    // Creates a new [WebSocket client](https://ballerina.io/swan-lake/learn/api-docs/ballerina/#/ballerina/websocket/latest/websocket/clients/Client).
   websocket:Client wsClient = check new("ws://echo.websocket.org");

   // Writes a text message to the server using [writeString](https://ballerina.io/swan-lake/learn/api-docs/ballerina/#/ballerina/websocket/latest/websocket/clients/Client#writeString).
   var textRespErr = wsClient->writeTextMessage("Text message");
   if (textRespErr is websocket:Error) {
      log:printError("Unexpected error occured when sending text data",
            err = textRespErr);
   }

   // Reads a text message echoed from the server using [readString](https://ballerina.io/swan-lake/learn/api-docs/ballerina/#/ballerina/websocket/latest/websocket/clients/Client#readString).
   string textResp = check wsClient->readTextMessage();
   io:println(textResp);

   // Writes a binary message to the server using [writeBytes](https://ballerina.io/swan-lake/learn/api-docs/ballerina/#/ballerina/websocket/latest/websocket/clients/Client#writeBytes).
   var byteRespErr = wsClient->writeBinaryMessage("Binary message".toBytes());
   if (byteRespErr is websocket:Error) {
      log:printError("Unexpected error occured when sending binary data",
            err = byteRespErr);
   }

   // Reads a binary message echoed from the server using [readBytes](https://ballerina.io/swan-lake/learn/api-docs/ballerina/#/ballerina/websocket/latest/websocket/clients/Client#readBytes).
   byte[] byteResp = check wsClient->readBinaryMessage();
   string|error stringResp = 'string:fromBytes(byteResp);
   if (stringResp is string) {
       io:println(stringResp);
   }
}
