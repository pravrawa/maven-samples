FROM tomcat:8

LABEL app=sample-app

COPY multi-module/webapp/target/*.war /usr/local/tomcat/webapps/webapp.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
