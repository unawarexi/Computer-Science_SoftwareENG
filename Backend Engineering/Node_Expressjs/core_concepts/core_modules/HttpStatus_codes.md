# HTTP Status Codes and Meanings

| **Code** | **Meaning**                              |
|----------|------------------------------------------|
| **100**  | Continue                                 |
| **101**  | Switching Protocols                      |
| **102**  | Processing                               |
| **200**  | OK                                       |
| **201**  | Created                                  |
| **202**  | Accepted                                 |
| **203**  | Non-Authoritative Information            |
| **204**  | No Content                               |
| **205**  | Reset Content                            |
| **206**  | Partial Content                          |
| **207**  | Multi-Status                             |
| **300**  | Multiple Choices                         |
| **301**  | Moved Permanently                        |
| **302**  | Found (Previously "Moved Temporarily")   |
| **303**  | See Other                                |
| **304**  | Not Modified                             |
| **305**  | Use Proxy                                |
| **306**  | Switch Proxy (No longer used)            |
| **307**  | Temporary Redirect                       |
| **308**  | Permanent Redirect                       |
| **400**  | Bad Request                              |
| **401**  | Unauthorized                             |
| **402**  | Payment Required                         |
| **403**  | Forbidden                                |
| **404**  | Not Found                                |
| **405**  | Method Not Allowed                       |
| **406**  | Not Acceptable                           |
| **407**  | Proxy Authentication Required            |
| **408**  | Request Timeout                          |
| **409**  | Conflict                                 |
| **410**  | Gone                                     |
| **411**  | Length Required                          |
| **412**  | Precondition Failed                      |
| **413**  | Payload Too Large                        |
| **414**  | URI Too Long                             |
| **415**  | Unsupported Media Type                   |
| **416**  | Range Not Satisfiable                     |
| **417**  | Expectation Failed                       |
| **418**  | I'm a teapot (April Fools' joke)         |
| **421**  | Misdirected Request                      |
| **422**  | Unprocessable Entity                     |
| **423**  | Locked                                   |
| **424**  | Failed Dependency                        |
| **425**  | Too Early                                |
| **426**  | Upgrade Required                         |
| **427**  | Unassigned                               |
| **428**  | Precondition Required                    |
| **429**  | Too Many Requests                        |
| **431**  | Request Header Fields Too Large          |
| **451**  | Unavailable For Legal Reasons            |
| **500**  | Internal Server Error                    |
| **501**  | Not Implemented                          |
| **502**  | Bad Gateway                              |
| **503**  | Service Unavailable                      |
| **504**  | Gateway Timeout                          |
| **505**  | HTTP Version Not Supported               |
| **506**  | Variant Also Negotiates                   |
| **507**  | Insufficient Storage                     |
| **508**  | Loop Detected                            |
| **510**  | Not Extended                             |
| **511**  | Network Authentication Required          |

## Notes:
- **1xx (Informational)**: The request was received, continuing process.
- **2xx (Success)**: The request was successfully received, understood, and accepted.
- **3xx (Redirection)**: Further action needs to be taken to complete the request.
- **4xx (Client Error)**: The request contains bad syntax or cannot be fulfilled.
- **5xx (Server Error)**: The server failed to fulfill a valid request.
