from socket import * 
import base64
# Choose a mail server (e.g. NYU. mail server) and call it mailserver
# Code Start (enter your dig command as a comment here) # Code End mailserver = #Code Start #Code End
# dig +short mx nyu.edu
# 10 mxb-00256a01.gslb.pphosted.com.
# 10 mxa-00256a01.gslb.pphosted.com.
serverPort = 25
mailserver = 'mxa-00256a01.gslb.pphosted.com'  
sender = "ak5814@nyu.edu"
recipient = "ak5814@nyu.edu"
# Create socket and establish TCP connection with mailserver
clientSocket = socket(AF_INET, SOCK_STREAM)
try:
    print(f"Connecting to {mailserver}:{serverPort} ...")
    clientSocket.connect((mailserver, serverPort))
    # Code Start
    # Code End
    tcp_resp = clientSocket.recv(1024).decode()
    print(tcp_resp)
    # Send HELO command to begin SMTP handshake. heloCommand = 'HELO Alice\r\n' clientSocket.send(heloCommand.encode()) helo_resp = clientSocket.recv(1024).decode() print(helo_resp)
    heloCommand = 'HELO nyu-client\r\n'
    print("C:", heloCommand.strip())
    clientSocket.send(heloCommand.encode())
    helo_resp = clientSocket.recv(1024).decode()
    print("S:", helo_resp.strip())

    # Send MAIL FROM command and print response.
    mail_from_cmd = f"MAIL FROM:<{sender}>\r\n"
    print("C:", mail_from_cmd.strip())
    clientSocket.send(mail_from_cmd.encode())
    mail_from_resp = clientSocket.recv(1024).decode()
    print("S:", mail_from_resp.strip())
    # Code Start # Code End
    # Send RCPT TO command and print server response.
    rcpt_to_cmd = f"RCPT TO:<{recipient}>\r\n"
    print("C:", rcpt_to_cmd.strip())
    clientSocket.send(rcpt_to_cmd.encode())
    rcpt_to_resp = clientSocket.recv(1024).decode()
    print("S:", rcpt_to_resp.strip())
    # Code Start
    # Code End
    # Send DATA command and print server response.
    data_cmd = "DATA\r\n"
    print("C:", data_cmd.strip())
    clientSocket.send(data_cmd.encode())
    data_resp = clientSocket.recv(1024).decode()
    print("S:", data_resp.strip())
    # Code Start # Code End
    # Send email data.
    subject = "SMTP socket test – NYU"
    body = (
        "Hello,\r\n\r\n"
        "This is a test email sent using Python sockets via SMTP.\r\n"
        "Assignment: Simple Mail Transfer Protocol (SMTP) implementation.\r\n"
        "Sent by ak5814@nyu.edu to ak5814@nyu.edu.\r\n\r\n"
        "Best,\r\n"
        "SMTP Client\r\n"
    )

    message = (
        f"From: {sender}\r\n"
        f"To: {recipient}\r\n"
        f"Subject: {subject}\r\n"
        "\r\n"
        f"{body}"
    )

    print("C: (sending message body)")
    clientSocket.send(message.encode())
    # Code Start # Code End
    # Send message to close email message.
    clientSocket.send(b"\r\n.\r\n")
    end_data_resp = clientSocket.recv(1024).decode()
    print("S:", end_data_resp.strip())

    # Code Start
    # Code End
    # Send QUIT command and get server response.
    quit_cmd = "QUIT\r\n"
    print("C:", quit_cmd.strip())
    clientSocket.send(quit_cmd.encode())
    quit_resp = clientSocket.recv(1024).decode()
    print("S:", quit_resp.strip())

except Exception as e:
    print("Error:", e)
finally:
    clientSocket.close()
    print("Connection closed.")
# Code Start
# Code End
