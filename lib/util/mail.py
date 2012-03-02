#
# Author: Filippo Squillace <sqoox85@gmail.com>
#
# Copyright 2010
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranties of
# MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.

'''Script for utility mail functions.
'''
__author__ = 'Filippo Squillace'
__date__ = '30/07/2010'
__license__   = 'GPL v3'
__copyright__ = '2010'
__docformat__ = 'restructuredtext en'
__version__ = "1.1.3"


import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import COMMASPACE, formatdate
from email.encoders import encode_base64
import poplib, os
import sys, getpass, re

#----------------------------------------------------------------------    
def send_mail(user, pwd, send_from, send_to, subject, text, files=[], server="localhost", port=25):
    """
    It send mail specifying use pass in orderto authtenticate for SMTP server.
    """
    assert type(send_to)==list
    assert type(files)==list

    msg = MIMEMultipart()
    msg['From'] = send_from
    msg['To'] = COMMASPACE.join(send_to)
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = subject

    msg.attach( MIMEText(text) )

    for f in files:
        part = MIMEBase('application', "octet-stream")
        part.set_payload( open(f,"rb").read() )
        encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(f))
        msg.attach(part)


    s = smtplib.SMTP(server,port)
    s.set_debuglevel(1)
    s.starttls()
    s.login(user,pwd)
    out = s.sendmail(send_from, send_to, msg.as_string())
    s.close()
    return len(out)==0

#----------------------------------------------------------------------
def send_gmail(user, pwd, send_from, send_to, subject, text, files=[]):
    """
    Send mail using Gmail SMTP server aving domain smtp.gmail.com on 587 port. using TLS
    """
    return send_mail(user, pwd, send_from, send_to, subject, text, files, "smtp.gmail.com", 587)


#----------------------------------------------------------------------
def receive_pop_mail(user, pwd, server, port=110):
    """
    Receive mail from a POP Server. pop.gmail.com 995 port SSL
    Per IMAP imap.gmail.com port 993 SSL
    """
    
    m = poplib.POP3_SSL(server,port)
    m.user(user)
    m.pass_(pwd)
    #
    # get general information (msg_count, box_size)
    #
    stat = m.stat( )
    m.top
    #
     
    #
    # print some information
    #
    print("Logged in as %s@%s" % (user, server))
    #
    print("Status: %d message(s), %d bytes" % stat)
    return 

#----------------------------------------------------------------------
def interactive_receive_mail(user, server='pop.gmail.com', port=995):
    """
    Interactive version to receive mail from a POP Server. pop.gmail.com 995 port SSL
    Per IMAP imap.gmail.com port 993 SSL
    """
    # view and delete e-mail using the POP3 protocol
    # change according to your needs
    POPHOST = server
    POPUSER = user
    POPPASS = ""
    # the number of message body lines to retrieve
    MAXLINES = 10
    HEADERS = "From To Subject".split()
    # headers you're actually interested in
    rx_headers = re.compile('|'.join(HEADERS), re.IGNORECASE)
    try:
        # connect to POP3 and identify user
        pop = poplib.POP3_SSL(POPHOST, port)
        pop.user(POPUSER)
        if not POPPASS or POPPASS=='=':
            # if no password was supplied, ask for it
            POPPASS = input("Password for %s@%s:" % (POPUSER, POPHOST))
            # authenticate user
            pop.pass_(POPPASS)
            # get general information (msg_count, box_size)
            stat = pop.stat( )
            # print some information
            print("Logged in as %s@%s" % (POPUSER, POPHOST))
            print("Status: %d message(s), %d bytes" % stat)
            bye = 0
            count_del = 0
            for n in range(stat[0]):
                msgnum = n+1
                # retrieve headers
                response, lines, bytes = pop.top(msgnum, MAXLINES)
                # print message info and headers you're interested in
                print("Message %d (%d bytes)" % (msgnum, bytes))
                print("-" * 30)
                print("\n".join(filter(rx_headers.match, lines)))
                print("-" * 30)
                # input loop
                while 1:
                    k = input("(d=delete, s=skip, v=view, q=quit) What?")
                    k = k[:1].lower( )
                    if k == 'd':
                        # Mark message for deletion
                        k = input("Delete message %d? (y/n)" % msgnum)
                        if k in "yY":
                            pop.dele(msgnum)
                            print("Message %d marked for deletion" % msgnum)
                            count_del += 1
                            break
                    elif k == 's':
                        print("Message %d left on server" % msgnum)
                        break
                    elif k == 'v':
                        print("-" * 30)
                        print("\n".join(lines))
                        print("-" * 30)
                    elif k == 'q':
                        bye = 1
                        break
                # done ...
                if bye:
                        print("Bye")
                        break
                # summary
            print("Deleting %d message(s) in mailbox %s@%s" % (count_del, POPUSER, POPHOST))
            # close operations and disconnect from server
            print("Closing POP3 session")
            pop.quit( )
    except poplib.error_proto as detail:
        # possible error
        print("POP3 Protocol Error:", detail)

