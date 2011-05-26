savepostits-jira
================

This project provides a Kanban style board for Jira projects.

Building
--------

This project is built using maven. Use standard maven process for building the project

    git clone git://github.com/rahulsom/savepostits-jira.git
    cd savepostits-jira
    mvn clean package

Development
-----------

This project comes with the Maven Jetty Plugin.

    mvn jetty:run

To tweak the jira url, username, password, look at src/test/resources/jetty-env.xml

Deployment
----------

For deploying on Tomcat, place the war file at say /home/rahul/tomcat/
Then create a file in /home/rahul/tomcat/conf/Catalina/localhost/savepostits-jira.xml

    <Context path="/savepostits-jira"
             docBase="/home/rahul/tomcat/savepostits-jira.war">

      <Environment name="jira/soapUrl" value="http://myhost/jira/rpc/soap/jirasoapservice-v2"
             type="java.lang.String" override="false"/>

      <Environment name="jira/username" value="rsom@certifydatasystems.com"
             type="java.lang.String" override="false"/>

      <Environment name="jira/password" value="secret"
             type="java.lang.String" override="false"/>

    </Context>
